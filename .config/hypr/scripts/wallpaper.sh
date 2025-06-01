#!/bin/bash

# --- Configuration ---
# Directory where your wallpapers and dynamic wallpaper subfolders are stored
WALLPAPER_DIR="$HOME/.config/wallpapers"
# Name of the preview file within each dynamic wallpaper folder (e.g., preview.png)
# This image will be listed by Wofi to represent the dynamic set.
DYNAMIC_WALLPAPER_PREVIEW_FILENAME="preview.png"
# Cache directory for Pywal
PYWAL_CACHE_DIR="$HOME/.cache/wal"
# Wofi configuration files (adjust if yours are different) - These are now unused but kept for reference
WOFI_CONFIG_WALLPAPER="$HOME/.config/wofi/wallpaper"
WOFI_STYLE_WALLPAPER="$HOME/.config/wofi/style-wallpaper.css"
# --- State File for Active Dynamic Wallpaper ---
STATE_FILE="$HOME/.cache/current_active_dynamic_wallpaper_dir"

# --- Function to get the current wallpaper path from swww using 'swww query' ---
get_current_swww_wallpaper() {
    local swww_query_output=$(swww query 2>/dev/null)
    
    if [ -z "$swww_query_output" ]; then
        echo "" # Return empty if swww query fails or returns nothing
        return 1
    fi

    echo "$swww_query_output" | grep -oP 'currently displaying: image: \K.*' | head -n 1
    return 0
}

# --- Helper function to apply pywal and update themes ---
apply_theme_updates() {
    local wallpaper_to_use_for_wal="$1"

    if [ -z "$wallpaper_to_use_for_wal" ] || [ ! -f "$wallpaper_to_use_for_wal" ]; then
        echo "Error: Valid wallpaper path not provided for theme updates: '$wallpaper_to_use_for_wal'"
        return 1
    fi

    echo "Updating themes using wallpaper: $wallpaper_to_use_for_wal"

    # Run Pywal
    wal -i "$wallpaper_to_use_for_wal" -n

    if [ ! -f "$PYWAL_CACHE_DIR/colors.sh" ]; then
        echo "Error: Pywal did not seem to run successfully. Aborting theme updates."
        return 1
    fi

    # --- Call the Python script to set GTK and Icon themes ---
    echo "Setting GTK and Icon themes based on pywal colors..."
    python3 $HOME/.config/hypr/scripts/gtk_wal.py || echo "Warning: Failed to run GTK/Icon theme script."
    # --- End of Python script call ---

    # Update Zed
    mkdir -p "$HOME/.config/zed/themes"
    if [ -f "$PYWAL_CACHE_DIR/zed.json" ]; then
        cp "$PYWAL_CACHE_DIR/zed.json" "$HOME/.config/zed/themes/pywal.json" || echo "Warning: Failed to copy zed theme."
    else
        echo "Warning: $PYWAL_CACHE_DIR/zed.json not found."
    fi

    # Reload SwayNC
    if command -v swaync-client &> /dev/null; then
        swaync-client --reload-css || echo "Warning: Failed to reload swaync CSS."
    else
        echo "Info: swaync-client not found, skipping."
    fi

    # Update Kitty
    mkdir -p "$HOME/.config/kitty"
    if [ -f "$PYWAL_CACHE_DIR/colors-kitty.conf" ]; then
        cat "$PYWAL_CACHE_DIR/colors-kitty.conf" > "$HOME/.config/kitty/current-theme.conf" || echo "Warning: Failed to update kitty theme."
    else
        echo "Warning: $PYWAL_CACHE_DIR/colors-kitty.conf not found."
    fi
    
    # Update Pywalfox
    if command -v pywalfox &> /dev/null; then
        pywalfox update || echo "Warning: Failed to update pywalfox."
    else
        echo "Info: pywalfox not found, skipping."
    fi
    
    # Source colors and copy wallpaper for other Pywal uses
    source "$PYWAL_CACHE_DIR/colors.sh" # This sets the 'wallpaper' variable
    if [ -n "$wallpaper" ] && [ -f "$wallpaper" ]; then
        cp -r "$wallpaper" "$WALLPAPER_DIR/pywallpaper.jpg" || echo "Warning: Failed to copy pywallpaper.jpg from wal's \$wallpaper."
    else
        # Fallback if wal's $wallpaper variable isn't what we expect
        cp -r "$wallpaper_to_use_for_wal" "$WALLPAPER_DIR/pywallpaper.jpg" || echo "Warning: Failed to copy pywallpaper.jpg (fallback)."
    fi

    # Restart Waybar
    pkill waybar && hyprctl dispatch exec waybar 

    echo "Theme updates applied."
}

# --- Function to set dynamic wallpaper ---
set_dynamic_wallpaper() {
    local dynamic_dir="$1"
    if [ ! -d "$dynamic_dir" ]; then
        echo "Error: Dynamic wallpaper directory not found: $dynamic_dir"
        exit 1
    fi

    local current_time_hm=$(date +%H%M)
    local current_minutes_total=$((10#${current_time_hm:0:2} * 60 + 10#${current_time_hm:2:2}))

    local best_match_file=""
    local max_past_minutes=-1 # To find the largest timestamp <= current time

    local fallback_file=""
    local max_overall_minutes=-1 # To find the largest timestamp overall (for wrap-around)

    shopt -s nullglob # Expands to nothing if no match
    local image_files=("$dynamic_dir"/*.png "$dynamic_dir"/*.jpg "$dynamic_dir"/*.jpeg "$dynamic_dir"/*.webp)
    shopt -u nullglob 

    if [ ${#image_files[@]} -eq 0 ]; then
        echo "Error: No compatible image files (png, jpg, jpeg, webp) found in $dynamic_dir"
        exit 1
    fi

    for img_path in "${image_files[@]}"; do
        local filename=$(basename "$img_path")
        local file_time_hm_str="${filename%.*}" # Extract HHMM from "HHMM.ext"

        if [[ "$file_time_hm_str" =~ ^[0-9]{4}$ ]]; then
            local file_hour=${file_time_hm_str:0:2}
            local file_min=${file_time_hm_str:2:2}

            if (( 10#$file_hour >= 0 && 10#$file_hour <= 23 && 10#$file_min >= 0 && 10#$file_min <= 59 )); then
                local file_minutes_total=$((10#$file_hour * 60 + 10#$file_min))

                # Logic for "largest value less than or equal to current time"
                if (( file_minutes_total <= current_minutes_total )); then
                    if (( file_minutes_total > max_past_minutes )); then
                        max_past_minutes=$file_minutes_total
                        best_match_file="$img_path"
                    fi
                fi

                # Always track the overall largest timestamp for potential wrap-around fallback
                if (( file_minutes_total > max_overall_minutes )); then
                    max_overall_minutes=$file_minutes_total
                    fallback_file="$img_path"
                fi
            else
                echo "Warning: Skipping image with invalid HHMM time in filename: $img_path (time: $file_hour:$file_min)"
            fi
        else
            # Skip files not matching HHMM pattern, like 'preview.png' itself
            if [[ "$filename" != "$DYNAMIC_WALLPAPER_PREVIEW_FILENAME" ]]; then
                echo "Info: Skipping non-HHMM named file in dynamic dir: $img_path"
            fi
        fi
    done

    # If no image was found with a timestamp <= current_minutes_total,
    # it means current time is earlier than all available timestamps.
    # In this case, wrap around and pick the largest timestamp overall.
    if [ -z "$best_match_file" ]; then
        if [ -n "$fallback_file" ]; then
            best_match_file="$fallback_file"
            echo "Info: No image found with timestamp <= current time. Wrapping around to the largest timestamp: $(basename "$best_match_file")"
        else
            echo "Error: Could not determine a best match wallpaper in $dynamic_dir. No valid HHMM-named images found."
            # Fallback: Use the preview image itself if no timed images are found or match.
            if [ -f "$dynamic_dir/$DYNAMIC_WALLPAPER_PREVIEW_FILENAME" ]; then
                best_match_file="$dynamic_dir/$DYNAMIC_WALLPAPER_PREVIEW_FILENAME"
                echo "Warning: Falling back to using the preview image: $best_match_file"
            else
                exit 1
            fi
        fi
    fi

    local current_wallpaper_path=$(get_current_swww_wallpaper)

    if [ -n "$current_wallpaper_path" ] && [ "$(readlink -f "$best_match_file")" = "$(readlink -f "$current_wallpaper_path")" ]; then
        echo "Current wallpaper is already $(basename "$best_match_file"). Aborting update to avoid Waybar flash."
        exit 0 # Exit successfully as no change is needed
    fi

    echo "Setting dynamic wallpaper to: $best_match_file (selected based on largest HHMM <= $current_time_hm)"
    if swww img "$best_match_file" --transition-type any --transition-fps 60 --transition-duration .5; then
        mkdir -p "$(dirname "$STATE_FILE")" # Ensure cache directory exists
        echo "$dynamic_dir" > "$STATE_FILE"
        echo "Active dynamic wallpaper directory set to: $dynamic_dir"
        apply_theme_updates "$best_match_file"
    else
        echo "Error: swww img command failed for $best_match_file"
        # Do not update state file if swww fails
    fi
}

# --- Function to set static wallpaper ---
set_static_wallpaper() {
    local static_file="$1"
    if [ ! -f "$static_file" ]; then
        echo "Error: Static wallpaper file not found: $static_file"
        exit 1
    fi

    local current_wallpaper_path=$(get_current_swww_wallpaper)

    if [ -n "$current_wallpaper_path" ] && [ "$(readlink -f "$static_file")" = "$(readlink -f "$current_wallpaper_path")" ]; then
        echo "Current wallpaper is already $(basename "$static_file"). Aborting update to avoid Waybar flash."
        exit 0 # Exit successfully as no change is needed
    fi

    echo "Setting static wallpaper to: $static_file"
    if swww img "$static_file" --transition-type any --transition-fps 60 --transition-duration .5; then
        # Static wallpaper is set, so clear the active dynamic wallpaper state
        if rm -f "$STATE_FILE"; then
            echo "Cleared active dynamic wallpaper state."
        fi
        apply_theme_updates "$static_file"
    else
        echo "Error: swww img command failed for "$static_file""
    fi
}

# Ensure swww daemon is running
if ! pgrep -x swww-daemon > /dev/null; then
    echo "swww daemon not running. Attempting to initialize..."
    if command -v swww &> /dev/null; then
        swww init || { echo "Failed to init swww. Is it installed and configured properly?"; exit 1; }
        sleep 1 # Give daemon a moment to start
    else
        echo "Error: swww command not found. Please install and configure swww."
        exit 1
    fi
fi

if [ $# -eq 0 ]; then
    # No arguments, attempt to set dynamic wallpaper from the last active dynamic directory
    if [ -f "$STATE_FILE" ]; then
        LAST_DYNAMIC_DIR=$(cat "$STATE_FILE")
        if [ -d "$LAST_DYNAMIC_DIR" ]; then
            echo "No arguments provided. Attempting to update last active dynamic wallpaper: $LAST_DYNAMIC_DIR"
            set_dynamic_wallpaper "$LAST_DYNAMIC_DIR"
        else
            echo "Error: Last active dynamic wallpaper directory ($LAST_DYNAMIC_DIR) not found. Cannot set wallpaper."
            echo "Usage:"
            echo "  $0 <path>       : Set wallpaper from specified file or dynamic directory."
            exit 1
        fi
    else
        echo "No arguments provided and no last active dynamic wallpaper found. Please provide a path."
        echo "Usage:"
        echo "  $0 <path>       : Set wallpaper from specified file or dynamic directory."
        exit 1
    fi
elif [ $# -eq 1 ]; then
    # One argument: path to file or directory
    INPUT_PATH="$1"
    if [ -f "$INPUT_PATH" ]; then
        set_static_wallpaper "$INPUT_PATH"
    elif [ -d "$INPUT_PATH" ]; then
        set_dynamic_wallpaper "$INPUT_PATH"
    else
        echo "Error: Path '$INPUT_PATH' is not a valid file or directory."
        exit 1
    fi
else
    echo "Usage:"
    echo "  $0 <path>       : Set wallpaper from specified file or dynamic directory."
    exit 1
fi

exit 0
