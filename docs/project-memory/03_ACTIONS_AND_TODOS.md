# Active Actions and TODOs — Group Compass

Updated 2026-10-23. No deadlines have been assigned.

## Next implementation

- GC-101 | HIGH | READY TO TEST | Tony | Validate the installed 0.5.0 thin horizontal
  strip at his UI scale. All markers/names/distances use their respective shared
  baselines; the 46-unit height and native appearance need his review.
- GC-102 | HIGH | OPEN | Codex + Tony | Refine visual presentation after the compact
  layout is reviewed: center cue, spacing, background contrast and collision rules.
- GC-103 | MEDIUM | READY TO TEST | Tony + another player | Verify 0.5.0 collision
  handling: crowded name labels stay on one row and full names remain in hover;
  every true bearing tick is retained. Minimap badge overlap is still separate work.

## Ready for client verification

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

- GC-301 | MEDIUM | BACKLOG | Codex | Assess saved settings, position/scale controls
  and independent compass/world-map/minimap toggles after live validation.
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
