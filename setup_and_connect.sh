#!/bin/bash

# Configuration
CONTAINER_NAME="your_container_name"      # ← Replace with your Docker container name
SSH_USER="root"
SSH_PASSWORD="1"                          # ← Replace with actual password

# Update package lists
echo "Updating package lists..."
apt-get update -y

# Install OpenSSH client
echo "Installing OpenSSH client..."
apt-get install -y openssh-client

# Install sshpass (if not already installed)
echo "Installing sshpass..."
apt-get install -y sshpass

# Get container IP dynamically
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$CONTAINER_NAME")

# Connect to the remote server using SSH
echo "Connecting to ${SSH_USER}@${CONTAINER_IP}..."
sshpass -p "$SSH_PASSWORD" ssh -o StrictHostKeyChecking=no "${SSH_USER}@${CONTAINER_IP}"

# Message on successful execution
echo "Script executed successfully."

