#!/bin/sh

# Directory where your wallpapers are stored
WALLPAPER_DIR="${HOME}/.wallpaper"

# List wallpapers, choose one using wofi
chosen=$(ls "$WALLPAPER_DIR"/* | wofi --dmenu --prompt "Select Wallpaper:")

# If a wallpaper was selected
if [ -n "$chosen" ]; then
   # Example using hyprpaper to set wallpaper
   # Overwrite hyprpaper config with the new wallpaper path
   echo "preload = $chosen" > ~/.config/hypr/hyprpaper.conf
   echo "wallpaper =, $chosen" >> ~/.config/hypr/hyprpaper.conf

   # Reload hyprpaper to apply the change
   hyprctl hyprpaper reload ,"$chosen" 
fi

