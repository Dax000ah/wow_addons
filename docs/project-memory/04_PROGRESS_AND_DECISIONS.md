# Progress, Verification and Decisions — Group Compass

Updated 2026-10-23. Current source, package and installed version: 0.5.2.

## Confirmed current state

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
- Latest clean installation contains exactly ten runtime files; SHA-256 hashes
  match project source. No new backup was created and no other addon folder changed.
- Version 0.5.0 replaces the tall frame with a 620-by-46 UI-unit strip and shared
  horizontal baselines, center cue, restrained background, and full-name hover.
- Tony authorized the initial local check-in on 2026-10-23. The 0.5.2 source,
  tests, instructions and project documentation are included; generated ZIPs and
  local tooling remain ignored. Use git log/status for the resulting commit.
  No remote push was requested. No native validation gate closes by committing.

## Local verification completed

- python scripts/run_tests.py — PASS, nine Lua 5.1 suites: classic startup, client
  compatibility, core UI, movement demo, directions, layout, maps, projection, tracking.
- python scripts/check_structure.py — PASS, both interfaces, TOC references/order,
  XML template syntax and no orphan runtime files.
- python scripts/build_zip.py — PASS, 0.5.2 archive integrity, exact entry names and
  byte-for-byte source agreement.
- PowerShell installation check — PASS, ten files, source/installed SHA-256 matches.
- git status --short — project files untracked. git diff --name-only and
  git diff --check have no tracked content; they are not untracked diff validation.

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

Code/local checks/installation: complete for 0.5.0. Native moving-demo verification:
pending Tony. Real-party class colors/maps: pending a grouped test. Compact UI:
implemented, awaiting native review. Forever verification: unavailable so far. Do not mark these gates
complete based on the installed-file hashes or simulated tests.
