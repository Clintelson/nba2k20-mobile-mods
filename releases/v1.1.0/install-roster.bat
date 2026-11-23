@echo off
rem Install the 2026-27 roster (v1.1.0) into NBA 2K20 Android 98.0.2. Requires adb (Android platform-tools) on PATH.
setlocal
cd /d "%~dp0roster-patch"
set PKG=com.t2ksports.nba2k20and
set OBB=/sdcard/Android/obb/%PKG%/main.98.%PKG%.obb
set STOCK=e26f52de8101739ee6bc216439d9c25470b31af36b2db19ab251fa15802c3b10
set OLD=8c87dec81f313b00bbfca9c2026fb015066820ee4412168fa8560844db7e9c62
set TARGET=ec76b8d460f762981c91f3a9e88b372e65e34b9755766cb3157189c4d5c61b32
for /f %%s in ('adb get-state 2^>nul') do set STATE=%%s
if not "%STATE%"=="device" (echo Phone not connected/authorized. & exit /b 1)
adb shell am force-stop %PKG%
echo Checking the phone's game file (about 30 seconds)...
for /f %%h in ('adb shell sha256sum %OBB%') do set CUR=%%h
if "%CUR%"=="%TARGET%" (echo Already installed. & exit /b 0)
if not "%CUR%"=="%STOCK%" if not "%CUR%"=="%OLD%" (echo Unexpected main OBB %CUR%. Nothing changed. & exit /b 1)
adb push roster-2026-27.bin toc-entry.bin archive-size.bin /data/local/tmp/ >nul
adb shell "dd if=/data/local/tmp/roster-2026-27.bin of=%OBB% bs=2048 seek=953698 conv=notrunc 2>/dev/null && dd if=/data/local/tmp/toc-entry.bin of=%OBB% bs=1 seek=23880 conv=notrunc 2>/dev/null && dd if=/data/local/tmp/archive-size.bin of=%OBB% bs=1 seek=40 conv=notrunc 2>/dev/null; rm -f /data/local/tmp/roster-2026-27.bin /data/local/tmp/toc-entry.bin /data/local/tmp/archive-size.bin"
for /f %%h in ('adb shell sha256sum %OBB%') do set NEW=%%h
if "%NEW%"=="%TARGET%" (echo SUCCESS: 2026-27 roster installed.) else (echo Verification failed. & exit /b 1)
