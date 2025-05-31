#!/bin/bash
WALLPAPER_DIR="$HOME/.config/wallpapers/"
#I dont know what the fuck I am doing
menu() {
    find "${WALLPAPER_DIR}" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.gif" \) | awk '{print "img:"$0}'
}
main() {
    choice=$(menu | wofi -c ~/.config/wofi/wallpaper -s ~/.config/wofi/style-wallpaper.css --show dmenu --prompt "Select Wallpaper:" -n)
    selected_wallpaper=$(echo "$choice" | sed 's/^img://')
    if [ -z "$selected_wallpaper" ]; then
        echo "No wallpaper selected"
        exit 1
    fi
    swww img "$selected_wallpaper" --transition-type any --transition-fps 60 --transition-duration .5
    wal -i "$selected_wallpaper" -n
    cp ~/.cache/wal/zed.json ~/.config/zed/themes/pywal.json
    swaync-client --reload-css
    cat ~/.cache/wal/colors-kitty.conf > ~/.config/kitty/current-theme.conf
    pywalfox update
    source ~/.cache/wal/colors.sh && cp -r $wallpaper ~/.config/wallpapers/pywallpaper.jpg
    pkill waybar
    sleep 1
    waybar &
}
main
