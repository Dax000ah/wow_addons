# Golden-path targets closeout — 2026-10-30

SUPERSEDED by CLOSEOUT_2026-10-30_STOCK_API.md. The custom source/status API
below was not upstream-supported and violated Tony's clarified integration
boundary. Removed in 0.10.2 / hc-test.7; this file preserves historical evidence.

## Completed and installed

Group Compass 0.10.0 right-click opens Golden path targets; left-click retains
options, dragging suppresses both click actions. Choose RXP current step, named
TomTom point or party member's freshly read current location. Member locations
are snapshots, not continuous following. GUID re-resolution avoids stale roster
slots. Unavailable sources explain why; Hardcore's native quest waypoint API is
missing. Status refreshes once a second while open. Retry, Stop, settings and Route
report are included. Availability explanations remain visible until page changes.

Separate private SPF v1.22.9-hc-test.6 supplies optional public source/status API
methods using its existing Navigate, RXP Resume/Refresh, SetOption and journey
methods. Manual selection disables automatic RXP/TomTom-arrow following; choosing
RXP resumes current and subsequent steps. Invalid locations and combat are
rejected. No routing engine or provider DB access is embedded in Group Compass.

Installed in place without backups: all 30 GC and 118 private SPF filenames and
SHA-256 hashes match source, no extras. Fully restart for new TOC modules.
No SavedVariables, TomTom, OpenMapClassic or live Forever addon edits. No Git
mutations or private provider distribution; previous worktree changes preserved.

## Original yellow-dot issue — still open

GC-218 remains OPEN. Settings on disk show RXP following on and TomTom-arrow
following off. A TomTom marker does not automatically request a golden route.
A goal dot can also coexist with a terrain search failure. Three known real
engine searches generate both maps' geometry; approximate endpoints near pictured
Teldrassil 56,41 return offmesh. This is a possible cause, not proof of the exact
live click. No terrain rule was weakened and no safe path was fabricated.
New status/report exposes the live reason for the retest.

## Files changed

GC runtime: GroupCompass/RouteMenu.lua (new), Options.lua, Routing.lua,
Tracking.lua, GroupCompass.toc. Tests: route_menu_test.lua (new), options_test.lua,
routing_test.lua, tracking_test.lua, classic_test.lua. Tool: check_structure.py.
README.md, docs/PROJECT_STATUS.md, TESTING.md, this closeout; project-memory
00_START_HERE.md, 01_PRD.md, 02_DESIGN.md, 03_ACTIONS_AND_TODOS.md,
04_PROGRESS_AND_DECISIONS.md, drive-manifest.json, archive/2026-10-30_COMPLETED.md.
Ignored dist/GroupCompass-0.10.0.zip is current; preliminary archive preserved.

Private sibling: ShortestPathForever/Classic/RouteSources.lua (new), TOC;
tests/route_sources_test.lua and restedxp_sources_test.lua (new); tools/verify.py,
check_engine.py, install.ps1; upstream-manifest.json, generated compatibility.patch,
install-report.json, engine-results-2026-10-30.json, .gitignore, README.md, STATUS.md,
FILES_CHANGED.md and ROUTE_TARGETS_CLOSEOUT_2026-10-30.md. Ignored original release
ZIP and upstream-v1.22.9 directory are immutable verification inputs.
Corresponding dated Drive memory/mirrors and completed implementation archive.

## Verification

- python scripts/run_tests.py: PASS 18 Lua 5.1 suites; menu/status/errors, capability
  explanations, fresh GUID/member snapshots, route guidance, left/right/drag.
- python scripts/build_zip.py: PASS structure, XML/TOC, art, ZIP integrity and all
  archived bytes versus source. No duplicate/orphan runtime introduced.
- python scripts/check_tomtom_offline.py [installed TomTom]: PASS actual v4.3.13
  registry/API. UI/projection remain doubled.
- Private python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools
  --consumer-project ../wow_addons-checkout: PASS seven suites, real RXP bridge/
  selector/consumer integration, manual isolation/guide progression, Lua/XML/TOC,
  118 files, 16 reviewed original compatibility differences and three adapters.
- The original-source audit initially FAILED: live Forever independently updated
  to v1.22.14. Published v1.22.9 recovery matches all 115 existing manifest hashes.
  Verifier now uses the local original reference, preserving old source path,
  release URL and SHA. Validation was not weakened; Forever was not modified.
- Private python tools/check_engine.py ShortestPathForever --lua-tools
  ../wow_addons-checkout/.test-tools: PASS three synchronous/asynchronous terrain
  searches with equal costs and both-map strokes, intercontinental transit and
  the new approximate offmesh refusal. This is not native gameplay validation.
- PowerShell full relative-file/SHA-256 comparisons: PASS 30 GC and 118 SPF files.
- Relevant diff and call paths reviewed; existing unrelated work kept intact.

## Tony's next check

GC-217 / HC-008: fully restart, confirm versions, right-click cyan icon. Alt +
right-click a nearby road to create a TomTom point; select its name in the menu.
Read status after search settles and check both maps. Switch RXP, advance a guide
step, then back to TomTom and a nearby member. Test Retry and Stop. Native quest
locations remain unavailable on Hardcore; no launch compatibility claim.

If only a dot remains, capture the menu status and any fresh Lua error or Route
report (/path report). Reproduce the exact endpoints before changing path/terrain
logic. Prior real-party/transport/Forever gates remain open.
