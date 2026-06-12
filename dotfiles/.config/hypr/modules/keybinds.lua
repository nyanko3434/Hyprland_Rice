-- keybinds.lua
-- All keybindings
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

local home = os.getenv("HOME")

-- Programs / scripts
local terminal               = "kitty"
local fileManager            = "dolphin"
local menu                   = home .. "/.config/hypr/scripts/toggle-wofi.sh"
local toggle_waybar          = home .. "/.config/hypr/scripts/toggle-waybar.sh"
local random_wallpaper       = home .. "/.config/hypr/scripts/random-wallpaper.sh"
local power_kill             = home .. "/.config/hypr/scripts/power-kill.sh"
local toggle_hardware_overlay = home .. "/.config/waybar/scripts/toggle_hardware.sh"
local switch_default_sink    = home .. "/.config/hypr/scripts/switch-default-sink.sh"
local window_volume          = home .. "/.config/hypr/scripts/window-volume.sh"
local toggle_cliphist        = home .. "/.config/hypr/scripts/toggle-cliphist.sh"

-- Modifier aliases
local mainMod = "SUPER"
local secMod  = "ALT"

-----------------------------
-- Applications & launchers
-----------------------------

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(toggle_waybar))
hl.bind(secMod  .. " + P", hl.dsp.exec_cmd(random_wallpaper))
hl.bind(secMod  .. " + R", hl.dsp.exec_cmd(toggle_hardware_overlay))

-----------------------------
-- Power / session
-----------------------------

hl.bind(secMod  .. " + F4",        hl.dsp.exec_cmd(power_kill))
hl.bind(mainMod .. " + l",         hl.dsp.exec_cmd("swaylock"))
-- MIGRATION_NOTE: hl.dsp.exit() removed in 0.55 — use uwsm stop instead
hl.bind(mainMod .. " + M",         hl.dsp.exec_cmd("uwsm stop"))

-----------------------------
-- Clipboard
-----------------------------

hl.bind(mainMod .. " + V",         hl.dsp.exec_cmd(toggle_cliphist))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist wipe"))

-----------------------------
-- Window management
-----------------------------

hl.bind(mainMod .. " + B", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))  -- dwindle only

-----------------------------
-- Screenshots
-----------------------------

hl.bind("PRINT",             hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("SHIFT + PRINT",     hl.dsp.exec_cmd("hyprshot -m window"))

-----------------------------
-- Focus movement
-----------------------------

hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-----------------------------
-- Workspaces (1–10)
-----------------------------

for i = 1, 10 do
    local key = i % 10  -- 10 → key 0
    hl.bind(mainMod .. " + "         .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move / resize with mouse drag
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-----------------------------
-- Volume
-----------------------------

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86Launch6",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- Per-window volume
hl.bind(secMod .. " + F3", hl.dsp.exec_cmd(window_volume .. " +0.05"), { locked = true, repeating = true })
hl.bind(secMod .. " + F2", hl.dsp.exec_cmd(window_volume .. " -0.05"), { locked = true, repeating = true })

-- Default sink switcher
hl.bind("SHIFT + F1", hl.dsp.exec_cmd(switch_default_sink), { locked = true })

-----------------------------
-- Brightness
-----------------------------

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Color temperature (hyprsunset)
hl.bind(secMod .. " + F5", hl.dsp.exec_cmd("hyprctl hyprsunset temperature +500"), { locked = true, repeating = true })
hl.bind(secMod .. " + F6", hl.dsp.exec_cmd("hyprctl hyprsunset temperature -500"), { locked = true, repeating = true })

-----------------------------
-- Media keys
-----------------------------

hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })