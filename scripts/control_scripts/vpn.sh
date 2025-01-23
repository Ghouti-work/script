#!/usr/bin/env bash

notify-send "Getting list of available OpenVPN configurations..."
# Get a list of available OpenVPN configurations
vpn_list=$(ls /etc/openvpn/*.ovpn | xargs -n 1 basename | sed 's/.ovpn//g')

# Check if there are any VPN configurations available
if [ -z "$vpn_list" ]; then
  notify-send "No OpenVPN configurations found."
  exit
fi

# Use rofi to select VPN configuration
chosen_vpn=$(echo -e "$vpn_list" | rofi -dmenu -i -p "Select VPN: ")

if [ -z "$chosen_vpn" ]; then
  exit
else
  # Message to show when connection is activated successfully
  success_message="You are now connected to the VPN \"$chosen_vpn\"."

  # Prompt for password if required
  if grep -q "auth-user-pass" "/etc/openvpn/${chosen_vpn}.ovpn"; then
    vpn_password=$(rofi -dmenu -p "Password: ")
    echo "$vpn_password" >/tmp/vpn_password.txt
    echo "auth-user-pass /tmp/vpn_password.txt" >>"/etc/openvpn/${chosen_vpn}.ovpn"
  fi

  # Start the OpenVPN connection in the background
  sudo openvpn --config "/etc/openvpn/${chosen_vpn}.ovpn" &

  # Get the PID of the OpenVPN process
  vpn_pid=$!

  # Notify the user
  notify-send "Connecting..." "Attempting to connect to VPN \"$chosen_vpn\"."

  # Wait for a few seconds to allow the connection to establish
  sleep 5

  # Check if the VPN is connected
  if pgrep -x "openvpn" >/dev/null; then
    notify-send "Connection Established" "$success_message"
  else
    notify-send "Connection Failed" "Could not connect to VPN \"$chosen_vpn\"."
  fi

  # Function to stop the OpenVPN connection
  stop_vpn() {
    if pgrep -x "openvpn" >/dev/null; then
      sudo kill "$vpn_pid"
      notify-send "VPN Stopped" "The VPN \"$chosen_vpn\" has been disconnected."
    else
      notify-send "No Active VPN" "There is no active VPN connection to stop."
    fi
  }

  # Trap SIGINT (Ctrl+C) to stop the VPN
  trap stop_vpn SIGINT

  # Wait for the OpenVPN process to finish
  wait "$vpn_pid"

  # Clean up the password file
  rm -f /tmp/vpn_password.txt
fi
