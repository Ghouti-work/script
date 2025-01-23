#!/bin/bash

# Script to select a file using rofi and create a hard link under ~/Notes/publish/content

# Define the target directory
TARGET_DIR=~/Notes/publish/content

# Ensure the target directory exists
mkdir -p "$TARGET_DIR"

# Use 'find' to list files and pass them to rofi for selection
FILE_TO_LINK=$(find / -type f 2>/dev/null | rofi -dmenu -i -p "Select a file to hard link:")

# Check if a file was selected
if [[ -z "$FILE_TO_LINK" ]]; then
  rofi -e "No file selected. Exiting."
  exit 1
fi

# Prompt for the new link name
LINK_NAME=$(rofi -dmenu -p "Enter a name for the hard link (leave blank for default):")

# Determine the final link path
if [[ -z "$LINK_NAME" ]]; then
  # Default to the original file name
  LINK_PATH="$TARGET_DIR/$(basename "$FILE_TO_LINK")"
else
  LINK_PATH="$TARGET_DIR/$LINK_NAME"
fi

# Check if the link already exists
if [[ -e "$LINK_PATH" ]]; then
  rofi -e "A file with this name already exists in $TARGET_DIR. Exiting."
  exit 1
fi

# Create the hard link
ln "$FILE_TO_LINK" "$LINK_PATH"

# Confirm success
if [[ $? -eq 0 ]]; then
  rofi -e "Hard link created successfully:\n$LINK_PATH"
else
  rofi -e "Failed to create hard link."
fi
