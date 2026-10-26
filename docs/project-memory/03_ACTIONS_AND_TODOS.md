# Active Actions and TODOs — Group Compass

Updated 2026-10-26. No deadlines have been assigned.

## Routing integration — selected architecture; implementation remains open

- GC-104 | IMPLEMENTED | Codex | Optional API Navigate/Replace/Stop/status and
  missing-provider behavior shipped in 0.8.0. Native controls gate remains GC-209.
- GC-105 | HIGH | PROVIDER GATE OPEN | Codex | Next-turn consumer shipped; composed
  tests with draft GetGuidance pass. Need a supported provider getter/build and
  native route guidance validation. Provider extension is not installed.
- GC-106 | HIGH | INVESTIGATING | Codex | Probe received October 26: function,
  function, nil, nil. Native waypoint getter/tracking-priority method are missing;
  full SPF port needs provider-local fallback and remaining API/data audit.
  Combat pauses accepted for routes. No further chat probe requested yet.

## Next implementation

- GC-101 | HIGH | READY TO TEST | Tony | Validate the installed 0.5.0 thin horizontal
  strip at his UI scale. All markers/names/distances use their respective shared
  baselines; the 46-unit height and native appearance need his review.
- GC-102 | HIGH | OPEN | Codex + Tony | Refine visual presentation after the compact
  layout is reviewed: center cue, spacing, background contrast and collision rules.
- GC-103 | MEDIUM | READY TO TEST | Tony + another player | Verify 0.5.0 collision
  handling: crowded name labels stay on one row and full names remain in hover;
  every true bearing tick is retained. Minimap badge overlap is still separate work.

## TomTom waypoint integration

- GC-108 | IMPLEMENTED | Codex | 0.9.0 shared TomTom points, automatic bar sync,
  native settings links, creation/facing help, one-time legacy import and API-backed
  Edit. Removed independent placement/store/waypoint map rendering. Archive GC-019.
- GC-212 | HIGH | READY TO TEST | Tony | Fully restart; use Waypoints & help,
  configured map shortcut, face point, verify automatic bar/list and no duplicate
  map pins. Test Edit/Cancel/name/icon/arrow, native settings, reload/profile,
  removal/import and ordinary group/demo behavior. 17 local suites plus actual
  TomTom API composition pass. Tony reports things look good and requested a local
  check-in October 26; detailed native acceptance checks remain unconfirmed.

## Historical waypoint editing

- GC-107 | IMPLEMENTED | Codex | 0.8.1 name + ten-icon editor, automatic map-create
  entry, Edit row and left-click pins on both maps. Save/Cancel/Enter/Escape and
  legacy/persistence/capacity protections pass locally; archived implementation GC-018.
- GC-211 | SUPERSEDED BY GC-212 | Tony | Reload 0.8.1; create on zone map, name and
  pick a tile, Save, reopen from both maps/list, cancel a draft and reload. Verify
  layout/focus/ten shapes, all three labels, saved data and ordinary member/map UI.

## Ready for client verification

- GC-209 | HIGH | READY TO TEST | Tony | Restart for 0.8.0; test saved-point
  Navigate/Replace/Stop/status and no-provider fallback in Hardcore. Existing
  waypoints/options/member behavior must remain usable. 16 local suites pass.
- GC-210 | HIGH | NATIVE PROVIDER PENDING | Tony + Codex | Verify actual SPF map
  routes, proposed next-turn API, ownership transitions, combat resume, transports
  and cross-continent recovery with a compatible provider/client. No live route
  is available in the current Hardcore install; provider draft is not installed.


- GC-208 | SUPERSEDED BY GC-212 | Tony | Restart for 0.7.0; test Alt-click zone-map
  placement, named save-current-location, coordinate command, all three views,
  removal/reload/per-character persistence, off/demo recovery, mixed groups and
  cross-world/missing-data behavior. 14 local suites pass; native review pending.

- GC-207 | HIGH | READY TO TEST | Tony | Verify 0.6.1 cyan launcher; open border-button
  options without a party, verify ten icons, two size sliders, effects/colors,
  reset, close/Escape, saved reload and draggable border position. Check real map
  markers and pin/animation reuse with a party. Local 12-suite coverage passes.

- GC-206 | HIGH | READY TO TEST | Tony + another player | Version 0.5.1 remote
  continent labels: /reload and /gcompass status with the current distant member;
  verify name/continent or explicit world-area fallback. Rejoin on the same world
  area and verify normal direction/distance resumes with no stale remote label.

- GC-201 | HIGH | READY TO TEST | Tony | Restart WoW and confirm 0.5.0 loaded.
  Run /gcompass demo; turn the character and walk. Verify motion, distance, behind
  hiding and /gcompass demo reset. Local tests pass; native motion not yet confirmed.
- GC-202 | HIGH | READY TO TEST | Tony + another player | Test real-party direction,
  distance, names and default class colors. The other player needs no addon.
- GC-203 | HIGH | READY TO TEST | Tony + another player | Check world-map party pins
  and minimap badges at each zoom, rotating/nonrotating mode, indoor/outdoor switch,
  roster changes, disconnects, zone/floor changes and unavailable coordinates.
- GC-204 | HIGH | READY TO TEST | Tony | Verify 0.5.2 continues tracking during
  combat/instances whenever coordinates are readable. Test unavailable-data clearing
  and recovery; off/demo still clear live map markers. Native dots are unaffected.
- GC-205 | MEDIUM | NOT YET AVAILABLE | Tony | Verify Forever separately when a
  client is available. Classic success is not evidence of Forever compatibility.

## Later backlog and unresolved choices

- GC-301 | MEDIUM | BACKLOG | Codex | Saved appearance/button position shipped
  in 0.6.0. Assess compass position/scale and independent view toggles later.
- GC-302 | LOW | BACKLOG | Codex | Consider a clearly labeled map/minimap solo demo
  in a dedicated preview. No synthetic locations are currently put on real maps.
- GC-303 | LOCAL CHECK-IN | Tony authorized 2026-10-23 | Initial source/tests/docs
  check-in requested. Git log/status identify the resulting commit. Remote push
  remains unrequested; further Git mutations require explicit authorization.
- GC-304 | LOW | USER SETUP | Tony | Enable Google Docs offline availability or sync
  the Drive project for offline use if desired. Local Markdown notes already exist.

## Ongoing project-memory work

- GC-401 | ACTIVE | Codex during this task | Keep this queue, PRD, design decisions,
  current progress and completed archive consistent after meaningful work.
- Preserve stable IDs when work moves to the completed archive. Record date, outcome,
  verification and residual limits; do not archive an open client validation gate.
- Store PRD updates in 01 Requirements, design assets in 02 Design, active work in
  03 Work, and completed records/superseded release packages in 99 Archive.
- Keep the native project-memory Doc as the resume entrypoint. Local Markdown
  copies and Drive file snapshots are dated mirrors, not automatic synchronization.
