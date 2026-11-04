# Group Compass project checkpoints

## November 3 —0.11.5 Leatrix launcher-tooltip compatibility fix

Screenshot's generic custom-button tooltip came from Leatrix Plus replacing our
non-standard minimap button. Register our cyan launcher through the existing
public LibDataBroker/LibDBIcon libraries so Leatrix recognizes it and retains our
three-line tooltip and left/right clicks. No provider code or settings changed.
Leatrix_Plus is now an OPTIONAL load-order dependency so its shared libraries
exist before GC; nothing new must be installed. Standalone custom launcher stays
as the tested fallback when no library supplier is enabled. No copied libraries.

Saved minimapPos migrates from legacy buttonAngle and both fields stay compatible.
Standard-library dragging persists position; ordinary appearance refreshes do not
reposition/unhide collector-managed icons. Reset restores position deliberately.
19 suites, structure/ZIP, actual standard libraries from BOTH TomTom and Leatrix
in BOTH game folders, diff and install checks PASS; native frames/collector filter
are doubled. Installed31 matching source/package files per GC target. Original
4,756 dependency hashes and all26 Leatrix files checked unchanged. No backups or
SavedVariables writes. GC-224 native grouped-hover/reload test pending. Existing
bed6dcb checkpoint untouched; new fix uncommitted. Tony withdrew the RXP-guidance
complaint; no RestedXP behavior/menu wording changed in this task.
Full closeout: docs/LAUNCHER_COMPAT_0.11.5.md.

## November 3 — approved0.11.4 Elsewhere milestone

Tony says the current changes look good and requests check-in. This milestone
contains the Elsewhere row/default-on saved toggle, remote member/waypoint labels,
compact overflow/hover details, clearer navigation actions, Other addons settings/
report tab, launcher left/right/drag help and honest guide-controls label. It
builds on313f893 and includes the0.11.1 through0.11.4 changes documented below.
Historical uncommitted notes below describe the state before this checkpoint.

Rechecked: python scripts/run_tests.py (18 suites), check_structure.py, actual
stock SPF API/RXP composition and TomTom4.4.0 Forever/4.3.13 Hardcore registry
checks PASS; git diff --check PASS. No runtime or installed-addon change in this
check-in. Existing0.11.4 package/install verification remains recorded. No push.
General visual approval does not prove every manual check: GC-221/GC-222 and
GC-220 guide-step/hidden-arrow/Forever acceptance stay open; GC-223 direct Resume
requires upstream public support. Commit message: Milestone: Elsewhere indicators
and navigation help.

## November 3 —0.11.4 guide-controls label clarification

Renamed our shortcut to RestedXP guide controls... to describe its real action:
it opens the native controls, then Guidance > Resume guide is still required.
The actual native Resume button calculates the golden route to the current RXP
destination, without restarting guide/quest progress. Checked stock API, slash
parser, settings initializer and tracker menu: no public Resume, named button or
stable /click target. Do not scrape private callbacks/widgets or modify providers.
Faster native path: right-click SPF journey tracker heading > Resume RestedXP guide.
GC-223: direct GC Resume requires an upstream public action; unavailable currently.

Installed0.11.4 in both exact GC folders;31 matching source/package files each.
All18 suites, structure/ZIP/diff pass;4,756 third-party hashes unchanged. No
backups/SavedVariables/provider writes or new commit. Includes0.11.3 launcher
three-line hover help. Native visual checks GC-222/GC-221/GC-220 remain open.

## November 3 —0.11.3 launcher hover help installed

Minimap launcher now has three separate wrapped tooltip rows: left-click opens
compass/map/other-addon options; right-click opens navigation choices for guide
controls, members and TomTom points; left-drag moves the icon. Click behavior is
unchanged. Installed31 source/package-matching files into both GC folders, no
backups/SavedVariables/provider writes;4,756 third-party hashes still unchanged.
18 suites, actual launcher three-line/leave check, structure/ZIP and diff checks
PASS. Native tooltip appearance remains part of GC-222. No new commit after313f893.

Clarification requested by Tony: the ACTUAL native Resume guide button plans the
golden path to RXP's current navigation destination (NPC/objective/travel step);
it does not restart the guide or alter quest progress. Our Resume... menu item
ONLY opens those controls. Stock API/CLI provides no direct Resume action, so
Guidance > Resume guide still requires a native click; no one-click promise.
This distinction is easy to misread and remains a native UX limitation.
Closeout supplement: docs/MENU_HELP_0.11.2.md (0.11.3 section).

## November 3 — 0.11.2 clearer target menu and settings/help

Installed0.11.2 in Hardcore and Forever's exact GroupCompass folders;31 files
match each source/package. Third-party4,756-file comparison still unchanged.
18 Lua5.1 suites, structure, actual stock SPF API/RXP composition, ZIP and diff
checks PASS. No provider changes, private calls, SavedVariables or backups.

Right-click menu now has Resume RestedXP guide..., Party members and TomTom points;
Selected Blizzard quest appears only when this client can provide it. Hover help
uses a title plus wrapped explanation on each actionable row. Recalculate this
route and Stop this route appear only for our applicable owned route; settings
and reports moved to cyan left-click > Other addons (or /gcompass options).
This tab has native SPF, RXP and TomTom settings plus Route report (diagnostics),
all with hover help. Menu height shrinks with the number of actions.

IMPORTANT: Resume is a native-controls shortcut, not a one-click resume. Stock
SPF exposes no public Resume API or slash action. It opens /path; choose Guidance
> RestedXP guide > Resume guide, bottom red button. Tooltip and chat say this.
No namespace/widget scraping or support patch was added. Recalculate resends the
same target/member snapshot; reselect a member for a fresh location. Stop cancels
only our route, not a separate guide, saved point or TomTom arrow. Report is
troubleshooting output and does not change a target or send anything automatically.

GC-222 OPEN: native hover wrapping, conditional rows, tab links, compact sizing
and Resume handoff. GC-221 Elsewhere visual/toggle and GC-220 guide advancement/
hidden arrows remain open. Unmodified Forever gameplay acceptance pending.
Pre-existing0.11.1 changes retained;0.11.2 work remains uncommitted after checkpoint
313f893. Detailed commands/files/manual checks: docs/MENU_HELP_0.11.2.md.

## November 3 — 0.11.1 Elsewhere line installed

Confirmed clean checkpoint 313f893 before feature edits (local commit; no push).
Installed 0.11.1 in both exact GroupCompass folders: 31 matching files each.
No backups, SavedVariables or third-party addon writes; 4,756 dependency files
matched pre-install hashes. New feature remains uncommitted after that checkpoint.

Elsewhere is a compact line beneath the original compass, visible alongside local
markers. Remote member names use available continent labels; remote TomTom points
use their map/area names. Missing names fall back to Different world area only
when a separate world/continent is established. Unknown/offline locations are not
misrepresented as remote. No invented bearing/distance or extra map pins.
Compass options > Show Elsewhere line (remote members and points) defaults ON,
applies immediately and saves OFF across reload; Reset defaults restores ON.
Empty lists/demo hide the row. Crowded rows summarize and hover lists up to 20
remote identities, with an explicit remaining count. Local bearings retain their
positions; the extra row adds text-size + 7 UI pixels only when visible.

18 regression suites, structure, actual stock SPF API/RXP composition, actual
Forever TomTom4.4.0 and Hardcore4.3.13 registry checks, ZIP integrity/source match
and diff check PASS. TomTom4.4.0 moved its public registry to core/waypoints.lua;
test harness now covers that audited layout; no GC bridge/runtime provider change
was required. WoW frames/projection/callback services are doubled in offline tests.

GC-221 OPEN: native visual placement, local+remote members/waypoints, hover/overflow,
checkbox OFF/reload persistence, re-entry/deletion clearing; unmodified Forever
acceptance stays open. Reload and confirm0.11.1; options are cyan left-click >
Compass (or /gcompass options). RXP after reload still needs /path > Guidance >
RestedXP guide > Resume guide: its public API has no current-destination getter.
Tony confirms toggling guide following refreshed [RXP]; do not claim automatic
reload recovery. Full closeout: docs/ELSEWHERE_0.11.1.md.

## November 3 — RXP marker visible; second TomTom point is cross-continent

Tony confirms the RestedXP marker did show up after enabling native guide
following/resuming. Settings screenshot shows both Follow RestedXP guides and
Follow TomTom's arrow enabled. This confirms one visible RXP marker, not yet
step advancement, reload recovery, hidden-arrow behavior or Forever acceptance.

Live `/gcompass waypoint list` screenshot identifies T1 DistinctltyName on
map1457 (Darnassus), 76.2,57.8, and T2 TomTom waypoint on map1453 (Stormwind),
57.9,41.3. The player is in Darnassus. T2 is on the other continent, so the
existing same-world compass filter explains its absence; no lost waypoint or
label-collision defect is established. Add a second local point and face it to
check simultaneous local markers. No code, settings, SavedVariables, install or
Git mutation is needed for these two findings. Native arbitrary SPF routes/turns
remain outside the public API; GC-220 stays open for the remaining checks.
Documentation-only update: no runtime tests rerun. Reviewed the inserted notes
and ran git diff --check; previous 18-suite pass is unchanged, not a new result.

## November 3 — missing unified markers reported; client check remains open

Tony reports two TomTom points in the menu but one label on the strip, a visible
RestedXP Step 22 arrow without an RXP strip marker, and a rendered native Shortest
Path journey without a strip marker. Screenshot places player in Darnassus while
viewing Stormwind; it does not establish the second point's live coordinates.

Code review confirms: TomTom markers require the same world and front-facing
bearing; overlapping labels retain ticks/hover but hide a name. RXP observation
requires SPF's native Follow RestedXP guides and a fresh Resume guide/step request.
Saved settings have restedxp=false, but the file may lag the current session.
The menu's separate-journey message is consistent with a native/manual route;
stock API v1 has no getter for that route's destination or next turn. Version
0.11.0 cannot display every rendered SPF journey. Earlier coverage was overstated;
do not mark GC-220 accepted or add private provider/frame reads to hide this limit.

Both installed GC folders match current source by SHA-256. Re-ran
`python scripts/run_tests.py`: all 18 suites PASS. These offline checks do not
reproduce the screenshot's live state. Requested `/gcompass status` output to
confirm loaded version and destination status; reply pending. No runtime,
installed addon, settings, SavedVariables or Git state changes in this diagnosis.
Native acceptance, second-point visibility reason and guide setup remain open.

## November3 —0.11.0 unified destination bar implemented

Installed0.11.0 into both exact GroupCompass folders (Hardcore and Forever); all31
files match package/source hashes. Other addons/settings untouched; no backups.

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

Historical checkpoints below retain the facts and limitations recorded at the time. Earlier private getter/source-menu instructions are superseded by this correction.

Date: 2026-10-30.

## Latest checkpoint: golden-path targets 0.10.0 / hc-test.6, 2026-10-30

Right-click launcher selects RXP, named TomTom points or a member's current
location snapshot; left-click retains options. Menu exposes target/search/failure
state, Retry, Stop and unavailable native quest reasons. Group Compass only calls
optional provider APIs; all compatibility/settings control remains in the separate
private provider. Source selection is an explicit replacement. Manual targets
disable RXP/TomTom automatic followers; selecting RXP resumes native progression.

18 consumer and seven provider suites pass, including actual RXP/selector/consumer
composition. Three real terrain searches and both-map geometry pass; approximate
points near the pictured area return offmesh. This is a possible lone-dot cause,
not confirmation of the exact live failure. GC-217/HC-008 and GC-218 stay open.
Original release hashes were re-pinned locally after Forever independently
updated to v1.22.14; all 115 original v1.22.9 hashes match the published release.
See docs/CLOSEOUT_2026-10-30_ROUTE_TARGETS.md. Full restart for new TOC modules.

## Latest checkpoint: first party-pin lifecycle fix 0.9.4, 2026-10-29

Tony's nil fill at MarkerStyle.lua:13 is reproduced by the real documented pool
order: OnReleased precedes OnLoad on first acquisition. Cleanup now tolerates
the expected pre-artwork state. The old test skipped this reset and missed the
failure. A map exception could abort Core before drawing the friend's name.

All 17 Lua 5.1 suites, actual installed TomTom API and structure/ZIP checks pass.
New coverage includes repeated party joins/leaves, new/reused pins, map switching
and actual Core/Maps composition. Source/package/install are 0.9.4; all 29
installed hashes and file names match. Automatic approval blocked directory
clearing; in-place copying succeeded without backups or extra files. Native
party/OpenMapClassic behavior remains GC-216; no full-client pass is claimed.
No changes to OpenMapClassic, Shortest Path, Forever or SavedVariables. Details:
docs/CLOSEOUT_2026-10-29_PARTY_PIN.md.

## Latest checkpoint: route-source clarity 0.9.3, 2026-10-27

Zero TomTom points can coexist with a separate Shortest Path journey. Screenshot
confirms foreign-journey status, not its owner. RestedXP is likely from source/
defaults, but not natively confirmed. Owned waypoint-deletion cancellation passes.
0.9.3 identifies RestedXP/TomTom through the public owner query, explains separate
journeys and adds Route settings in the waypoint window. No provider preferences
changed or foreign journeys cancelled. Native source/clearing review is GC-215.

17 suites, actual TomTom API, five private provider consumer suites, package and
29 installed hashes pass. Three changed runtime files installed; no provider,
Forever, SavedVariables or Git mutations. Full file/check/manual details:
docs/CLOSEOUT_2026-10-27_ROUTE_SOURCE.md.

## Latest checkpoint: hc-test.5 XML map artwork, 2026-10-27

Tony confirms native gold path rendering on both maps. Map.xml:10 still warned
about missing UI-QuestPoi-OuterGlow, repeated 19 times. Hidden atlas attributes
are resolved by XML before Lua guards. All six are removed from the separate
provider template; dock/flight callbacks use checked native art or existing
Classic ring/goal fallbacks. Goal-stop artwork remains checked on acquisition.

Five private suites pass, including reproduction before the fix, actual pin
callbacks and repeated missing/native art profiles. Syntax/XML/TOC, unchanged
original source and 117 installed SHA-256 checks pass. Five private runtime files
updated; Group Compass 0.9.2 runtime, Forever and SavedVariables unchanged.
/reload and close/reopen the main map; native warning-free lifecycle remains
HC-007 / GC-113. Full movement/turn/transport/launch acceptance remains open.
Private file/check/manual details: shortest-path-hardcore-test/XML_ART_CLOSEOUT_2026-10-27.md.

## Latest checkpoint: compass appearance controls 0.9.2, 2026-10-27

Added Compass (default) and Map markers tabs without enlarging the options window.
Compass sliders adjust width (320–1200), height (40–160), and all bar text (8–20),
with current values, limits and live saved preview. Height also enforces a minimum
of 3 * text size + 16 to prevent overlapping rows. Defaults stay 620/46/10.
Geometry, N/E/S/W/member bearings, collision widths and hover resize together;
hidden bars stay hidden. Existing map controls and global reset remain available.

All 17 suites, actual installed TomTom API composition, structure/ZIP/source,
29 installed SHA-256 comparisons and the four private-provider consumer suites
pass. Five changed addon files installed without backups; no provider runtime or
Git changes. Native interaction/layout/persistence review is GC-214. Details and
exact file/check list: docs/CLOSEOUT_2026-10-27_COMPASS_APPEARANCE.md.

## Latest checkpoint: 0.9.1 headings and hc-test.4 map artwork, 2026-10-27

Tony confirmed golden path rendering on the minimap. Opening the world map then
failed because StopPin dereferenced a missing Forever-only waypoint atlas. The
separate hc-test.4 provider now uses its existing gold dot when goal/ring/button
art is absent, with readable font numbers for fallback stops. Native art remains
unchanged when available. Four private regression suites and three terrain/map
geometry checks pass; all 117 installed files match source. Reopen-map verification
is HC-006; sustained RXP/turns/movement/transports and Forever remain open.

Group Compass 0.9.1 adds N/E/S/W without increasing the 46-unit strip. Labels
follow the same angular convention as members, work solo and without coordinates,
and clear with unavailable facing. All 17 suites, actual TomTom API composition,
structure/ZIP/source checks and 29 installed hashes pass. Visual gate GC-213.

Automatic approval review rejected directory clearing; changed-file copies into
both exact addon folders succeeded with complete hash/file-set verification, no
backups or SavedVariables edits. No Git mutations. Detailed files, commands,
limitations and retest: docs/CLOSEOUT_2026-10-27_CARDINALS_AND_MAP_ART.md.

## Latest checkpoint: private hc-test.3 hazard/planner watchdog fix, 2026-10-27

Tony's native timeout at 13:13:12 goes RXP.UpdateGotoSteps > JourneySearch.Start >
Planner.Plan/BakedCost > Hazards.Segment/Clip. Initial graph preview was synchronous
and had no active deadline. Reused-batch proof and timer planning could also enter
directly. The new private search_budget_test.lua reproduces synchronous excessive
map reads before the fix using actual data/graph/hazards/search/scheduler.

Provider-only runtime changes: PathJobs.lua adds cancellable deferred work using
its existing notification queue; JourneySearch.lua queues preview/reuse/timer
planning with revision guards; Hazards.lua yields between zone checks; TOC is
hc-test.3. Core path/Planner/Nav/Strokes and avoidance rules are preserved.
Timer jobs coalesce, work is FIFO, path callbacks retain priority, unexpected
errors remain visible. No Group Compass runtime, RXP source or Forever edit.

Checks: private verify.py passes three suites, source hashes, syntax/TOC/XML,
unchanged consumer composition, stale-work cancellation, replacement, combat,
warm/timer cache rebuild, scheduling order, error delivery and original penalty
equivalence. Fixture max slice 2.902 ms over 452 aggregate slices uses simulated
map API cost, not native timing. check_engine.py passes three cold asynchronous
terrain jobs with identical synchronous costs plus both-map strokes and the
historical limited cross-world plan. Four private files installed; all 117 hashes
match. Native RXP/manual routes and responsiveness remain HC-005/GC-109; /reload
and retest. Detailed inventory/checks: private TIMEOUT_FIX_CLOSEOUT_2026-10-27.md.

## Latest checkpoint: private provider hc-test.2 startup event fix

Tony's first native load failed with unknown SUPER_TRACKING_CHANGED in both
journey and flight-pin startup. Journey initialization stopped before attaching
its event handler/final Hide. The adjacent USER_WAYPOINT_UPDATED registration was
also incompatible. The existing test double accepted every event and missed this.
New private tests/events_test.lua reproduces the exact fault using both actual
initializers, then verifies unsupported/supported/no-query profiles after the fix.

Private Classic/Compat.lua now registers optional navigation events only when
supported; Journey/Journey.lua and UI/FlightPins.lua use it at three call sites.
TOC version is v1.22.9-hc-test.2. Normal required events and unexpected errors are
not suppressed. Private tools/verify.py passes both suites including unchanged
Group Compass consumer composition and original Forever SHA checks. Four deployed
runtime files changed; all 117 installed hashes match. No Group Compass runtime,
Forever or SavedVariables file changed; prior documentation edits are preserved.
Detailed files/checks: private EVENT_FIX_CLOSEOUT.md. /reload and Navigate to the
nearby point; native route visibility/movement remain pending. No Git mutation.

## Latest checkpoint: separate private SPF Hardcore test copy, 2026-10-26

Tony explicitly selected a separate, undistributed provider test for pre-launch
testing. Workspace: C:\Users\Gaming PC\Documents\git\Wow_Addons\shortest-path-hardcore-test.
Based on installed SPF v1.22.9, version v1.22.9-hc-test.1/interface 11509. It is
installed into Hardcore AddOns\ShortestPathForever; all 117 source/installed file
SHA-256 values match. Group Compass remains 0.9.0. No GroupCompass/ runtime file,
original Forever source, other addon or SavedVariables was modified.

Provider-only work: nine original files changed, two Classic modules added. The
full upstream engine/nav/route geometry remains unchanged and SHA-pinned. Native
waypoint capability guards choose its existing fallback arrow; added private
read-only GetGuidance and local minimap/map opening/item cooldown/flight tracking
guards. Initial duplicate compass/TomTom-follow/sharing/release popup disabled;
bend progression enabled. Licence/attribution retained. No Git init/commit/push.

Checks: private tools/verify.py passes Lua 5.1 syntax for all source, XML/TOC paths,
upstream immutability and real Guide/Arrow/API regression plus unchanged Group
Compass consumer composition. tools/check_engine.py passes three real walking
paths and world/minimap geometry (9/23/17 points, 182/139/151 world strokes,
8/9/8 minimap strokes), missing terrain and an estimated cross-continent plan.
UI/client services and map projection are doubled; encoding uses Python adapters.
Native loading, placement, movement/arrival/combat, transports and Forever launch
verification remain open. Private README.md/STATUS.md/install-report.json,
upstream-manifest.json, compatibility.patch, tools and tests record the exact work.

This checkout changes only these notes, active tracker/design and Drive manifest;
the separate test source is not added to the Group Compass repository or package.

## Latest checkpoint: local check-in of 0.9.0, 2026-10-26

Tony reports that things look good and explicitly authorized this local check-in.
Includes all accumulated addon, original artwork, regression tests, routing API
research/prototype and project notes since 02e0bbe. Generated ZIPs/logs and local
.test-tools remain ignored. No runtime behavior or installed file changed in this
check-in task. Only this checkpoint, progress note and feedback item were edited.

Checks repeated: python scripts/run_tests.py PASS all 17 Lua 5.1 suites;
python scripts/check_structure.py PASS; git diff --check PASS. Inspected current
status, tracked diff and every untracked candidate; no credential-pattern matches
in source/test/docs/scripts/integrations. Git staging review/check precedes commit.
Use git log for the resulting commit ID. This request authorizes a local commit;
no remote push was requested. The detailed file list and implementation checks
remain in the previous checkpoint below.

Tony's feedback is broad, not a claim that every native acceptance scenario ran.
GC-212 remains open for the detailed in-game matrix; SPF Hardcore compatibility
and actual next-turn/golden routes remain separate GC-105/106/210. Next priority:
record specific native checks as they are completed, then continue routing work.

## Previous checkpoint: TomTom shared waypoints and options help 0.9.0, 2026-10-26

Completed: switched live waypoint creation/storage/map pins to TomTom, and reads
its existing/native-created points for our shared compass. No duplicate map pins.
New points enable live display and leave demo; nearest 20 locatable points enter
the bar, filtered to the forward half. Group tracking/appearance stays independent.

Menus: cyan launcher > Waypoints & help shows the configured map modifier (default
Alt + right-click), numbered creation steps, automatic bar sync and character-facing
visibility note. Both main and waypoint menus link to native TomTom settings.
The retained Edit window supplies name and ten texture choices missing from its
context menu. Save/Enter commits, Cancel/X/Escape discards. Keep current preserves
native theme/custom texture/portrait. TomTom handles its own themes, map sizes and
profile persistence; group-member glow/flash/class colors do not style its points.

Removed independent waypoint live CRUD, Alt-left-click handler, custom waypoint
map projection/renderer, map-pin Edit handlers and dead style branches. Legacy
GroupCompassWaypointsDB records are retained unchanged for once-only confirmed
API import, not a second live store. Imported deletions are not resurrected. Without
TomTom, group tracking works and waypoint help says enable/restart; no new fallback.

Bridge details: optional dependency and capability guards; exposed waypoints/UID
layout read for enumeration (a provider coupling, not a dedicated list API). No
private frame/profile-key mutation. API Add/Remove owns registry changes. Since
titles form TomTom's keys and no Rename method exists, rename adds/validates first,
rejects existing UID/key collisions and removes original last. Same-name icon edits
refresh the same UID via ClearWaypoint/SetWaypoint and restore options on failure.
Callbacks/persistence/unknown fields and reload arrow option are preserved. A public
SetCrazyArrow post-hook tracks known arrow references; if an existing active arrow
is unknown, rename explicitly asks to clear it first. Other-addon-owned points are
read-only here. Session IDs can change on TomTom reload/profile changes; routes
remain session-only. No copies of TomTom code/artwork were redistributed or edited.

Files created this task:

- GroupCompass/TomTomBridge.lua; tests/tomtom_test.lua;
  scripts/check_tomtom_offline.py;
  docs/research/tomtom-integration-2026-10-26.json; generated dist/GroupCompass-0.9.0.zip.

Files modified this task (earlier uncommitted work preserved):

- GroupCompass/Waypoints.lua, WaypointUI.lua, Core.lua, Maps.lua, Routing.lua,
  Options.lua, MarkerStyle.lua and GroupCompass.toc.
- tests/waypoints_test.lua, waypoint_ui_test.lua, maps_test.lua, options_test.lua,
  style_test.lua, core_test.lua and classic_test.lua; scripts/check_structure.py.
- README.md, docs/TESTING.md, docs/PROJECT_STATUS.md.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-26_COMPLETED.md and drive-manifest.json.

Checks run:

- python scripts/run_tests.py: PASS all 17 Lua 5.1 suites. Covers configured help,
  settings links, external addition detection, real facade/editor interactions,
  names/UTF-8, shared CRUD, cancellation, icons/portrait preservation, collisions,
  failed add/icon restoration, foreign ownership, arrow references, nearest cap,
  unavailable/secret data, migration/removal/no-resurrection and unchanged groups.
- python scripts/check_tomtom_offline.py with the installed Classic TomTom path:
  PASS, actual TomTom.lua Add/Remove/registry/persistence methods; UI pins doubled.
  The version guard initially caught an external v4.3.12-to-v4.3.13 update. Re-audit
  found identical TomTom.lua hash and the same dependent icon/settings contracts;
  final v4.3.13 composition passes. Not a native renderer/HBD/map-click/gameplay test.
- python scripts/build_zip.py: PASS structure, Classic/Forever TOC order, XML,
  artwork, no orphan runtime files and ZIP integrity/entries/source bytes.
- git diff --check: PASS. Reviewed task changes against start-of-task contents and
  tracked diff; searched callers for deleted HookMap/MapMembers/pin Edit paths.
  No competing waypoint subsystem remains. Existing unrelated work left intact.
- Authorized exact-target clean install: PASS version 0.9.0, all 29 installed files
  match source SHA-256. No backup; TomTom, other addons and WTF untouched. No Git
  stage/commit/push. Provider fingerprint evidence is in docs/research JSON.

Tony's native check (GC-212): fully restart, confirm /gcompass status 0.9.0, then
cyan button > Waypoints & help. Press M and Alt + right-click a zone-map spot (or
the displayed configured shortcut). Face the point with the character; it should
appear automatically in our list/bar. Edit its name/icon, Cancel a draft, open
TomTom settings, reload and remove. Check migration and no duplicate pins. Other
worlds/behind/over nearest-20 cap omit bearings. Detailed steps: docs/TESTING.md.

Remaining: native WoW layout/click/focus/HBD/bar/persistence/migration acceptance
is unverified. GC-108 implementation archived as GC-019; GC-208/211 superseded by
GC-212 rather than claimed passed. Next priority is that gameplay check, fixing
any observed issue, then the separately pending SPF Hardcore compatibility and
supported next-turn contract (GC-105/106/210). No live golden route was enabled.

## Previous checkpoint: waypoint editor 0.8.1, 2026-10-26

Completed: name and ten-icon editing for personal waypoints. Alt-click map creation
opens the editor; later left-click either map icon or use Waypoints > Edit. Save/
Enter commits, Cancel/X/Escape discards edits. New points remain saved as default
pins when cancelled. Names update both map tooltips and bar; shapes update both maps.
ID/location/unknown fields and character storage are preserved. Invalid stored
icons fall back; invalid updates reject without mutation. No route restart or new
provider capability. Existing member styles/sizes/effects remain usable.

Root cause: map creation supplied no name input, the list had no edit action and
Waypoints.marker hardcoded pin. Reused shared sanitation and existing icon catalog;
added one editor to WaypointUI and public Find/Icon/Update helpers. MapCanvas uses
its native OnClick callback; minimap waypoint markers accept inside left-release,
party markers pass clicks through. Full native behavior remains a manual gate.

Files changed this task (prior 0.6.x–0.8.0 work preserved):

- GroupCompass/Waypoints.lua, WaypointUI.lua, Maps.lua, GroupCompass.toc.
- tests/waypoints_test.lua, waypoint_ui_test.lua, maps_test.lua, classic_test.lua.
- README.md, docs/TESTING.md, docs/PROJECT_STATUS.md.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-26_COMPLETED.md and drive-manifest.json.
- Generated dist/GroupCompass-0.8.1.zip; no runtime modules/assets/dependencies added.

Checks actually run:

- Focused Lua 5.1 execution via project-local lupa for waypoint, editor and map
  suites: PASS. Real editor/storage and lazy map-first composition, all ten tiles,
  Save/Cancel/Enter/Escape, draft isolation, deletion, reload, UTF-8, empty names,
  edit at capacity, legacy/bad icon fallback, invalid choice rejection, map events
  and party-marker reuse/pass-through are covered.
- python scripts/run_tests.py: PASS all 16 Lua 5.1 suites. Final added lazy-entry
  case also passed its focused suite. WoW frame/map/API behavior is simulated.
- python scripts/build_zip.py: PASS structure/TOC/XML/artwork and ZIP integrity,
  entries and byte-for-byte source match.
- git diff --check: PASS; reviewed task-specific source/test diff against starting
  contents, final tracked diff and affected callers. No duplicate editor or orphan.
- Exact-target PowerShell clean install: PASS, version 0.8.1 and all 28 files
  SHA-256 match source. No backup; other addons and WTF untouched. No Git mutation.

Tony's verification: /reload then /gcompass status (0.8.1; restart if metadata is
stale). Press M, open zone, Alt-left-click; name Camp, choose Star, Save. Reopen from
world pin/minimap/list Edit, try Cancel/Enter/Escape, then reload for persistence.
Check readable palette/layout/focus and unchanged ordinary map/group behavior.
Detailed steps: docs/TESTING.md. Native gate GC-211 is open; implementation GC-107
is recorded in completed archive GC-018. No native 0.8.1 gameplay claim.

Remaining/next: Tony's native editor test first; resolve any observed errors, then
resume provider-local Hardcore routing compatibility GC-105/106/210. Golden routes
and next-turn navigation remain unavailable in the current Hardcore provider setup.

## Previous checkpoint: native probe and optional routing bridge 0.8.0, 2026-10-26

Confirmed screenshot output: SPF: function function nil nil. canaccessvalue and
C_EncodingUtil.DecompressString exist; C_Map.GetUserWaypoint and
C_SuperTrack.GetHighestPrioritySuperTrackingType are unavailable. This does not
establish namespace absence, decode success, remaining API availability or client
build. SPF v1.22.4 still has unguarded uses in JourneyGuide.lua; unchanged native
guidance cannot run here. No further chat probe needed for this initial finding.

Implemented GroupCompass/Routing.lua, optional public API v1 discovery and saved
point Navigate/Replace/Stop/status. New same-baseline cyan next step consumes only
the proposed GetGuidance result; validates version, world space and readable finite
data. Clear on combat/lost ownership/inactive/missing data. Keep route-turn points
out of party/map samplers. Missing provider/getter and external errors remain visible.
Off/demo/removal stop only our owned route; cancellation refusal remains visible.
Route selection is session-only. New optional TOC dependency; no new library/data.

Created GroupCompass/Routing.lua, tests/routing_test.lua,
docs/CLASSIC_ROUTING_COMPATIBILITY.md, docs/research/classic-routing-probe-2026-10-26.png
(copy of Tony's supplied image), its JSON sidecar, and
 docs/project-memory/archive/2026-10-26_COMPLETED.md. Modified Core.lua, WaypointUI.lua,
GroupCompass.toc; tests/classic_test.lua, core_test.lua, waypoint_ui_test.lua;
scripts/check_structure.py; README.md, docs/TESTING.md, ROUTING_FEASIBILITY.md,
ROUTING_TEST_RESULTS.md, integrations/ShortestPathForever/README.md, this file,
five active memory Markdown files and drive-manifest.json. Built dist/GroupCompass-0.8.0.zip.
Prior 0.6.x/0.7.0 uncommitted changes preserved; no staging/commit/push. No SPF edit.

Verification: focused routing/core checks PASS; python scripts/run_tests.py PASS
all 16 Lua 5.1 suites. Actual consumer + proposed getter composition passes with
C_Map/C_SuperTrack absent, alongside missing/version/late provider, normalized named
input, explicit replacement, cancellation refusal, removed point, foreign ownership,
provider errors/rejection, combat resume, remote/secret clearing and window controls.
python scripts/build_zip.py PASS, structure/TOC/XML/artwork + ZIP integrity/paths/source
bytes. git diff --check PASS. Reviewed final tracked diff and new Routing module.
No duplicate pathfinder, fake native globals or orphan runtime module introduced.

Final clean replacement of only the exact authorized Classic GroupCompass directory
passed all 28 file SHA-256 matches; no backup. Other addons and WTF untouched. An
initial preflight ZIP was preserved locally before final removed-route status cleanup;
only final 0.8.0 is installed/current package. No further runtime edit after final install.

Manual GC-209: fully restart, /gcompass waypoints, check Navigate/Replace/Stop/status
and safe missing-provider behavior; /gcompass route status gives same status. Existing
saved pins, demo, class colors and maps must remain usable. No live golden route or
native next-step test is available in current unported Hardcore. Provider GetGuidance
remains an uninstalled/unadopted draft; full Classic port and native provider navigation
are open GC-105/106/210. No live 0.8.0 UI/provider validation was claimed.

Next: native controls/fallback review, provider-local non-native guidance adaptation
and remaining Classic API/data audit, supported getter/build, then full Forever route
and transport/cross-continent acceptance. Detailed evidence: docs/CLASSIC_ROUTING_COMPATIBILITY.md.

## Previous checkpoint: guidance prototype and testing, 2026-10-24; installed 0.7.0

Tony selected reuse of the optional SPF public API and accepts combat deferrals
for waypoint routing. Existing no-auto-pause party/member behavior stays unchanged.
Prepared an additive provider-side GetGuidance(owner) prototype returning copied
current/next-turn, step-end and destination world coordinates. It declines foreign
ownership, combat, corpse-run borrowing, inactive and invalid targets. No private
frames/hooks or duplicate pathfinder. Not installed or accepted upstream; public
route controls and our top-bar consumer remain open as GC-104/105.

New files: integrations/ShortestPathForever/GuidanceAPI.lua and README.md,
tests/guidance_api_test.lua, scripts/check_spf_offline.py,
docs/ROUTING_TEST_RESULTS.md and docs/research/spf-offline-results-2026-10-24.json.
Created generated dist/GroupCompass-Routing-Research-2026-10-24.zip; seven entries
passed integrity and source-byte checks. This is a research artifact, not a release.
Modified docs/ROUTING_FEASIBILITY.md, this checkpoint, five active memory Markdown
files, archive/2026-10-24_COMPLETED.md and drive-manifest.json. Prior source/tests/
artwork worktree changes preserved. No installed-addon edits, third-party source
copy, dependency, stage, commit or push; source/package/installed addon remains 0.7.0.

Checks: focused guidance test via project-local lupa.lua51 PASS; then
python scripts/run_tests.py PASS all 15 Lua 5.1 suites (14 existing plus prototype).
python scripts/check_structure.py PASS. git diff --check PASS. Reviewed new source,
contract tests, runtime exclusion, fingerprints and changed documentation. No new
runtime file or obsolete implementation was introduced. No release rebuild/install
needed because the provider prototype is outside GroupCompass.toc and package.

Real-engine command: python scripts/check_spf_offline.py <installed SPF directory>
PASS, with actual installed v1.22.4 terrain and search modules loaded read-only.
Shadowglen/Dolanaar-area: 9 points, searched cost 720.98 yd; Coldridge/Kharanos-area:
23 points, 1198.37 yd; Goldshire/Stormwind: 17 points, 1073.48 yd. Missing terrain
returned nodata. Real transport planner produced a 5-leg intercontinental boat
plan; endpoint walking legs estimated, no known flight paths or live boat clocks.
Raw output/source hashes saved. This does not prove native path safety, timing,
UI, API.Navigate or client compatibility. Development runtime reuses existing
Lupa plus Python standard base64/zlib; these adapters cannot run inside WoW.

Blizzard confirms beta closed October 23, name creation October 27, world launch
November 4. No public Forever gameplay test realm was established. Recommend
offline engine coverage plus existing Classic UI checks now. Full provider port
is plausible but unproven: encoding, native waypoint/supertracking/navigation and
other client APIs require live inventory before scope is known. A four-API
read-only WoW chat probe was requested asynchronously; output is still pending.
No quick-port claim or promise that another WoW version proves Forever is made.

Next: implement owner-scoped Navigate/Stop adapter, establish/load the supported
getter and bar consumer, use the pending probe to bound any Classic test adapter,
then execute local/cross-continent and combat-resume acceptance in native Forever.
Completed prototype/offline work is GC-016; native/consumer gates remain active.

## Previous checkpoint: routing feasibility, 2026-10-24; installed 0.7.0 unchanged

Completed the requested installed-addon inspection. Found Shortest Path Forever
v1.22.4 in the Forever AddOns folder (interface 16001). It already accepts arbitrary
map destinations and plans local/cross-continent travel. Public API.Navigate can
accept our existing saved point coordinates. Recommended an optional Navigate/Stop
adapter; a complete standalone engine is a separate architecture decision.

Two material limits remain: next-turn coordinates/geometry are not exposed in the
public API, and searches/progress/map refresh defer in combat. Classic Hardcore
compatibility is not established. No runtime feature, third-party source copy,
installed-addon edit, dependency, build/version bump or Git mutation this task.
Existing uncommitted 0.6.x/0.7.0 source/tests/artwork changes were preserved.

Created docs/ROUTING_FEASIBILITY.md and
 docs/project-memory/archive/2026-10-24_COMPLETED.md (GC-015 completed research).
Updated this checkpoint, project-memory 00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md, and drive-manifest.json.
GC-104/105/106 track proposed integration, next-target API and combat/client policy.
No completed-implementation claim follows from the completed investigation.

Checks: read-only Python source probe PASS, installed API v1/minor1, Navigate
signature, ten public functions, no exported GuideTargets; 27 navigation Lua files,
11,882,769 bytes. python scripts/check_structure.py PASS. git diff --check PASS.
Final documentation diff reviewed; no new runtime/duplicate implementation created.
No Lua suite rerun or package/install was needed for documentation-only changes;
prior 14-suite release evidence remains historical. Initial git status in the
non-repository parent failed, then succeeded in the active checkout; missing search
paths were corrected using the installed TOC. No unresolved check failure.

Tony's next native check: in Forever, Shift-click a nearby zone-map point (use
/path way instead if another addon intercepts clicks), then a zone-map point on
the other continent, to exercise the existing provider before integration. Record
actual available legs and combat behavior. No exact starter-to-continent itinerary
was executed here. Prioritize the optional adapter after the dependency/continuity
tradeoff is selected, then supported next-target output, then native route coverage.

## Previous checkpoint: personal waypoints, version 0.7.0

Implemented personal waypoints on the world map, minimap and shared horizontal
compass bar. Gold pins and [Wnumber] names distinguish waypoints from members.
Alt-left-click a zone map, save the current location in the Waypoints window, or
use /gcompass waypoint here Camp. /gcompass waypoints opens the list/removal UI;
/gcompass waypoint 45 60 Camp uses percentages in the player's current zone.
Up to 20 points persist per character. Adding a real point exits demo, enables
live views and refreshes immediately; removing points refreshes all views.

Created GroupCompass/Waypoints.lua, GroupCompass/WaypointUI.lua,
tests/waypoints_test.lua and tests/waypoint_ui_test.lua. Modified Core.lua,
Maps.lua, MarkerStyle.lua, Options.lua, GroupCompass.toc, scripts/check_structure.py,
tests/classic_test.lua, core_test.lua, maps_test.lua, style_test.lua and
options_test.lua. Updated README.md, docs/TESTING.md, FEASIBILITY.md, this file,
six core project-memory Markdown files and drive-manifest.json. Built
 dist/GroupCompass-0.7.0.zip. Earlier 0.6.x work remains uncommitted and preserved;
no staging, commits, push, dependencies or unrelated cleanup this task.

Native C_Map conversions supply world-space bearings and cross-map projections;
no guessed positions or cross-continent bearings. Same-map pins use their saved
normalized coordinates during transient conversion failure. Unsupported maps or
unreadable coordinates are rejected or unavailable. Points behind the character
are outside the bar's existing forward-facing view. No waypoint sharing yet.

Checks: python scripts/run_tests.py PASS, all 14 Lua 5.1 suites;
python scripts/check_structure.py PASS (TOC order, XML, assets and runtime orphans);
python scripts/build_zip.py PASS (integrity, paths and source-byte agreement);
git diff --check PASS. Reviewed waypoint modules, affected callers, persistence,
map projection, input hooks, UTF-8 labels, sampler ownership and task diff.
Coverage includes CRUD/reload/character DB, conversion/facing/turn/walk, map input,
missing data, UI, gold pin override, demo recovery and merged-array isolation.
Clean-installed 27 runtime/art files in the exact authorized Classic GroupCompass
directory; all match source by SHA-256. No backup; other addons/WTF untouched.

Manual gate GC-208 remains open: fully restart WoW for new TOC/modules/character
SavedVariables. Save Camp with /gcompass waypoint here Camp, walk away, turn toward
it and inspect both maps plus the top bar. Alt-click a zone map, remove a point,
/reload and verify persistence and character isolation. Check mixed party markers,
combat/instances and unavailable coordinates. Automated Lua stubs do not verify
native client rendering/API behavior. Forever is still unverified. Prioritize
this native smoke test, then the existing appearance and live-party checks.

## Previous checkpoint: colored minimap launcher, version 0.6.1

Tony requested color instead of the white-looking launcher. Previous tint was
pale gold. Options.lua now tints the head-and-shoulders icon saturated cyan
(0.1, 0.8, 1), over dark teal (0.02, 0.16, 0.22), keeping the gold rim.

Changed this task: GroupCompass/Options.lua, GroupCompass/GroupCompass.toc,
tests/classic_test.lua (version fixture), README.md, docs/TESTING.md, this checkpoint,
six core project-memory Markdown files and drive-manifest.json. Built
dist/GroupCompass-0.6.1.zip. All prior 0.6.0 changes/notes were preserved; no new
dependencies, staging, commits or push. No new behavior test mirrors the RGB literals.

Verification: python scripts/run_tests.py PASS, all 12 Lua 5.1 suites;
python scripts/check_structure.py PASS; python scripts/build_zip.py PASS, archive
integrity/paths/source bytes; git diff --check PASS. Reviewed the scoped RGB/version
edits against the already-reviewed options implementation. Final clean install
contains 25 files matching source by SHA-256; no backup. Initial install attempt
was not executed because automatic approval review hit a usage limit. Tony asked
to continue; the normal approved retry succeeded. Native color/contrast review is
still open under GC-207. Run /reload to inspect the launcher.

## Previous checkpoint: marker options and default person, version 0.6.0

Tony selected head & shoulders and requested a minimap-border button opening
simple icon/size/effect/color options. Implemented a one-page 430x490 panel with
live minimap/world-map previews, ten original marker styles, separate 12–40 size
sliders, None/Glow/Slow flash, Class/Party/Gold/Cyan/Pink/White colors, reset, close
and Escape. Defaults are person, minimap 20, world 24, no effect and class colors.
GroupCompassDB saves appearance and draggable border-button angle across reload.
/gcompass, options and config open the panel without enabling a hidden compass.
Map tooltip identity remains available; compass names keep class colors.

Added runtime modules GroupCompass/Settings.lua, MarkerStyle.lua and Options.lua;
twelve original 32-bit TGA assets under GroupCompass/Textures; generator
scripts/build_icons.py; tests/settings_test.lua, style_test.lua, options_test.lua.
Modified Core.lua, GroupCompass.toc, Maps.lua and Projection.lua; size-aware inset
retains large markers. Maps use pooled styles and stop flash on hide/release.
Modified scripts/build_zip.py and check_structure.py, tests/classic_test.lua,
core_test.lua, maps_test.lua and projection_test.lua. Updated README.md,
docs/FEASIBILITY.md, TESTING.md, this checkpoint, six project-memory Markdown files
and drive-manifest.json. Generated dist/GroupCompass-0.6.0.zip. Pre-existing
uncommitted marker-exploration notes in 02_DESIGN.md were preserved and contextualized.
No new dependencies, staging, commits, pushes, or unrelated source cleanup.

Checks: python scripts/run_tests.py PASS, all 12 Lua 5.1 suites. New UI regression
caught first-click menu logic comparing two nils; fixed and retested. Coverage
includes saved reload/reset/invalid settings, menu choices, live previews, independent
sizes/colors, border dragging/hiding, effects without per-tick restart, hide/release
cleanup and larger minimap edge clearance. python scripts/build_icons.py PASS;
python scripts/check_structure.py PASS, texture headers/alpha/paths/TOC/XML/orphans.
python scripts/build_zip.py PASS, runtime/artwork ZIP paths, integrity and source
byte agreement. Texture contact sheet visually inspected via a standard-library
PNG renderer after optional Pillow proved unavailable; no dependency was added.
git diff --check PASS. Tracked diff and untracked modules/tests reviewed directly.

Final installation: clean-replaced only the authorized Classic GroupCompass folder;
25 runtime/artwork files match source by SHA-256; no backup. A preflight ZIP was
retained locally under a distinct name before final drag-hide cleanup was packaged.

Native verification remains GC-207: fully restart WoW for TOC/SavedVariables/TGA,
click the gold person minimap-border button (fallback /gcompass options), check
previews, all controls, actual grouped map markers, saved reload, dragging, Escape,
animation/pin reuse, UI scale and addon skins. Local mocks do not prove native UI
appearance, combat frame behavior or Forever compatibility. No synthetic markers
were placed onto maps. Saved appearance is account-wide; compass layout unchanged.

Memory closeout: native project Doc updated through 21 scoped paragraph groups
with revision guard; readback verified all 193 expected paragraphs, heading styles
and list membership. Six Markdown mirrors, checkpoint and manifest updated in place.
0.6.0 package stored in Work; 0.5.2 moved to Archive with verified parent metadata.

## Previous checkpoint: initial local check-in of 0.5.2

Tony requested "check in our code now" on 2026-10-23. This authorizes staging and
a local commit. No remote push was requested. Initial repository has no prior
commits on main; origin is Dax000ah/wow_addons. Existing Git author/committer
configuration is available. No implementation changes were needed for check-in.

Included: addon runtime source/XML/TOC, nine Lua suites, three Python scripts,
development requirements, .gitignore, AGENTS.md, README, engineering docs and
project memory/design assets. Generated release ZIPs, logs, .test-tools and Python
caches remain ignored. Source is 0.5.2; marker styles are proposals only.

Re-ran python scripts/run_tests.py: PASS, all nine Lua 5.1 suites. Re-ran python
scripts/check_structure.py: PASS. Credential-pattern scan of nonignored source/
documentation found no private-key/token pattern matches (not a comprehensive
security audit). Staged inventory/diff and whitespace checks are the final commit
gate. git log -1 and git status --short identify the final commit and clean tree.
Project-memory edits for this check-in affect the index, active actions, progress
record and this checkpoint. Native combat/instance/map/Forever checks stay open.
No addon reinstall is needed for this Git-only checkpoint.

## Previous checkpoint: continuous tracking, version 0.5.2

Tony explicitly requested no automatic combat/instance pause. Root cause: two
blanket checks in Tracking.PlayerState and Tracking.MapMembers disabled otherwise
valid data. Removed both gates; all existing coordinate/secret/offline checks stay.
Compass, demo and map sampling continue when data is valid. Missing coordinates
clear affected markers and recover on the next refresh; remote-label behavior is
preserved. No attempt to bypass client restrictions or invent unavailable data.

Files changed: GroupCompass/Tracking.lua, GroupCompass/GroupCompass.toc,
tests/tracking_test.lua, tests/demo_test.lua, tests/core_test.lua, tests/classic_test.lua, README.md,
docs/TESTING.md, docs/FEASIBILITY.md, this checkpoint, the six core memory Markdown
files and drive-manifest.json. Added dist/GroupCompass-0.5.2.zip. Unrelated source
and old packages preserved. No dependencies or Git state-changing operations.

Checks: new combat/instance assertions first failed against old implementation.
python scripts/run_tests.py then passed all nine Lua 5.1 suites. Tests cover valid
tracking in combat/instances, missing-data clearing/recovery in those contexts,
map sampling, demo anchor retention, remote members and Classic startup. Commands
python scripts/check_structure.py and python scripts/build_zip.py passed: runtime
references/order/XML, no orphans, ZIP integrity and source-byte agreement. Exact
Classic folder clean-installed: ten files verified by SHA-256, no backup created.
Git status remains all untracked; tracked diff/check cannot assess untracked code,
so affected implementations and callers/tests were reviewed directly.

Native test remains GC-204: /reload, confirm 0.5.2 with /gcompass status, verify
valid tracking through combat and a shared instance and unavailable-data recovery.
An instance/client may still withhold coordinates, and different coordinate spaces
cannot produce a valid shared bearing. Map frame behavior during native combat
requires client verification. Remaining native layout/map/Forever checks stay open.

Project-closeout and Google Drive/Docs skills applied. Local and Drive memory
record this policy change; completed implementation GC-010 is archived separately
from the pending native verification.

Drive closeout: 15 scoped native Doc edits with revision guard, readback text and
native heading/list membership verified. Updated six Markdown mirrors, manifest
and checkpoint in place. Uploaded 0.5.2 to Work and moved 0.5.1 to Archive with
parent readback verified. Local and Drive records remain dated mirrors.

## Previous checkpoint: remote-member labels, version 0.5.1

Tony confirmed his unavailable member was on another continent and approved a
name/continent label. The previous implementation combined all missing world
coordinates and world-ID mismatches into one generic unavailable count.

Tracking now resolves player/party UI-map ancestry to a named continent. Different
known continents identify a remote member even without world coordinates. Known
world-ID mismatches use "Different world area" if no continent name is available.
Offline/unknown states stay unavailable. No remote bearings/distances are invented;
normal tracking resumes without stale labels. Existing strip hover/status displays
these messages; mixed groups keep local markers and remote text in hover/status.

Changed: GroupCompass/Tracking.lua, GroupCompass/GroupCompass.toc,
tests/tracking_test.lua, tests/classic_test.lua, README.md, docs/TESTING.md,
docs/FEASIBILITY.md, docs/PROJECT_STATUS.md, all six core project-memory Markdown
files and drive-manifest.json. Generated dist/GroupCompass-0.5.1.zip. Unrelated
implementation files and prior release packages were preserved. No dependencies,
Git staging, commits or pushes.

Verification: new remote-label regression initially failed against the old code.
python scripts/run_tests.py passes all nine Lua 5.1 suites after implementation
and updating the old mismatch assertion to the approved behavior. Coverage includes
missing world/API data, known continents, unknown/offline distinction, cyclic
map ancestry, secret values, raid API boundary, mixed groups and local resumption.
python scripts/check_structure.py and python scripts/build_zip.py passed; package
entries/integrity/source-byte checks passed. Clean-installed exactly ten runtime
files in the authorized Classic folder; SHA-256 source matches passed, no backup.
All project files remain untracked; tracked diff/check commands show no tracked
changes, so implementation/tests were reviewed directly. No runtime orphan added.

Native validation remains open as GC-206: /reload, /gcompass status with the current
distant member, inspect remote label and then meet in the same world area to test
resumption. Continent names depend on actual Classic API data; no lookup result
means the safe fallback or unavailable state. Existing movement/map/Forever checks
remain open. Project-closeout and Google Drive/Docs skills were applied.

Memory closeout: native Doc updated in place with a revision guard and verified
against all expected paragraph text, heading styles and list membership. Six
Markdown mirrors, manifest and this checkpoint updated in place; 0.5.1 package
stored in Work, 0.5.0 moved to Archive with parent metadata readback verified.

## Previous checkpoint: shared horizontal baseline, version 0.5.0

Tony supplied annotated and clean Enshrouded HUD references and explicitly asked
for every person to share the same horizontal plane. The old Core.lua stagger
formula assigned each member a different Y. A new regression assertion reproduced
that mismatch before changing the code.

Implemented a 620-by-46 UI-unit strip (previously 620-by-130), positioned closer
to the top with a subtle background and center cue. Every bearing tick shares
one Y and retains its true X. Names share one row; distances share one row. Removed
the large normal-state title/status block. Empty/paused/behind-only text fits in
the same strip. Label collisions use deterministic center/distance/slot priority;
no bearing is moved to fake separation. Full class-colored names and distances
remain available on hover, including all members at a coincident bearing. Exact
coincident ticks can overlay. Native clipping, mouse behavior and appearance still
need Tony's client review. These references do not imply waypoint integration.

Files changed in this task:

- Added `GroupCompass/Layout.lua` and `tests/layout_test.lua`.
- Modified `GroupCompass/Core.lua`, `GroupCompass/GroupCompass.toc`,
  `tests/core_test.lua`, `tests/classic_test.lua`, `scripts/check_structure.py`,
  `README.md`, `docs/FEASIBILITY.md`, `docs/TESTING.md`, and this checkpoint.
- Updated the six core Markdown memory files under `docs/project-memory/` and
  `drive-manifest.json`; added local reference assets
  `assets/enshrouded-hud-annotated.png` and `assets/enshrouded-hud-clean.png`.
- Generated `dist/GroupCompass-0.5.0.zip`. Prior packages and unrelated files
  were preserved. No dependency, staging, commit or push changes.

Checks completed:

- `python scripts/run_tests.py`: PASS, nine Lua 5.1 suites. Coverage includes the
  previously failing shared-baseline requirement, fixed strip dimensions, identical
  tick/name/distance Y positions, single-row collision rules, full-name hover at
  coincident bearings, Classic startup, movement demo, live data and maps.
- `python scripts/check_structure.py`: PASS, interfaces, TOC order, XML template,
  runtime paths and absence of orphan runtime files.
- `python scripts/build_zip.py`: PASS, 0.5.0 archive integrity, paths and exact
  runtime source-byte agreement.
- Clean-installed 0.5.0 in Tony's exact Classic GroupCompass directory, after
  resolving/validating the path and rejecting links. Exactly ten runtime files
  match source by SHA-256; no new backup or unrelated addon change occurred.
- Git inspection: all project files remain untracked, so tracked diff commands
  provide no untracked-file validation. Source/call paths were reviewed directly.

Memory update: retain the supplied Enshrouded references in Drive Design and local
assets, update current requirements/design/progress, and archive GC-008's completed
implementation only. GC-101/GC-103 remain active for native validation; further
styling and minimap collision work remain open. The local memory files and Drive
Doc are dated mirrors, not a background sync service.

Drive closeout: updated the existing native Doc in 23 scoped paragraph groups
with a revision guard. Readback matches all 170 expected paragraphs, native
heading styles and bullet membership. Uploaded both Enshrouded reference images
to Design and the 0.5.0 package to Work; moved the prior 0.4.1 package to Archive.
The six Markdown mirrors, checkpoint and manifest were updated in place.

Next verification: restart WoW for Layout.lua, run `/gcompass demo reset`, and
check that A/B/C share one horizontal marker line with one common name row and
one common distance row. Turn/walk, hover, then test crowded real members. Native
appearance/hover, real-party map behavior and Forever remain unverified.

## Previous checkpoint: moving solo demo and class colors, version 0.4.1

Tony confirmed native Classic static-demo rendering in a screenshot, then reported
that it did not move. The root cause was the prototype's hardcoded sample angles
and distances. Version 0.4.0 replaced those with fixed simulated world locations,
using current player state and shared bearing math. Turning moves labels; walking
changes distances. `/gcompass demo reset` reseeds samples. World-space changes
reseed automatically; unavailable data/combat/instances pause without fabricated
readings. Samples are A/B/C so names stay valid after changing relative direction.

Version 0.4.1 implements Tony's next preference: real members use class colors by
default with their names on the compass and in map/minimap hover labels. Modern
and Classic class-color APIs are supported, with slot colors as a safe fallback.
Demo colors remain synthetic. Existing map behavior is retained.

Tony also requested a thin horizontal slice and nicer presentation. That design
requirement is recorded in project memory and the active queue, not implemented.
The current installed overlay remains the tall prototype.

Changed in this combined follow-up: added `GroupCompass/Demo.lua`,
`tests/demo_test.lua`, `AGENTS.md`, and the following local project-memory files:
`docs/project-memory/00_START_HERE.md`, `01_PRD.md`, `02_DESIGN.md`,
`03_ACTIONS_AND_TODOS.md`, `04_PROGRESS_AND_DECISIONS.md`,
`archive/2026-10-23_COMPLETED.md`, and `drive-manifest.json`. Preserved design
references locally as `assets/classic-tall-prototype.png` and
`assets/earlier-compass-concept-fragment.html` under that memory directory.
Modified `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`, `GroupCompass/Maps.lua`,
`GroupCompass/GroupCompass.toc`, `tests/core_test.lua`, `tests/classic_test.lua`,
`tests/tracking_test.lua`, `tests/maps_test.lua`, `scripts/check_structure.py`,
`README.md`, `docs/FEASIBILITY.md`, `docs/TESTING.md`, and this checkpoint.
Generated versioned 0.4.0 and 0.4.1 ZIPs; earlier artifacts and unrelated files
were preserved. No new runtime or test dependencies were added.

Verification:

- `python scripts/run_tests.py`: passed all eight Lua 5.1 suites, including solo
  world anchors/turning/walking/reset, unchanged live tracking, class-color API
  variants, unavailable/secret data, map lifecycle and class-colored hover names.
- `python scripts/check_structure.py`: passed interfaces, TOC order, XML declaration,
  runtime-file presence and no orphan runtime files.
- `python scripts/build_zip.py`: passed for both new versions; current 0.4.1 archive
  integrity, entry paths and byte-for-byte source matching verified.
- Clean-installed 0.4.1 into the exact named Classic GroupCompass folder. All nine
  installed runtime files match source SHA-256 hashes. No backup created; no other
  addon folder touched. No stage, commit or push performed.
- Native moving-demo, real-party class/name/map behavior and Forever remain
  unverified. API-double tests and installed-file hashes are not native validation.

Project memory lives in Google Drive `ChatGPTStorage / Development / Group Compass`
with a native project-memory Doc and Requirements/Design/Work/Archive areas.
The Drive folder and Doc links, confirmed requirements and working preferences
are indexed in `docs/project-memory/00_START_HERE.md`. Local Markdown mirrors are
offline-readable snapshots; remote synchronization/offline Google Docs settings
are not automatically enabled by connector writes. Existing Wow Forever Drive
notes were preserved.

Drive closeout: readback of the native project-memory Doc exactly matched the
authored text, with named headings and native list items. Folder listings verified
the root Doc/index, Requirements PRD, Design brief and reference assets, Work queue,
progress/checkpoint/current package, and Archive completed records plus releases
0.1.0–0.4.0. Local `drive-manifest.json` records observed file/folder IDs for future
in-place updates. This is a dated memory snapshot, not a background sync service.

Next: Tony restarts the client, runs `/gcompass demo`, turns the character, walks
and tests reset. Then implement/review the thinner horizontal layout and validate
real-party behavior with a second player. Keep the open native tests on the active
queue even though their implementation work has been archived as locally checked.

## Previous checkpoint: Classic Hardcore startup support, version 0.3.0

Installation follow-up: at Tony's explicit request, cleared the contents of
`C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\GroupCompass`
and installed exactly eight 0.3.0 runtime files: `GroupCompass.toc`, `Compat.lua`,
`Direction.lua`, `Projection.lua`, `Tracking.lua`, `Maps.lua`, `Maps.xml`, and
`Core.lua`. Resolved the exact target and checked for links before clearing it;
file count and SHA-256 comparisons against project source all passed. No other
addon folders were touched. Tony requests clean replacement of this exact addon
directory without new backups for subsequent installs in this task. An archive
created before that instruction remains in project `dist/`; it was not deleted.
Client restart and live verification are still required. No runtime source changes
were made during this installation follow-up.

Tony's screenshots identify Classic 1.15.9/build 70003/interface 11509, show the
old addon as out of date, and show an unrecognized `/gcompass demo` command.
The old manifest advertised only Forever's 16001 interface. That mismatch is
confirmed; the native client's exact refusal/abort reason was not captured.
`/console scriptErrors 1` normally gives no chat confirmation and is not itself
evidence of a failure. No other installed addons were changed.

Implemented: the manifest advertises both 11509 and 16001; client metadata works
through either API generation; successful startup announces the installed addon
version and solo-demo command. Classic minimap geometry has an Era-only fallback
using documented zoom/diameter constants, with mode detection, caching, original
zoom restoration, and a guard against synchronous probe-event reentry. Native
radius APIs remain preferred. Existing demo and tracking behavior are preserved.

Files in this follow-up:

- Added `GroupCompass/Compat.lua`, `tests/classic_test.lua`, `tests/compat_test.lua`.
- Modified `GroupCompass/GroupCompass.toc`, `GroupCompass/Core.lua`,
  `GroupCompass/Maps.lua`, `tests/core_test.lua`, `tests/maps_test.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/FEASIBILITY.md`,
  `docs/TESTING.md`, and this checkpoint.
- Generated ignored `dist/GroupCompass-0.3.0.zip`. Earlier archives, parent-folder
  copies, unrelated files, and installed game files were preserved. No dependencies
  added, staging, commit, or push performed.

Checks:

- New Classic startup test initially failed against 0.2.0 because the manifest
  lacked 11509. It now executes all TOC Lua files with Classic-style globals and
  verifies startup notice, slash registration, demo, and status for build 70003.
- `python scripts/run_tests.py`: passed all seven Lua 5.1 suites. Coverage includes
  Classic API absence, legacy/modern metadata, native radius priority, all six
  Classic zoom levels in both modes, probe restoration/cache/reentry, and the
  existing compass/map/projection/tracking regressions.
- `python scripts/check_structure.py`: passed both interfaces, full load order,
  runtime paths, XML template declaration and absence of orphan runtime files.
- `python scripts/build_zip.py`: passed; 0.3.0 archive integrity, exact paths,
  and byte-for-byte runtime source agreement verified.
- Git status/diff review: files remain untracked, so tracked diff commands cannot
  assess the changes. Changed source was reviewed directly. Native client startup
  and rendering are not verified by the API doubles or XML syntax check.

Next required verification: Tony must fully exit WoW, install the 0.3.0 archive
over the existing GroupCompass addon folder in the active Classic installation,
restart, and check for `Group Compass 0.3.0 loaded` in chat. Run `/gcompass demo`
and `/gcompass status`. If no loaded notice appears, capture the addon loader
information using the commands in README plus any Lua error text. Then complete
the live tests with a grouped player. Neither Classic live party functionality
nor Forever compatibility is declared verified at this checkpoint.

## Current checkpoint: map/minimap integration, version 0.2.0

Implemented numbered, matching-color compass labels, custom world-map party pins,
and custom minimap party/raid badges. World-map names appear on hover; minimap
tooltips also report horizontal distance and clamped edge status. Minimap placement
uses the current view radius, map size, rotation setting, and player facing.
An inset keeps square badge corners within the default round minimap.

World-map sampling is independent of world coordinates/facing and uses normalized
positions for the displayed UI map, with its own data provider and virtual pin
template. Pins are reused and removed through Blizzard's map-canvas lifecycle.
No native dots or other addons' markers are removed. Native and custom markers
can overlap. Demo mode intentionally places no synthetic locations on real maps.
`off` clears our markers from all views. Shared combat/instance restrictions and
unavailable/offline handling remain in place.

Current checks:

- `python scripts/run_tests.py`: passed all five suites (core, direction, maps,
  projection, tracking), using Lua 5.1 and API doubles. Map tests include lazy
  loading, current-map selection, normalized bounds, nil/secret placeholders,
  pin reuse/removal, minimap rotation/zoom/edge geometry, hover preservation,
  map visibility, provider reattachment, and off/demo/roster cleanup.
- `python scripts/check_structure.py`: passed runtime files, TOC order, interface,
  XML syntax/template declaration, and orphan-file checks.
- `python scripts/build_zip.py`: passed; created `dist/GroupCompass-0.2.0.zip`.
  ZIP integrity, exact entry paths, and source-byte agreement verified. The
  previous 0.1.0 archive was preserved.
- Final Git status/diff inspection: project files remain untracked; no tracked
  diff exists. Runtime files were reviewed directly, including API callers,
  map-provider cleanup, template order, and unaffected compass behavior.
- Live Forever verification: not run. API doubles cannot validate native secret
  values, XML/mixin initialization, map rendering, phasing/floors, minimap addons,
  or client position availability. Custom world-map pins are party-only because
  the documented map-coordinate API does not promise raid-member support.

Files changed in this integration:

- Added `GroupCompass/Projection.lua`, `GroupCompass/Maps.lua`,
  `GroupCompass/Maps.xml`, `tests/projection_test.lua`, and `tests/maps_test.lua`.
- Modified `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`,
  `GroupCompass/GroupCompass.toc`, `tests/core_test.lua`, `tests/tracking_test.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/FEASIBILITY.md`,
  `docs/TESTING.md`, and this checkpoint.
- Generated ignored `dist/GroupCompass-0.2.0.zip`. No dependencies were added.
  Parent-folder backups, the existing direction module/test, prior ZIP, build/test
  runners, and unrelated files were preserved. No staging, commit, or push occurred.

Next: install 0.2.0 and run the map/minimap section of TESTING.md, recording the
client build and `/gcompass status` output. Resolve client-specific failures before
calling this release verified. Crowded-group label/badge overlap and persistent
settings remain future work after client validation.

The records below describe the earlier prototype checkpoints.

## Completed

- Located public GitHub repository `Dax000ah/wow_addons` through the GitHub connector.
- Researched the Forever API surface and documented conditional feasibility.
- Created a dependency-free addon prototype, installation guide, Lua math tests,
  structure validator, and client test checklist.
- Kept runtime files together in the installable `GroupCompass` directory.
- Copied the starter files into Tony's successfully cloned `wow_addons-checkout`.
- Executed direction, tracking, and UI logic tests under Lua 5.1. Reproduced and
  fixed position sampling for offline members; they now count as unavailable.
- Added immediate roster/zone/combat event refresh, `/gcompass status`, and demo
  activation while hidden. Behind-member text preserves unavailable-member counts.
- Added local test tooling and an installable ZIP builder. Existing addon research
  identified MateCompass as a close advertised match; see README for source links.

## Repository state

Initial clone attempts from the sandbox failed to connect to GitHub. Tony then
successfully cloned the empty remote into `wow_addons-checkout`. Its origin is
`https://github.com/Dax000ah/wow_addons.git`. The checkout initially contained only
`.git`; starter files were copied without overwriting any existing files. The
original copies in the parent folder were preserved. Use this checkout for future
development; the parent copies are retained backups, not additional runtime files.
No staging, commits, or pushes were performed.

## Verification record

- `python scripts/check_structure.py`: passed; required files, interface number,
  TOC paths/load order, and absence of orphan addon Lua files validated.
- `python scripts/run_tests.py`: passed all three Lua 5.1 suites (direction,
  tracking, and core UI logic). The new offline test initially failed against the
  prototype and passed after the connection guard was added. Tests use API doubles;
  native WoW restrictions, opaque secret values, and UI rendering remain unverified.
- `python scripts/build_zip.py`: passed. Created `dist/GroupCompass-0.1.0.zip`
  containing exactly the TOC and three runtime Lua files under `GroupCompass/`.
  ZIP integrity, entry paths, and byte-for-byte source agreement passed.
- Forever startup/UI/API validation: not run; no live client was operated.
- Git inspection uses a command-scoped `safe.directory` for this exact checkout
  because the sandbox account differs from Tony's Windows account. No global Git
  configuration was changed. New starter files are untracked, so ordinary
  `git diff` has no tracked changes to display; their contents were reviewed directly.
- Manual source review: checked TOC load order, addon namespace, frame ownership,
  slash commands, marker clearing, coordinate-space checks, and scope boundaries.
  No duplicate runtime modules or unused placeholder folders were introduced.

## Files changed in the tested prototype follow-up

- Modified `.gitignore`, `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/TESTING.md`, and this status file.
- Created `requirements-dev.txt`, `scripts/run_tests.py`, `scripts/build_zip.py`,
  `tests/tracking_test.lua`, and `tests/core_test.lua`.
- Created ignored local test tooling in `.test-tools/` and the generated ZIP in
  `dist/`. Neither belongs in the game addon folder.
- Preserved the existing direction implementation/test, TOC, feasibility document,
  and original parent-folder copies. Git still reports the project files as
  untracked because the remote repository has no initial commit. `git diff --check`
  and `git diff --name-only` ran but contain no tracked changes to assess; direct
  source review and executed tests provide the verification for these files.

## Next steps in priority order

1. Install the ZIP and run the Forever checklist in TESTING.md. Record
   `/gcompass status` output. Coordinate availability and orientation are the main
   release gates. Lua regression suites now pass locally.
2. When Tony requests it, commit and push the starter files from this checkout.
3. After client validation, address label collisions and decide whether persistent
   settings and a richer compass UI are worthwhile. Do not promise instance or
   camera-relative support without new API evidence.

## November 4 — native launcher tooltip confirmed

Tony reloaded and confirmed that the cyan Group Compass icon inside Leatrix
shows Group Compass with left-click, right-click and drag help. This closes the
reported GC-224 tooltip failure; saved-drag and standalone/Forever gameplay gates
are not inferred from that confirmation. All 19 Lua 5.1 suites, structure check,
actual Forever TomTom launcher-library composition and git diff --check pass
again before the requested checkpoint. No provider or SavedVariables edits.
