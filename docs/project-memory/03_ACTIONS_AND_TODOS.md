# Active Actions and TODOs — Group Compass

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

## November 3 — fresh TomTom point through GC menu PASSED

Tony confirms the suggested fresh road waypoint works when selected through GC.
Record HC-013 / GC-035 as a native single-waypoint selection pass. No new report,
coordinates or stroke counts supplied; do not invent them. Member selection was
also user-confirmed working earlier. The old saved point fails via the native
provider command too, so that specific case is not a GC menu handoff defect.
No runtime/provider/install changes were needed. General repeated A/B/A routes,
precise cause of the old point's refusal, and unmodified Forever acceptance are
separate remaining checks. GC0.10.2 is still not installed in Forever. No new
runtime tests run for this documentation-only acceptance update.

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

Updated 2026-11-02. No deadlines have been assigned.

## Captured target versus known-routable control — November2

- Native capture received. paths0/no walk, minimap visible/alpha1/radius valid,
  zero strokes; world closed. Exact coordinates reproduce unreachable in actual
  engine; full search settles no plan. Same-start nearby anchors route correctly.
  Path code and14 Kalimdor Nav chunks identical to installed Foreverv1.22.14.
- GC-218 / HC-011 | OPEN CONTROL TEST | Tony | In Teldrassil create
  /tway 58.6 44.8 Path test; select from GC right-click > TomTom waypoints; wait15s.
  If drawn, original destination's engine refusal explains no line. If absent,
  capture this valid point with /path report then /reload; investigate extra issue.
  No runtime changes or invented route/data fixes in this diagnostic turn.

## Both maps still lack path — November2

- GC-218 / HC-011 | EXACT TARGET REFUSAL REPRODUCED; NATIVE CONTROL PENDING | Tony + Codex | Both maps fail on
  Hardcore after hc-test.8; do not claim projection repair fixed it. Settings on
  disk enable journeys/mapRoutes. New hc-test.9 /path report records geometry,
  strokes/visibility/alpha/radius/coordinates and stores a detached capture in
  character SavedVariables. /reload, reproduce with world map open, /path report,
  close and /reload; Codex then reads file directly. No GC runtime change.
- GC-118 | IMPLEMENTED | Private diagnostic capture installed. Seven suites,
  real terrain/repeated searches and116 source hashes pass. Native capture received; valid-point control remains pending.
  Archive GC-032 records implementation only; root-cause/fix gate stays open.

## Stock API correction and intermittent route — October 30

- GC-117 | IMPLEMENTED | Codex | 0.10.2 uses stock public API only; removed private
  getter/source dependency and proposal. RXP native settings handoff, owned Retry/
  Stop, no false path-success claim. 17 GC suites, unmodified v1.22.9/v1.22.14 API
  composition, 5 private suites, real repeated/moved-goal terrain checks PASS.
  GC-030 records implementation; no native navigation pass claimed.
- GC-116 | SUPERSEDED | 0.10.0 custom source API violated clarified R18. Removed
  from source in hc-test.7; two inert installed files remain after deletion was
  blocked by automatic approval review. New TOC references neither file.
- GC-217 / HC-008 | READY TO VERIFY | Tony | Fully restart; test named point A,
  move, select B and return to A through the cyan launcher's right-click menu.
  Check both maps, Retry/owned Stop, member snapshot and native RXP Resume guide.
- GC-218 / HC-009 | FIX INSTALLED, NATIVE RETEST | Tony + Codex | Native report
  received hc-test.7: player-owned settled66s route, no errors, RXP off, OpenMap1.2.1.
  Approximate replay yields five points/67s. Found and reproduced an independent
  SPF/OpenMap world-yard versus map-fraction projection bug; repaired privately in
  hc-test.8, six suites pass including actual map API/Route/Strokes composition.
  /reload, reopen same map, repeat points A/B/A after movement; check BOTH maps
  separately. No claim of native fix until observed. Same upstream v1.22.14 adapter
  is faulty and remains untouched; native unmodified Forever/OpenMap gate stays.
- GC-219 | OPEN CLEANUP | Tony | Automatic approval review blocked removing
  installed Classic/GuidanceAPI.lua and Classic/RouteSources.lua. They are absent
  from source/TOC and do not load after restart. Native behavior independent.

## Real party member / map-pin crash — October 29

- GC-115 | IMPLEMENTED | Codex | 0.9.4 handles Blizzard's pre-OnLoad pin reset.
  The new lifecycle regression fails on the exact original nil fill before the
  fix, then passes with party join/leave, recycling, map changes and Core/Maps
  composition. All 17 suites, TomTom API, ZIP and 29 installed hashes pass.
  Completed implementation archived as GC-028; native acceptance stays open.
- GC-216 | READY TO VERIFY | Tony + friend | /reload and confirm 0.9.4. Disable
  demo if active; /gcompass on. Stand nearby outdoors on the same continent and
  face the friend. Check name/class color, both maps, opening/closing/zooming and
  zone/world switches with OpenMapClassic enabled, then party leave/rejoin.
  If absent, capture /gcompass status and any fresh Lua error.

## Empty waypoint list with a provider journey — October 27

- GC-114 | IMPLEMENTED | Codex | 0.9.3 identifies RestedXP/TomTom route ownership
  through existing public API; unknown journeys get honest fallback. Waypoint
  window links Route settings. Existing owned deletion cancellation preserved,
  foreign routes untouched. 17 suites/package/29 hashes pass. Archive GC-027.
- GC-215 | READY TO VERIFY | Tony | Reload, read new source status with zero
  points, open Route settings. If RestedXP is identified and only manual routes
  desired, disable Follow RestedXP guides and verify the path clears. Test manual
  Navigate/delete next. Actual source/clearing not confirmed from screenshots.

## Both-map rendering and XML warning — October 27

- GC-113 | PRIVATE FIX INSTALLED; RETEST | Codex + Tony | Gold paths on both maps
  confirmed by Tony/screenshots. Map.xml outer-glow warnings persisted (count 19).
  hc-test.5 defers all six XML atlas entries to checked Lua art assignment.
  Five private suites and 117 installed hashes pass. Archive GC-026; native
  HC-007: reload, close/reopen/zoom/hover main map with no artwork warnings.
- GC-111 / GC-210 | PARTIAL NATIVE CONFIRMATION | Tony | Both map lines render.
  Error-free map lifecycle, full destination/multi-stop appearance, next turns,
  movement/arrival, sustained RXP response, transports and Forever remain open.

## Compass appearance — October 27

- GC-112 | IMPLEMENTED | Codex | 0.9.2 Compass/Map markers tabs, saved live width,
  height and font sliders with bounds/readable minimum. Shared bearings and rows,
  updated collision/hover, off/reset behavior. 17 suites, actual TomTom API,
  package checks and 29 installed hashes pass. Archive implementation GC-025.
- GC-214 | READY TO TEST | Tony | /reload, cyan button > Compass. Drag all three
  sliders through limits, including large font/small width. Check actual bar,
  minimum-height help, hover/alignment, tab switching and map controls. Choose
  sizes, reload, verify persistence; test off/on and Reset defaults at your UI scale.

## October 27 updates — implementation and native evidence

- GC-110 | IMPLEMENTED | Codex | 0.9.1 N/E/S/W, solo heading support, guarded
  facing and unchanged 46-unit frame. 17 suites, TomTom composition and package
  checks pass; 29 installed hashes match. Completed implementation GC-023.
- GC-213 | READY TO TEST | Tony | /reload then /gcompass on. Turn the character
  through all directions while solo and in demo. Check cardinal/member alignment,
  readability, off/on and real waypoint behavior at your UI scale.
- GC-111 | PRIVATE FIX INSTALLED; RETEST | Codex + Tony | Golden minimap line
  confirmed by Tony. Big-map StopPin nil-atlas error reproduced offline. Separate
  hc-test.4 provides shipped-art fallbacks for goals/numbered stops. Four private
  suites and three terrain/geometry cases pass, 117 installed hashes match.
  Reload and reopen the failing map; native gate HC-006. Archive GC-024.
- GC-109 / GC-210 | PARTIAL NATIVE EVIDENCE | Tony | Minimap gold rendering is
  confirmed, but world-map art recovery, sustained RXP responsiveness, next turns,
  movement/arrival, transports and Forever remain open. Do not mark full routing done.

## Routing integration — selected architecture; implementation remains open

- GC-104 | IMPLEMENTED | Codex | Optional API Navigate/Replace/Stop/status and
  missing-provider behavior shipped in 0.8.0. Native controls gate remains GC-209.
- GC-105 | RETIRED APPROACH | Tony requires stock upstream only. Custom guidance
  getter/proposal removed. Use native Shortest Path arrow/compass for next turns;
  reconsider only if the maintainer independently publishes a supported getter.
- GC-106 | HIGH | PRIVATE BUILD INSTALLED; NATIVE GATE OPEN | Codex + Tony |
  Separate shortest-path-hardcore-test sibling workspace, no distribution or Git
  mutation. Provider-local fallbacks address missing native navigation plus map,
  cooldown, minimap and flight tracking APIs. 117 installed hashes match; offline
  geometry/guide checks pass. First native load failed on unknown navigation
  events; hc-test.2 guards them and both real initializers pass a strict registry
  regression. Native HC-001 retest/HC-002 and transport audit HC-003 remain
  in its STATUS.md. Forever source unchanged; combat pauses accepted for routes.
- GC-109 | HIGH | PRIVATE WATCHDOG FIX INSTALLED; RETEST | Codex + Tony |
  RXP triggered a native hazard/planner timeout on October 27. hc-test.3 defers
  initial/reused/timer planning to the existing budget and adds zone checkpoints.
  Three private suites, penalty equivalence and cold asynchronous terrain/cost
  checks pass. Native responsiveness/route rendering remain private HC-005.

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
- GC-210 | HIGH | PRIVATE PROVIDER NATIVE TEST PENDING | Tony + Codex | Verify actual SPF map
  routes, proposed next-turn API, ownership transitions, combat resume, transports
  and cross-continent recovery with a compatible provider/client. Private
  v1.22.9-hc-test.3 is installed after startup-event/watchdog fixes; native retest pending.


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
