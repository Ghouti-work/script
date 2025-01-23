#!/bin/bash

# Start and enable the Tor service
echo "Enabling and starting Tor service..."
sudo systemctl enable tor.service
sudo systemctl start tor.service

# Check if the Tor service is active
echo "Checking Tor service status..."
if systemctl is-active --quiet tor.service; then
  echo "Tor service is running."
else
  echo "Failed to start Tor service. Exiting."
  exit 1
fi

# Update Proxychains configuration to use Tor (if not already set)
PROXYCHAINS_CONF="/etc/proxychains.conf"
if grep -q "^socks4 127.0.0.1 9050" "$PROXYCHAINS_CONF"; then
  echo "Proxychains is configured to use Tor."
else
  echo "Configuring Proxychains to use Tor..."
  sudo sed -i 's/^#socks4 127.0.0.1 9050/socks4 127.0.0.1 9050/' "$PROXYCHAINS_CONF"
fi

# Launch Firefox through Proxychains
echo "Launching Firefox with Proxychains..."
proxychains firefox &

echo "Done! Firefox is running through Tor's proxy."
