#!/bin/bash

mapfile -t SINKS < <(pactl list short sinks | cut -f2)
DEFAULT_SINK=$(pactl info | awk -F': ' '/Default Sink/{print $2}')
len=${#SINKS[@]}

for ((i=0; i<len; i++)); do
    if [[ "${SINKS[i]}" == "$DEFAULT_SINK" ]]; then
        next=$(( (i + 1) % len ))
        pactl set-default-sink "${SINKS[next]}"
        break
    fi
done
