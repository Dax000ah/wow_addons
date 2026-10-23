# Design Brief and Decisions — Group Compass

Updated 2026-10-23. Current UI: 0.5.2 single-baseline strip. Native visual review pending.

## Tony's feedback

The old overlay took up too much space. Tony supplied two Enshrouded HUD screenshots
and explicitly wants every person on the same horizontal plane, with a nicer
presentation eventually. Real members default to class colors with their names.
The earlier tall Classic panel is a baseline problem, not the intended final design.

## Confirmed design direction

- Use a compact strip near the upper center; minimize vertical game-world coverage.
- Make straight ahead clear with a restrained center cue. Members move along the
  horizontal axis as the character turns.
- Show readable member names in their standard class colors. Use the same class
  colors for map/minimap badges and name tooltips; numbers provide an extra identifier.
- Keep distance subordinate to name/direction. Avoid a large persistent status area.
- Preserve clarity over decorative frames. Improve spacing, contrast and typography
  after the compact layout works reliably in the client.
- Only character rotation drives the compass; camera-only rotation is not supported.
- Native and custom map dots can overlap. Do not remove other addons' map elements.

## Implemented alignment and open design work

- Version 0.5.0 uses a 620-by-46 UI-unit strip instead of the old 130-unit height.
  Every bearing tick has the same Y; names and distances each have a shared row.
  Position and visual density still need Tony's in-game review at his UI scale.
- No alternate vertical rows are allowed for different members. When names collide,
  prefer labels nearest center, then shorter distance, then slot. All true bearing
  ticks remain. Hover shows full class-colored names, including crowded members.
- Normal tracking hides the large title/status area. Empty/paused/behind states
  use a message in the same strip; hover and /gcompass status retain diagnostics.
- A subtle translucent background and center cue are implemented. Cardinal ticks
  and further ornamental polish remain proposals, not shipped features.
- Check long/localized names, two members on the same bearing, narrow screens,
  UI scale changes, raids and class-color contrast over bright/dark scenery.

## Reference assets

- Earlier interactive compass mockup: a conceptual comparison of refined vs current
  prototype. It is not a final screenshot or approved compact layout.
- Tony's Classic screenshot: static demo rendering in Teldrassil with a tall overlay.
  This is the baseline to improve and evidence that version 0.3.0 could display.
- Enshrouded references: annotated HUD and clean HUD, supplied on 2026-10-23.
  They confirm alignment/density. The images' waypoint visuals do not establish
  new WoW waypoint/quest integration as an implemented feature.
- Store design assets in Drive /02 Design. Link accepted revisions with a decision
  date; retain rejected/superseded references in the archive with a reason.

## Marker style proposals — awaiting Tony's choice

Tony requested alternatives to the square map badges. Previewed round numbered
badges (recommended), numbered diamonds, minimal ring dots, and class-symbol
concepts. Class colors and hover identity are retained. Class-symbol preview
glyphs are illustrative; actual WoW artwork would differ. No choice is approved
and the installed 0.5.2 addon still uses squares with no style picker. Preview:
C:/Users/Gaming PC/.codex/visualizations/2026/10/23/01a1692d-351a-7492-90a0-22534ba3148f/group-compass-marker-choices.html

## Interaction decisions

- Version 0.5.2 removes automatic combat/instance pause per Tony. Track readable
  coordinates continuously; missing/secret data clears only affected views. No
  stale coordinates or invented cross-world bearings. Native behavior needs testing.

- In 0.5.1, remote party members appear as "Name - Continent" in empty-strip
  status, hover details and /gcompass status. With local members also visible,
  remote labels remain in hover/status without adding a false bearing marker.
  Offline/unknown positions remain unavailable; raids use the world-area fallback.

- /gcompass demo toggles synthetic fixed-world compass members. A/B/C names avoid
  falsely implying that a member named Left must stay on the left after turning.
- /gcompass demo reset starts/reseeds the demo around current location/facing.
- /gcompass off and on control the addon. Demo mode never plants synthetic markers
  on the real world map or minimap.
- Demo uses a synthetic sample palette; real member class colors need live group
  verification. No class is invented for Demo A/B/C.

## Open design questions

- What compact height remains readable at Tony's UI scale?
- Should map names be permanently visible or remain hover-only? Current behavior
  is hover-only to limit clutter; no product decision for permanent map labels exists.
- Does center-priority labeling plus shared hover keep same-bearing members clear
  enough, or is a future single-row grouped marker needed?
- Should individual views be independently toggleable after initial validation?
