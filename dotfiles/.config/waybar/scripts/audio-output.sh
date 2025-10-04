#!/usr/bin/env bash
default=$(pactl info | awk -F': ' '/Default Sink/ {print $2}')
desc=$(pactl list sinks | awk -v def="$default" '
  $0 ~ "Name: "def {f=1}
  f && /device.description =/ {gsub(/.*= /,""); gsub(/"/,""); print; exit}
')
echo "${desc:-$default}"
