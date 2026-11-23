# Install the 2026-27 roster using only your phone

No computer and no root needed. This takes about 10 minutes the first time.

**You need:**
- An Android phone with **Android 11 or newer**
- **NBA 2K20 version 98.0.2**, opened at least once so all game data is downloaded
- **Wi-Fi turned on** (wireless debugging needs it, even though nothing is downloaded over it except the mod)

> **Why the extra steps?** The roster lives inside the game's data file, not inside an app. Android doesn't let normal apps change another game's data, so we use **Termux** (a free terminal app) plus Android's built-in **Wireless debugging** to apply the change on your phone.

---

## Step 1: Install Termux

Download Termux from **F-Droid** (<https://f-droid.org/packages/com.termux/>) or the **Termux GitHub releases** page (<https://github.com/termux/termux-app/releases>).

> Don't use the old Play Store version if it gives errors. The F-Droid/GitHub version is the one that's kept up to date.

Open Termux once and wait until you see the `$` prompt.

## Step 2: Turn on Developer options

1. Open **Settings → About phone**.
2. Tap **Build number** 7 times. (On some phones it's under **Software information**.)
3. Enter your PIN if asked. You'll see *"You are now a developer."*

## Step 3: Turn on Wireless debugging

1. Open **Settings → System → Developer options**. (Or search Settings for "Developer options".)
2. Turn on **Wireless debugging** and tap **Allow**.
3. Tap the words **Wireless debugging** to open its page. Keep this page handy.

## Step 4: Install the tools in Termux

In Termux, type this and press Enter. Answer `y` if asked:

```bash
pkg update -y && pkg install -y android-tools git
```

## Step 5: Pair Termux with your phone (one time only)

The pairing code disappears if you leave the Settings screen, so use **split screen**: Settings on top, Termux on the bottom. (Open recent apps, tap the Settings icon, then choose **Split screen**.)

1. In Settings → Wireless debugging, tap **Pair device with pairing code**.
   You'll see a **6-digit code** and an address like `192.168.1.5:37145`.
2. In Termux, type `adb pair` followed by **that address**, then press Enter:
   ```bash
   adb pair 192.168.1.5:37145
   ```
3. Type the **6-digit code** and press Enter.
   You should see **"Successfully paired"**.

## Step 6: Connect

1. On the main **Wireless debugging** page, find **IP address & Port** (e.g. `192.168.1.5:41823`).
   **This port is different** from the pairing port in Step 5.
2. In Termux:
   ```bash
   adb connect 192.168.1.5:41823
   ```
   You should see **"connected to ..."**. If Android asks to allow debugging, tap **Allow**.

## Step 7: Download and install the roster

In Termux, run these three lines:

```bash
git clone https://github.com/Clintelson/nba2k20-mobile-mods
cd nba2k20-mobile-mods/releases/v1.1.0
bash install-roster.sh
```

Wait about a minute. When you see **`SUCCESS: 2026-27 roster installed.`**, you're done.

## Step 8: Play

Open NBA 2K20 and start a **Play Now** game. Try Spurs vs Warriors to see Wembanyama.

You can turn **Wireless debugging** off again after installing.

---

## Undo (go back to the original roster)

Turn Wireless debugging back on, redo **Step 6** (the port changes each time), then in Termux:

```bash
cd nba2k20-mobile-mods/releases/v1.1.0
bash uninstall-roster.sh
```

## Troubleshooting

| Message | What to do |
|---|---|
| `Phone not connected/authorized` | Redo **Step 6**. The port changes every time Wireless debugging is turned off or the phone restarts. |
| `adb pair` fails or the code disappears | Use split screen (Step 5) so the code stays on screen, and type it quickly. |
| `Unexpected main OBB` | Your game isn't version 98.0.2 with its original data, or it isn't fully downloaded. Open the game once, let it finish downloading, and try again. |
| `Release files are damaged` | Delete the folder (`rm -rf ~/nba2k20-mobile-mods`) and run Step 7 again. |
| `Wireless debugging` is missing | Your phone is older than Android 11. Use the computer method in [README.md](README.md) instead. |

**Notes**
- Your MyCAREER and saved leagues keep the roster they were created with. Start a new career, or use Play Now, to get the 2026-27 rosters.
- Only the roster changes. Your app, saves and settings stay as they are.
