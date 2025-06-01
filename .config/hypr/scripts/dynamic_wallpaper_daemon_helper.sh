#!/bin/bash

# This script is called by a systemd timer to periodically update the dynamic wallpaper.
# It reads the currently active dynamic wallpaper directory from a state file
# and then calls the main wallpaper.sh script to set the appropriate timed image.

STATE_FILE="$HOME/.cache/current_active_dynamic_wallpaper_dir"
# Adjust this path if your wallpaper.sh is located elsewhere
MAIN_WALLPAPER_SCRIPT="$HOME/.config/hypr/scripts/wallpaper.sh"

# Check if the main wallpaper script exists and is executable
if [ ! -x "$MAIN_WALLPAPER_SCRIPT" ]; then
    echo "Daemon Helper Error: Main wallpaper script not found or not executable at $MAIN_WALLPAPER_SCRIPT" >&2
    exit 1
fi

# Check if a dynamic wallpaper is configured
if [ ! -f "$STATE_FILE" ]; then
    # No state file means no dynamic wallpaper is currently active, or a static one is.
    # This is normal, so we exit quietly.
    # echo "Daemon Helper: No active dynamic wallpaper configured ($STATE_FILE not found). Exiting."
    exit 0
fi

# Read the configured dynamic wallpaper directory
active_dynamic_dir=$(cat "$STATE_FILE")

if [ -z "$active_dynamic_dir" ]; then
    # State file is empty, which is unexpected if it exists.
    # echo "Daemon Helper: State file is empty. Exiting."
    exit 0 # Or exit 1 if this should be considered an error
fi

# Check if the configured directory actually exists
if [ ! -d "$active_dynamic_dir" ]; then
    echo "Daemon Helper Error: Configured dynamic directory '$active_dynamic_dir' does not exist. Clearing state." >&2
    rm -f "$STATE_FILE" # Clean up invalid state
    exit 1
fi

# All checks passed, call the main wallpaper script with the active dynamic directory.
# The main script will handle finding the closest image for the current time and setting it.
# echo "Daemon Helper: Triggering update for $active_dynamic_dir"
"$MAIN_WALLPAPER_SCRIPT" "$active_dynamic_dir"
(waybar & disown)

exit 0
