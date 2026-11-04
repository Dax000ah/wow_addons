# Design Brief and Decisions — Group Compass

## November3 —0.11.0 unified destination bar implemented

TomTom points remain; GC menu destinations now show[Route], selected TomTom points
merge into one label, and stock SPF's RXP public requests show[RXP] with step/title
updates. No private frame/state reads or provider modifications. RXP requires
SPF Follow RestedXP guides + Resume guide after reload. This is final destination
bearing only; native Alt-click journeys/next bends/cross-world targets remain
unavailable through the stock API.18 suites and actual Forever/HC API+RXP adapter
composition pass. No new commit after milestone9cfb3e1. Native label/hidden-arrow
checks and unmodified Forever acceptance remain open. See UNIFIED_COMPASS_0.11.0.md.

## November 3 — milestone checkpoint and arrow roles

Tony authorized a milestone commit of current Group Compass work. Documented
arrow ownership in docs/NAVIGATION_GUIDE.md: our horizontal compass, RXP blue
Step arrow, TomTom gold name/yards/stars arrow, and SPF travel route/turn guidance.
Member selection changes the SPF request only; other arrows retain their own
targets. Cyan map line means boat travel. No new runtime behavior or third-party
changes in this checkpoint. All17 suites, structure, actual Forever API/TomTom
checks and both stock-engine switching replays pass. Fresh TomTom/member native
Hardcore controls are user-confirmed; repeated A/B/A and native Forever tests
remain open. Milestone is a local Git commit; no push requested.

## November 3 — same saved point also fails without GC; cyan means boat

Read working capture as text: rev584, map1457(Darnassus),12 measured/drawn walk
points,13mini/16world strokes. Playerworld1(9948.900390625,2091.60009765625),
goal(10082.162109375,2041.90234375). Both start and goal differ from failed GC
TomTom case; goals are about1604yd apart. Snapshot has no owner field.
Tony confirms member selection through GC menu works. Screenshot's cyan curve
is stock SPF's boat-leg color, not member class color; GC sends coordinates/name
only. Gold walking, green flight. No color, runtime or installed-addon edits.

Exact-point control: Tony ran `/path way #1414 44.800972673 8.387378696 Exact
saved point` (the stored TomTom UID, bypassing GC) and confirms NO route appears.
This case is therefore not menu-specific: the provider cannot currently plan
to that saved destination. Combined with stock-engine replay, do not patch GC
or a provider to hide the refusal. This is not proof of physical inaccessibility
or the precise terrain defect. Suggest a fresh uniquely named TomTom point on
a known road where map-click navigation works, then select it in GC's menu.
No user waypoint was deleted or changed. GC-218's exact saved-point case is
explained; general native repeated TomTom selections and unmodified Forever
acceptance remain open. Evidence: working-click-comparison-2026-11-03.json.

## November 3 — stock Forever audit and menu/click discrepancy

Forever is the primary acceptance target; all third-party addons must remain
unmodified. AGENTS.md and R06/R18 now enforce this. Audited24 addon folders:
SPFv1.22.18, TomTomv4.3.13, OpenMapv0.7.5-beta/API4, RXPv4.11.29. GC0.10.2
is not installed in Forever yet; its30-file ZIP matches source. Private hc-test.9
still uses v1.22.9 (24 upstream files changed,2 added); it is NOT a current full
simulation and was not partially upgraded. No runtime or installed-addon changes.

17 GC suites, stock API/TomTom checks, structure and7 private suites pass.
New scripts/check_spf_journeys.py loads actual stock API/GC/Nav/Planner/Search/
Walks without HC modules: five alternating selections pass on both v1.22.9 and
v1.22.18. Exact saved failed world goal has no plan; valid goal recovers.
Projection/driver/time are doubled, so this is not native Forever acceptance.

Tony confirms direct long control rendered9 points/14mini/8world strokes,103s.
Later GC menu request: ownerGroupCompass, guidedoff, settled2rounds/no plan,
paths0. Saved goal world1(10742.2080078125,579.92578125); player
(10335.7001953125,820.7000122070312). TomTom UID is map1414 fractions
(0.4480097267300475,0.08387378695540161), not report's rounded map1438 location.
Tony subsequently says Alt+left-click works where our UI does not. Do not close
GC-218: working-click /path report + /reload capture requested to compare exact
destinations. Native GC known-reachable point test also pending. Stock SPF's
OpenMap conversion remains a separate unverified launch concern. Full versions,
checks, boundaries and next steps: docs/FOREVER_LAUNCH_CHECKLIST.md and
CLOSEOUT_2026-11-03_FOREVER_AUDIT.md. Hardcore control passed; all rendering and
menu/client acceptance are NOT declared complete.

## 2026-11-02 — direct provider route exists; short-path drawing unresolved

Additional check after Tony said continue: using the exact reported player and
zone-bounds approximation of58.6,44.8 gives32.081yd; actual world-map Strokes.Map
with1002x668canvas,10px goal andzoom0.2/0.5/1/2 yields0 strokes at every zoom;
minimap0. Approximate projection is NOT the exact saved endpoint/view.
A longer control, map1438 55.9,57.8, routes from reported player through actual
Nav1/Path in9 points,722.915yd. Actual stroke generation gives6world/12minimap
strokes in tested views with goal gaps enabled. No character movement required:
first close /path report and /reload to save; then /path way #1438 55.9 57.8 Long
path test. Stay still, wait15s, check both maps and /path report if absent.
No native success or code fix claimed; original gate remains OPEN.

Tony ran `/path way #1438 58.6 44.8 Path test` directly. New native report:
player Teldrassil 58.9,44.0; Journey Path test, owner player, guided on;
search settled in one round; walk4s, measured=true, two drawable points;
revision2; minimap visible/alpha1/radius233.333 with0 strokes; world1438
visible/stitched, one route pin and0 strokes; no caught errors. First point
matches player world1(10337.700195312,813.40002441406). Route creation and
geometry now confirmed; this differs from the earlier no-journey/rev0 report
and the separate exact destination that the engine refused.

Current destination is close. A read-only replay of actual FlightLines/Strokes
with a synthetic28yd segment,140px minimap,1.53 scale,233.333yd radius and8px
goal radius yields0 strokes because all breadcrumbs fall inside the stop gap.
The same fixture at179yd yields8 strokes. This establishes normal short-route
suppression, NOT the exact cause of Tony's report: its endpoint/zoom/frame
values are not yet saved. Earlier farther-away failure remains unverified.

GC-218 / HC-011 OPEN: asked Tony to close report, /reload once and reply saved.
Read the latest character capture as text; replay exact path endpoints and map
view before editing. Disk still held older paths0/revision0 capture when checked.
If exact short route is entirely covered, test a farther routable destination
without walking before reporting; do not invent a straight-line fallback.
No runtime edit, install, public API, Group Compass or Forever change in this
checkpoint. Seven private suites and git diff --check pass; native visibility
is NOT declared fixed. See private SHORT_ROUTE_CLOSEOUT_2026-11-02.md.

## Native capture interpretation — November2

The exact saved target returns unreachable in the unchanged engine; nearby
same-start controls route. Never replace refusal with a guessed safe line.
A zero-geometry sample is distinct from hidden/transparent rendered lines.
Native control test remains open; runtime stays0.10.2/hc-test.9.

## November2 — diagnostic boundary

Both maps still fail in Hardcore. Logging is private-provider-only: existing
/path report saves a plain rendering snapshot to its character SavedVariables;
/reload flushes it for local readback. No GC public API requirement, engine
changes or Forever edits. Counts distinguish no geometry from zero painted
strokes or hidden frames. Native cause remains open; hc-test.8 was insufficient.

## Current hc-test.8 — stitched-map projection repair

Tony supplied a native hc-test.7 report: build 70576, level-4 NightElf Rogue,
Teldrassil 56.0,41.0 to 63.6,35.6; owner player, guided on, settled one-walk plan
66s, no caught errors, RXP following off. This is a player-selected provider route,
not a GC-owned API route. The previous nearby offmesh fixture is not its cause.

Rounded-coordinate replay with bundled zone bounds finds five terrain points,
469.18 yards / 67.03s. Rounding/projection is approximate; native report says66s.
Found a concrete independent bug: UI/OpenMap.lua projected continent/world yards
through C_Map.GetWorldPosFromMapPos, which expects UI-map fractions. OpenMap's
public CanvasFromWorldPos already takes continent/world yards. That unnecessary
conversion can silently return nil or wrongly place lines on the stitched map.
The new regression fails before repair; now passes using the actual installed
OpenMap v1.2.1 API plus Route.lua's resolver and both-map stroke generators.

hc-test.8 passes the existing world point directly to OpenMap's public API.
This is a separate provider/OpenMap bug fix, not an interface added for GC.
GC 0.10.2 stays stock-API-only. Six private suites, real terrain/repeated-journey
checks and 116 installed source hashes pass. The 17th reviewed changed upstream
file is UI/OpenMap.lua; terrain/Planner/API/RXP/TomTom remain unchanged.

The same faulty adapter exists in the read-only installed Forever v1.22.14.
It was NOT modified. GC's API compatibility is verified offline, but an unmodified
Forever + OpenMap rendering pass remains a launch gate; we cannot promise an
upstream drawing bug is absent. No message/issue/PR sent to its maintainer.

Native GC-218 / HC-009 stays OPEN until Tony reloads/reopens maps and repeats
point A, moved start, point B, return to A. If world lines return but minimap
still fails, capture that distinction; this fix only changes world-map projection.
Two inert installed support modules remain unreferenced; prior deletion block
GC-219 is unchanged. No backups, SavedVariables or live Forever writes.

## Stock API correction — 0.10.2, first installed with hc-test.7

Tony clarified that Group Compass must work with the unmodified Forever addon.
The 0.10.0 source menu depended on custom provider methods and violated that
boundary. They were not upstream APIs. That implementation is superseded.

Group Compass now calls only upstream API v1 Navigate, CurrentStop, Active,
Cancel and optional Ended. No private namespace/DB, injected methods, source
setting writes or engine code is used. TomTom/member selection sends coordinates;
members are snapshots. Retry resubmits our owned destination; Stop cancels only
GroupCompass-owned routes. Shortest Path's automatic followers stay as configured.
RestedXP opens native settings: Guidance > Follow RestedXP guides, then RestedXP
guide > Resume guide. Native arrow/compass supplies turns; our bar still shows
member and TomTom destination bearings. No next-turn getter exists in stock API.

Blizzard tracked quest means the quest selected in Blizzard's tracker, whose
exposed destination can be submitted when available. That lookup is unavailable
on the tested Hardcore client; TomTom and RestedXP routing are separate features.
API acceptance/Active is not proof that walking geometry was found. Route report
opens the provider's existing /path report; our status does not invent progress.

Removed both private app-support modules and their TOC entries from source.
Private hc-test.7 retains only Hardcore compatibility changes. The current
unmodified Forever v1.22.14 install was read only. Composition passes with its
unchanged Core/API.lua and the pinned original v1.22.9 API. Seventeen GC suites,
five private suites, actual TomTom composition, structure/ZIP and real terrain
checks pass. Real Search/Walks/Nav tests pass after moving start, switching goals,
returning to an existing goal, repeating it and warm replanning.

Installed GC 0.10.2: all 30 filenames/hashes match. Installed private hc-test.7:
all 116 source files match; two obsolete files remain on disk because automatic
approval review blocked deletion without a specific reason. The TOC references
neither file, so neither loads after restart. No backups or SavedVariables edits.

GC-218 remains OPEN: Tony reports no Lua error and a path that works once but
sometimes fails after moving and selecting another/existing point. Offline tests
do not reproduce that exact failure; an approximate offmesh fixture is not its
proven cause. The native hc-test.7 report has since been received; the hc-test.8 projection
repair above requires native retest.
Full client restart, then right-click cyan icon > TomTom waypoints > select a
nearby point, move, select another and return to the first. No second map click
is needed. GC-217/HC-008 native review and Forever launch acceptance remain open.
See docs/CLOSEOUT_2026-10-30_STOCK_API.md for file inventory and commands.

Updated 2026-10-27. Current UI: 0.9.2 adjustable single-baseline strip with cardinal headings. Native visual review pending.

## Compass appearance controls — 0.9.2

October 30 correction: the 340-by-390 right-click panel now uses stock API only.
Named party/TomTom sublists, owned Retry/Stop, native settings/report and capability
explanations remain. Status reports request acceptance, never invented search
progress. RestedXP uses native settings Resume guide; no settings are rewritten.
The source-menu extension in 0.10.0 was not an upstream public API and is removed.

The existing 430-by-490 options window now has Compass (default) and Map markers
tabs. Compass contains three horizontal sliders with current values and min/max
labels: Bar width (horizontal), Bar height (vertical), Text size. Values save
immediately and preview on the actual bar. Shared help/Done/Reset controls remain.
Map markers retains icons, independent map sizes, effects, colors and previews.

Width 320–1200 UI pixels changes the member/cardinal bearing span together; label
padding scales with font. Height 40–160 adds row spacing. Text size 8–20 updates
all compass text while preserving font face/flags. Enforce minimum height of
3 * text size + 16; raising text grows a too-short bar and updates the slider
limit. Lowering text keeps chosen height. Defaults stay 620/46/10; no whole-frame
scale is used. Collision bounds and hover use the new layout. Hidden bars stay
hidden. Review readability/interaction in game as GC-214.

## Private routing compatibility boundary — 2026-10-26

Tony requires all Hardcore provider fixes outside Group Compass. Use the sibling
shortest-path-hardcore-test workspace for the local SPF v1.22.9 copy; no publication
or distribution. Group Compass retains its existing public-API consumer. Only the
private provider adds Hardcore capability fallbacks only. TomTom
following stays off initially so our explicit Navigate controls route ownership.
Disable the provider's duplicate compass by default and enable bend progression.
Native tests remain separate gates; Forever's unmodified release must be verified
again at launch. No Classic compatibility code belongs in GroupCompass/.

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
- A subtle translucent background and center cue are implemented. Version 0.9.1
  adds gold N/E/S/W in a separate heading row, using the same angular scale as
  member ticks. The frame stays 46 units high; name/tick/distance rows remain shared.
  Headings work while solo or without coordinates and clear when facing is unavailable.
  Further ornamental polish remains open.
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

## Routing interaction — current 0.10.2

Saved rows expose Navigate/Replace and owned Stop. The right-click menu provides
TomTom points and fresh GUID-resolved party snapshots. All requests use upstream
Navigate("GroupCompass", uiMapID, x, y, title). CurrentStop/Active/optional Ended
supply ownership/lifecycle only. They cannot expose search failures or next turns.
Status says navigation requested; native Route report holds diagnostics. We never
scrape the provider's namespace, frames, DB or internal current guide to fill gaps.

Retry resubmits our target; deletion/demo/off cancels only our owned route.
RestedXP opens existing /path settings and explains Guidance/Resume guide. Existing
provider follower preferences stay user-configured. The private guidance/source
extensions and proposal were removed. Native arrow/compass handles turns; ordinary
member/TomTom bearing display is independent. Full restart clears prior globals.

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

## Elsewhere row — 0.11.1

Tracking returns remote labels separately from its legacy status, with a clean
local-only status for the compass. Shared MapLocation resolves UI-map ancestry;
Waypoints returns remote labels separately from bearing samples. Core adds one
non-directional row below configured bar height, font-size +7 high, without moving
existing rows. It fits up to three names plus remaining count; if no name fits,
uses a compact count. Hover lists up to20 names and explicit overflow. No private
provider data, new dependencies, new runtime files or map pins. Compass checkbox
showElsewhere defaults true; false survives reload. Demo and empty lists hide it.

## Target menu / other-addon links — 0.11.2

Navigation menu entries carry optional wrapped hover help separately from disabled
reasons. Quest and owned-route controls are conditional; height follows entry count.
Resume's ellipsis, tooltip and printed result disclose native-controls handoff.
Existing public /path handler remains authoritative; no unsupported Resume call.
Options now has Compass, Map markers and Other addons tabs. Native /rxp dispatch
uses its audited AceConsole slash entry; /tomtom and /path use existing wrappers.
Failed/missing handlers keep Options open with an explanation. Reports remain
read-only diagnostic actions; route ownership/cancellation logic is unchanged.

## Standard minimap launcher —0.11.5

Options registers a GroupCompass launcher data object, OnTooltipShow and OnClick
with public shared LDB/LibDBIcon. Standard LibDBIcon10_GroupCompass naming bypasses
Leatrix's nonstandard-button replacement. Optional Leatrix load ordering provides
its libraries even without TomTom. No private collector callbacks/settings are
changed. Missing libraries retain the standalone custom button, sharing the same
click/tooltip functions. Canonical minimapPos migrates from buttonAngle; aliases
stay compatible. Library owns normal drag/placement; ordinary options refreshes
never force icon visibility/position. Only explicit Reset/position changes Refresh.
