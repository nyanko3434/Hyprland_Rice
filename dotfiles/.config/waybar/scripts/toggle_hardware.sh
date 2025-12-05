#!/bin/bash

CONFIG="$HOME/.config/waybar/config"

hw_start="@hardware_start"
hw_end="@hardware_end"

# Check if hardware block is active (uncommented)
hw_active=$(sed -n "/$hw_start/,/$hw_end/p" "$CONFIG" | grep -v "^//")

if [ -n "$hw_active" ]; then
    # Hardware group active → collapse it
    sed -i "/$hw_start/,/$hw_end/s/^/\/\//" "$CONFIG"
else
    # Collapsed module active → expand hardware
    sed -i "/$hw_start/,/$hw_end/s/^\/\///" "$CONFIG"
fi

# Reload Waybar
pkill -SIGUSR2 waybar
