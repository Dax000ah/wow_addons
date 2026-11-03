# Completed Implementation and Evidence Archive — 2026-10-29

## GC-028 — First party-pin initialization crash, 0.9.4

Reproduced Tony's MarkerStyle.lua:13 nil-fill failure by correcting the map pool
test to run its reset callback before OnLoad. Blizzard's ObjectPool Acquire calls
reset on a new frame; MapCanvas's reset invokes the pin's OnReleased before
AcquirePin calls OnLoad. The marker textures do not exist yet. Stop now checks
fill before resetting its alpha and still stops any existing flash animation.

All 17 Lua 5.1 suites pass, including first acquisition, recycling, map changes,
three party join/leave cycles and actual Core/Maps member-label composition.
Actual installed TomTom v4.3.13 API composition, structure and 0.9.4 ZIP/source
checks pass. All 29 installed file names/hashes match. Directory clearing was
blocked by automatic approval review; in-place copy passed without backups.

Only implementation/offline verification is complete. Tony must verify the
nearby real-party compass and OpenMapClassic map lifecycle as GC-216. Previous
coordinate, map, routing and Forever acceptance gates remain open. No provider,
Forever, SavedVariables or Git-state mutations were performed.
