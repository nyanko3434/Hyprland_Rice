-- hyprland.lua
-- Entry point — requires all config modules
-- NyaArch | Ryzen 7 8845HS + RTX 4060 | AMD iGPU card2 + Nvidia dGPU card1
-- https://wiki.hypr.land/Configuring/Start/

require("modules.monitors")
require("modules.autostart")
require("modules.env")
require("modules.appearance")
require("modules.input")
require("modules.keybinds")
require("modules.rules")