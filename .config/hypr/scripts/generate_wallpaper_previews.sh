# Utility script to generate bordered preview for dynamic wallpapers to distinguish them from normal wallpapers

#!/bin/bash

WALLPAPER_DIR="$HOME/.config/wallpapers"
MAX_JOBS=10

process_dir() {
    dir="$1"
    preview_src="$dir/_preview.png"
    dst="$dir/preview.png"

    if [[ -f "$preview_src" ]]; then
        src="$preview_src"
    else
        src=$(find "$dir" -maxdepth 1 -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.bmp" -o -iname "*.gif" \) | head -n 1)
        if [[ -z "$src" ]]; then
            echo "No image found in $dir, skipping."
            return
        fi
    fi

    echo "Processing $src -> $dst"
    convert "$src" \
        -bordercolor black -border 160 \
        -bordercolor white -border 80 \
        "$dst"
}

job_count=0

for dir in "$WALLPAPER_DIR"/*/; do
    dir="${dir%/}"
    process_dir "$dir" &
    ((job_count++))
    
    if (( job_count >= MAX_JOBS )); then
        wait -n  # Wait for any job to finish before starting another
        ((job_count--))
    fi
done

wait  # Wait for all background jobs to finish
