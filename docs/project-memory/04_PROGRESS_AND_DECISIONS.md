# Progress, Verification and Decisions — Group Compass

Updated 2026-10-26. Current source, package and installed version: 0.9.0.

## Local check-in authorized — 2026-10-26

Tony reported that things look good in 0.9.0 and explicitly requested a local check-in on 2026-10-26. This is positive general feedback; the detailed native acceptance matrix and SPF provider compatibility remain open. All 17 Lua 5.1 suites, structure validation and Git whitespace checks passed again before check-in. Runtime/install files were unchanged during this checkpoint. Use git log for the resulting commit; no remote push was requested.

## Shared TomTom waypoints — 0.9.0

TomTom is now the sole live waypoint store and map/minimap renderer. Group Compass
reads its exposed point list for the shared top bar; there are no duplicate pins
or Group Compass map-click handlers. New TomTom points automatically exit demo
and enable the live bar. The closest 20 locatable points share the existing member
baseline; points behind the character or in another world have no visible bearing.

Open the cyan button > Waypoints & help. The menu shows TomTom's configured map
shortcut (default Alt + right-click), automatic bar behavior, character-facing help,
an Open world map button and TomTom settings. Edit supplies the missing name and
individual-icon controls; TomTom settings handle its global themes and sizes.
No native rename/icon picker exists in the installed TomTom context menu.

Old Group Compass records are retained unchanged for a one-time API import. Only
confirmed imports are marked; deleting an imported TomTom point does not recreate
it. New and edited points live only in TomTom's current waypoint profile. With
TomTom disabled, group tracking still works, but waypoint controls explain how to
enable it. No independent local waypoint fallback remains.

Names and ten icon textures update through the bridge, with Keep current icon
preserving an existing theme/custom texture/portrait. Rename uses add-first/remove
because TomTom has no rename method; collisions and provider failures keep the
original. Same-name icon refresh keeps the UID and callbacks. Known active arrow
references transfer; an unknown pre-existing arrow asks to be cleared before rename.
Points owned by another addon appear on the bar/list but are edited/removed there.

17 Lua 5.1 suites, actual installed TomTom.lua API composition, structure/package
checks and all 29 installed SHA-256 matches pass. The provider API/registry is real
in that harness, but UI pins/projection remain doubled. Current TomTom v4.3.13 was
re-audited after an in-session update; its TomTom.lua hash matches v4.3.12. Native
clicks, layout, bar movement, migration and persistence remain GC-212. No live
Hardcore golden route or next turn was enabled; SPF compatibility stays separate.

## Historical waypoint naming and icon editor — 0.8.1

Alt + left-click a zone map creates a saved point and immediately opens its editor.
Choose a name and one of ten visual icon tiles, then Save. Existing points open
from Edit in the saved-point list or left-clicking their world-map/minimap icon.
Save updates names on all three views and shapes on both maps. Cancel, X and
Escape discard editor changes; cancelling a newly placed point leaves its default
saved pin. Save my location still accepts a name and its row can then be edited.

Edits preserve ID, coordinates, character storage, route destination and unknown
saved fields. Legacy/missing/invalid saved icons display the gold pin; invalid edit
choices are rejected. Names share the existing 48-character UTF-8 sanitation.
No imported textures, per-waypoint colors or coordinate-moving UI were added.

16 Lua 5.1 suites pass, including real editor + storage composition, lazy map-first
editing, Save/Cancel/Enter/Escape, removal while editing, persistence, capacity,
legacy icons, both map click paths and reused party-marker pass-through. Package
checks pass and all 28 installed files match source SHA-256. Native appearance,
click/focus handling and reload persistence remain GC-211. No live Hardcore route
was enabled; provider compatibility remains separate GC-105/106/210.

## API bridge and received Classic probe — 2026-10-26

0.8.0 implements optional public-API Navigate/Replace/Stop/status and a versioned
next-step consumer. Route points stay on the shared bar baseline; existing map
samples remain unchanged. Missing provider/getter, combat, lost ownership, errors
and invalid/remote data clear or explain the route state. 16 suites, package checks
and 28 installed-file hashes pass. No backups or other addon edits. Native UI and
provider execution remain GC-209/210. GetGuidance provider draft is not installed.

Tony supplied function function nil nil: canaccessvalue/decompression exist; the
checked native waypoint getter and supertracking-priority function do not. Full
Classic provider compatibility remains unproven. Evidence and next port boundaries
are in docs/CLASSIC_ROUTING_COMPATIBILITY.md. This is sufficient for the first probe.

## Earlier routing prototype and testing — 2026-10-24

Tony selected the API approach and accepts waypoint-route combat deferrals.
Prepared an original provider-side GetGuidance prototype with copied, owner-scoped
world targets and guards for inactive/corpse/combat/unavailable states. Not installed
or upstream-supported; the Group Compass bar consumer is still open. All 15 Lua
suites pass. A read-only harness ran real SPF terrain: Shadowglen/Dolanaar-area,
Coldridge/Kharanos-area and Goldshire/Stormwind paths pass. Its real transit planner
also produced a cross-world boat plan with estimated endpoints and no live clocks.
Raw hashes/results and client recommendations are in docs/ROUTING_TEST_RESULTS.md.
Classic probe pending; no full provider port or native integration validation yet.
Beta closed October 23, world launch November 4. No installed addon changed.

## Confirmed current state

- 0.7.0 adds saved personal waypoints across both maps and the compass, using
  native coordinate conversion and existing direction math. Alt-click map placement,
  a simple list/save-here/remove window and commands are implemented. Character
  persistence is separate from appearance settings. 14 suites and 27 installed-file
  hashes pass; native validation remains GC-208.

- Version 0.6.1 changes the minimap launcher to saturated cyan on dark teal with
  its gold rim. All 12 Lua suites, structure/package checks and 25 installed-file
  hashes passed. Native appearance remains part of GC-207.

- Version 0.6.0 implements Tony's head-and-shoulders default and minimap-border
  options button. Ten icons, separate map sizes, None/Glow/Slow flash, class/party/
  preset colors, live previews, saved settings and reset are implemented. 12 Lua
  suites, texture/structure/package checks and 25 installed-file hashes passed.
  Native UI/artwork/persistence remains open under GC-207.

- Version 0.5.2 removes the two combat/instance gates in Tracking.lua. Compass,
  demo, minimap and world-map sampling now depend on usable data. Nine Lua 5.1
  suites, structure/package checks and ten installed-file SHA-256 checks passed.
  Native combat/instance verification remains active under GC-204.

- Tony's screenshot confirms 0.5.0 loading, demo off, and one unavailable member;
  Tony confirmed that member was on another continent. Version 0.5.1 distinguishes
  remote locations using party UI-map continent ancestry and known world-ID
  differences. Nine Lua suites, structure/package checks and ten installed-file
  SHA-256 checks pass for 0.5.1. Native remote-label validation remains open.

- GroupCompass is installed at Tony's requested Classic Era AddOns path.
- Version 0.3.0 static demo was visible in Tony's screenshot. That confirms partial
  native loading/rendering, not real-party tracking or current-version motion.
- Version 0.4.0 introduced fixed simulated world anchors. Version 0.4.1 adds real
  member class-color defaults with names on compass and in map tooltips.
- Latest clean installation contains exactly 29 runtime/texture files; SHA-256 hashes
  match project source. No new backup was created and no other addon folder changed.
- Version 0.5.0 replaces the tall frame with a 620-by-46 UI-unit strip and shared
  horizontal baselines, center cue, restrained background, and full-name hover.
- Tony authorized the initial local check-in on 2026-10-23. The 0.5.2 source,
  tests, instructions and project documentation are included; generated ZIPs and
  local tooling remain ignored. Use git log/status for the resulting commit.
  No remote push was requested. No native validation gate closes by committing.

## Local verification completed

- python scripts/run_tests.py — PASS, 16 Lua 5.1 suites, including routing and guidance API: waypoints, waypoint UI, settings, styles, options, classic startup, client
  compatibility, core UI, movement demo, directions, layout, maps, projection, tracking.
- python scripts/check_structure.py — PASS, both interfaces, TOC references/order,
  XML template syntax and no orphan runtime files.
- python scripts/build_zip.py — PASS, 0.8.0 archive integrity, exact entry names and
  byte-for-byte source agreement.
- PowerShell installation check — PASS, 28 files, source/installed SHA-256 matches.
- git status/diff — 0.6.0 changes are uncommitted after initial 02e0bbe. Tracked
  diff/check passed; new modules/tests/artwork were reviewed directly. No new Git mutations.

Local tests use simulated WoW APIs and cannot prove native XML/mixin loading,
opaque-secret behavior, real-party coordinate availability or final visual layout.

## Decisions and preferences

- D01 | Confirmed | Character-facing compass. Camera-only heading is not available
  through the reviewed API, so camera rotation does not drive member positions.
- D02 | Confirmed | Real members default to class colors, with names. Missing class
  data falls back safely. Demo members remain clearly synthetic.
- D03 | Confirmed | Add custom map/minimap badges without removing native dots.
  World-map custom pins are party-only; compass/minimap include locatable raid members.
- D04 | Updated by Tony, 0.5.2 | No automatic combat/instance pause. Use available
  coordinates; no restricted-data bypass, stale fake bearings or communications fallback.
- D05 | Confirmed | Clean-replace only the exact named GroupCompass install folder,
  no new installation backups. A backup made before this preference remains locally;
  it is not an active workflow and was not uploaded to project memory.
- D06 | Confirmed | Tony wants a thin horizontal slice and every person on the same
  horizontal plane, as in his Enshrouded references. The 0.5.0 strip implements that
  alignment; final height/visual polish still require native review.
- D07 | Confirmed | Durable project memory belongs under ChatGPTStorage / Development
  / Group Compass, with requirements, design, active work and completed archives.

## Release readiness

Code/local checks/installation: complete for 0.7.0. Native moving-demo verification:
pending Tony. Real-party class colors/maps: pending a grouped test. Compact UI:
implemented, awaiting native review. Forever verification: unavailable so far. Do not mark these gates
complete based on the installed-file hashes or simulated tests.
