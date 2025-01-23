#!/bin/bash

# Function to display all running services
list_services() {
  echo "=== Running Services ==="
  systemctl list-units --type=service --state=running --no-pager
  echo "========================"
}

# Function to start a service
start_service() {
  read -p "Enter the name of the service to start: " service_name
  sudo systemctl start "$service_name"
  if [ $? -eq 0 ]; then
    echo "Successfully started $service_name."
  else
    echo "Failed to start $service_name."
  fi
}

# Function to stop a service
stop_service() {
  read -p "Enter the name of the service to stop: " service_name
  sudo systemctl stop "$service_name"
  if [ $? -eq 0 ]; then
    echo "Successfully stopped $service_name."
  else
    echo "Failed to stop $service_name."
  fi
}

# Main script logic
while true; do
  echo
  echo "1) List all running services"
  echo "2) Start a service"
  echo "3) Stop a service"
  echo "4) Stop mpd and kill adb server"
  echo "5) Exit"
  read -p "Select an option: " choice

  case $choice in
  1)
    list_services
    ;;
  2)
    start_service
    ;;
  3)
    stop_service
    ;;
  4)
    echo "Stopping mpd and adb server..."
    sudo systemctl stop mpd
    adb kill-server
    echo "Stopped mpd and adb server."
    ;;
  5)
    echo "Exiting..."
    break
    ;;
  *)
    echo "Invalid option. Please try again."
    ;;
  esac
done
