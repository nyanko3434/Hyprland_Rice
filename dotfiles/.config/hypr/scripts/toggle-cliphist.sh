#!/bin/bash

if pgrep -x "wofi" > /dev/null; then
    pkill -x wofi
else
    selection=$(cliphist list | wofi --dmenu)
    [ -z "$selection" ] && exit 0

    echo "$selection" | cliphist decode | wl-copy

    # Give focus time to return to the previous window, then paste into it
    sleep 0.15
    case "$(hyprctl activewindow -j | jq -r '.class')" in
        kitty|Alacritty|foot|org.wezfurlong.wezterm|com.mitchellh.ghostty) mods="CTRL SHIFT" ;;
        *) mods="CTRL" ;;
    esac
    hyprctl dispatch "hl.dsp.send_shortcut({ mods = \"$mods\", key = \"V\" })" > /dev/null
fi
