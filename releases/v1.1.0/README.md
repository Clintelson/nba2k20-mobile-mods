# v1.1.0

Adds the 2026-27 NBA roster to NBA 2K20 Mobile.

## What's new

- **2026-27 rosters:** 30 teams and 518 players, based on the official NBA opening-night rosters (October 19, 2026). Trades after that date aren't included.
- **363 new players** (Wembanyama, Flagg, Castle, Harper, Podziemski and others), each with their own name, position, height, weight, attributes and 2026-27 age.
- **Player models:** every new player uses a complete in-game model. Faces come from 2019-20 players who aren't on a current roster, matched on skin tone and build, with no face used more than twice. Faces are approximations, not real likenesses.
- Fixes the missing-head / white-body bug from the earlier test roster.

## Compatibility

- **Game version:** 98.0.2 (`com.t2ksports.nba2k20and`), Android only, 64-bit (arm64) phones
- **Game data:** the original `main.98.com.t2ksports.nba2k20and.obb`. Any other data file is left untouched.

## Install: pick one of 3 ways

| | Easiest | Keeps your saves? | Needs |
|---|---|---|---|
| **A. Install the APK** | ✅ Just install | ⚠️ Only if you already have the v1.0.0 mod | Nothing extra |
| **B. Phone only** | 10 min setup | ✅ Yes | Android 11+, Termux |
| **C. With a computer** | 5 min | ✅ Yes | Windows/Mac/Linux + USB cable |

---

### A. Install the APK (easiest)

`apk/NBA2K20-Mobile-Mod-v1.1.0.apk` includes **everything**: the 2026-27 roster plus all v1.0.0 mods (MyCAREER coaching/substitutions, unlimited money, badges, boosted players). The roster installs **by itself the first time you open the game**.

> ## ⚠️ READ THIS FIRST: your data may be deleted
>
> **If you have the original (unmodded) NBA 2K20 installed**, Android won't install this APK over it. You must **uninstall the original game first**, and uninstalling **deletes all your progress**: MyCAREER, saved leagues and settings. **You will start completely new.**
>
> Uninstalling also removes the game's **data files** (the large OBB download). Before uninstalling, make sure you can put the game data back the same way you first got it.
>
> **If you already have the v1.0.0 mod installed**, nothing is deleted. Just install v1.1.0 over it as an update and keep all your progress.
>
> Want to keep your saves on the original game? Use **B** or **C** instead.

**Steps**

1. **Coming from the original game:** uninstall NBA 2K20. *(Coming from the v1.0.0 mod: skip this step.)*
2. Download and open `NBA2K20-Mobile-Mod-v1.1.0.apk`. If Android warns about unknown apps or Play Protect, choose **Install anyway**.
3. Make sure the game data is in place (`Android/obb/com.t2ksports.nba2k20and/`), the same way as for any NBA 2K20 98.0.2 install.
4. Open the game. The 2026-27 roster is applied automatically on launch. If the game data wasn't there yet, it's applied the next time you open the game.
5. Try **Play Now**, e.g. Spurs vs Warriors.

---

### B. Phone only (keeps your saves)

Follow **[INSTALL-ON-PHONE.md](INSTALL-ON-PHONE.md)**. It uses Termux and Android's Wireless debugging to add the roster to your current game. Only the roster changes; your app and saves stay.

---

### C. With a computer (keeps your saves)

1. Install NBA 2K20 98.0.2, open it once so the game data finishes downloading, then close it.
2. On the phone, enable **Developer options → USB debugging**, connect it to your computer, and tap **Allow**.
3. Run the installer from this folder:
   - macOS/Linux: `./install-roster.sh`
   - Windows: `install-roster.bat` (needs `adb` on PATH; not yet tested on Windows)
4. Wait for `SUCCESS`, then open the game and try **Play Now**.

To go back to the original roster: `./uninstall-roster.sh`

B and C only add the roster. For the gameplay mods too, also install the APK (A).

## Notes

- Existing MyCAREER and saved-league files keep the roster they were created with. Start a new career, or use Play Now, to get the 2026-27 rosters.
- Starting lineups and minutes are approximate.

## Files

- `apk/NBA2K20-Mobile-Mod-v1.1.0.apk`: the full mod (way A). SHA-256 `d362654e936902ec6cbacf41612db2957ef797078f237000b465337bcce50a78`
- `apk/source/RosterPatcher.java`: source of the small add-on that installs the roster on launch. It only writes to the game's own data file, and only if that file is the original 98.0.2 data; otherwise it does nothing.

- `roster-patch/roster-2026-27.bin`: the updated roster data
- `roster-patch/toc-entry.bin`, `archive-size.bin`: the OBB index changes the installer writes
- `roster-patch/original-*.bin`: the original values, used by the uninstaller
- `roster-patch/SHA256SUMS`: checksums the installer verifies

The game's data files (OBB) aren't included.
