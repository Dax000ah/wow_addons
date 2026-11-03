# Progress, Verification and Decisions — Group Compass

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

## 2026-11-02 — native capture received; exact destination rejected by engine

hc-test.9 capture: paths0, no walking leg, minimap visible/alpha1/radius233.33,
zero strokes; world map closed at capture. Player world1 (10435.6005859375,
958.6000366210938), goal (10742.2080078125,579.92578125). Only initial route event;
capture4.041s after request. Search status was not stored, so the capture alone
cannot distinguish still calculating from settled failure. It rules out minimap
opacity as the reason for zero lines in that sample.

Replayed EXACT captured world positions through the real unchanged Path and
JourneySearch/Walks/Nav. Direct result: unreachable. Full journey settles with
no plan, pending0, one round. Controls from the SAME player position succeed:
Shadowglen anchor4 points/186.15yd; Dolanaar11 points/897.80yd; 25/50/75% toward the
failed target also succeed. Suggested TomTom point58.6,44.8 projects approximately
to the tested nearby anchor and produces4 points in the zone-bounds fixture.
This is a recorded-engine reachability refusal, not proof the place cannot be
walked to in the real game; the precise data/geometry reason remains unverified.

Installed Foreverv1.22.14 has byte-identical Path.lua, PathGrid.lua and all14
Kalimdor navigation chunks. No runtime file, data, GC or Forever change made in
this diagnosis. hc-test.9 remains installed. Seven private suites and expanded
actual-engine replay pass. No invented straight-line fallback or terrain edits.

Native control requested: while in Teldrassil, /tway 58.6 44.8 Path test, then
GC cyan right-click > TomTom waypoints > Path test; wait15s without moving. If this draws, the
original destination's rejection explains the missing path. If not, take another
/path report and /reload capture for the valid control; another issue remains.
GC-218/HC-011 remains OPEN until that distinction is observed. Evidence JSON,
raw local SV copy and engine output live in the private workspace. Use the
CAPTURE_ANALYSIS_CLOSEOUT_2026-11-02.md inventory/commands for handoff.

## 2026-11-02 — hc-test.9 rendering diagnostics; both-map failure remains open

Tony confirms the golden path is absent on BOTH maps in Hardcore after hc-test.8.
Installed source/manifest still match the private test copy. Saved options have
journeys/mapRoutes on, RestedXP/TomTom-arrow follow off. Existing FrameXML.log only
has an old unrelated addon-load error; no persisted render capture existed.
/path debug traces rides; the old /path report lacks paint/geometry visibility.
The prior projection repair did not resolve the reported symptom.

hc-test.9 adds private diagnostics to existing /path report: source point count,
walk measurement/error, minimap/world stroke count, visibility/alpha, map/radius,
player/path coordinates. It saves a detached snapshot to the existing character
SavedVariables field ShortestPathForeverCharDB.hardcoreRenderCapture, including
frame levels, first stroke geometry/alpha/width, paint revision/time and the last
16 route updates. WoW flushes this on /reload/logout; no SavedVariables file was
edited by Codex. No Group Compass or public-provider API change, no engine/terrain
change, no extra support extension, no Forever writes or provider distribution.

Capture steps: /reload to load hc-test.9, reproduce the missing path, leave the
main map open, run /path report, close the report and /reload again. Tell Codex
when done; it can read the character's saved file directly, so pasting is optional.
Only the last requested report capture is retained; normal gameplay does not
continuously write snapshots. Existing preferences/waypoints/progress are retained.

Seven private suites pass, including actual Route/Core Report composition with
both-map painters, empty geometry without errors, detached bounded captures,
false/secret values, stale-stroke clearing and report size. Existing real terrain
and repeated/moved searches still pass. All116 installed source hashes match;
18 reviewed upstream differences plus one Compat module, 115 originals unchanged.
Two pre-existing inactive installed support files remain unreferenced.
GC-218 / HC-010 remains OPEN: awaiting a native failed-state capture, not a claimed
routing fix. Group Compass remains0.10.2. See DIAGNOSTICS_CLOSEOUT_2026-11-02.md
in the private workspace for exact files, commands and remaining checks.

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

Updated 2026-10-30. Current source/package version: 0.10.0; provider hc-test.6.

## Explicit golden-path source selection — 2026-10-30

Tony requested right-click targets on the existing minimap launcher and reported
only a yellow goal dot after Alt-left-click. Source/settings inspection confirms
automatic TomTom following is off and RestedXP is on. A point's presence does not
prove a walking route exists. Approximate terrain near pictured 56,41 fails with
offmesh; three known real searches still generate both maps' walking geometry.
Exact live click failure remains unconfirmed and open as GC-218.

0.10.0 adds a source panel with live provider status/target, named TomTom and
party sublists, RXP resume, unavailable native quest explanation, Retry and Stop.
Member routes are explicit current-location snapshots. Private hc-test.6 supplies
the optional public selector/status methods; provider settings/routing stay out
of Group Compass. Manual routes isolate automatic followers until RXP is selected
again. Actual RestedXP bridge/selector/consumer composition verifies this behavior.
18 consumer and seven provider suites plus real terrain/geometry checks pass.

Forever's original install independently advanced to v1.22.14. Its mismatch was
reported, not bypassed: the original published v1.22.9 release matches all 115
recorded hashes and is now the private verifier's immutable local reference.
The manifest preserves the original install path and release URL/checksum.
No current Forever or unrelated addon files were edited. New TOC modules require
a full client restart; GC-217/HC-008 native controls and GC-218 remain open.

## Real-party map-pin initialization failure — 2026-10-29

Tony reports his joined friend missing and MarkerStyle.lua:13 nil fill, triggered
from OpenMapClassic's map switch. Source confirms Blizzard resets brand-new pins
before OnLoad decorates them. Correcting that order in maps_test reproduces the
exact error. Stop now resets alpha only on an existing fill; normal animation
cleanup and pool reuse remain enabled. Map updates precede compass name drawing,
explaining how a map failure can also interrupt the bar.

All 17 suites pass after the fix, including actual Core/Maps party rendering,
repeated join/leave, pin reuse and zone/world changes. TomTom composition and
structure/ZIP/source checks pass. Version 0.9.4 is installed with 29 matching
SHA-256 files and no extras. Directory clearing was blocked by automatic approval;
safe in-place replacement passed, no backups. No provider/Forever/SavedVariables
changes or Git mutations. Implementation is GC-028 in the October 29 archive;
native party/map verification is GC-216, still open. See the dated closeout.

## Zero TomTom points with another journey — 2026-10-27

Tony's screenshot shows zero points and Another journey is active. Confirmed
code meaning: provider Active true, CurrentStop(GroupCompass) nil. Actual source
is not yet verified. RestedXP is likely; its integration defaults on and follows
guide elements without TomTom. Existing deletion cancellation passes; source
inspection does not establish a stale owned-route defect.

0.9.3 explains known RestedXP/TomTom owners via the existing public CurrentStop
API and links native Route settings. It preserves foreign ownership and existing
manual route cancellation. No provider preferences or guide progress changed.
All 17 suites, actual TomTom API composition, five private consumer suites,
package/source and 29 installed SHA comparisons pass. Native source identification,
settings interaction and owned deletion remain GC-215. Closeout:
docs/CLOSEOUT_2026-10-27_ROUTE_SOURCE.md.

## Both maps render; repeated XML glow warning — 2026-10-27

Tony's screenshots confirm native gold paths on both maps. Main-map pin creation
still logs missing UI-QuestPoi-OuterGlow, count 19. The root cause is XML's eager
resolution of hidden atlas attributes, before the previous Lua fallback can run.
Private hc-test.5 removes all six static Map.xml atlases. Dock/flight OnLoad checks
availability, keeps native art or uses existing Classic ping-ring/goal fallbacks;
checked goal-stop acquisition already handles its remaining textures.

New regression fails against the old XML; five private suites now pass with actual
dock/flight callbacks, 19 repeated pins, missing/native art, preserved anchors and
visible faults. All 117 installed hashes match; sixteen original files differ
plus two adapters. Group Compass runtime and original Forever remain unchanged.
Only implementation is archived (GC-026). Native error-free reopen/zoom/hover is
HC-007 / GC-113; prior movement, transport and launch gates stay open.

## Compass width, height and text size — 2026-10-27

Tony requested common-named sizing controls. Version 0.9.2 adds Compass and
Map markers tabs in the existing window. Width, height and text-size sliders
save/live-preview; limits and values are shown. Width 320–1200, height 40–160,
text 8–20 UI pixels, default 620/46/10. Minimum height 3 * text size + 16 avoids
row overlap; text enlargement grows height if needed, shrinking text retains it.
N/E/S/W and member bearings share the new span; label bounds and hover follow.

17 Lua 5.1 suites pass, including real Settings/Core composition, every supported
font at min/max geometry, persistence/default migration, range callback reentrancy,
resized hover, hidden updates and reset. Actual TomTom API composition and four
separate provider suites pass. Package/source checks and all 29 installed hashes
match; five changed files copied without backups. No provider runtime or Git
mutation. Native controls/appearance/persistence remain GC-214. Full closeout:
docs/CLOSEOUT_2026-10-27_COMPASS_APPEARANCE.md.

## Cardinal labels and missing world-map atlas — 2026-10-27

Tony confirmed gold path rendering on the minimap, then reported a world-map
StopPin.lua:107 nil-atlas error. Actual StopPin/Art modules reproduce missing
quest/waypoint art. The separate hc-test.4 provider uses its existing round dot
for absent goal/ring/button artwork and contrasting font stop numbers, retaining
native art/aspect/grid when present. Four private suites, three terrain/geometry
checks and 117 installed SHA-256 matches pass. Native world-map recovery HC-006,
watchdog HC-005, movement HC-002 and transport/launch gates remain open.

Group Compass 0.9.1 separately adds N/E/S/W on the shared character-facing scale.
Each heading has its own row; all member names, ticks and distances keep their
respective shared rows inside the existing 46-unit height. Heading reading is
independent of world coordinates and rejects nil/secret/nonfinite values. All 17
Lua 5.1 suites, actual TomTom API composition, structure/ZIP/source and all 29
installed hashes pass. In-game visual/facing review is GC-213.

The clean-directory install command was blocked by automatic approval review.
A smaller changed-file copy succeeded; complete file counts and SHA comparisons
show no stale/mismatched files in either installed addon. No backups, SavedVariables,
Forever edits, commits, pushes or private provider distribution. Closeout:
docs/CLOSEOUT_2026-10-27_CARDINALS_AND_MAP_ART.md.

## Private provider synchronous planning timeout — 2026-10-27

Tony's native error at 13:13:12 runs from RestedXP.UpdateGotoSteps into
JourneySearch.Start, Planner.BakedCost and Hazards.Segment/Clip. The first preview
built the transport graph synchronously, outside the existing scheduler deadline.
Warm settled-batch proof and timer planning also had direct entry points. A test
with the actual shipped graph/hazards/search/scheduler reproduced a caller watchdog.

hc-test.3 dispatches these paths through existing notification jobs, with FIFO
work, cancellation/revision guards and coalesced timer replans. Zone checkpoints
bound costly map sampling. Original penalties compare equal; avoidance and RXP
stay enabled. Three private suites pass, including 452 aggregate simulated slices
with maximum 2.902 ms under the fixture's simulated map cost, plus cancellation,
replacement, combat, reused topology and visible errors. Three cold real terrain
jobs match synchronous costs and preserve map/minimap geometry. These are not
native timing or gameplay measurements. Four private files deployed, 117 hashes
match, Group Compass/Forever unchanged. Native retest HC-005 remains active.

## Private provider startup event fix — 2026-10-26

Tony's first native test reported unknown SUPER_TRACKING_CHANGED events and no
golden path. Actual journey/flight initializers failed before their handlers were
attached. The adjacent USER_WAYPOINT_UPDATED event is also native-only. The
previous permissive RegisterEvent test double missed this; new events_test.lua
rejects unsupported events and reproduces the exact error before the fix.

hc-test.2 checks these optional registrations through C_EventUtils.IsEventValid,
falling back to native navigation capability when that query is absent. Required
events and unexpected errors remain strict. Both actual module initializers,
supported/unsupported event profiles and unchanged consumer composition pass.
Only four installed private runtime files changed, all 117 hashes match. Group
Compass runtime and Forever are unchanged. Native route retest remains HC-001;
/reload then choose Navigate. No native success, commit or push is claimed.

## Separate private Hardcore routing test — 2026-10-26

Tony authorized a separate SPF copy for pre-launch testing, with no distribution.
Created shortest-path-hardcore-test beside this checkout from installed v1.22.9.
Pinned all 115 upstream files, retained attribution/licences, changed nine files
and added two provider-side modules. Engine/Nav/Strokes are unchanged. Missing
navigation uses the original fallback arrow; minimap/map/cooldown/flight API guards
stay entirely in the provider. The private getter uses the existing consumer.

Installed only the previously absent Hardcore ShortestPathForever addon directory,
117 files verified by SHA-256; original Forever and Group Compass runtime unchanged.
No Git repository creation, commit, push or distribution. Compatibility regression,
Lua syntax/TOC/XML, real terrain and map/minimap geometry checks pass, including
composition with the unchanged Group Compass consumer. Native load, gold lines,
bends, transport data/timings and launch verification remain HC-001 through HC-004
in the private STATUS.md. These results do not establish native compatibility.

## Local check-in authorized — 2026-10-26

Tony reported that things look good in 0.9.0 and explicitly requested a local check-in on 2026-10-26. This is positive general feedback; the detailed native acceptance matrix and SPF provider compatibility remain open. All 17 Lua 5.1 suites, structure validation and Git whitespace checks passed again before check-in. Runtime/install files were unchanged during this checkpoint. Use git log for the resulting commit; no remote push was requested.

## Shared TomTom waypoints — 0.9.0

TomTom is now the sole live waypoint store and map/minimap renderer. Group Compass
reads its exposed point list for the shared top bar; there are no duplicate pins
or Group Compass map-click handlers. New TomTom points automatically exit demo
and enable the live bar. The closest 20 locatable points share the existing member
baseline; points behind the character or in another world have no visible bearing.

Open the cyan button > Waypoints & help. The menu shows TomTom's configured map
shortcut (default Alt + right-click), automatic bar behavior, character-facing help,
an Open world map button and TomTom settings. Edit supplies the missing name and
individual-icon controls; TomTom settings handle its global themes and sizes.
No native rename/icon picker exists in the installed TomTom context menu.

Old Group Compass records are retained unchanged for a one-time API import. Only
confirmed imports are marked; deleting an imported TomTom point does not recreate
it. New and edited points live only in TomTom's current waypoint profile. With
TomTom disabled, group tracking still works, but waypoint controls explain how to
enable it. No independent local waypoint fallback remains.

Names and ten icon textures update through the bridge, with Keep current icon
preserving an existing theme/custom texture/portrait. Rename uses add-first/remove
because TomTom has no rename method; collisions and provider failures keep the
original. Same-name icon refresh keeps the UID and callbacks. Known active arrow
references transfer; an unknown pre-existing arrow asks to be cleared before rename.
Points owned by another addon appear on the bar/list but are edited/removed there.

17 Lua 5.1 suites, actual installed TomTom.lua API composition, structure/package
checks and all 29 installed SHA-256 matches pass. The provider API/registry is real
in that harness, but UI pins/projection remain doubled. Current TomTom v4.3.13 was
re-audited after an in-session update; its TomTom.lua hash matches v4.3.12. Native
clicks, layout, bar movement, migration and persistence remain GC-212. No live
Hardcore golden route or next turn was enabled; SPF compatibility stays separate.

## Historical waypoint naming and icon editor — 0.8.1

Alt + left-click a zone map creates a saved point and immediately opens its editor.
Choose a name and one of ten visual icon tiles, then Save. Existing points open
from Edit in the saved-point list or left-clicking their world-map/minimap icon.
Save updates names on all three views and shapes on both maps. Cancel, X and
Escape discard editor changes; cancelling a newly placed point leaves its default
saved pin. Save my location still accepts a name and its row can then be edited.

Edits preserve ID, coordinates, character storage, route destination and unknown
saved fields. Legacy/missing/invalid saved icons display the gold pin; invalid edit
choices are rejected. Names share the existing 48-character UTF-8 sanitation.
No imported textures, per-waypoint colors or coordinate-moving UI were added.

16 Lua 5.1 suites pass, including real editor + storage composition, lazy map-first
editing, Save/Cancel/Enter/Escape, removal while editing, persistence, capacity,
legacy icons, both map click paths and reused party-marker pass-through. Package
checks pass and all 28 installed files match source SHA-256. Native appearance,
click/focus handling and reload persistence remain GC-211. No live Hardcore route
was enabled; provider compatibility remains separate GC-105/106/210.

## API bridge and received Classic probe — 2026-10-26

0.8.0 implements optional public-API Navigate/Replace/Stop/status and a versioned
next-step consumer. Route points stay on the shared bar baseline; existing map
samples remain unchanged. Missing provider/getter, combat, lost ownership, errors
and invalid/remote data clear or explain the route state. 16 suites, package checks
and 28 installed-file hashes pass. No backups or other addon edits. Native UI and
provider execution remain GC-209/210. GetGuidance provider draft is not installed.

Tony supplied function function nil nil: canaccessvalue/decompression exist; the
checked native waypoint getter and supertracking-priority function do not. Full
Classic provider compatibility remains unproven. Evidence and next port boundaries
are in docs/CLASSIC_ROUTING_COMPATIBILITY.md. This is sufficient for the first probe.

## Earlier routing prototype and testing — 2026-10-24

Tony selected the API approach and accepts waypoint-route combat deferrals.
Prepared an original provider-side GetGuidance prototype with copied, owner-scoped
world targets and guards for inactive/corpse/combat/unavailable states. Not installed
or upstream-supported; the Group Compass bar consumer is still open. All 15 Lua
suites pass. A read-only harness ran real SPF terrain: Shadowglen/Dolanaar-area,
Coldridge/Kharanos-area and Goldshire/Stormwind paths pass. Its real transit planner
also produced a cross-world boat plan with estimated endpoints and no live clocks.
Raw hashes/results and client recommendations are in docs/ROUTING_TEST_RESULTS.md.
Classic probe pending; no full provider port or native integration validation yet.
Beta closed October 23, world launch November 4. No installed addon changed.

## Confirmed current state

- 0.7.0 adds saved personal waypoints across both maps and the compass, using
  native coordinate conversion and existing direction math. Alt-click map placement,
  a simple list/save-here/remove window and commands are implemented. Character
  persistence is separate from appearance settings. 14 suites and 27 installed-file
  hashes pass; native validation remains GC-208.

- Version 0.6.1 changes the minimap launcher to saturated cyan on dark teal with
  its gold rim. All 12 Lua suites, structure/package checks and 25 installed-file
  hashes passed. Native appearance remains part of GC-207.

- Version 0.6.0 implements Tony's head-and-shoulders default and minimap-border
  options button. Ten icons, separate map sizes, None/Glow/Slow flash, class/party/
  preset colors, live previews, saved settings and reset are implemented. 12 Lua
  suites, texture/structure/package checks and 25 installed-file hashes passed.
  Native UI/artwork/persistence remains open under GC-207.

- Version 0.5.2 removes the two combat/instance gates in Tracking.lua. Compass,
  demo, minimap and world-map sampling now depend on usable data. Nine Lua 5.1
  suites, structure/package checks and ten installed-file SHA-256 checks passed.
  Native combat/instance verification remains active under GC-204.

- Tony's screenshot confirms 0.5.0 loading, demo off, and one unavailable member;
  Tony confirmed that member was on another continent. Version 0.5.1 distinguishes
  remote locations using party UI-map continent ancestry and known world-ID
  differences. Nine Lua suites, structure/package checks and ten installed-file
  SHA-256 checks pass for 0.5.1. Native remote-label validation remains open.

- GroupCompass is installed at Tony's requested Classic Era AddOns path.
- Version 0.3.0 static demo was visible in Tony's screenshot. That confirms partial
  native loading/rendering, not real-party tracking or current-version motion.
- Version 0.4.0 introduced fixed simulated world anchors. Version 0.4.1 adds real
  member class-color defaults with names on compass and in map tooltips.
- Latest clean installation contains exactly 29 runtime/texture files; SHA-256 hashes
  match project source. No new backup was created and no other addon folder changed.
- Version 0.5.0 replaces the tall frame with a 620-by-46 UI-unit strip and shared
  horizontal baselines, center cue, restrained background, and full-name hover.
- Tony authorized the initial local check-in on 2026-10-23. The 0.5.2 source,
  tests, instructions and project documentation are included; generated ZIPs and
  local tooling remain ignored. Use git log/status for the resulting commit.
  No remote push was requested. No native validation gate closes by committing.

## Local verification completed

- python scripts/run_tests.py — PASS, 16 Lua 5.1 suites, including routing and guidance API: waypoints, waypoint UI, settings, styles, options, classic startup, client
  compatibility, core UI, movement demo, directions, layout, maps, projection, tracking.
- python scripts/check_structure.py — PASS, both interfaces, TOC references/order,
  XML template syntax and no orphan runtime files.
- python scripts/build_zip.py — PASS, 0.8.0 archive integrity, exact entry names and
  byte-for-byte source agreement.
- PowerShell installation check — PASS, 28 files, source/installed SHA-256 matches.
- git status/diff — 0.6.0 changes are uncommitted after initial 02e0bbe. Tracked
  diff/check passed; new modules/tests/artwork were reviewed directly. No new Git mutations.

Local tests use simulated WoW APIs and cannot prove native XML/mixin loading,
opaque-secret behavior, real-party coordinate availability or final visual layout.

## Decisions and preferences

- D01 | Confirmed | Character-facing compass. Camera-only heading is not available
  through the reviewed API, so camera rotation does not drive member positions.
- D02 | Confirmed | Real members default to class colors, with names. Missing class
  data falls back safely. Demo members remain clearly synthetic.
- D03 | Confirmed | Add custom map/minimap badges without removing native dots.
  World-map custom pins are party-only; compass/minimap include locatable raid members.
- D04 | Updated by Tony, 0.5.2 | No automatic combat/instance pause. Use available
  coordinates; no restricted-data bypass, stale fake bearings or communications fallback.
- D05 | Confirmed | Clean-replace only the exact named GroupCompass install folder,
  no new installation backups. A backup made before this preference remains locally;
  it is not an active workflow and was not uploaded to project memory.
- D06 | Confirmed | Tony wants a thin horizontal slice and every person on the same
  horizontal plane, as in his Enshrouded references. The 0.5.0 strip implements that
  alignment; final height/visual polish still require native review.
- D07 | Confirmed | Durable project memory belongs under ChatGPTStorage / Development
  / Group Compass, with requirements, design, active work and completed archives.

## Release readiness

Code/local checks/installation: complete for 0.7.0. Native moving-demo verification:
pending Tony. Real-party class colors/maps: pending a grouped test. Compact UI:
implemented, awaiting native review. Forever verification: unavailable so far. Do not mark these gates
complete based on the installed-file hashes or simulated tests.
