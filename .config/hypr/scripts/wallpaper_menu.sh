#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers/"
CONFIG_DIR="$HOME/.config/"

menu() {
    images=()

    # Load normal wallpapers (depth 1)
    while IFS= read -r -d '' img; do
        images+=("img:$img")
    done < <(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
        -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) -print0)

    # Load dynamic wallpaper previews (depth 2, filename preview.*)
    while IFS= read -r -d '' img; do
        images+=("img:$img")
    done < <(find "$WALLPAPER_DIR" -mindepth 2 -maxdepth 2 -type f \( \
        -iname "preview.jpg" -o -iname "preview.jpeg" -o -iname "preview.png" -o -iname "preview.gif" \) -print0)

    # Show list in wofi and get selection
    selection=$(printf '%s\n' "${images[@]}" | wofi -d -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)

    # Handle empty selection (user pressed Esc or closed wofi)
    [[ -z "$selection" ]] && exit 1

    # Strip the 'img:' prefix from the selected entry
    filepath="${selection#img:}"

    filename=$(basename "$filepath")

    if [[ "$filename" == preview.* ]]; then
        # If dynamic wallpaper preview, output folder path
        $CONFIG_DIR/hypr/scripts/wallpaper.sh "$(dirname "$filepath")"
    else
        # Otherwise, output full file path
        $CONFIG_DIR/hypr/scripts/wallpaper.sh "$filepath"
    fi
}

menu
