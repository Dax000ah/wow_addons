# Design Brief and Decisions — Group Compass

Updated 2026-10-26. Current UI: 0.9.0 single-baseline strip. Native visual review pending.

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
  They confirmed alignment/density. Personal waypoint support was later requested
  and implemented in 0.7.0; quest integration remains outside current scope.
- Store design assets in Drive /02 Design. Link accepted revisions with a decision
  date; retain rejected/superseded references in the archive with a reason.

## Earlier marker exploration (superseded by approved 0.6.0 default)

Tony requested alternatives to the square map badges. Previewed round numbered
badges (recommended), numbered diamonds, minimal ring dots, and class-symbol
concepts. Class colors and hover identity are retained. Class-symbol preview
glyphs are illustrative; actual WoW artwork would differ. No choice is approved
and the installed 0.5.2 addon still uses squares with no style picker. Preview:
C:/Users/Gaming PC/.codex/visualizations/2026/10/23/01a1692d-351a-7492-90a0-22534ba3148f/group-compass-marker-choices.html

Follow-up proposals: Tony requested more non-circle styles and glow/flashing.
Previewed diamonds, pointed map pins, shield crests and flags, each with none,
steady glow, gentle pulse or slow flash. Default preview is steady glow; motion
respects reduced-motion preference. Recommended starting point: diamonds with a
subtle class-colored glow. These remain proposals, with no chosen style/effect
or installed runtime change. New preview:
C:/Users/Gaming PC/.codex/visualizations/2026/10/23/01a1692d-351a-7492-90a0-22534ba3148f/group-compass-shapes-and-glow.html

## TomTom waypoint interaction — 0.9.0

TomTom owns creation and all waypoint map pins. Remove our previous Alt-left-click
handler, separate live store, waypoint projection/renderer and map-pin Edit hooks.
The top bar reads TomTom and keeps its shared baseline/nearest-20 cap. Newly added
points enable live display and leave demo; no duplicates are planted on either map.

Main options: Waypoints & help plus TomTom settings. The 450-by-620 waypoint window
shows numbered creation steps with the configured modifier, automatic bar behavior
and character-facing/remote visibility explanation. Open world map and native
TomTom settings are direct buttons. Existing Save my location/Edit/Remove and route
controls remain API wrappers. Other-addon-managed points are read-only.

The 450-by-380 editor remains only for TomTom's missing name/individual-icon controls.
Save/Enter applies to TomTom, Cancel/X/Escape discards drafts, and Keep current icon
preserves an existing texture/theme/portrait. Our light textures override the point's
native theme; member class colors/glow/flash stay independent. TomTom handles its
own theme/size choices. No frame hooks or copied provider engine/artwork.

Legacy Group Compass saved records are retained for one-time import, not another
live store. Missing TomTom shows enable/restart instructions. Native review GC-212.

## Historical waypoint editor — 0.8.1 (superseded)

A 450-by-380 editor opens above the world map after Alt-click creation, on either
map icon's left-click, or from Edit in the list. Name is selected for replacement;
ten gold icon tiles share the existing artwork catalog. The selected tile has a
gold border. Save/Enter commits; Cancel/X/Escape keeps the saved values. A newly
placed point already exists, so cancelling its editor leaves its default pin.

Names update map hover labels and the shared compass row. Individual shapes
apply on both maps, retain waypoint gold and inherit global map sizes/effects.
No per-point colors/coordinate movement or imported icons are in this iteration.
The compact list keeps Edit, Navigate/Replace and Remove; hover retains full names.
Native visual/focus/click review is GC-211; no route-provider changes were needed.

## Routing interaction — 0.8.0

Saved-point rows have Navigate, an explicit second-click Replace, and Remove.
The window has provider status and Stop route; stop is enabled only for our owned
route. An optional SPF API v1 receives saved coordinates and supplies map routes.
Our bar consumes only the proposed GetGuidance schema, as cyan next step on the
shared baseline; no duplicate route point is added to the map sampler. Missing
provider/getter and rejected/error/paused states are explicit. Off/demo/removing
the routed point cancels only our route. No session route is auto-resumed.

The provider getter is still a locally tested draft, not installed or supported
upstream. Classic probe confirms two missing native-navigation functions; our
consumer uses neither, while the full provider needs adaptation. Combat can pause
routes; party tracking stays independent. Details: docs/CLASSIC_ROUTING_COMPATIBILITY.md.

## Interaction decisions

- 0.7.0 adds personal gold waypoint pins on both maps and matching [W] compass
  names on the shared baseline. Alt + left-click a zone map places one. Options >
  Waypoints opens saved points, optional-name save-current-location and Remove.
  Up to 20 persist per character. Creating exits demo/enables live views; appearance
  reset keeps points. Marker sizes/effects apply; gold is retained and 0.8.1 allows per-point shapes.
  Normal map clicks remain native. Native click/coordinate/UI review is pending.

- Tony requested a colored minimap options icon instead of its near-white look.
  Version 0.6.1 gives the launcher a saturated cyan person over a dark teal disc,
  retaining the gold rim. Native color/contrast review remains pending.

- Tony selected head & shoulders as the default and requested a minimap-border
  options button. Implemented in 0.6.0: ten styles, two size sliders, three effects,
  six color modes, two live previews, automatic saved settings and Reset defaults.
  The gold border button is draggable; /gcompass options and Escape are supported.
  Map settings affect map markers/hover; compass names retain class colors. Native
  appearance and interaction are still pending Tony's review.

Tony next requested a simple palette rather than map previews. Supplied 25
illustrative choices covering portraits/faces, head-and-shoulders/body silhouettes,
fantasy/class symbols, and basic shapes. These outline examples are concepts,
concept exploration, not final game artwork. Actual character portraits remain
a separate option. Tony subsequently chose head & shoulders, implemented in 0.6.0.
Palette: C:/Users/Gaming PC/.codex/visualizations/2026/10/23/01a1692d-351a-7492-90a0-22534ba3148f/group-compass-icon-palette.html

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
