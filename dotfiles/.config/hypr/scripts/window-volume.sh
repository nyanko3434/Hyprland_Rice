#!/bin/bash

# Usage: focused-window-volume.sh +0.05 | -0.05 | 0.5
DELTA="${1:-+0.05}"

# Get focused window PID
PID=$(hyprctl activewindow -j | jq -r '.pid')

if [[ -z "$PID" || "$PID" == "null" ]]; then
    exit 1
fi

# Find matching PipeWire stream node by PID
NODE_ID=$(wpctl status | awk -v pid="$PID" '
/Streams:/ {in_streams=1; next}
/Video/ {in_streams=0}
in_streams && /^[[:space:]]*[0-9]+\./ {
    id=$1
    gsub("\\.", "", id)
    current=id
}
in_streams && $0 ~ pid {
    print current
    exit
}')

if [[ -z "$NODE_ID" ]]; then
    exit 0
fi

# Change volume of that stream only
wpctl set-volume "$NODE_ID" "$DELTA"
