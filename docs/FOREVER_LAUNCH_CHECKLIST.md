# Forever launch target — November 3, 2026

Group Compass must work with the user's unmodified Forever addons. Hardcore is
only a secondary development aid. Consumer changes must use existing provider
interfaces and work without any private patches. Never install the private
Hardcore Shortest Path build in Forever.

## Audited local installation

| Component | Forever version | Verification |
| --- | --- | --- |
| Group Compass | 0.10.2 package; not installed in Forever | 17 suites pass; 30 ZIP files match source; TOC includes 16001 |
| Shortest Path Forever | v1.22.18 | Unmodified API composition passes; Core/API.lua identical to pinned v1.22.9 |
| TomTom | v4.3.13-release | Actual installed registry/API composition passes |
| OpenMap | v0.7.5-beta; public API major1/version4 | Private adapter test passes against its actual API; stock pair still needs native testing |
| RestedXP | v4.11.29 | GC only opens Shortest Path's existing settings; its upstream RXP adapter is unchanged from v1.22.9 |
| Questie | 12.4.0 (Camelot TOC16001) | Inventory only; GC has no direct Questie dependency |

The full 24-folder inventory and hashes are in
`docs/research/forever-audit-2026-11-03.json`. Inventory is not gameplay validation
of every addon. No installed third-party addon was edited in this audit.

## Existing integration boundary

- Routing calls only stock API v1 `Navigate`, `CurrentStop`, `Active`, `Cancel`
  and optional `Ended`. Settings/report use the existing slash handler.
- TomTom supplies saved waypoints and its own map pins. The bridge is tested
  against this installed version; no patched TomTom is required.
- Members routed from GC are position snapshots. The upstream v1.22.18 native
  `/path follow` feature does not change that and is not a GC requirement.
- No private next-turn getter, injected source selector, provider DB changes,
  copied terrain or route engine ships in the Group Compass package.
- A successful request does not prove the engine found a route. Use the native
  provider report when the path is absent.

## Hardcore simulation is behind

Private hc-test.9 is based on v1.22.9, not v1.22.18. Upstream has24 changed files
and2 new files: Journey/Follow.lua and UI/DestinationPin.lua. Changes include
planner-cache retention and transport/data updates. Core/API.lua, Path.lua,
PathGrid.lua and the existing TomTom/RXP adapters match. This does not make the
old private client a complete simulation of the current release.

No partial upstream fixes were copied into that old baseline in this audit.
Refreshing it requires a separate audited port; it is not required to run GC
against the stock Forever API. Current acceptance takes precedence over further
Hardcore emulation work.

## Native test gates

1. Install only our `GroupCompass` folder/package into Forever's AddOns directory;
   keep all other addons as supplied by CurseForge. Fully restart the client.
   Check `/gcompass status` shows0.10.2 and client interface16001.
2. Test solo demo, turning, bar sizes, cardinal directions, then disable demo.
3. With a real nearby member, check name/class color on the compass and both
   maps, turning, movement, roster changes and map zoom/pan with stock OpenMap.
4. Create a TomTom waypoint on a known road several hundred yards away. Right-
   click GC's cyan launcher, TomTom waypoints, select it. Check `/path report`
   names ownerGroupCompass and a settled measured route; check both maps.
5. Without reloading, select another reachable point and return to the first;
   repeat after moving. Test owned Retry/Stop without cancelling an RXP route.
6. Resume RestedXP through native Shortest Path settings/guide controls. Test
   route changes, combat recovery and a transport trip independently.
7. If the stock pair fails, retain `/path report`, exact start/goal, versions and
   Lua errors. Diagnose consumer versus provider; never fix it by silently
   requiring a patched provider. No upstream issue/message is sent without Tony.

Known uncertainty: stock SPF v1.22.18 retains the OpenMap world-yard-to-map-
fraction conversion previously repaired privately. The private test's result
does not establish that the stock pair renders correctly on Forever.

## Native Hardcore evidence, separately recorded

Tony's November3 direct `/path way` long control to map1438(55.9,57.8) rendered
on both maps:9 measured points,14 minimap strokes,8 world strokes,103s walk,
one settled round, no caught errors. Owner was player. This passes the long
control only; it is not a GC menu, transport or native Forever pass.

The short control's missing dots are consistent with stop-icon gap suppression;
exact native short-view replay remains unconfirmed. A later GC-owned request
to63.5,32.1 settled with no plan, no geometry and guided off. Its saved world
target is(10742.2080078125,579.92578125) on continent1. Keep that destination's
engine reachability investigation distinct from successful long-route rendering.

The real stock API/GC/engine replay now reproduces that failure on BOTH unmodified
v1.22.9 andv1.22.18: reachable → failed → reachable → failed → reachable. Every
selection reaches the provider and retains GC ownership; the failed target has
no plan, while each return to the reachable target restores measured geometry.
This reproduces an engine refusal to plan to that destination, not physical
inaccessibility or the precise nav-data defect. Native GC selection of the
reachable point remains pending: `/tway 55.9 57.8 GC route test`, then cyan
right-click > TomTom waypoints > GC route test; stay still and wait15s.

Tony subsequently reports Alt+left-click works where menu selection does not.
Do not conclude that the record above explains that difference: compare the
working click's exact saved world goal with the failed request first. The saved
TomTom UID is map1414(0.4480097267300475,0.08387378695540161); the provider report
locates that world point in Teldrassil. Different coordinate spaces must not be
compared as if both were map1438 fractions. Working-click capture requested;
the menu-versus-click native discrepancy remains OPEN.

## Repeatable offline commands

From the Group Compass checkout, use `python scripts/run_tests.py`,
`python scripts/check_structure.py`,
`python scripts/check_spf_api.py "C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever"`
and `python scripts/check_tomtom_offline.py "C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/TomTom"`.
For the captured failure and repeated switching, run
`python scripts/check_spf_journeys.py "C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever"`.
These load actual installed provider implementations read-only, with client
services doubled. They do not establish native rendering or gameplay support.

## Subsequent exact-point result

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
