# Completed Implementation and Evidence Archive — 2026-10-26

## GC-021 — Private provider unknown-event startup fix

Reproduced Tony's unknown SUPER_TRACKING_CHANGED error in the actual Journey.lua
and FlightPins.lua initializers with a strict rejecting event registry. Guarded
three optional native-navigation registrations, including USER_WAYPOINT_UPDATED,
through a provider-local event-support helper. Required events stay strict;
unexpected errors remain visible. Supported, unsupported and no-query profiles
plus the existing real guide/API/unchanged consumer composition pass.
hc-test.2 installed by updating four private files, all 117 SHA-256 matches pass.
Native retest remains HC-001; no golden-path/gameplay pass is archived here.

## GC-020 — Separate private provider test build prepared and installed

Tony authorized a local, undistributed Hardcore copy of SPF v1.22.9 outside this
checkout. The sibling shortest-path-hardcore-test workspace retains 115 original
file hashes, attribution/licences and a reviewable compatibility.patch. Nine
original files and two adapter additions cover native navigation fallback,
minimap/map/cooldown/flight compatibility and private read-only next-turn output.
No engine, nav or stroke code was changed. Group Compass runtime and installed
Forever remain unchanged; no Git init, commit, push or distribution.

Private syntax/structure, real Guide/Arrow/API and unchanged consumer composition
pass, as do three actual terrain/both-map stroke cases and a limited estimated
cross-world planner check. First install into Hardcore ShortestPathForever matches
all 117 source SHA-256 values. Only implementation and offline verification are
archived here. Native load/routes/movement/transports/launch checks remain active
as GC-105/106/210 and private HC-001–HC-004; none is marked a native pass.

## GC-017 — Native probe and optional routing API bridge 0.8.0

Recorded Tony's exact function function nil nil screenshot: access/decompression
helpers exist; the checked native waypoint getter and tracking-priority method do
not. Audited SPF's unguarded uses; no full Classic port claim follows.

Implemented optional Navigate/Replace/Stop/status controls, owner-scoped lifecycle,
provider errors/missing/version/rejection states and the proposed guidance consumer.
Shared-baseline cyan next step uses same-world direction math; no route point is
fed into party/map samples. Combat deferrals accepted for routes; group tracking
continues. Removed points/off/demo stop only our route; cancellation failures stay
visible. Contract composition passes with native navigation APIs absent.

All 16 Lua 5.1 suites, structure/package checks and 28 installed-file SHA-256
matches pass. Clean-replaced only Classic GroupCompass, no backup or new dependency.
Existing worktree preserved, no Git mutations or SPF edits. Native UI/provider
checks remain GC-209/210; supported getter and full Classic port remain GC-105/106.
Detailed evidence/files/checks: docs/PROJECT_STATUS.md and
 docs/CLASSIC_ROUTING_COMPATIBILITY.md. Do not archive those native gates as complete.

## GC-018 — Waypoint naming and icon editor 0.8.1

Implemented ten preview tiles, explicit Save/Cancel and Enter/Escape, automatic
editor after map creation, reopening from either map marker and Edit in the list.
Shared name sanitation and icon validation preserve existing point IDs/locations,
unknown fields and character saves. Legacy/invalid stored icons use a gold pin.
Names update all three views; icons update both maps. No new assets/dependencies.

All 16 Lua suites pass, with real UI/storage composition and lazy map-first entry,
CRUD/persistence/capacity/legacy guards, both map clicks, party-marker pass-through
and reuse. Structure/package checks and 28 installed SHA-256 comparisons pass.
Clean replacement only of authorized GroupCompass, no backup; prior source changes
preserved and no Git mutation. Native editor acceptance remains active as GC-211.

## GC-019 — Shared TomTom waypoints, clear options help and cleanup 0.9.0

Tony confirmed TomTom's menu and selected reuse of its waypoints. Added a guarded
TomTom bridge and optional dependency. Reads existing/native-created points for
nearest-20 shared compass labels, automatically leaving demo/enabling live display
on additions. TomTom owns pins, persistence, themes and sizes. Our remaining Edit
supplies names/individual textures through its APIs, preserving settings/portraits,
rejecting collisions and protecting points managed by other addons.

Removed independent waypoint live CRUD, Alt-left-click placement, custom waypoint
map projection/renderer, map-pin Edit handlers and obsolete appearance branches.
Legacy data is retained solely for a once-only confirmed import; removals do not
resurrect. Waypoints & help gives the configured map shortcut, automatic bar and
character-facing instructions, with native TomTom settings links on both menus.

17 Lua 5.1 suites, actual installed TomTom.lua API/registry/persistence composition,
structure/package and 29 installed SHA-256 comparisons pass. TomTom moved from
v4.3.12 to v4.3.13 during work; its core API file hash was unchanged and dependent
methods were re-audited. No provider code/artwork copied or TomTom files modified.
Clean installed only GroupCompass; no backup or Git mutation. Native verification
remains GC-212. Older placement/editor checks are superseded rather than passed.
