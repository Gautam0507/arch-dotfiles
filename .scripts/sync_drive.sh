#!/bin/bash

notify-send "Google Drive Sync" "Sync Started" --icon=cloud-sync
# Download changes from Google Drive
rclone sync gdrive:/ /home/Gautam/Drive --progress

# Upload local changes to Google Drive (optional)
rclone sync /home/Gautam/Drive gdrive:/ --progress

# Notification
if [ $? -eq 0 ]; then
    notify-send "Google Drive Sync" "Two-way sync completed!" --icon=cloud-sync
else
    notify-send "Google Drive Sync" "Sync failed!" --icon=cloud-error
fi
