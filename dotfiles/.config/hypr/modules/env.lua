-- env.lua
-- Environment variables
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

-- Nvidia dGPU (uncomment if switching to Nvidia rendering)
-- hl.env("LIBVA_DRIVER_NAME",         "nvidia")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("GBM_BACKEND",               "nvidia-drm")
hl.env("NVD_BACKEND",                  "direct")

hl.env("__GL_GSYNC_ALLOWED",           "0")
hl.env("__GL_VRR_ALLOWED",             "0")

-- hl.env("WLR_NO_HARDWARE_CURSORS",   "1")
hl.env("WLR_DRM_NO_ATOMIC",            "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("AQ_FORCE_LINEAR_BLIT",         "0")
hl.env("AQ_DRM_DEVICES",               "/dev/dri/card2:/dev/dri/card1")  -- AMD card2 first, Nvidia card1

-- XDG
hl.env("XDG_CURRENT_DESKTOP",          "Hyprland")
hl.env("XDG_SESSION_TYPE",             "wayland")
hl.env("XDG_SESSION_DESKTOP",          "Hyprland")
hl.env("XDG_MENU_PREFIX",              "arch-")

-- Scaling & cursor
hl.env("GDK_SCALE",                    "5")
hl.env("XCURSOR_SIZE",                 "32")

-- Qt
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR",  "1")
hl.env("QT_QPA_PLATFORM",              "wayland")

-- GTK / cursor themes (uncomment to override)
-- hl.env("GTK_THEME",      "Adwaita:dark")
-- hl.env("XCURSOR_THEME",  "Breeze")
-- hl.env("HYPRCURSOR_SIZE","24")

-- VA-API / VDPAU — AMD iGPU (radeonsi)
hl.env("LIBVA_DRIVER_NAME",            "radeonsi")
hl.env("VDPAU_DRIVER",                 "radeonsi")

-- GNOME Keyring / SSH agent
hl.env("SSH_AUTH_SOCK",                "/run/user/1000/keyring/ssh")
hl.env("GNOME_KEYRING_CONTROL",        "/run/user/1000/keyring")