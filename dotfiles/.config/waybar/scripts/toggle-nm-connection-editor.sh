#!/bin/bash

# Find the PID of the nm-connection-editor process
PID=$(pgrep -f -o nm-connection-editor)

if [ -n "$PID" ] && [ "$PID" != "$$" ]; then
    kill "$PID"
else
    nm-connection-editor &
fi
