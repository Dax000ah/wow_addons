# Compass appearance 0.9.2 — October 27 closeout

## Completed

The existing options window now has a default Compass tab and a Map markers tab.
Compass contains saved, live sliders for Bar width (horizontal), Bar height
(vertical), and Text size. Each displays its value and minimum/maximum.

Width is 320–1200, height 40–160, text 8–20 UI pixels. The effective height minimum
is also 3 * text size + 16: size 10 needs 46; size 20 needs 76. Raising text grows
a too-short bar and updates the slider range. Lowering text keeps chosen spacing.
Defaults remain 620/46/10. Each text row remains aligned across members. Width
rescales cardinal/member/waypoint/route bearings together. Label collisions and
hover follow the new layout. Font face/flags are preserved. Hidden bars stay
hidden when adjusting settings. Reset defaults resets compass and map appearance.

Map markers retains shapes, independent map sizes, effects, colors and previews.
Waypoints & help, TomTom settings, Done/X/Escape and the launcher remain available.

Installed by copying five changed files into the exact authorized Hardcore
GroupCompass directory, without backups or SavedVariables writes. All 29 installed
file names/counts and SHA-256 values match source. Used the accepted changed-file
update method after the earlier task's directory-clearing policy rejection.
No provider runtime, original Forever, other addon or Git state changed.

## Files changed in this task

Relative to wow_addons-checkout:

- GroupCompass/Settings.lua — saved defaults, ranges, finite-value validation,
  dependent minimum height, migration and reset.
- GroupCompass/Layout.lua — shared dimension/font-dependent row/bearing geometry.
- GroupCompass/Core.lua — cached live size/fonts, shared projection/collision/hover.
- GroupCompass/Options.lua — tabs, three sliders, live callbacks and limit labels.
- GroupCompass/GroupCompass.toc — version 0.9.2.
- tests/settings_test.lua — limits, invalid values, saved migration/persistence/reset.
- tests/layout_test.lua — 78 geometry combinations at extremes/all font sizes.
- tests/core_test.lua — real Settings/Layout/Core composition, fonts, projection,
  hover, hidden changes and reset.
- tests/options_test.lua — tab visibility, callbacks, range clamping/reentrancy,
  unchanged map controls/previews and resets.
- tests/classic_test.lua — font API doubles and expected 0.9.2 startup.
- README.md, docs/TESTING.md — current controls, persistence and manual steps.
- docs/PROJECT_STATUS.md — checkpoint.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-27_COMPLETED.md, drive-manifest.json — memory/archive/native gate.
- docs/CLOSEOUT_2026-10-27_COMPASS_APPEARANCE.md — this report.
- dist/GroupCompass-0.9.2.zip — generated ignored package, source bytes verified.

Earlier uncommitted cardinal/provider documentation and tests were preserved.
No dependency, duplicate runtime module or unused source file was introduced.

## Checks run

- PASS: `python scripts/run_tests.py` — all 17 Lua 5.1 regression suites, including
  changed settings/UI/layout/core behavior and existing map/waypoint/route logic.
- PASS: `python scripts/build_zip.py` — structure, TOC/XML/art inventory, no orphan
  runtime files, ZIP integrity and byte-for-byte source match.
- PASS: `python scripts/check_tomtom_offline.py "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\TomTom"`
  — actual installed v4.3.13 registry/API composition, UI pins doubled.
- PASS (private sibling, no runtime edits):
  `python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools --consumer-project ../wow_addons-checkout`
  — four provider suites, source/syntax audit and Group Compass consumer composition.
- PASS: PowerShell complete installed file-count/SHA-256 comparison: 29 matches.
- PASS: `git diff --check`; runtime diff reviewed against the 0.9.1 package,
  plus Git status/diff inspection. No Git mutations.

All checks are offline. Native slider interaction, font metrics/readability,
UI-scale fit and reload persistence need Tony's review; no in-game pass claimed.
Prior provider map-art/movement/transport/Forever gates remain open.

## Tony's next checks, in order

1. `/reload`, open cyan launcher or `/gcompass options`, choose Compass. Drag each
   slider and confirm visible value/limits and immediate bar change (GC-214).
2. `/gcompass demo`; try smallest width/largest text, then larger height/width.
   Turn and hover to check shared rows, bearings and full crowded-member names.
3. Check Map markers and existing controls, save custom sizes, `/reload`, reopen
   and confirm persistence. Test off/on and Reset defaults (620/46/10).
4. Continue the separate provider world-map retest when convenient (HC-006);
   this appearance change does not close earlier routing acceptance gates.

Requirements, design, progress and completed implementation are mirrored to the
existing Drive project. GC-112 implementation is archived as GC-025; GC-214 stays
active until actual-client verification. Offline Google Docs availability remains
user setup; local Markdown is available without network access.
