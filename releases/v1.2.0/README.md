# v1.2.0

MyCAREER Team Practice, unlocked equipment and store fixes. Includes everything from v1.1.0 (2026-27 roster) and v1.0.0 (boosted players, coaching, unlimited money, badges).

## What's new

- **Team Practice:** 2K NAV → Practice → Shoot Around now asks *"Are you sure this is how you want to spend your off-day?"*
  - **Yes** starts a Team Practice drill with your teammates (e.g. Screen and Read).
  - **No** starts the normal Shoot Around.
- **All equipment unlocked:** shoes, arm and leg items that said *"Unlock in My Career Connections"* can now be bought with VC. You still have to buy them.
- **Prices for former Connections rewards:** these items had no store price (they showed 0 VC). They now cost the same as the store's other items with the same boost: +1 = 1,500, +2 = 4,000, +3 = 9,000 VC. Animations, rituals and uniforms that were rewards get the store's typical price for their category.
- **Animation icons fixed:** Layups, Free Throws and Rituals now show their own icons in the Store.

## Install

**Coming from v1.0.0 or v1.1.0:** install `apk/NBA2K20-Mobile-Mod-v1.2.0.apk` over your current game as an update. Nothing is deleted and your career, saves and the 2026-27 roster stay.

**Coming from the original game:** follow the APK steps and data warning in the [v1.1.0 README](../v1.1.0/README.md#a-install-the-apk-easiest) (uninstalling the original deletes your progress).

## Notes

- Badges: the mobile game has 44 badges in total, and the mod already gives all 44. There are no more badges to unlock.
- Starting Team Practice from this menu doesn't use up an off-day. The calendar's off-day practice is unchanged.
- Tested on an Android phone with an existing MyCAREER: Team Practice (Yes and No), Equipment prices and Store icons.

## Compatibility

Same as v1.1.0: game version 98.0.2 (`com.t2ksports.nba2k20and`), Android, 64-bit (arm64).

## Files

- `apk/NBA2K20-Mobile-Mod-v1.2.0.apk`: the full mod. SHA-256 `f7df970311b7ec25205717d7f52a88eaa260a6e4f1caf09d1fd5404c38bff254`
- `apk/source/`: the patch sources. `build_v1.2.0.py` applies them to the v1.1.0 APK's game library (assemble the two `.s` files with `clang --target=aarch64-linux-gnu -c` first), then the APK is aligned and signed with the same key as earlier releases:
  `python3 build_v1.2.0.py ../../../v1.1.0/apk/NBA2K20-Mobile-Mod-v1.1.0.apk unsigned.apk fix '{"A":1031886470,"B":2749743909,"C":3571643315}'`
