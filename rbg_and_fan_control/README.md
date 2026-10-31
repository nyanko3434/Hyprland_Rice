# NitroSense on Arch: RGB, fans and Nitro key

How keyboard RGB, fan control and the Nitro key work on **NyaArch** (Arch + Hyprland) on the **Acer Nitro 16 AN16-43**, plus what to do when an update breaks it.

Last working: 2026-10-31 · kernel `7.2.11-arch1-1` · `linuwu_sense` 1.0.2

---

## How it fits together

| Piece | What it is |
|---|---|
| `div-acer-manager-max` (AUR) | DAMX: GUI (`damx`), daemon and driver source, all in one package |
| `linuwu_sense` | Out-of-tree kernel module (DKMS). Replaces the stock `acer_wmi` and exposes the controls in sysfs |
| `damx-daemon.service` | Root daemon the GUI talks to |
| `linuwu_sense` group | Your user must be in it to use the controls |
| Hyprland bind | Nitro key → opens DAMX |

Windows still uses NitroSense. Some settings (keyboard color, battery limit) live in firmware, so they can carry over between the two OSes.

---

## Fresh install

Two things in the AUR package are broken as of this writing, so build it manually:

1. **Linux 7.2 removed `strncpy()`**, and the driver uses it in 3 places, so the build fails.
2. **`makepkg` strips binaries by default**, which corrupts DAMX's .NET single-file GUI. It then fails with `Failure processing application bundle ... Arithmetic overflow while reading bundle`.

```bash
# 1. Get the PKGBUILD and stop makepkg from stripping the .NET binary
yay -G div-acer-manager-max && cd div-acer-manager-max
sed -i '/^arch=/a options=('\''!strip'\'' '\''!debug'\'')' PKGBUILD
grep -n -A1 "^arch=" PKGBUILD            # check the options line is there

# 2. Build and install. The DKMS build WILL fail here with a strncpy error; that's expected
makepkg -si

# 3. Patch the driver and rebuild it (or just run ./fix-damx.sh)
sudo sed -i 's/\bstrncpy(/memcpy(/' /usr/src/linuwu_sense-1.0.2/linuwu_sense.c
sudo dkms install linuwu_sense/1.0.2 -k "$(uname -r)" --force

# 4. Group, then reboot
sudo usermod -aG linuwu_sense "$USER"
reboot
```

Needs `linux-headers` installed. Secure Boot is **off** for Arch, so no key enrollment is needed. If Secure Boot is ever on, the module is signed with `/var/lib/dkms/mok.pub`, and that key must be enrolled with `mokutil --import` before the module will load.

### Why `memcpy` is safe here

All three call sites (`predator_fan_speed_store` and two other store functions) follow the same pattern:

```c
size_t len = min(count, sizeof(input) - 1);
strncpy(input, buf, len);       // → memcpy(input, buf, len);
/* then input[len] or input[len-1] = '\0' by hand */
```

`len` is capped below the buffer size and the string is terminated right after, so `memcpy` does the same job. **If a newer upstream version changes this code, check the pattern again before blindly running the `sed`.**

---

## Check that it works

```bash
lsmod | grep -E "linuwu|acer"        # linuwu_sense present, acer_wmi absent
systemctl status damx-daemon --no-pager
groups | grep -o linuwu_sense
ls /sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi/nitro_sense/
damx                                  # run from a terminal to see errors
```

`nitro_sense/` should list: `backlight_timeout battery_calibration battery_limiter boot_animation_sound fan_speed lcd_override usb_charging version`

---

## Manual control (sysfs)

DAMX is the normal way to control everything, but these files work directly for scripts, keybinds and Waybar.

```bash
BASE=/sys/module/linuwu_sense/drivers/platform:acer-wmi/acer-wmi
```

**Fans:** `CPU,GPU` as a percentage. `0,0` = firmware Auto, `100,100` = max. Avoid `1` (minimum).

```bash
cat $BASE/nitro_sense/fan_speed
echo 50,50 | sudo tee $BASE/nitro_sense/fan_speed
echo 0,0   | sudo tee $BASE/nitro_sense/fan_speed     # back to Auto
```

**Keyboard RGB (4 zones):** `zone1,zone2,zone3,zone4,brightness`, colors as hex with no `#`.

```bash
echo ff0000,00ff00,0000ff,ffffff,100 | sudo tee $BASE/four_zoned_kb/per_zone_mode
```

`four_zoned_kb/four_zone_mode` handles the animated effects; DAMX's GUI is the easiest way to use them.

---

## Nitro key

The Nitro key arrives as `KEY_F16`, which Hyprland sees as the keysym **`XF86Launch7`**.

**keyd grabs the `Acer WMI hotkeys` device** (`/dev/input/event14`) and re-emits its keys through `keyd virtual keyboard`. Because of that, DAMX's `nitro-key-detection` service can't see the key. The key still reaches Hyprland through keyd, so a plain Hyprland bind does the job:

```lua
hl.bind("XF86Launch7", hl.dsp.exec_cmd("damx"))  -- Nitro key (F16)
```

`nitro-key-detection` is **disabled**:

```bash
sudo systemctl disable --now nitro-key-detection
```

**Debugging the key:**

```bash
sudo fuser -v /dev/input/event14      # who has the device open (keyd = grabber)
sudo evtest /dev/input/event21        # keyd virtual keyboard; press the Nitro key
wev                                    # keysym as Hyprland sees it
```

Event numbers can change between boots or devices, so run `sudo evtest` with no argument to list them.

**Alternative**, if the service is ever wanted: exclude the hotkey device from keyd (vendor:product `0000:0000`) in `/etc/keyd/default.conf`, then `sudo keyd reload`:

```ini
[ids]
*
-0000:0000
```

---

## When things break

| Symptom | Cause | Fix |
|---|---|---|
| `dkms install` fails, `make.log` says `implicit declaration of function 'strncpy'` | Package reinstall/upgrade restored unpatched source | `./fix-damx.sh` |
| `damx` → `Failure processing application bundle` | Package was rebuilt **with** stripping | Redo Fresh install step 1–2 (`!strip`), then `./fix-damx.sh` |
| `nitro_sense/` missing after reboot | Module didn't build for the new kernel | `dkms status`, then `./fix-damx.sh` |
| DKMS fails with a *different* error | Another kernel API change | `grep -n -B2 -A3 error /var/lib/dkms/linuwu_sense/*/build/make.log` |
| GUI opens but controls do nothing | Daemon down or not in group | `systemctl restart damx-daemon`, check `groups` (log out/in after `usermod`) |
| Fans ignore commands | Firmware quirk (seen on some Nitros) | Boot Windows once, *reboot* (don't power off) into Arch, then retry |
| Nitro key dead | keyd config or bind changed | See *Nitro key* section |

**Kernel upgrades alone are fine.** The DKMS pacman hook rebuilds from `/usr/src`, which stays patched. Only reinstalling or upgrading `div-acer-manager-max` puts the unpatched source back.

### Recovery script: `fix-damx.sh`

Re-applies the `strncpy` patch (skipped if already applied) and rebuilds the driver. Usage: `./fix-damx.sh` for the running kernel, or `./fix-damx.sh <kernel-version>`.

```bash
#!/usr/bin/env bash
# Re-apply the Linux 7.2 strncpy fix to linuwu_sense and rebuild it via DKMS.
set -euo pipefail

SRCDIR=$(ls -d /usr/src/linuwu_sense-* 2>/dev/null | sort -V | tail -1)
[[ -n "$SRCDIR" ]] || { echo "linuwu_sense source not found in /usr/src"; exit 1; }
VER=${SRCDIR##*-}
SRC="$SRCDIR/linuwu_sense.c"
KVER=${1:-$(uname -r)}

[[ -d "/usr/lib/modules/$KVER/build" ]] || { echo "Missing headers for $KVER (install linux-headers)"; exit 1; }

if grep -q '\bstrncpy(' "$SRC"; then
    echo "Patching strncpy -> memcpy in $SRC"
    sudo cp "$SRC" "$SRC.orig"
    sudo sed -i 's/\bstrncpy(/memcpy(/' "$SRC"
else
    echo "Already patched (no strncpy found)"
fi

sudo dkms install "linuwu_sense/$VER" -k "$KVER" --force
echo "Done. Loaded now? -> lsmod | grep linuwu   (reboot if not)"
```

---

## Upstream

Both fixes should go to the AUR package maintainer: a comment on the [`div-acer-manager-max` AUR page](https://aur.archlinux.org/packages/div-acer-manager-max) with `options=('!strip' '!debug')` and the `strncpy` → `memcpy` change. Once they're merged, this whole workaround becomes unnecessary.

Related projects, if DAMX ever stops working: [ASense](https://github.com/fladirm/asense), which supports the AN16-43 and has its own AUR package and socket API.
