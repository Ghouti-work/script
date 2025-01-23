#!/bin/bash

# Set the source and destination directories
cd
SOURCE_DIR="Dropbox/phone_note/"
DEST_DIR="Documents/my_brain_obs_v2/02_phone_note/"

# Sync from SOURCE_DIR to DEST_DIR
rsync -av --delete "$SOURCE_DIR" "$DEST_DIR" > /dev/null 2>&1

# Check the Dropbox status
DROPBOX_STATUS=$(dropbox status 2>&1)

# If Dropbox is running, wait for synchronization to complete
if [[ $DROPBOX_STATUS == *"Up to date"* ]]; then
    echo "Dropbox is up to date. Backup complete." 
else
    echo "Waiting for Dropbox synchronization to complete..." 
    dropbox wait > /dev/null 2>&1
    echo "Dropbox synchronization complete. Backup complete." 
fi