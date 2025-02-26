#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <number_of_instances>"
    exit 1
fi

# Configuration Variables
N=$1  # Number of instances
BASE_NAME="ssh_cluster_"  # Base name for containers
SSH_KEY="$HOME/.ssh/id_rsa"  # Path to your SSH private key
SERVICE_NAME="rvo-ssh-service"
NETWORK_NAME="rvo-network"
IMAGE_NAME="rvo-ssh"

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

RUN apk update && apk add --no-cache openssh-server pssh bash
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

# Retrieve container IPs
echo "Retrieving container IPs..."
container_ips=$(docker network inspect "$NETWORK_NAME" --format '{{range .Containers}}{{.IPv4Address}} {{end}}' | awk '{$NF=""; sub(/[[:space:]]+$/, ""); print}')

# Run `pssh` in each container
echo "Running 'pssh' inside each container..."
container_ids=$(docker service ps "$SERVICE_NAME" --filter "desired-state=running" --format "{{.ID}}" | \
    xargs docker inspect --format '{{ .Status.ContainerStatus.ContainerID }}')



for container_id in $container_ids; do
    # Get the current container's IP address
    current_ip=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}' "$container_id" | sed -E 's/^[^ ]+ //')
    
    # Filter out the current IP from the list of all IPs
    target_ips=$(echo "$container_ips" | tr '\n' ' ' | sed 's:/[0-9]*::g' | grep -v -w "$current_ip")

    # Debugging: Output the target IPs for validation
    echo "Current container: $current_ip"
    echo "Connecting to target hosts: $target_ips"

    # Execute `pssh` within the current container
    docker exec -it "$container_id" bash -c "
        echo 'Executing pssh to all other containers...';
        pssh -H \"$target_ips\" -x \"-o StrictHostKeyChecking=no\" 'hostname -i'
    "

    echo "Completed 'pssh' for container: $current_ip"
done

# Cleanup resources
echo "Removing Docker service '$SERVICE_NAME'..."
docker service rm "$SERVICE_NAME"

echo "Removing Docker network '$NETWORK_NAME'..."
docker network rm "$NETWORK_NAME"

echo "Removing Docker image '$IMAGE_NAME'..."
docker rmi -f "$IMAGE_NAME"

echo "Done!"
