#!/bin/bash

WALLPAPER_DIR="$HOME/.wallpaper"

# Get list of wallpapers (supports jpg, png, webp)
WALLPAPERS=($(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.webp" \)))

# Display Wofi menu and get selected wallpaper
SELECTED=$(printf '%s\n' "${WALLPAPERS[@]}" | wofi --dmenu --prompt "Select Wallpaper...")

# Apply wallpaper if a selection was made
if [[ -n "$SELECTED" ]]; then
    hyprctl hyprpaper preload "$SELECTED"
    hyprctl hyprpaper wallpaper " ,$SELECTED"
    notify-send "Wallpaper Changed" "$(basename "$SELECTED")" -i "$SELECTED"
fi
