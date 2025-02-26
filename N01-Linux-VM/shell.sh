#!/bin/sh

# Exit immediately if any command fails
set -e

# Define variables
CONTAINER_NAME="ssh_alpine_test"
USERNAME="remoteuser"
PASSWORD="8082"
PUBLIC_KEY_PATH="/mnt/c/Users/simon/.ssh/id_rsa.pub"
AUTHORIZED_KEYS_PATH="/home/$USERNAME/.ssh/authorized_keys"

# Create and start the Docker container
echo "Starting Docker container '$CONTAINER_NAME'..."
docker run -d -p 2222:22 --name $CONTAINER_NAME alpine:latest /bin/sh -c "
    apk add --no-cache openssh && \
    ssh-keygen -A && \
    /usr/sbin/sshd -D
"

# Add a new user and set up the home directory
echo "Setting up user '$USERNAME'..."
docker exec -it $CONTAINER_NAME /bin/sh -c "
    adduser -D $USERNAME && \
    echo '$USERNAME:$PASSWORD' | chpasswd && \
    mkdir -p /home/$USERNAME/.ssh && \
    chmod 700 /home/$USERNAME/.ssh
"

# Copy the public key to the container
echo "Copying public key to the container..."
docker cp $PUBLIC_KEY_PATH $CONTAINER_NAME:$AUTHORIZED_KEYS_PATH

# Set permissions for the authorized_keys file
echo "Setting permissions for 'authorized_keys'..."
docker exec -it $CONTAINER_NAME /bin/sh -c "
    chown $USERNAME:$USERNAME $AUTHORIZED_KEYS_PATH && \
    chmod 600 $AUTHORIZED_KEYS_PATH
"

echo "Setup complete! The container '$CONTAINER_NAME' is ready for SSH access."
