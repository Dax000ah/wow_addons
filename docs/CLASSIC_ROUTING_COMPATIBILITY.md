# Classic routing compatibility and API bridge — 2026-10-26

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

## Current native evidence — both maps render; hc-test.5 XML warning fix

Tony confirms gold paths on both maps. The repeated Map.xml outer-glow error is
caused by XML loading even hidden atlas declarations before Lua capability checks.
hc-test.5 defers all six atlas assignments; dock/flight pins preserve available
native art and use existing Classic ring/goal fallbacks otherwise. Five private
suites and all 117 installed hashes pass. Native error-free reopen/hover/zoom is
HC-007; movement/turn/transport/Forever gates remain open. Group Compass runtime
remains 0.9.2 and contains no provider compatibility code.

## Native update — minimap gold seen; world-map art fix hc-test.4

October 27: Tony confirms a golden path on the minimap. World-map opening failed
at StopPin.lua:107: C_Texture.GetAtlasInfo for Waypoint-MapPin-Tracked returned nil.
Private hc-test.4 checks available art and uses the shipped dot for missing goal,
ring and quest-button art. Font numbers remain readable; native aspect/grid are
preserved. Actual StopPin missing/native profiles and pooled reuse pass, as do
three other private suites and the three existing terrain/geometry cases. All
117 installed files match source; fourteen upstream files differ plus two adapters.
World-map appearance/reopen/zoom/multi-stop review remains HC-006. Minimap evidence
does not close sustained watchdog, movement, transport or Forever launch gates.
Group Compass's unrelated 0.9.1 headings contain no provider compatibility code.

## Current separate private test copy

SPF has advanced to v1.22.9, including an upstream TomTom-arrow follow option
(off by default). That option still needs native compatibility fixes in Hardcore.
Tony authorized a private, undistributed copy outside the Group Compass checkout:
C:\Users\Gaming PC\Documents\git\Wow_Addons\shortest-path-hardcore-test.
Version v1.22.9-hc-test.5 is installed only into Hardcore AddOns\ShortestPathForever.
All 117 files match source SHA-256. Provider compatibility stays separate from
Group Compass; the original Forever addon remains unchanged.

Sixteen upstream files plus two adapter modules contain navigation capability guards,
the provider's existing fallback arrow, a private guidance getter, minimap scale,
map opening, item cooldown and flight tracking compatibility. Terrain/core path
algorithm/Planner/Strokes remain unchanged. All Lua syntax, TOC/XML, focused real Guide/Arrow/API regression,
unchanged consumer composition and three real terrain/both-map geometry cases pass.
Client/UI/encoding/projection services are doubled; this is not a native pass.

October 27: RXP-triggered native timeout in Hazards.Segment came from synchronous
initial preview graph building. hc-test.3 queues initial/reused/timer planning on
the existing scheduler and adds per-zone hazard checkpoints without changing
penalties or disabling avoidance/RXP. Three private suites and three cold
asynchronous terrain/cost checks pass; native responsiveness/gold routes need HC-005.

Current Classic-era Blizzard documentation also omits GetViewRadius, the native
user waypoint API, C_Map.OpenWorldMap, C_Item.GetItemCooldown and
C_TaxiMap.ShouldMapShowTaxiNodes; some Lua helper globals can exist independently
of generated docs, so capability tests retain real methods where available.
First native load exposed unknown SUPER_TRACKING_CHANGED during module startup;
hc-test.2 checks optional navigation events and its strict registry regression
executes both actual affected initializers successfully. Native retest is pending.
See the private api-audit.json for source hashes/links. Native loading, movement,
transport validity and unmodified Forever release checks remain HC-001–HC-004
in that workspace's STATUS.md. Historical v1.22.4 research below remains historical.

## Confirmed native probe

Tony's screenshot prints SPF: function function nil nil, in the exact command order:

| Function checked | Result |
| --- | --- |
| canaccessvalue | function exists |
| C_EncodingUtil.DecompressString | function exists |
| C_Map.GetUserWaypoint | unavailable |
| C_SuperTrack.GetHighestPrioritySuperTrackingType | unavailable |

Evidence is preserved at docs/research/classic-routing-probe-2026-10-26.png and
its JSON sidecar. The probe does not prove all encoding works, that either entire
namespace is absent, or that other APIs are available. No more chat commands are
needed for this initial finding. Current exact client build was not re-queried.

Installed SPF v1.22.4 calls GetUserWaypoint in Journey/JourneyGuide.lua's ownership,
start and restore paths, and calls GetHighestPrioritySuperTrackingType in
RememberTracking/SameTracking. These are unguarded calls. UI/Arrow.lua also uses
C_Navigation.GetFrame. The installed provider cannot use its current guidance path
unchanged on this client. Missing native tracking APIs are presentation/ownership
integration gaps, not evidence its terrain search is impossible.

## Implemented now: Group Compass 0.8.0

GroupCompass/Routing.lua optionally discovers public SPF API v1. It sends the
selected saved uiMapID, normalized x/y and case-preserved name through Navigate.
It uses CurrentStop/Active/Ended and owner-scoped Cancel, with explicit replacement
of an active foreign journey. No provider means a readable unavailable state;
party/member and saved-waypoint features continue. External API failures remain
visible in status instead of silently clearing the error.

The saved-waypoint window now has Navigate, a second-click Replace action, a
routing status and Stop route (disabled without an owned route). Commands:
/gcompass route ID, route replace ID, route stop, route status. Adding a waypoint
does not automatically start navigation. Starting an accepted route exits demo and
enables the display. Off/demo and removing a routed point cancel only our route.
Provider refusal to cancel remains visible and preserves access to Stop route.
Saved points/appearance are preserved; active route selection is session-only.

With only the existing public API, SPF provides the two map routes and our status
explains that next-turn output is unavailable. With the proposed GetGuidance API,
the top bar consumes its version-1 copied world-space target as a cyan [Route]
Next step, using existing angle/distance math and the same horizontal baseline.
That distance is to the next point, not total route length. It omits targets in a
different world or with unavailable/secret data. The turn is bar-only: our map
renderer does not duplicate SPF's route/turn markers or mutate party samples.
Combat suppresses the route-turn marker while members/ordinary waypoints stay live.

The original proposed provider-side extension remains in integrations/ShortestPathForever.
It is not installed or an adopted upstream API. No SPF file or native global API
was changed/faked. The consumer and extension were composed in regression tests
with C_Map and C_SuperTrack absent. This proves their contract in a test double,
not that the whole SPF addon runs on Classic.

## Verification and install

Focused routing/core tests PASS. python scripts/run_tests.py PASS all 16 Lua 5.1
suites; this includes ownership/replacement/cancel, removed waypoints, provider
errors/rejection/missing/version/late loading, combat resume, remote/secret target
clearing, real getter/consumer composition, shared bar and UI controls. Existing
15 suites pass. python scripts/build_zip.py PASS, structure/order/XML/artwork and
archive integrity/paths/source bytes. git diff --check PASS. Final diff and source
review completed. No dependencies or Git mutations.

Clean-installed only the authorized Classic GroupCompass folder: 28 runtime/art
files match source by SHA-256, no backup. Package: dist/GroupCompass-0.8.0.zip.
WTF saved data and other addons are untouched. No native 0.8.0 UI or provider route
execution was observed; these remain open tests.

## What Tony can test now

Fully restart WoW, then /gcompass waypoints. Save Camp if the list is empty. The
list should include Navigate and Stop route; with no compatible SPF provider it
must say routing requires that provider, without breaking the list or map/compass
waypoints. /gcompass route status reports the same state. Test Remove, saved reload,
options and existing movement demo normally. No golden route or real next-turn
tracking is promised on the current Hardcore installation.

A Classic test provider remains additional work. It should implement provider-local
non-native guidance ownership and custom rendering, plus audit the remaining
encoding/minimap/quest/spell/item/taxi/UI calls and data coverage. Do not install
fake global C_Map/C_SuperTrack functions that make the addon think native tracking
succeeded. Standard Era uses the same client family, so a different ruleset alone
does not provide these missing methods. Prefer a limited test adapter over a full
second-client UI fork if the remaining compatibility work is proportionate.

Next gates: GC-209 for the installed window/commands and fallback; GC-105 for a
supported provider guidance getter/build and actual next-turn output; GC-106 for
native Classic provider compatibility; GC-210 for full provider routing in Forever.
No engine duplication or full Classic port is claimed. Offline real terrain and
estimated intercontinental evidence remains recorded separately in ROUTING_TEST_RESULTS.md.
