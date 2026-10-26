# Product Requirements — Group Compass

Status: living PRD. Updated 2026-10-26. Product owner: Tony.

## Problem and desired outcome

Tony wants to find existing group members by looking in their direction, similar
to Enshrouded. The addon should show understandable names and directions with
minimal obstruction of the game world. World-map and minimap member markers are
also in scope. This is not an addon for recruiting strangers or browsing LFG.

## Confirmed requirements

- R01: Show group-member bearings relative to the character's facing. An ahead
  member appears at the center; left/right members appear on that side.
- R02: Show member names and approximate horizontal distance. Default each real
  member's visual color to their class. Map marker color overrides are optional.
- R03: Provide world-map and minimap member visibility when the client supplies
  usable data. Keep names available in map/minimap hover labels without forcing
  permanent name labels across the entire map.
- R04: Use a thin horizontal slice with every member on the same horizontal plane,
  as in Tony's Enshrouded references. Never stagger different members vertically.
  Final height, styling and label-density rules need validation with Tony.
- R05: Support solo compass testing. Simulated members must remain clearly labeled;
  turning and moving should exercise the actual bearing/distance calculation.
- R06: First support Tony's available Classic Hardcore client (1.15.9/70003/11509)
  for testing while retaining the Forever target (interface 16001).
- R07: Report unavailable data honestly. Clear stale custom markers; combat and
  instances must not automatically pause tracking. Never fabricate real locations.
- R08: Keep installation simple: install directly to Tony's named addon directory
  using clean replacement, with no installation backup creation.
- R10: Default map markers to head & shoulders. A minimap-border button opens
  simple options for icon, independent minimap/world-map sizes, None/Glow/Slow
  flash and class/other colors. Save choices and provide live previews/reset.
- R11 (revised 0.9.0): Reuse TomTom's live points, map/minimap pins and persistence.
  Read them for our compass instead of a parallel store/placement/renderer. Existing
  Group Compass records are retained and imported once; deleted imports stay deleted.
- R13: Keep name/icon editing in our list where TomTom's native context menu lacks
  it. Use Save/Cancel; delegate themes/sizes to TomTom settings. Show map creation,
  automatic bar sync and character-facing instructions in Waypoints & help.
  Other addons' managed points are read-only. No fabricated cross-world bearings.
- R12: Route to a selected saved waypoint locally and across continents, using
  real walkable paths and available transport. Keep map routes and next local
  guidance consistent. Optional API controls/consumer implemented in 0.8.0; native
  provider execution still unverified. Tony selected
  the optional SPF API provider and accepts combat deferrals for routes. The
  supported next-target contract and native test-client strategy remain open.
- R09: Maintain durable project memory in the designated Google Drive development
  project, with local readable copies and completed-work archives.

## Current implementation boundaries

- Compass: character-facing, front 180 degrees, approximate horizontal yards.
- Minimap: party/raid world offsets, zoom/rotation handling, inset edge badges.
- World map: party-only normalized map positions; the documented API does not
  promise raid support. Native dots remain; custom badges are an additional layer.
- Class defaults: modern class-color API or Classic class-color table. If data is
  absent, invalid or secret, use a safe slot-color fallback. Numbers follow slots.
- Names: visible on compass; names/class colors in map/minimap hover labels.
- Demo: fixed simulated world locations on compass only. It pauses when player
  state is unavailable, continues through combat/instances with valid data, and reseeds on a
  world-coordinate-space change or explicit demo reset.
- Current panel is a 620-by-46 UI-unit strip. Ticks share one horizontal baseline;
  names/distances use their respective shared rows. Crowded labels use hover details.
- Waypoints: TomTom profile/persistence and map pins; all points are listed, nearest
  20 locatable points enter the forward compass as [T] labels. No local pin renderer.
  Coordinate spaces must match; missing TomTom leaves group tracking usable.
- Saved map appearance/button-position settings and a one-page options panel
  are implemented in 0.6.0. No automatic movement or group messages. Routing uses an optional SPF API; native/provider gates remain open.

## Acceptance criteria

- Remote-member status (0.5.1): show the member's name and resolved continent
  instead of a generic unavailable count when different continent ancestry or
  differing world IDs establish a remote location. Fall back to "Different world
  area" when no continent name is available. Do not fabricate bearing/distance.

- AC01: Correctly installed 0.9.0 announces its version and recognizes /gcompass.
- AC02: Solo demo starts A/B/C left/ahead/right at approximately 25/40/60 yards.
  Turning the character moves labels; walking changes distances; reset reseeds.
- AC03: With a real grouped player, bearing and distance match cardinal direction
  and movement, and class color/name match the game character. A class lookup
  failure keeps a readable fallback instead of failing the whole display.
- AC04: Custom map/minimap markers follow live data, zoom and rotation, and clear
  on roster loss, unavailable positions, off or demo. Combat/instances alone do not
  clear markers; only actual coordinate availability determines tracking.
- AC05: The compact redesign does not reintroduce vertical obstruction or hide
  essential member identity. Close headings, long names and crowded party states
  must be checked for collisions before calling that design complete.
- AC06: Version status, exact checks, native test evidence and remaining work are
  recorded. Completed implementation is distinct from completed client validation.

- AC07 (0.9.0): TomTom map creation appears automatically in our list/bar, with
  no duplicate map pin/shortcut. Waypoints & help gives configured creation steps
  and visibility explanation. Edit names/shapes and verify persistence, Cancel,
  removal, old import and unchanged groups. Local checks pass; native GC-212 remains.
  Session IDs survive an API rename; TomTom reload/profile changes may create new IDs.

## Evidence and release gates

All 17 Lua 5.1 suites, structure/XML checks and package checks passed locally.
Installed source hashes match 0.9.0 (29 runtime/art files). Classic screenshot confirms older static
demo rendering only. Real-party APIs, new motion demo, class colors, map rendering,
minimap replacements and Forever remain native test gates.

## Related products and references

- MateCompass: https://www.curseforge.com/wow/addons/matecompass — advertised close
  match for Forever; not installed or tested during this project.
- CompassHUD: https://github.com/BelegCufea/CompassHUD — group-marker functionality
  advertised; Forever compatibility not established here.
- Technical API evidence and compatibility caveats: docs/FEASIBILITY.md.
