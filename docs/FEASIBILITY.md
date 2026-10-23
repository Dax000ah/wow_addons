# Feasibility: Enshrouded-style group compass

Research date: 2026-10-23. Target: WoW Forever, initially interface 16001.

## Enshrouded-style single baseline (0.5.0)

Tony supplied two Enshrouded HUD references and clarified that every person should
share the same horizontal plane. The old stagger formula in Core.lua deliberately
assigned different Y positions; it was the cause of the mismatch. The new strip
keeps every tick at one Y and the true relative-bearing X. Names and distances
each have their own shared baseline. A small layout module selects non-overlapping
labels by center/distance/slot priority without moving or deleting bearing ticks.
Hover details preserve full identities at crowded bearings. Exact-coincident ticks
may overlay each other; their shared tooltip lists the members at that position.

The source frame height is 46 rather than 130 UI units, with a subtle background,
center cue, no large heading, and status text only in empty/paused/behind states.
This implements alignment/density from the reference, not Enshrouded's quest or
waypoint systems. Native appearance and hover behavior still need client review.

## Solo movement demo (0.4.0)

Tony's Classic screenshot confirms 0.3.0 renders the static demo. The fixed-angle
sample definitions were the reason those labels did not respond to movement.
Version 0.4.0 replaces them with simulated world anchors, seeded once from the
player's actual position/facing. Samples initially sit 25/40/60 yards away at
relative angles of -60/0/+60 degrees. Each update uses the shared direction math
against the current player position and facing; the anchors do not follow along.
Player-state validation and member colors are shared with live tracking.

`/gcompass demo reset` reseeds the anchors. A world-space ID change reseeds them
automatically. Missing/secret coordinates pause the demo;
returning to the same readable space resumes the existing anchors. Simulated
members remain explicitly labeled and compass-only. Actual group-data APIs and
map marker availability still require a real grouped player to verify.

## Classic Era/Hardcore target added in 0.3.0

Tony supplied a screenshot of `GetBuildInfo()` showing Classic 1.15.9, build
70003, interface 11509. The manifest now declares that interface alongside 16001.
The older package only declared Forever's interface; the screenshot of an unknown
slash command indicates no registered handler but does not reveal the client's
exact load-failure reason. A startup notice and loader diagnostics were added.

The [Classic minimap API](https://github.com/Gethe/wow-ui-source/blob/classic_era/Interface/AddOns/Blizzard_APIDocumentationGenerated/MinimapDocumentation.lua)
does not expose the modern radius getter. Classic fallback geometry uses the
established zoom/diameter values documented by the primary
[HereBeDragons implementation](https://github.com/Nevcairiel/HereBeDragons/blob/master/HereBeDragons-Pins-2.0.lua).
No library dependency was added. When indoor/outdoor zoom settings coincide,
the fallback briefly probes an adjacent zoom and restores the original setting
to distinguish the active mode. The result is cached until a map/zoom event;
probe-triggered synchronous events are ignored to prevent reentrant sampling.
Native radius APIs remain authoritative where present, including unavailable
returns; the fallback is confined to the Classic 1.15 interface family.

Classic metadata supports the legacy addon API as well as `C_AddOns`. Local tests
exercise full Lua load order, demo and status commands without modern-only globals,
plus minimap mode detection and restoration. Native loading/rendering and all live
party coordinates remain unverified. Passing Classic checks will not by itself
verify Forever compatibility.

## Decision

**Conditionally feasible as a character-facing outdoor prototype.** The client
documents position and facing APIs that can support relative bearings when they
return readable coordinates in a common world space. This is an inference from
the API surface, not confirmation from a running Forever client.

An exact camera-facing Enshrouded-style overlay is not established: the reviewed
camera documentation provides field-of-view defaults and UI model camera data,
but no getter for the gameplay camera's heading. Rotating the camera independently
of the character therefore does not rotate this prototype's compass.

## Source evidence

The linked files are Blizzard-generated API documentation mirrored by Gethe.
The `forever` branch is mutable; record the installed build when verifying.

- [Forever Unit documentation](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/UnitDocumentation.lua)
  exposes `UnitPosition(unit)` with world coordinates and a map identifier.
- [Forever player documentation](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/PlayerScriptDocumentation.lua)
  exposes `GetPlayerFacing()` with a nullable numeric return.
- [Forever camera documentation](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/CameraDocumentation.lua)
  lacks a gameplay yaw getter; UI model cameras are a different system.
- [ManaMaster's Forever implementation notes](https://github.com/olav9/ManaMaster/blob/main/CLAUDE.md)
  document interface 16001 and use of modern APIs. This is an addon author's
  report, not an official compatibility guarantee for this project.

Generated signatures do not establish when coordinates are populated, usable,
or restricted. Outdoor availability, range, phasing, axis orientation, distance
units, and changes between client builds require direct client verification.

## Intended behavior

The addon samples at most ten times per second. It enumerates party or raid unit
tokens, excludes the player, compares only matching world map identifiers, and
calculates a bearing relative to character facing. Names move left or right along
a fixed compass strip; straight ahead is the center. Approximate horizontal
distance ignores elevation and path length. It is not route planning or a
line-of-sight check. Three alternating label rows reduce, but do not eliminate,
overlap in crowded groups.

Math currently assumes world X increases north, world Y increases west, and
facing grows counterclockwise from north. The Lua tests encode these conventions;
the cardinal-direction client test must confirm them on Forever.

## Supported boundary and graceful failure

- Version 0.5.2 removes the prototype combat/instance pause at Tony's request.
  Tracking remains active wherever the client supplies usable coordinates,
  including combat and instances. No game restrictions are bypassed.
- Missing APIs, nil or secret numeric values, invalid numbers, and mismatched
  coordinate spaces produce an unavailable state or omit that member.
- Unloaded, offline, distant, phased, or cross-zone members may have no usable
  coordinates. The addon cannot guarantee markers for every member.
- The prototype does not cache stale coordinates or fabricate fallback bearings.
  It does not use addon communication to recover inaccessible data.
- A shared map identifier alone cannot prove the members share a phase. This
  prototype only locates positions the client supplies; it cannot prove visibility.
- Demo mode is synthetic, explicitly labeled, and can run in restricted contexts.

## Client verification gate

Use the checklist in [TESTING.md](TESTING.md) before claiming compatibility.
First verify two party members outdoors, then all four cardinal directions and
independent camera rotation. Check combat, instances, roster changes, unavailable
members, and reload. If Forever does not expose usable positions for the target
scenario, limit the feature to confirmed contexts and record that result. Broader
world-map fallbacks, persistent settings, overlap management, icons, and an
options panel are future work after this gate.

## Map and minimap implementation (0.2.0)

The first map integration is implemented and locally tested using API doubles;
it remains unverified in the game client.

- [Forever map API](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/MapDocumentation.lua)
  documents `C_Map.GetPlayerMapPosition(uiMapID, unitToken)` for the player and
  party members. Custom world-map pins use these normalized coordinates on the
  displayed UI map. They do not confuse UI-map IDs with world map identifiers.
  Because raid support is not documented for this API, custom world-map pins
  are disabled while in a raid. Native raid markers remain under Blizzard control.
- [Forever MapCanvas](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_MapCanvas/Blizzard_MapCanvas.lua)
  provides `AcquirePin`, `RemovePin`, and data-provider lifecycle methods. The
  implementation registers its own provider after the world map becomes available,
  reuses its pins, responds to map changes, and removes only its own template.
- [Forever minimap API](https://github.com/Gethe/wow-ui-source/blob/forever/Interface/AddOns/Blizzard_APIDocumentationGenerated/MinimapDocumentation.lua)
  exposes `GetViewRadius()` in yards and `IsRotateMinimapIgnored()`. World offsets
  are projected into minimap pixels using that radius, the frame dimensions,
  player facing when rotating, and the standard `rotateMinimap` setting.
  An inset ellipse keeps the badge corners inside the default circular map;
  clamped badges are direction indicators, not exact on-map locations.

Custom map views no longer automatically pause for combat/instances. Native
markers are never removed, so custom badges can overlay native dots. The world
map uses independent sampling, allowing it to work without readable facing or
world coordinates; no cross-zone data is fabricated when the API returns nil.
Numbers/colors indicate group slots, not a persistent player identity or class.
Demo locations remain exclusively on the compass. Map badges require live data.

## Remote status (0.5.1)

Classic GetBestMapForUnit supports player/party and may return nil. We resolve
continent ancestry with GetMapInfo and keep UI-map IDs separate from world IDs.
Differing known continents can identify a remote party member even if UnitPosition
is absent. Differing world IDs alone use a generic world-area label. Raid members
skip the party-only lookup. Missing API/data does not establish a continent.
Primary API reference: https://github.com/Gethe/wow-ui-source/blob/classic/Interface/AddOns/Blizzard_APIDocumentationGenerated/MapDocumentation.lua
