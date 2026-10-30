# Patched waybar-git

This folder holds my own build of `waybar-git` from the AUR with one patch:
`workspace-click-on-release.patch`.

## Why the patch exists

Hyprland uses `cursor.no_warps = true` (see `dotfiles/.config/hypr/modules/input.lua`),
so the cursor doesn't move when switching workspaces.

Stock Waybar switches workspace on mouse **press**. When the clicked workspace is
on the other monitor, Hyprland moves focus back to the monitor under the cursor
on **release**. The bar then shows the old workspace as active again.

The patch makes Waybar switch on **release** instead, so the click sticks.

## One-time setup (already done once, redo on a fresh install)

Stop pacman/yay from replacing the patched build with the plain AUR one.
In `/etc/pacman.conf`, under `[options]`, set this line (no trailing colon):

```
IgnorePkg   = waybar-git
```

The one-liner that does it:

```
sudo sed -i 's/^#IgnorePkg   =$/IgnorePkg   = waybar-git/' /etc/pacman.conf
```

If more packages need ignoring later, list them separated by spaces on the same line:
`IgnorePkg = waybar-git other-pkg`.

Then build and install it:

```
cd ~/Documents/Projects/Hyprland_Rice/pkgbuilds/waybar-git
makepkg -si --nocheck
```

## Normal system updates

```
yay -Syu --devel
```

Everything updates except Waybar. When upstream Waybar has new commits, yay prints:

```
warning: waybar-git: ignoring package upgrade
```

That's expected. **Don't** run `yay -S waybar-git`, because it would install the unpatched version.

## Updating Waybar

Whenever you want (doesn't have to be every time):

```
cd ~/Documents/Projects/Hyprland_Rice/pkgbuilds/waybar-git
makepkg -si --nocheck
pkill waybar; (waybar &>/dev/null &)
```

This pulls the latest Waybar source and applies the patch again.

If `makepkg` fails with a "patch failed" / "Hunk FAILED" error, upstream changed
`src/modules/hyprland/workspace.cpp` and the patch needs updating. The whole patch
is 3 lines: press → release in the workspace button's click handler.
