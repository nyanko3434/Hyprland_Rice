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
