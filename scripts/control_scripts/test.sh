#!/usr/bin/env bash

notify-send "Getting list of available Wi-Fi networks..."

# Dynamically detect the Wi-Fi interface
interface=$(nmcli -t -f DEVICE,TYPE device | grep "wifi" | cut -d: -f1)
if [ -z "$interface" ]; then
  notify-send "Error" "No wireless interface found. Check your hardware or drivers."
  exit 1
fi

# Get a list of available Wi-Fi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

# Get Wi-Fi status
connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
  toggle="󰖪  Disable Wi-Fi"
else
  toggle="󰖩  Enable Wi-Fi"
fi

# Add options for MAC address switch and monitor mode toggle
mac_switch="󰣻  Switch MAC Address"
monitor_mode_toggle="󰍂  Toggle Monitor Mode"

# Use rofi to select option or Wi-Fi network
chosen_option=$(echo -e "$toggle\n$mac_switch\n$monitor_mode_toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: ")

# Extract the chosen connection ID
read -r chosen_id <<<"${chosen_option:3}"

# Handle each option
if [ "$chosen_option" = "" ]; then
  exit
elif [ "$chosen_option" = "󰖩  Enable Wi-Fi" ]; then
  nmcli radio wifi on
elif [ "$chosen_option" = "󰖪  Disable Wi-Fi" ]; then
  nmcli radio wifi off
elif [ "$chosen_option" = "$mac_switch" ]; then
  # Switch MAC address
  sudo macchanger -r "$interface" && notify-send "MAC Address Changed" "New MAC: $(macchanger -s $interface | grep 'Current MAC' | awk '{print $3}')"
elif [ "$chosen_option" = "$monitor_mode_toggle" ]; then
  # Toggle monitor mode
  mode=$(iw "$interface" info | grep type | awk '{print $2}')
  if [ "$mode" = "monitor" ]; then
    sudo ip link set "$interface" down
    sudo iw "$interface" set type managed
    sudo ip link set "$interface" up
    notify-send "Mode Switched" "Switched to Managed Mode."
  else
    sudo ip link set "$interface" down
    sudo iw "$interface" set type monitor
    sudo ip link set "$interface" up
    notify-send "Mode Switched" "Switched to Monitor Mode."
  fi
else
  # Attempt to connect to the selected Wi-Fi network
  success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
  saved_connections=$(nmcli -g NAME connection)
  if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
    nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
  else
    if [[ "$chosen_option" =~ "" ]]; then
      wifi_password=$(rofi -dmenu -p "Password: ")
    fi
    nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
  fi
fi
