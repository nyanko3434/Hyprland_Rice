#!/usr/bin/env bash
mapfile -t sinks < <(pactl list short sinks | awk '{print $2}')
current=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')
idx=-1
for i in "${!sinks[@]}"; do
  [[ "${sinks[$i]}" == "$current" ]] && idx=$i && break
done
next=$(( (idx + 1) % ${#sinks[@]} ))
new="${sinks[$next]}"
pactl set-default-sink "$new"
while read -r input; do
  pactl move-sink-input "$input" "$new"
done < <(pactl list short sink-inputs | awk '{print $1}')
