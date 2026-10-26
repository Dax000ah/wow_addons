# Routing guidance and testing decisions — 2026-10-24

Current update 2026-10-26: Group Compass 0.8.0 implements the optional API controls
and next-turn consumer. The provider extension remains a local prototype. See
CLASSIC_ROUTING_COMPATIBILITY.md for the received probe, 16-suite results and native
gates. The following records the initial October 24 engine/prototype investigation. This report supersedes the earlier combat
policy question in ROUTING_FEASIBILITY.md.

## Confirmed decisions

Use Shortest Path Forever through its API. Keep its pathfinding and data in the
provider; do not duplicate its route engine in Group Compass. Tony accepts pauses
in combat for waypoint routing. Existing party/member tracking must continue with
readable coordinates as previously requested. Forever is the production target;
Classic Hardcore is a useful test client, not a new required production target.

## Solving next-turn output

SPF v1.22.4 already computes current bend, next bend, step end and final destination
inside UI/Arrow.lua's ns.GuideTargets(). Only an API boundary is missing. Created
an original provider-side prototype: integrations/ShortestPathForever/GuidanceAPI.lua.
It proposes API.GetGuidance(owner), returning independent world-coordinate point
snapshots. It performs no path search, movement, user-waypoint write or frame hook.
Group Compass would poll the getter as it refreshes the strip and point at its
current local target with the existing bearing/distance math. Clearing an invalid
result avoids old turn indicators after travel, cancellation or lost ownership.

The prototype explicitly declines another owner's journey, combat, corpse-run
borrowing, inactive guidance and unavailable points. It preserves a future existing
GetGuidance implementation. Tests cover updated targets, world map zero, secret/
invalid values and immutable provider-owned points. An implementation of this API
inside SPF requires only an added module and TOC entry; the provider's private
namespace stays private from Group Compass. The proposed name/shape is not an
upstream contract until adopted. A small maintained local addition can bridge the
gap for development; upstream adoption is the preferred maintenance outcome.
No installed SPF file was modified and no maintainer message, issue or PR was sent.
The module's README documents the contract and development-load location.

## Testing that ran now

The new scripts/check_spf_offline.py reads the installed SPF v1.22.4 modules and
compressed terrain in XML order. It executes the actual walking search in the
project's existing Lua 5.1 test runtime, using Python's standard base64/zlib only
as adapters for C_EncodingUtil. No third-party route source or terrain was copied.

| Scenario | Actual path points | Search cost, yards | Straight-line yards |
| --- | ---: | ---: | ---: |
| Shadowglen area to Dolanaar area | 9 | 720.98 | 458.10 |
| Coldridge Valley area to Kharanos area | 23 | 1198.37 | 1035.02 |
| Goldshire to Stormwind flight master | 17 | 1073.48 | 762.90 |

The starter-area anchors are approximate world coordinates, not recorded native
character spawns. Costs are the engine's searched weights, not exact displayed
polyline lengths or promised gameplay times. The Stormwind test checks a meaningful
detour relative to a straight line. Missing terrain returns nodata as expected.

A separate run of the real transport planner, with shipped docks/routes/portals/
landmass and baked walking data, produced an Alliance world-1 to world-0 plan:
walk, boat, walk, boat, walk. No flight paths were supplied, so it did not require
an already-discovered flight. Endpoint walks were estimated and boat sightings
were absent. This is evidence the intercontinental topology/planner works offline,
not a fully measured/safest/fastest native itinerary. Native transport clocks,
boarding, map lines and zone/continent transitions remain untested.

Raw results include source hashes:
docs/research/spf-offline-results-2026-10-24.json.

Reproduction from the checkout:

```powershell
python scripts/check_spf_offline.py 'C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever'
python scripts/run_tests.py
python scripts/check_structure.py
```

Results: offline engine checks PASS; all 15 Lua 5.1 suites PASS, including the
new proposed-guidance contract test and the existing 14 suites; structure PASS;
git diff --check PASS. No new dependency. No runtime package/install required.

## Test-client recommendation

Blizzard's October 23 announcement confirms the beta is closed. Character creation
opens October 27; the announcement does not offer world gameplay then. Launch is
November 4, 2026. An installed client or predownload alone does not provide a game
server for addon gameplay tests. No currently available Forever gameplay realm was
established by this investigation.

Recommended now: keep running the real engine offline and use existing Hardcore
for Group Compass rendering/movement checks. A normal Classic Era character is
also suitable for common-client checks; using that ruleset does not supply missing
Forever APIs. Another retail/progression client would still not prove Forever
compatibility or validate its world data. No extra client installation is needed
for the offline results above. Full integration must receive a Forever smoke test
when world gameplay returns, even if a Classic test port also succeeds.

## Classic test port assessment

A test port is plausible but unproven; changing only the TOC is not a validated
solution. SPF calls modern encoding, native user-waypoint/supertracking/navigation,
quest, spell/item, taxi and UI services. Python adapters prove the route engine
can run outside its client; Python cannot serve those adapters inside WoW. A real
Classic build needs compatible Lua/client implementations and tests for each gap,
and Forever-only terrain/transports must not silently be treated as Classic data.

Before committing to a full port, inspect the live 1.15.9 client's main gaps using
this read-only WoW chat command (already requested from Tony):

```text
/run print("SPF:",type(canaccessvalue),type(C_EncodingUtil and C_EncodingUtil.DecompressString),type(C_Map and C_Map.GetUserWaypoint),type(C_SuperTrack and C_SuperTrack.GetHighestPrioritySuperTrackingType))
```

Four function results confirm those entry points exist, not overall compatibility;
nil identifies likely adaptation work. More detailed checks follow if warranted.
October 26 output received: function function nil nil. The checked decompression
helper exists; native user-waypoint getter and tracking-priority method do not.
There is still no evidence supporting a quick full-addon Hardcore port. Recommend the offline harness first, then a narrowly scoped test
adapter if the client probe makes that proportionate, rather than committing to
maintain the whole provider UI on a second client. Live port/route availability
must remain explicitly unverified until executed.

## Remaining work in order

1. GC-104: implemented in 0.8.0; native controls/fallback validation is GC-209.
2. GC-105: establish the getter contract/provider build, then consume only that API
   for our top-bar next turn. Consumer shipped in 0.8.0; provider extension is not installed.
3. GC-106: use the received Classic probe to choose the smallest useful native test
   adapter. Combat routing deferral is accepted and no longer a policy blocker.
4. Native Forever acceptance: local starter-area routes, crossing between continents,
   cancellation/replacement, combat resume and no stale target after transport.

Primary sources checked 2026-10-24:
- https://github.com/cjber/shortest-path-forever/blob/main/docs/api.md
- https://github.com/cjber/shortest-path-forever/blob/main/tests/README.md
- https://us.forums.blizzard.com/en/wow/t/thank-you-for-testing-the-wow-forever-beta/2390465
- https://worldofwarcraft.blizzard.com/en-us/forever/
