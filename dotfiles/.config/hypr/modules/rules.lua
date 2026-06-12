-- rules.lua
-- Window rules + workspace → monitor assignments
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-----------------------------
-- Workspace → monitor
-----------------------------

hl.workspace_rule({ workspace = "1", monitor = "eDP-1"    })
hl.workspace_rule({ workspace = "2", monitor = "HDMI-A-2" })

-----------------------------
-- Floating app windows
-----------------------------

-- PulseAudio volume control
hl.window_rule({
    name      = "pulseaudio-volume-control",
    match     = { class = "org.pulseaudio.pavucontrol" },
    float     = true,
    size      = { 710, 450 },
    move      = { 570, 42 },
    immediate = true,
    animation = "popin",
})

-- Network Manager connection editor
hl.window_rule({
    name      = "network-manager-connection-editor",
    match     = { class = "nm-connection-editor" },
    float     = true,
    size      = { 710, 450 },
    move      = { 570, 42 },
    immediate = true,
    animation = "popin",
})

-- Picture-in-Picture
hl.window_rule({
    name      = "picture-in-picture",
    match     = { title = "^(Picture%-in%-Picture)$" },
    float     = true,
    pin       = true,
    immediate = true,
    move      = { "69.5%", "4%" },
})

-----------------------------
-- XWayland drag fix
-----------------------------

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})