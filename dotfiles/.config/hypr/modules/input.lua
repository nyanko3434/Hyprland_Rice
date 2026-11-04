-- input.lua
-- Keyboard, touchpad, gestures, per-device config
-- See https://wiki.hypr.land/Configuring/Basics/Variables/#input

hl.config({
    input = {
        kb_layout          = "us",
        kb_variant         = "",
        kb_model           = "",
        kb_options         = "",
        kb_rules           = "",
        numlock_by_default = true,
        follow_mouse       = 1,
        sensitivity        = 0,  -- -1.0 to 1.0, 0 = no modification
        touchpad = {
            natural_scroll = true,
            scroll_factor  = 0.2,
        },
    },
    cursor = {
        no_warps = true,  -- don't move the cursor when focus/workspace changes
    },
})

-- Gestures
-- See https://wiki.hypr.land/Configuring/Basics/Gestures/
-- Valid actions: workspace, move, float, close, fullscreen, scroll_move
hl.gesture({ fingers = 4, direction = "horizontal", action = "workspace"  })
hl.gesture({ fingers = 3, direction = "swipe",      action = "move"       })
hl.gesture({ fingers = 4, direction = "up",         action = "float"      })
hl.gesture({ fingers = 4, direction = "pinchin",       action = "fullscreen" })

-- Per-device overrides
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})