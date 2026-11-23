#!/bin/bash
# Restore the original NBA 2K20 roster (undo install-roster.sh).
set -e
cd "$(dirname "$0")/roster-patch"
ADB="${ADB:-$(command -v adb || echo "$HOME/Library/Android/sdk/platform-tools/adb")}"
# Works on macOS/Linux (shasum or sha256sum) and in Termux on the phone itself.
sha_check() { if command -v sha256sum >/dev/null; then sha256sum -c "$1"; else shasum -a 256 -c "$1"; fi; }
PKG=com.t2ksports.nba2k20and
OBB=/sdcard/Android/obb/$PKG/main.98.$PKG.obb
STOCK=e26f52de8101739ee6bc216439d9c25470b31af36b2db19ab251fa15802c3b10
[ "$("$ADB" get-state 2>/dev/null)" = device ] || { echo "Phone not connected/authorized."; exit 1; }
"$ADB" shell am force-stop $PKG
"$ADB" push original-toc-entry.bin original-archive-size.bin /data/local/tmp/ >/dev/null
"$ADB" shell "dd if=/data/local/tmp/original-toc-entry.bin of=$OBB bs=1 seek=23880 conv=notrunc 2>/dev/null && \
  dd if=/data/local/tmp/original-archive-size.bin of=$OBB bs=1 seek=40 conv=notrunc 2>/dev/null && \
  truncate -s 1953173504 $OBB; rm -f /data/local/tmp/original-*.bin"
NEW=$("$ADB" shell sha256sum "$OBB" | cut -d' ' -f1)
[ "$NEW" = "$STOCK" ] && echo "Original roster restored." || echo "Restore did not match the original file ($NEW). Reinstall the game's data to recover."
