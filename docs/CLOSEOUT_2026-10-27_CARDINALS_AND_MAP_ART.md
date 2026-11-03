# October 27 closeout — compass headings and private map-art fix

## Completed

Group Compass 0.9.1 adds gold N/E/S/W on the same character-facing angular scale
as members. Headings have their own row inside the existing 620-by-46 frame.
Names, ticks and distances each retain their shared row. Solo display requires
only readable facing; unavailable coordinates do not hide headings. Secret,
nil and nonfinite heading values cannot reach the direction calculation.

Tony confirmed a gold line on the Hardcore minimap, then hit StopPin.lua:107
opening the world map. The separate private provider hc-test.4 fixes the missing
Forever atlas assumption. Its existing round dot supplies missing goal/ring/button
art, with contrasting font stop numbers. Available native art keeps its aspect
and numeral grid. Provider compatibility remains outside Group Compass.

Installed into the two previously authorized exact Hardcore addon directories.
Automatic approval review rejected the directory-clearing install command with
“blocked by policy”; no more specific reason was supplied. A safer copy of four
changed files per addon succeeded. Complete file counts and every SHA-256 match
source: GroupCompass 29, ShortestPathForever 117. No stale files or backups.
No SavedVariables/WTF, original Forever, other addon, Git state or distribution
changes. Existing documentation changes were preserved, including October 26's
archive. Implementation is ready for use; native checks below remain open.

## Files changed in this task

Paths relative to wow_addons-checkout:

- GroupCompass/Core.lua — heading row, compact row spacing, solo baseline.
- GroupCompass/Direction.lua — shared normalized relative-bearing function.
- GroupCompass/Tracking.lua — guarded coordinate-independent heading reader.
- GroupCompass/GroupCompass.toc — version 0.9.1.
- tests/core_test.lua — all headings/turns/wrap, solo/demo/off, stale clearing.
- tests/tracking_test.lua — missing coordinates and invalid/secret heading checks.
- tests/classic_test.lua — actual TOC version in startup fixture.
- README.md, docs/TESTING.md — behavior and exact native steps.
- docs/CLASSIC_ROUTING_COMPATIBILITY.md, docs/PROJECT_STATUS.md — current evidence.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-27_COMPLETED.md, drive-manifest.json — memory and open gates.
- docs/CLOSEOUT_2026-10-27_CARDINALS_AND_MAP_ART.md — this report.
- dist/GroupCompass-0.9.1.zip — generated ignored release artifact.

Private sibling shortest-path-hardcore-test files changed:

- ShortestPathForever/UI/StopPin.lua — missing destination/stop art handling.
- ShortestPathForever/Classic/Compat.lua — shared goal-art fallback.
- ShortestPathForever/UI/Route.lua — same fallback for minimap goal/ring.
- ShortestPathForever/ShortestPathForever.toc — hc-test.4.
- tests/stop_pin_test.lua — actual Art/StopPin profiles and pooled reuse.
- tools/verify.py — allow audited StopPin change; automatically runs new suite.
- tools/install.ps1 — current version in first-install receipt.
- README.md, STATUS.md, FILES_CHANGED.md,
  MAP_ART_FIX_CLOSEOUT_2026-10-27.md — private documentation.
- compatibility.patch, install-report.json — generated audit/install evidence.

Earlier source/notes are retained; there is no new dependency or orphan runtime
file. No compatibility logic was added to the Group Compass consumer.

## Checks run

- PASS: `python scripts/run_tests.py` — all 17 Lua 5.1 suites, including new
  cardinal cases, existing member/waypoint/route/map/UI lifecycle and Classic load.
- PASS: `python scripts/build_zip.py` — structure, TOC/XML/art inventory, no
  orphan runtime modules, ZIP integrity and byte-for-byte packaged source.
- PASS: `python scripts/check_tomtom_offline.py "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\TomTom"`
  — actual installed v4.3.13 registry/API composition; UI pins doubled.
- PASS in private workspace:
  `python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools --consumer-project ../wow_addons-checkout`
  — four suites, all Lua syntax/TOC/XML, actual provider Guide/API/consumer,
  strict event registry, watchdog/cancellation/penalty equivalence and map art.
  The new art test failed against the prior source before the repair.
- PASS in private workspace:
  `python tools/check_engine.py ShortestPathForever --lua-tools ../wow_addons-checkout/.test-tools`
  — three terrain searches, asynchronous/synchronous cost equality, both maps'
  stroke geometry, missing-world nodata and estimated cross-world plan.
- PASS: PowerShell full file-count and SHA-256 comparisons against both installs.
- PASS: `git diff --check`, status and focused runtime/test diff review.
- PASS: private verification checks all 115 original Forever SHA-256 values
  against the pinned manifest; originals remain unchanged.

All automated checks are offline. UI services/projection are doubled; timings
from the budget fixture are simulated. These do not prove gameplay or native UI.

## Tony's next checks, in priority order

1. `/reload`, reopen the same world map. Check gold path and destination mark,
   close/reopen and zoom; try numbered guide stops. Report the first new error.
   HC-006 / GC-111 remain open until observed in game.
2. `/gcompass on`, turn your character through a full circle while solo and in
   `/gcompass demo`. N/E/S/W should slide with member bearings; north centered
   shows W left, E right. Check readability at your UI scale. GC-213 remains open.
3. Continue RXP/manual navigation, movement, bends, arrival, replacement and
   combat resume. One observed minimap line does not close HC-002/005 or GC-210.
4. Audit transport differences before cross-continent acceptance, then repeat
   with unmodified Forever at launch. HC-003/004 remain open.

Drive project memory and Markdown mirrors are updated separately from local
source. They are dated snapshots; Google Docs offline mode remains user setup.
