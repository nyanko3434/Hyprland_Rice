-- monitors.lua
-- Monitor layout + workspace → monitor assignments
-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

hl.monitor({
    output   = "eDP-1",
    mode     = "highres",
    position = "auto-left",
    scale    = "auto",
})

hl.monitor({
    output   = "HDMI-A-2",
    mode     = "preferred",
    position = "auto-right",
    scale    = "auto",
})