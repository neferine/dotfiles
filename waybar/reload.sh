#!/bin/bash

# Import pywal colors into waybar style
cat ~/.cache/wal/colors-waybar.css > ~/.config/waybar/style-combined.css
cat ~/.config/waybar/style.css >> ~/.config/waybar/style-combined.css

# Reload waybar
killall waybar 2>/dev/null
waybar -c ~/.config/waybar/config.jsonc -s ~/.config/waybar/style-combined.css &
