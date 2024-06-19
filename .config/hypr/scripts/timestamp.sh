#!/bin/bash

# Define the output directory
output_dir="/home/daveydark/Pictures/screenshots"

# Define the filename format
filename_format="%Y-%m-%d_%H-%M-%S.png"

# Create the output directory if it doesn't exist
mkdir -p "$output_dir"

# Generate the timestamp
timestamp=$(date +"$filename_format")
echo $timestamp

# Take the screenshot using grim and save it with the timestamp as the filename
if [[ "$1" == "full" ]]; then
  # Capture the full screen using grim
  grim "$output_dir/$timestamp"
elif [[ "$1" == "region" ]]; then
  # Capture a region using slurp and grim
  slurp | grim -g- "$output_dir/$timestamp"
elif [[ "$1" == "edit" ]]; then
  # Capture a region using slurp and pass it to Swappy for editing
  region=$(slurp)
  grim -g "$region" "$output_dir/$timestamp"
  swappy -f "$output_dir/$timestamp" "$output_dir/$timestamp"
else
  echo "Invalid argument. Usage: ./screenshot.sh [full|region]"
  exit 1
fi
