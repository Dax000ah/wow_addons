# Waypoint routing feasibility — 2026-10-24

Current 2026-10-26: optional API bridge and next-turn consumer installed as 0.8.0.
Provider extension/native execution remain unverified. See CLASSIC_ROUTING_COMPATIBILITY.md.
The following preserves initial feasibility reasoning from October 24. Owner: Tony. Dates use America/Los_Angeles.

## Answer and installed reference

Local and cross-continent journeys to a saved waypoint are feasible on Forever.
The installed addon is Shortest Path Forever v1.22.4, interface 16001, by cjber:
C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever.
Its own map clicks and typed destinations already support arbitrary locations;
this is not restricted to preset towns or flight masters. Integrating our saved
waypoint picker would add our workflow and retain our party/member display.
Assumption: Tony's elf starting area means night elf Shadowglen/Teldrassil;
gnomes start in Coldridge Valley/Dun Morogh. Individual routes remain untested.

## What builds the golden route

- Routing/Planner.lua selects travel legs using their costs and available transports.
- Routing/PathGrid.lua, Path.lua and PathJobs.lua search bundled walkable terrain,
  account for floors and water, smooth paths and spread work across frames.
- Nav contains 27 Lua files totaling 11,882,769 bytes: compressed terrain for world
  maps 0 (Eastern Kingdoms), 1 (Kalimdor) and 2991. This is world-map space, not the
  uiMapID of a zone. No terrain or other source files were copied into our project.
- Data/Routes.lua, Transports.lua, Taxi.lua, Portals.lua and Teleports.lua supply
  travel connections; Transport handles timing/observations and known flights.
- UI/Route.lua and Strokes.lua draw and clip pooled lines on the maps. Copying
  only this drawing layer would produce lines, not terrain-aware route finding.

Data/Zones.lua includes Dun Morogh (uiMapID 1426, world 0), Teldrassil (1438,
world 1), Ironforge and Darnassus. Data/Portals.lua includes the Darnassus/Rut'theran
portal and tram entrances; transport data includes intercontinental boats and the
Deeprun Tram. This supports the requested kinds of journeys; static source review
does not establish a valid path from every exact starter-area coordinate.

## Selected integration boundary

Tony selected an optional Shortest Path Forever API adapter. See ROUTING_TEST_RESULTS.md
for the tested guidance prototype, offline engine results and current client decisions. Add a
Navigate action beside a saved waypoint and a Stop route action. Waypoint creation
continues saving points without automatically replacing an existing journey.
Our records already use uiMapID, normalized 0–1 x/y and a name, matching API input.
An illustrative call is:

```lua
ShortestPathForever.API.Navigate("GroupCompass", point.mapID, point.x, point.y, point.name)
```

Check API version 1 and function presence before calling. Navigate returns false
for combat, unavailable input/state or disabled Journeys; accepting a destination
is not proof that a reachable route was found. CurrentStop reports ownership and
which submitted destination is current, not which boat or walking turn is next.
Cancel("GroupCompass") only cancels our journey; Subscribe/Ended let us react to
arrival, cancellation or replacement. Another destination can replace ownership.
If an unrelated journey is active, the UI should offer an explicit Replace route
action rather than silently taking it over. API.Active alone is not reachability.

Shortest Path would keep calculating and drawing both map routes. Our existing
saved destination/member pins and direct destination bearings remain ours.
Missing or incompatible provider means routing unavailable while existing Group
Compass functionality continues. This is a proposed architecture, not a new
installed dependency or a promised standalone route engine.

## The top bar needs the next local instruction

A destination on another continent cannot give a useful local bearing. Routing
should point to the next reachable walking turn, dock, tram entrance or portal,
then update after the crossing, while retaining the saved final destination.
The installed public API exposes no route geometry or next-turn coordinates.
EstimateDetail returns leg labels, modes and times, not points. The internal
ns.GuideTargets() in UI/Arrow.lua returns bend/next-bend/step-end/goal for SPF's own
compass, but is not exported as ShortestPathForever.API and is not a stable contract.

Do not inspect another addon's private frames or replace its callbacks to recover
this data. A small supported target/geometry API extension is the clean solution
for complete guidance on our bar. Native C_Map.GetUserWaypoint can sometimes show
SPF's current bend, but may belong to another action and may be absent when SPF
yields tracking; it is not an ownership-safe general replacement for that API.
Map routing can be integrated first; next-turn guidance on our bar remains a
separate requirement. Existing bar markers continue to be direct bearings.

## Constraints relevant to Tony

- Combat: Core/API.lua Ready/NavigateRoute reject new navigation in combat;
  Routing/PathJobs.lua waits for PLAYER_REGEN_ENABLED; Journey.lua Update/driver
  and UI/Route.lua defer planning/progress/map refresh. Retained route graphics
  are not evidence of continuing updates. Tony now accepts
  these waypoint-routing delays. Existing member/waypoint tracking stays independent.
- Clients: this installed addon targets Forever interface 16001. It is absent
  from the inspected Classic Era AddOns location and uses Forever-era APIs such as
  canaccessvalue and C_EncodingUtil. Hardcore Classic compatibility is unverified;
  copying this folder there is not a validated port.
- Coverage: transport availability, discovered flight paths, character abilities,
  cooldowns, terrain coverage and current boat observations affect route quality.
  Time estimates are not guaranteed optimal arrival times. Unsupported goals should
  report no route, without drawing a straight line as if it were a walkable path.
- Safety preferences: SPF already penalizes high-level zones and hostile towns;
  penalties are not a safety guarantee. An eventual Hardcore mode needs an explicit
  travel policy and tests; fastest estimated time and lowest risk differ.
- Instances: SPF can route an outside player to an instance entrance; it does not
  provide unrestricted interior navigation. No blanketed instance pause is added
  to our existing tracker by this proposed adapter.
- Reuse: installed TOC/README identify GPL-3.0-or-later. LICENSE and THIRD_PARTY.md
  describe code/data provenance. Embedding a fork would require a deliberate
  licensing/attribution and update-maintenance plan, plus terrain and transport
  data. No copied third-party code/data, licence change or external addon edit
  occurred in this investigation. An API connection keeps the existing installation
  as the routing provider rather than bundling its engine.

## Proposed sequence and acceptance checks

1. GC-104: optional provider adapter with Navigate/Stop, missing-provider/version/
   combat/unreachable/replaced states, explicit replacement and owner-scoped cancel.
   Test saved normalized points, local/cross-map inputs, callbacks, reload policy,
   removal of the routed waypoint, off/demo behavior and no effect on party tracking.
2. GC-105: supported next-target contract and shared-bar guidance. Test turns,
   same-baseline labels, boarding, travel-space transitions, missing coordinates,
   arrival/removal, cancellation, lost ownership and no stale or remote bearings.
3. GC-106: assess Classic test-client gaps before a native test port. Combat delays
   are accepted for routes; existing member tracking keeps its no-auto-pause behavior.
4. Native Forever smoke tests: Shadowglen to a nearby saved Teldrassil point;
   Coldridge Valley to a nearby Dun Morogh point; then a saved point on the other
   continent. Confirm actual available transport steps and next local target.
   Test an undiscovered flight, a mountain/water obstacle and a disconnected goal.
   These are test scenarios, not precomputed itineraries or completed tests.

## Evidence and verification

Installed source read only: ShortestPathForever.toc, README, LICENSE,
THIRD_PARTY, Core/API.lua, Routing/Planner.lua, PathGrid.lua, Path.lua,
PathJobs.lua, Journey/JourneyInput.lua, Journey.lua, JourneyGuide.lua,
Hazards.lua, UI/Route.lua, Arrow.lua, Compass.lua, and relevant Data/Nav headers.

Read-only Python probe: PASS API version 1/minor 1, Navigate signature, ten
public functions, absence of exported GuideTargets, and terrain file sizes.
python scripts/check_structure.py: PASS. git diff --check: recorded in checkpoint.
Initial assessment: no Lua code or build/install was needed. Later prototype and
offline results are recorded separately in ROUTING_TEST_RESULTS.md.
Previously passing 14-suite evidence belongs to release 0.7.0, not an integration.
No native route search, transport ride, client startup or combat test ran.
The first git status ran in the non-repository parent and failed; repeated in the
active checkout successfully. Source-search guesses for absent paths were replaced
with the observed TOC paths; they do not indicate an addon failure.

Installed reference fingerprints, SHA-256:
- ShortestPathForever.toc: 9b6a048de12f8be6858bffd7f36d3a9aa74b6c1c815e0ac87375afb2bd191aa1
- Core/API.lua: 2938eaec05b7452ffb5ec665e20e45530fd299bcca9bab1bd6699ae3ccc3e088
- Routing/PathGrid.lua: 5ebbf25a5b8aa08bb6fbb7316097c54bb2569940024758a8e022fecbd0c80626
- UI/Route.lua: 1661578398f3b716fb81195b9677f89ced423a4fc5d3e09abb015be77cc26d27

Primary upstream references (read 2026-10-24; upstream main can differ from installed):
- https://github.com/cjber/shortest-path-forever
- https://github.com/cjber/shortest-path-forever/blob/main/docs/api.md
- https://github.com/cjber/shortest-path-forever/blob/main/docs/features.md
- https://github.com/cjber/shortest-path-forever/blob/main/THIRD_PARTY.md
