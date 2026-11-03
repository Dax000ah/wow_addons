# Elsewhere 0.11.1 — implementation and installation closeout

Implemented remote member and TomTom waypoint labels below the compass. Default
ON; cyan minimap left-click > Compass > Show Elsewhere line (remote members and
points). /gcompass options reaches the same checkbox. It applies immediately,
saves OFF across reload, and Reset defaults turns it ON. No separate bearing,
distance or map pin is generated for remote locations.

The original strip size remains the setting; one font-size +7 row is added below
it only when remote entries exist. It stays visible with local markers, summarizes
crowded names, and lists up to20 full remote entries in hover plus overflow count.
Member labels depend on readable continent/world data; unknown/offline locations
remain unavailable rather than being guessed remote. Remote waypoint UI-map names
are preferred; absent names fall back to Different world area when separation is
known. UI-map ancestry can identify remote locations without player facing.

Checkpoint before edits: clean main at313f893. No new commit or push requested for
this feature. Changed files (relative to repository root):

- GroupCompass/Core.lua
- GroupCompass/GroupCompass.toc
- GroupCompass/Options.lua
- GroupCompass/Settings.lua
- GroupCompass/Tracking.lua
- GroupCompass/Waypoints.lua
- README.md
- docs/NAVIGATION_GUIDE.md
- docs/PROJECT_STATUS.md
- docs/project-memory/00_START_HERE.md
- docs/project-memory/01_PRD.md
- docs/project-memory/02_DESIGN.md
- docs/project-memory/03_ACTIONS_AND_TODOS.md
- docs/project-memory/04_PROGRESS_AND_DECISIONS.md
- docs/project-memory/archive/2026-11-03_COMPLETED.md
- docs/project-memory/drive-manifest.json
- scripts/check_tomtom_offline.py
- tests/classic_test.lua
- tests/core_test.lua
- tests/options_test.lua
- tests/settings_test.lua
- tests/tomtom_test.lua
- tests/tracking_test.lua
- tests/waypoint_ui_test.lua
- tests/waypoints_test.lua
- docs/ELSEWHERE_0.11.1.md (this closeout)

Checks run:

- python scripts/run_tests.py — PASS all18 Lua5.1 suites, including new mixed local/
  remote, fit/font/hover, checkbox/defaults/false persistence, clearing and demo cases.
- python scripts/check_structure.py — PASS TOC/order, XML/art and no orphan runtime files.
- python scripts/check_spf_api.py "C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever"
  — PASS actual unmodified public API and stock RXP adapter composition.
- python scripts/check_tomtom_offline.py against Forever/TomTom — initially refused
  newly installed4.4.0 at the intentional version gate. Read the new registry and
  integration contract; adapted the TEST harness to core/waypoints.lua, reran PASS.
  Same API consumer/runtime bridge, no provider edits or weakened assertions.
- Same TomTom command against Hardcore/TomTom4.3.13 — PASS actual registry/API.
- python scripts/build_zip.py — PASS31 files, integrity and byte-for-byte source match.
- Installed only two exact GroupCompass folders (Hardcore/Forever); all31 source
  hashes match each. No backup, deletion of user data, SavedVariables or third-party
  writes. All4,756 captured dependency files match pre-install hashes.
- git diff --check — PASS. Final runtime diff reviewed; existing mappings, route
  requests and provider settings unchanged. Test doubles updated to compose shared
  map-name resolver; no tests disabled or provider-private runtime reads introduced.

WoW frames, map projection and callback services are doubled in offline tests;
these results do not establish native visual or unmodified Forever acceptance.

Tony's next checks (GC-221 open):

1. /reload; confirm /gcompass status reports0.11.1. Keep demo OFF.
2. With the current Stormwind TomTom point and player in Darnassus, look immediately
   beneath the strip for Elsewhere. It should remain with local markers visible.
3. Hover the strip/row for remote names. Change width/text size and inspect fit.
4. Cyan left-click > Compass: uncheck Show Elsewhere line. It should disappear
   immediately; /reload should retain OFF. Re-enable it and verify it returns.
5. Remove/move a remote point or bring a remote member to the same world and verify
   that entry clears. Missing API data must not leave stale names or fake bearings.
6. After any reload, /path > Guidance > RestedXP guide > Resume guide (bottom red
   button) refreshes [RXP]. Keep Follow RestedXP guides ON and Follow TomTom's arrow
   OFF for guide navigation. Reload clears our observed guide request; stock API
   has no getter to recover it. Tony confirmed toggling following refreshed it.

Remaining: GC-221 native visual/toggle checks, GC-220 guide-step/hidden-arrow checks,
and unmodified Forever end-to-end acceptance. Arbitrary native Shortest Path goals/
next turns are still outside the public API. Private HC provider base is still old;
no upgrade or provider support patch was made in this task.

## Approved checkpoint — November3

Tony approved the current0.11.4 visuals/work and requested check-in of Elsewhere
and the associated menu/help changes. Included in milestone 'Milestone: Elsewhere
indicators and navigation help'. Earlier uncommitted-state notes are historical.
Re-ran all18 suites, structure, stock SPF API/RXP and both audited TomTom registry
checks: PASS. Diff check PASS. No new runtime/install changes or push. Full native
Forever acceptance and detailed manual checks remain open; direct GC Resume still
requires upstream public support. Inspect git log for this checkpoint's hash.
