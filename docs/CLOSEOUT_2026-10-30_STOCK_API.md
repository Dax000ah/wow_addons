# Stock API correction and intermittent routing investigation — 2026-10-30

## Completed and installed

Group Compass 0.10.0 depended on custom source-selection/status methods added to
private Shortest Path. Its optional guidance getter also required provider-side
support. Those methods were NOT upstream public APIs and violated Tony's clarified
requirement. Corrected in 0.10.2: only upstream API v1 Navigate, CurrentStop, Active,
Cancel and optional Ended are called. No private provider namespace, DB/settings
writes, injected methods, copied engine or unsupported source getter remains.

TomTom/member menu selection uses stock Navigate; member targets are snapshots.
Retry resubmits our target, Stop cancels only our owner. RestedXP opens native
settings and explains Guidance > Follow RestedXP guides > Resume guide. Existing
automatic follower preferences stay configured in Shortest Path; GC cannot switch
them through an API that does not exist. Provider native arrow/compass supplies
turns; the GC bar retains member and TomTom destination bearings. No invented
next-turn marker. Request acceptance is not proof that terrain routing succeeded.
Blizzard tracked quest refers only to the selected native quest's exposed waypoint;
Hardcore lacks this lookup. TomTom/RXP use different inputs and remain available.

Private hc-test.7 removes both app-support modules from source and TOC; only
Hardcore compatibility changes remain in the separate sibling. Forever v1.22.14
was read only and unchanged. No Git mutation or private provider distribution.

## Current hc-test.8 — stitched-map projection repair

Tony supplied a native hc-test.7 report: build 70576, level-4 NightElf Rogue,
Teldrassil 56.0,41.0 to 63.6,35.6; owner player, guided on, settled one-walk plan
66s, no caught errors, RXP following off. This is a player-selected provider route,
not a GC-owned API route. The previous nearby offmesh fixture is not its cause.

Rounded-coordinate replay with bundled zone bounds finds five terrain points,
469.18 yards / 67.03s. Rounding/projection is approximate; native report says66s.
Found a concrete independent bug: UI/OpenMap.lua projected continent/world yards
through C_Map.GetWorldPosFromMapPos, which expects UI-map fractions. OpenMap's
public CanvasFromWorldPos already takes continent/world yards. That unnecessary
conversion can silently return nil or wrongly place lines on the stitched map.
The new regression fails before repair; now passes using the actual installed
OpenMap v1.2.1 API plus Route.lua's resolver and both-map stroke generators.

hc-test.8 passes the existing world point directly to OpenMap's public API.
This is a separate provider/OpenMap bug fix, not an interface added for GC.
GC 0.10.2 stays stock-API-only. Six private suites, real terrain/repeated-journey
checks and 116 installed source hashes pass. The 17th reviewed changed upstream
file is UI/OpenMap.lua; terrain/Planner/API/RXP/TomTom remain unchanged.

The same faulty adapter exists in the read-only installed Forever v1.22.14.
It was NOT modified. GC's API compatibility is verified offline, but an unmodified
Forever + OpenMap rendering pass remains a launch gate; we cannot promise an
upstream drawing bug is absent. No message/issue/PR sent to its maintainer.

Native GC-218 / HC-009 stays OPEN until Tony reloads/reopens maps and repeats
point A, moved start, point B, return to A. If world lines return but minimap
still fails, capture that distinction; this fix only changes world-map projection.
Two inert installed support modules remain unreferenced; prior deletion block
GC-219 is unchanged. No backups, SavedVariables or live Forever writes.

## Files changed this correction

- Runtime: GroupCompass/Routing.lua, RouteMenu.lua, Core.lua, GroupCompass.toc.
- Tests: routing_test.lua, route_menu_test.lua, core_test.lua, maps_test.lua, classic_test.lua;
  removed obsolete guidance_api_test.lua; added fixtures/stock_spf_api.lua.
- Tools: added scripts/check_spf_api.py; updated scripts/check_structure.py.
- Integration: removed integrations/ShortestPathForever/GuidanceAPI.lua; rewrote
  its README.md around the supported contract, no patch-install instructions.
- Docs: README.md, CLASSIC_ROUTING_COMPATIBILITY.md, PROJECT_STATUS.md, TESTING.md,
  project-memory 00_START_HERE.md, 01_PRD.md, 02_DESIGN.md, 03_ACTIONS_AND_TODOS.md,
  04_PROGRESS_AND_DECISIONS.md, drive-manifest.json, archive/2026-10-30_COMPLETED.md,
  prior CLOSEOUT_2026-10-30_ROUTE_TARGETS.md marked superseded, this closeout.
- Private sibling changes are inventoried in STOCK_API_CLOSEOUT_2026-10-30.md:
  removed support modules/tests, updated TOC/verifier/compat tests, added real
  repeated-journey fixture; existing HC compatibility patch retained.
- Generated local dist/GroupCompass-0.10.2.zip validated. Existing worktree edits
  from earlier tasks were preserved. No staging/commit/push.

Final review also retains a failed owned cancellation message across UI polls;
its regression verifies that the next refresh does not hide that failure.

## Checks run

- python scripts/run_tests.py: PASS all 17 Lua 5.1 suites, including strict
  API allowlist rejecting every unsupported access, repeated same-point requests,
  native quest capability, preserved foreign ownership, core status polling,
  menu/settings handoff and existing tracking/map/appearance/TT regressions.
- python scripts/check_spf_api.py "C:/Program Files (x86)/World of Warcraft/
  _forever_/Interface/AddOns/ShortestPathForever": PASS real unmodified v1.22.14
  Core/API.lua composition. Also PASS against pinned original v1.22.9. Both API
  hashes are 2938eaec05b7452ffb5ec665e20e45530fd299bcca9bab1bd6699ae3ccc3e088.
  Journey execution/client services are doubled, not a native route/render test.
- python scripts/check_tomtom_offline.py TOMTOM_DIRECTORY: PASS actual installed
  v4.3.13 registry/API composition; pins and projection are doubled.
- python scripts/build_zip.py: PASS structure, TOC/XML, exact archive/source bytes.
- Private python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools
  --consumer-project ../wow_addons-checkout: PASS five suites, consumer composition,
  116 source files/16 reviewed HC differences/one addition, unchanged 115 originals.
- Private python tools/check_engine.py ShortestPathForever --lua-tools
  ../wow_addons-checkout/.test-tools: PASS actual Nav/Path terrain geometry in
  three areas plus actual Search/Walks with moved origin, replaced/reused goals,
  repeated goal and warm replan. Position/projection/time services are fixtures.
- Native report evidence: docs/research/route-report-2026-10-30.json (added).
- git diff --check: PASS. Diff/call paths reviewed; prior unrelated changes kept.
- Installed GC: PASS all 30 filenames and SHA256 match, no extras. Provider:
  PASS 116 source hashes, 118 files on disk (two inactive extras described below).

## Installation limit

Automatic approval review blocked the command containing deletion of installed
Classic/GuidanceAPI.lua and Classic/RouteSources.lua, without a specific reason.
Safer copying succeeded. Both references are removed from the installed TOC, so
neither module loads after restart. Source contains neither; GC has no dependency
on their functions. GC-219 tracks disk cleanup. No backups or SavedVariables edits.

## Tony's native verification / remaining work

Fully exit/reopen WoW. Right-click cyan icon > TomTom waypoints > point A. Check
both maps, move elsewhere, select B and return to A. No additional Alt-left-click
is needed. Test Retry/owned Stop, party snapshot and the native RXP Resume guide.
Use /path settings to disable automatic RXP following if manual targets should
remain selected through guide-step updates; GC does not change that preference.

GC-218 / HC-009 remains OPEN for native retest. Tony supplied the failed-state
hc-test.7 report during this turn: player-owned settled66s route with no caught
errors. It led to a reproduced independent SPF/OpenMap projection bug, repaired
privately in hc-test.8. The approximate rounded-coordinate replay has five points
and67s; this is not proof of native success. Retest world map/minimap separately,
then report which view still fails. GC-217/HC-008 and unmodified Forever/OpenMap
acceptance remain open. Two inert installed modules await cleanup (GC-219).
