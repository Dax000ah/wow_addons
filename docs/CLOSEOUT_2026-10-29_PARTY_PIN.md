# Party-pin crash closeout — 2026-10-29

## Completed

Group Compass 0.9.4 fixes the reported MarkerStyle.lua:13 nil-fill crash. Blizzard
resets a newly allocated map pin before its OnLoad creates the marker artwork.
Cleanup now handles that expected uninitialized state without allocating artwork
early or skipping normal animation cleanup. The map exception could also prevent
Core from reaching member-name rendering later in the same refresh.

OpenMapClassic's installed WorldMap.lua:524 switches viewed maps. It exposes the
failure in our provider; there is no evidence that its code clears our textures.
No third-party code was changed. Sources for the lifecycle order:
- https://github.com/Gethe/wow-ui-source/blob/classic_era/Interface/AddOns/Blizzard_SharedXMLBase/Pools.lua
- https://github.com/Gethe/wow-ui-source/blob/classic_era/Interface/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua

## Files changed for this task

- GroupCompass/MarkerStyle.lua: handle reset before fill texture exists.
- GroupCompass/GroupCompass.toc: 0.9.3 to 0.9.4.
- tests/maps_test.lua: realistic pre-OnLoad reset and pool reuse; actual compass/
  map composition across party joins/leaves and zone/world map changes.
- tests/classic_test.lua: startup version assertion for 0.9.4.
- README.md: current startup version.
- docs/PROJECT_STATUS.md and docs/TESTING.md: checkpoint and GC-216 instructions.
- docs/project-memory/00_START_HERE.md, 03_ACTIONS_AND_TODOS.md,
  04_PROGRESS_AND_DECISIONS.md and drive-manifest.json: current memory/checkpoint.
- docs/project-memory/archive/2026-10-29_COMPLETED.md: implementation archive.
- This closeout; ignored dist/GroupCompass-0.9.4.zip is the verified release.
- Corresponding dated Drive memory/mirrors and current package are updated.

Pre-existing uncommitted 0.9.1–0.9.3 work remains intact. No staging, commits,
pushes, branch changes, provider, OpenMapClassic or SavedVariables edits.

## Checks run

- Focused maps_test.lua via project .test-tools/lupa.lua51: FAILED with the exact
  nil-fill stack before the runtime change; PASSED afterward.
- python scripts/run_tests.py: PASSED all 17 Lua 5.1 suites. New test executes the
  real Core/Maps modules with doubled WoW frames and supplied party coordinates.
- python scripts/check_tomtom_offline.py against installed TomTom: PASSED actual
  v4.3.13 registry/API composition; UI/projection remain doubled.
- python scripts/build_zip.py: PASSED structure, TOC/XML, texture checks, ZIP
  integrity and every archived file's byte equality with current source.
- PowerShell full source/install filename and SHA-256 comparison: PASSED all 29
  installed files, no extras. Directory clearing was rejected by automatic
  approval review (blocked by policy); copying in place succeeded, no backups.
- Final relevant Git diff reviewed; no duplicate or obsolete runtime introduced.

## Tony's next check / remaining work

GC-216 is READY TO VERIFY. /reload, confirm 0.9.4, demo off, /gcompass on. Join a
nearby friend outdoors on the same continent and face them. Verify the bar and
both maps, open/close/zoom/pan with OpenMapClassic enabled, then leave/rejoin.
If the friend remains absent, capture /gcompass status and any fresh Lua error.

This reproduces and fixes the reported crash offline; native gameplay is not
claimed as passed. Coordinate restrictions, different continents and the forward
180-degree view still apply. Prior routing/Forever acceptance gates remain open.
First priority is the real-party retest, then the previously recorded native gates.
