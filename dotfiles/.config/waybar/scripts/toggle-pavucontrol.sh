#!/bin/bash

# Check if pavucontrol is running
if pgrep -x "pavucontrol" > /dev/null; then
    pkill -x "pavucontrol"
else
    pavucontrol &
fi
