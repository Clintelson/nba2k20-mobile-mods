#!/bin/bash
# Install the 2026-27 roster (v1.1.0) into NBA 2K20 Android 98.0.2 over USB debugging.
# Changes only the roster inside the main OBB. APK, saves and other game files are untouched.
set -e
cd "$(dirname "$0")/roster-patch"
ADB="${ADB:-$(command -v adb || echo "$HOME/Library/Android/sdk/platform-tools/adb")}"
# Works on macOS/Linux (shasum or sha256sum) and in Termux on the phone itself.
sha_check() { if command -v sha256sum >/dev/null; then sha256sum -c "$1"; else shasum -a 256 -c "$1"; fi; }
PKG=com.t2ksports.nba2k20and
OBB=/sdcard/Android/obb/$PKG/main.98.$PKG.obb
STOCK=e26f52de8101739ee6bc216439d9c25470b31af36b2db19ab251fa15802c3b10
OLD_V06=8c87dec81f313b00bbfca9c2026fb015066820ee4412168fa8560844db7e9c62
TARGET=ec76b8d460f762981c91f3a9e88b372e65e34b9755766cb3157189c4d5c61b32

[ -x "$ADB" ] || { echo "adb not found. Install Android platform-tools or set ADB=/path/to/adb."; exit 1; }
sha_check SHA256SUMS >/dev/null || { echo "Release files are damaged. Re-download them."; exit 1; }
[ "$("$ADB" get-state 2>/dev/null)" = device ] || { echo "Phone not connected/authorized. Computer: enable USB debugging, plug in, tap Allow. Phone only: run adb connect first (see INSTALL-ON-PHONE.md)."; exit 1; }
"$ADB" shell am force-stop $PKG
echo "Checking the phone's game file (about 30 seconds)..."
CUR=$("$ADB" shell sha256sum "$OBB" 2>/dev/null | cut -d' ' -f1)
case "$CUR" in
  $TARGET) echo "Already installed."; exit 0;;
  $STOCK|$OLD_V06) ;;
  *) echo "Unexpected main OBB ($CUR). Needs NBA 2K20 98.0.2 with its original game data. Nothing changed."; exit 1;;
esac
"$ADB" push roster-2026-27.bin toc-entry.bin archive-size.bin /data/local/tmp/ >/dev/null
"$ADB" shell "dd if=/data/local/tmp/roster-2026-27.bin of=$OBB bs=2048 seek=953698 conv=notrunc 2>/dev/null && \
  dd if=/data/local/tmp/toc-entry.bin of=$OBB bs=1 seek=23880 conv=notrunc 2>/dev/null && \
  dd if=/data/local/tmp/archive-size.bin of=$OBB bs=1 seek=40 conv=notrunc 2>/dev/null; \
  rm -f /data/local/tmp/roster-2026-27.bin /data/local/tmp/toc-entry.bin /data/local/tmp/archive-size.bin"
echo "Verifying..."
NEW=$("$ADB" shell sha256sum "$OBB" | cut -d' ' -f1)
[ "$NEW" = "$TARGET" ] && echo "SUCCESS: 2026-27 roster installed." || { echo "Verification failed. Run ./uninstall-roster.sh"; exit 1; }
