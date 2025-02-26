#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_instances>"
    exit 1
fi

# Configuration Variables
N=$1  # Number of instances
SSH_KEY="$HOME/.ssh/id_rsa"  # Path to your SSH private key
SERVICE_NAME="mpi-service"
NETWORK_NAME="mpi-network"
IMAGE_NAME="mpi-image"
MPI_PROGRAM="pingpong.cpp"

# Ensure SSH key exists
if [ ! -f "$SSH_KEY" ]; then
    echo "SSH key not found. Generating one..."
    ssh-keygen -t rsa -b 2048 -f "$SSH_KEY" -N ""
fi

# Build Docker image
echo "Building Docker image '$IMAGE_NAME'..."
docker build -t "$IMAGE_NAME" --build-arg SSH_KEY_PUB="$(cat "${SSH_KEY}.pub")" --build-arg SSH_KEY="$(cat "$SSH_KEY")" - <<EOF
FROM alpine:latest

ARG SSH_KEY_PUB
ARG SSH_KEY

RUN apk update && apk add --no-cache openssh-server pssh bash build-base openmpi openmpi-dev
RUN ssh-keygen -A

RUN mkdir -p /root/.ssh
RUN echo "\$SSH_KEY_PUB" > /root/.ssh/authorized_keys
RUN echo "\$SSH_KEY" > /root/.ssh/id_rsa
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
RUN echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/id_rsa

CMD ["/usr/sbin/sshd", "-D"]
EOF

# Initialize Docker Swarm if not already active
if ! docker info | grep -q "Swarm: active"; then
    echo "Initializing Docker Swarm..."
    docker swarm init
else
    echo "Docker Swarm is already active."
fi

# Create Docker network
echo "Creating Docker overlay network '$NETWORK_NAME'..."
docker network create --driver overlay --subnet 192.168.100.0/23 "$NETWORK_NAME" || echo "Network '$NETWORK_NAME' already exists."

# Deploy the service
echo "Deploying service '$SERVICE_NAME' with $N replicas..."
docker service create \
    --name "$SERVICE_NAME" \
    --replicas "$N" \
    --network "$NETWORK_NAME" \
    --publish published=2222,target=22 \
    "$IMAGE_NAME"

# Fetch the master container ID early
master_id=$(docker ps -q --filter "name=$SERVICE_NAME" | head -n 1)

# Generate a unique hostfile
hostfile="hostfile"
> "$hostfile"

container_ids=$(docker service ps "$SERVICE_NAME" --filter "desired-state=running" --format "{{.ID}}" | \
    xargs docker inspect --format '{{ .Status.ContainerStatus.ContainerID }}')

for container_id in $container_ids; do
    #container_ip=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_id")
	container_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$container_id" | sed -E 's/^[^ ]+ //')
    if [ -z "$container_ip" ]; then
        echo "Error: Unable to get IP for container $container_id"
        exit 1
    fi
    echo "$container_ip slots=1" >> "$hostfile"
    docker cp "$MPI_PROGRAM" "$container_id:/root/$MPI_PROGRAM"
    docker exec "$container_id" bash -c "mpic++ -o /root/pingpong /root/$MPI_PROGRAM"
done

# Odstrani morebitne podvojene vrstice (če se pojavijo)
sort "$hostfile" | uniq > "${hostfile}.tmp" && mv "${hostfile}.tmp" "$hostfile"

echo "Generated hostfile contents:"
cat "$hostfile"

docker cp "$hostfile" "$master_id:/root/hosts"

# Execute MPI program
echo "Running MPI program..."
docker exec "$master_id" bash -c \
	"export OMPI_ALLOW_RUN_AS_ROOT=1; \
	export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1; \
	mpirun -v --hostfile /root/hosts -mca plm_rsh_args '-o StrictHostKeyChecking=no' /root/pingpong"	

#mpirun --verbose --allow-run-as-root --mca orte_routed direct --hostfile /root/hosts -np $N --mca btl_tcp_if_include eth0 --mca plm_rsh_args '-o StrictHostKeyChecking=no' /root/pingpong"

# Cleanup resources
echo "Removing Docker service '$SERVICE_NAME'..."
docker service rm "$SERVICE_NAME"

echo "Removing Docker network '$NETWORK_NAME'..."
docker network rm "$NETWORK_NAME"

echo "Removing Docker image '$IMAGE_NAME'..."
docker rmi -f "$IMAGE_NAME"

echo "Done!"
