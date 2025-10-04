#!/usr/bin/env bash

WALLPAPER_DIR="/home/nyanko/.config/hypr/wallpapers"
FOCUSED_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
CURRENT_WALL=$(hyprctl hyprpaper listloaded)
# Track last wallpaper for this monitor
STATE_FILE="/tmp/hyprpaper_${FOCUSED_MONITOR}.last"

# If last wallpaper exists, unload it
#if [[ -f "$STATE_FILE" ]]; then
#    LAST_WALL=$(<"$STATE_FILE")
#    hyprctl hyprpaper unload "$LAST_WALL"
#fi

# Pick a new random wallpaper
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Preload + apply
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper "$FOCUSED_MONITOR","$WALLPAPER"

# Save state
#echo "$WALLPAPER" > "$STATE_FILE"

