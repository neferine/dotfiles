#!/usr/bin/env bash
# wallpaper-picker.sh - Choose wallpaper with preview

WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Find all wallpapers recursively
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) | sort | fuzzel --dmenu --prompt "Select Wallpaper: ")

# Exit if nothing selected
[ -z "$WALLPAPER" ] && exit 0

# Generate color scheme with pywal
wal -i "$WALLPAPER" -n -q

# Link pywal zathura config
ln -sf ~/.cache/wal/zathurarc ~/.config/zathura/zathurarc

# Generate Eww CSS from pywal colors
if [ -f ~/.config/eww/generate-css.sh ]; then
    ~/.config/eww/generate-css.sh
fi

# Update fuzzel theme
~/.config/fuzzel/update-theme.sh

# Generate waybar colors and reload
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/style-combined.css
cat ~/.config/waybar/style.css >> ~/.config/waybar/style-combined.css

# Reload waybar with new colors
killall waybar 2>/dev/null
sleep 0.2
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style-combined.css &

# Reload Kitty terminal colors
killall -SIGUSR1 kitty 2>/dev/null

# Reload Eww bar
if pgrep -x eww > /dev/null; then
    eww close bar
    sleep 0.3
    eww open bar
fi

# Set wallpaper with swww
if command -v swww &> /dev/null; then
    if ! swww query &>/dev/null; then
        swww-daemon &
        sleep 0.5
    fi
    swww img "$WALLPAPER" --transition-type fade --transition-duration 2
elif command -v swaybg &> /dev/null; then
    killall swaybg 2>/dev/null
    swaybg -i "$WALLPAPER" -m fill &
elif command -v hyprctl &> /dev/null; then
    hyprctl hyprpaper unload all 2>/dev/null
    hyprctl hyprpaper preload "$WALLPAPER" 2>/dev/null
    hyprctl hyprpaper wallpaper ",$WALLPAPER" 2>/dev/null
fi
