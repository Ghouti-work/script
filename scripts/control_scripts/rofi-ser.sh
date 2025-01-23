#!/bin/bash

# Function to list running services
list_running_services() {
  systemctl list-units --type=service --state=running --no-pager | awk '{print $1}' | tail -n +2
}

# Function to list all services
list_all_services() {
  systemctl list-units --type=service --all --no-pager | awk '{print $1}' | tail -n +2
}

# Function to stop a service
stop_service() {
  local service_name=$1
  sudo systemctl stop "$service_name"
  if [ $? -eq 0 ]; then
    notify-send "Service Stopped" "Successfully stopped $service_name."
  else
    notify-send "Error" "Failed to stop $service_name."
  fi
}

# Function to start a service
start_service() {
  local service_name=$1
  sudo systemctl start "$service_name"
  if [ $? -eq 0 ]; then
    notify-send "Service Started" "Successfully started $service_name."
  else
    notify-send "Error" "Failed to start $service_name."
  fi
}

# Display services using rofi
manage_services() {
  local services=$(list_all_services)
  local selected=$(echo "$services" | rofi -dmenu -i -p "Select a service")
  if [ -n "$selected" ]; then
    # Ask to start or stop the selected service
    local action=$(echo -e "Stop\nStart" | rofi -dmenu -i -p "Action for $selected")
    case $action in
    "Stop")
      stop_service "$selected"
      ;;
    "Start")
      start_service "$selected"
      ;;
    *)
      notify-send "No Action" "No action taken for $selected."
      ;;
    esac
  fi
}

# Menu using rofi
while true; do
  choice=$(echo -e "Manage Services\nStop mpd & Kill adb\nExit" | rofi -dmenu -i -p "Service Manager")
  case $choice in
  "Manage Services")
    manage_services
    ;;
  "Stop mpd & Kill adb")
    sudo systemctl stop mpd
    adb kill-server
    notify-send "Stopped" "mpd and adb server stopped."
    ;;
  "Exit")
    break
    ;;
  *)
    notify-send "Invalid Option" "Please select a valid option."
    ;;
  esac
done
