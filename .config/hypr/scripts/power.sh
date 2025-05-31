#!/bin/bash

# Define the path to your custom logo for notifications
# Ensure this path is correct for your system
CUSTOM_LOGO_PATH="/home/daveydark/.local/share/logo.png"

# Source the colors script, it's good practice to ensure it runs here if needed by other parts
# or if it sets variables like $wallpaper that notify-send used to rely on.
source /home/$USER/.cache/wal/colors.sh

ACTION=$1
OPTION=$2 # Can be --ac, --bat
AC_STATUS=$(cat /sys/class/power_supply/ACAD/online)

# AC_STATUS: 0 = on battery, 1 = plugged in

if [ "$ACTION" = "lock" ]; then
    if [ "$OPTION" = "--ac" ]; then
        if [ "$AC_STATUS" = "1" ]; then
            loginctl lock-session
        else
            echo "Not locking: System is not on AC power."
        fi
    elif [ "$OPTION" = "--bat" ]; then
        if [ "$AC_STATUS" = "0" ]; then
            loginctl lock-session
        else
            echo "Not locking: System is not on battery power."
        fi
    else
        # Default behavior: lock on both AC and battery if no specific option is given
        loginctl lock-session
    fi

elif [ "$ACTION" = "suspend" ]; then
    if [ "$AC_STATUS" = "0" ]; then
        systemctl suspend
    fi

elif [ "$ACTION" = "warn" ]; then
    if [ "$OPTION" = "--bat" ]; then
        if [ "$AC_STATUS" = "0" ]; then
            notify-send "System" "Locking in 1 minute..." -i "$CUSTOM_LOGO_PATH"
        fi
    elif [ "$OPTION" = "--ac" ]; then
        if [ "$AC_STATUS" = "1" ]; then
            notify-send "System" "Locking in 1 minute..." -i "$CUSTOM_LOGO_PATH"
        fi
    fi

elif [ "$ACTION" = "notify-unlocked" ]; then
    # Give some time for Hyprlock to actually unlock and the session to be ready
    sleep 2
    # Re-source colors.sh here if it's strictly needed for the notification's theme,
    # though notify-send usually doesn't rely on it for content/icon.
    # It was in your original on-resume, so keeping it here.
    source /home/$USER/.cache/wal/colors.sh
    notify-send "System" "Unlocked! Hey $USER" -i "$CUSTOM_LOGO_PATH"
fi
