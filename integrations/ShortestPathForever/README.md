# Proposed next-turn API extension

Status: original, locally tested provider-side prototype for SPF v1.22.4. It is
not installed, not an upstream-supported API, and not included in the Group Compass
release ZIP. No issue, PR or message has been sent to the maintainer.

`GuidanceAPI.lua` demonstrates an additive `ShortestPathForever.API.GetGuidance(owner)`.
SPF already computes the current bend through its internal `ns.GuideTargets()`.
The proposed getter calls it inside SPF's own namespace, validates the points and
returns new tables. Group Compass would consume only this public getter. It does
not read private frames, hook guidance callbacks, calculate paths or change the
engine's settings. The maintainer can choose its final name and API minor version.

The result is `{version=1, target, nextTarget?, stepEnd?, destination?}`. Each point
is `{worldMapID, north, west}` in world-space yards, matching UnitPosition axes.
World map ID zero is valid. These are not zone uiMapIDs or 0–1 map coordinates.
Group Compass should convert only a target sharing the player's world coordinate
space into an angle/distance using its existing Direction.Calculate function.

The getter returns `nil, reason` when guidance cannot be used: `not-owned`,
`combat`, `corpse`, `inactive` or `no-target`. Callers must clear their route-turn
marker on those results. Reading again after combat/ownership/position changes
gets current guidance; no cached old bend is returned by the extension. Party
tracking stays independent. API.CurrentStop remains the index of a submitted
destination, not a turn index. Ownership can survive a suspended journey, so a
corpse run is checked separately. No provider table escapes by reference.

For a controlled provider development build, the file would live at
`ShortestPathForever/Core/GuidanceAPI.lua` and its TOC would load
`Core\GuidanceAPI.lua` after `Core\API.lua` and the other modules. Loading it in
GroupCompass.toc would give it the wrong namespace. This requires one additive
module and one TOC entry; it does not require copying or porting the route engine.
No installed provider or TOC was modified during this task. A provider update
would remove a local addition; upstream adoption is the preferred maintenance path.

Tests: `python scripts/run_tests.py` includes `tests/guidance_api_test.lua`.
The tests cover ownership, combat, corpse guidance, data validity, copied snapshots,
updated bends, world map zero and preserving an existing future implementation.
These are contract tests with a provider double, not a native integration test.

Real terrain/transport checks use the installed engine read-only:

```powershell
python scripts/check_spf_offline.py 'C:/Program Files (x86)/World of Warcraft/_forever_/Interface/AddOns/ShortestPathForever'
```

See `docs/ROUTING_TEST_RESULTS.md` for evidence, client-testing limits and the
Hardcore compatibility probe. The API bridge, route controls and guidance-bar
consumer are installed in Group Compass 0.8.0; this provider extension is still
uninstalled. Composed tests pass without native user-waypoint/supertracking APIs.
Actual provider navigation and a supported guidance API remain native gates.
