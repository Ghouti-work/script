#!/bin/bash

# Variables for the swap file size (adjust as needed)
SWAP_SIZE="12G" # Set the swap file size (12GB recommended)

# Check if the script is run as root, as some commands require root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root (use sudo)."
  exit 1
fi

# Step 1: Install Docker (if not installed)
echo "Checking if Docker is installed..."
if ! command -v docker &>/dev/null; then
  echo "Docker not found, installing Docker..."
  # Install Docker (Debian/Ubuntu)
  apt update
  apt install -y docker.io

  # Start and enable Docker service
  systemctl start docker
  systemctl enable docker
else
  echo "Docker is already installed."
fi

# Step 2: Add the current user to the Docker group
echo "Adding user to the docker group..."
usermod -aG docker $USER
echo "User $USER added to the docker group. Please log out and log back in for changes to take effect."

# Step 3: Set up Swap Space (if not already done)
echo "Checking swap space..."

# Check if swap space is already configured
if ! swapon --show | grep -q "/swapfile"; then
  echo "Setting up swap space..."

  # Create a swap file
  fallocate -l $SWAP_SIZE /swapfile

  # Set appropriate permissions for the swap file
  chmod 600 /swapfile

  # Initialize the swap file
  mkswap /swapfile

  # Activate the swap file
  swapon /swapfile

  # Make swap permanent by adding it to /etc/fstab
  echo "/swapfile swap swap defaults 0 0" >>/etc/fstab

  echo "Swap space of size $SWAP_SIZE has been successfully set up."
else
  echo "Swap space is already configured."
fi

# Step 4: Pull and Run the Oracle 11g Docker Image
echo "Pulling Oracle 11g Docker image..."
docker pull oracleinanutshell/oracle-xe-11g

# Step 5: Run Oracle 11g Docker Container
echo "Running Oracle 11g Docker container..."
docker run -d -p 1521:1521 -p 8080:8080 --name oracle-xe-11g --restart unless-stopped oracleinanutshell/oracle-xe-11g

# Provide information about how to start/stop the container in the future
echo ""
echo "Oracle Database 11g is now running in Docker."
echo "You can access the database on port 1521 and the web interface on port 8080."
echo "To manage the container, use the following commands:"
echo "  - Start the container: docker start oracle-xe-11g"
echo "  - Stop the container: docker stop oracle-xe-11g"
echo "  - Restart the container: docker restart oracle-xe-11g"
echo "To restart the container automatically on system reboot, use 'docker restart oracle-xe-11g' after a reboot."

# End of script
echo "Oracle 11g installation and setup complete!"
