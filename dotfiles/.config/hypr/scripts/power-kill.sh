#!/bin/bash

# Check if there is an active window
active_window=$(hyprctl activewindow | grep "Window" | wc -l)

if [ "$active_window" -eq 0 ]; then
    # No active window, check if wlogout is already running
    if ! pgrep -x "wlogout" > /dev/null; then
        # wlogout is not running, launch it
        wlogout
    else
        pkill wlogout
    fi
else
    # Active window exists, kill it
    hyprctl dispatch killactive
fi
