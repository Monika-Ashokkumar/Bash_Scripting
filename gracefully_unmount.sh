#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root."
  exit 1
fi

# Check if a disk path is provided as an argument
if [ -z "$1" ]; then
  echo "Usage: $0 <disk_path>"
  exit 1
fi

disk_path="$1"

# Check if the disk is already mounted
if mountpoint -q "$disk_path"; then
  # Gracefully unmount the disk
  umount "$disk_path"
  echo "Disk unmounted successfully."
else
  echo "Disk is not currently mounted at $disk_path."
fi
