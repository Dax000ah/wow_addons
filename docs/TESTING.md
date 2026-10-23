# Verification

## Remote member labels (0.5.1, client verification pending)

1. Run `/reload` and `/gcompass status`, with demo off and the member still on
   another continent. Confirm version 0.5.2 and a name/continent label when the
   client exposes map ancestry, or Different world area for known world-ID mismatch.
2. Hover the strip to read the full message if long names or multiple members clip.
3. Return to the same world area and confirm normal direction/distance resumes.
4. Disconnect that member: unknown/offline must not retain a continent claim.

Local Lua regressions cover these decisions; native API returns still need Tony.

## Compact horizontal strip (0.5.0, client verification pending)

Restart WoW for the new Layout.lua load order, verify the 0.5.0 loaded notice,
then use `/gcompass demo reset`. A/B/C must sit on one horizontal bearing line,
with all names on the same name row and all distances on the same distance row.
The strip should occupy much less height than the old panel. Character turning
and walking must still update positions/distances. Check at Tony's actual UI scale.

Hover a member position to see its full name and distance. With two real members
on nearly the same bearing, verify labels do not stack vertically or collide:
one may be suppressed while every bearing tick remains at its exact location.
Hover the shared position to see both identities. Long names should stay on one
line with full text in hover. Move the cursor along the strip, then off it and
toggle off; ensure the tooltip updates and dismisses. Check empty, behind-only,
paused, demo and live states without a large persistent status area.

The new regression assertion failed against 0.4.1 because member label Y positions
differed. It passes after removing the row-stagger formula. Layout tests cover
non-overlap, center priority, deterministic ties and crowded raid labels while
preserving every actual bearing. UI doubles do not prove native font clipping,
mouse behavior or final appearance; those remain manual checks.

## Local checks

From the project root:

```powershell
python scripts/check_structure.py
python -m pip install --target .test-tools -r requirements-dev.txt
python scripts/run_tests.py
python scripts/build_zip.py
```

The Python check validates required files, interface number, TOC references,
load order, and orphan addon Lua files. It does **not** parse or execute Lua.
The test runner uses Lupa's Lua 5.1 runtime in `.test-tools`; this is development
tooling only. Alternatively, run each `tests/*_test.lua` with standalone Lua 5.1.
The suites cover bearing math, missing/invalid/secret-marked coordinates,
offline members, party/raid roster changes, restriction guards, slash commands,
demo display, and marker clearing. UI tests use API doubles; secret handling tests
use a detectable placeholder, not actual opaque WoW values. They cannot verify
native restrictions or rendering. Packaging checks ZIP integrity, exact runtime
paths, and byte-for-byte agreement with source. ZIP creation refuses overwrites.
The map suites also validate normalized-map bounds, offline/secret/nil map data,
late world-map loading, pin reuse/removal, minimap rotation and zoom, and marker
corner safety. The XML check verifies syntax and the template declaration; it
does not replace the client's XML loader.

## Classic Hardcore 1.15.9 startup and moving demo check (0.4.0)

Tony reported build 70003/interface 11509. Version 0.2.0 was listed out of date,
and `/gcompass demo` was not recognized. No Lua error or loader-reason output was
captured. This establishes a missing command and an interface mismatch, not a
complete diagnosis of the native loader failure.

1. Follow the Classic installation instructions in README. Fully exit/restart
   the game after replacing the addon with 0.4.0; verify the manifest/version,
   `Compat.lua`, and `Demo.lua` are present in the actual game folder.
2. Check that the out-of-date warning clears and `Group Compass 0.4.0 loaded`
   appears in chat. Confirm `/gcompass demo` displays three simulated sample labels
   without a party, and `/gcompass status` reports build 70003/interface 11509.
   A starts left, B ahead, and C right, at roughly 25/40/60 yards. Turn the
   character (not just the camera) and verify labels move. Walk toward B's original
   location and verify its distance decreases. Turn away: it hides behind you.
   `/gcompass demo reset` should reseed the initial arrangement around your current
   location/facing, even if demo was off. `off`/`on` should retain the same anchors.
   Combat and instances should not automatically pause demo. Unavailable position
   data clears labels; resume the same locations when readable again in the same
   world coordinate space. A different world-space ID should reseed safely.
3. If loading fails, run the loader diagnostics in README and capture any Lua
   error text after enabling `/console scriptErrors 1` and restarting. The console
   command itself normally produces no chat confirmation.
4. With another grouped player, run the live map/compass checklist below. For
   Classic minimap testing, check each zoom level and indoor/outdoor transitions.
   The compatibility fallback temporarily probes and restores native zoom only
   when the two zoom settings are equal; verify the chosen zoom stays unchanged
   and badges align with native dots. Minimap replacements need separate checks.

Local startup tests execute every TOC Lua file with Classic-style API doubles,
verify command registration and metadata through the legacy API, and exercise
the demo with modern-only globals absent. The manifest check initially failed
against 0.2.0 because interface 11509 was missing. Radius tests cover native API
preference, Classic outdoor/indoor tables, probe restoration/caching, and reentry.
These checks do not execute the native TOC/XML loader or establish live support.

## Required live client checks (Classic and Forever, not yet completed)

Record `/dump GetBuildInfo()` and the date with each test result. Enable Lua
errors with `/console scriptErrors 1` while testing and record any errors.

1. Install exactly as README describes. Confirm the addon appears and loads
   without errors. While solo, the strip should say no locatable members.
2. Run `/gcompass demo`: three labeled sample markers appear. Toggle it off to
   restore live mode. Test `off` and `on` and the alternate slash command. Demo
   should also show the display if it was hidden. Run `/gcompass status`, and
   record its build and live tracking output alongside the manual results.
3. Join a party with one nearby member outdoors, out of combat. Face them:
   their marker should be near the center and distance should decrease on approach.
4. Face north with a member north, east, west, then south: expect center, right
   edge, left edge, then hidden behind. Repeat while facing west. Confirm angles
   near north wrap smoothly instead of jumping across the display.
5. Rotate only the camera: the compass should stay character-relative. Turn the
   character: the compass should respond within approximately 0.1 seconds.
6. Move across zone boundaries, to another floor/phase, and beyond loading range;
   disconnect one member. Confirm no stale markers or invented bearings. Note
   whether the client actually returns nil, zeros, or otherwise unusable data.
7. Join/leave party, convert to raid, and leave raid. Verify no self marker and
   no leftover markers after roster changes. Check overlapping labels in a raid.
8. Enter combat and instances (dungeon, raid, battleground/arena if available).
   Live markers should continue while valid coordinates are available. If the client
   withholds coordinates, affected markers clear and recover when data returns.
   No blanket combat/instance paused message should appear. Demo remains synthetic.
9. `/reload` and restart the client: verify loading and command registration.
   The prototype intentionally resets enabled/demo state; no settings are saved.

## Additional map/minimap checks for 0.2.0 (not yet performed)

1. Start with the world map closed, then open it after the addon has loaded.
   Confirm no XML/mixin errors and one custom numbered pin per locatable party
   member. Hover for the member name. Match its number/color to the compass.
2. Pan/zoom the world map, select another zone, change floors, and reopen it.
   Pins must follow the displayed map coordinates, disappear where data is nil,
   and return without duplicating. No native dots should be removed.
3. Move a party member north/east/south/west of the player and compare the
   minimap badges to native group dots. Change minimap zoom and enable/disable
   the standard rotating minimap. Check cardinal alignment after turning.
4. Move beyond minimap view range while remaining locatable. The badge should
   stay inside the edge, become translucent, and describe the inset edge on hover.
   Verify its direction instead of interpreting it as an exact nearby location.
5. Hover a moving member's minimap badge: name/distance should update without
   repeatedly dismissing the tooltip. Move away and check tooltip dismissal.
6. Leave party, disconnect a member, enter combat/an instance, and run `off`.
   Roster loss, disconnect and `off` clear affected markers. Combat/instances alone
   must not clear them; missing coordinates still do. Turn `on` to restore live
   tracking. Native markers should retain their normal behavior.
7. Convert to raid: custom world-map pins clear (party-only API), while locatable
   raid members remain eligible for compass/minimap badges. Return to party and
   verify world-map pins resume.
8. Toggle demo on: all custom map markers clear and only synthetic compass
   labels remain. Toggle demo off and verify real map markers return.
9. If using a minimap replacement, verify anchoring, clipping, scaling, and mouse
   interaction separately. Default round minimap compatibility is the first target;
   overlap between badges and collisions with other addons are not solved yet.

## Class-color defaults (0.4.1)

Join a party with known classes and verify each real member's compass name,
world-map badge, minimap badge, and tooltip name use that class's standard color.
Member names must remain readable. Class colors are preferred through the modern
API, with the Classic global color table supported as well. Missing, nil, secret,
or invalid class/color data uses a slot-color fallback. Demo A/B/C are synthetic
members and keep their sample palette, so demo cannot establish real class lookup.
Local tests cover class/name data across tracking views and tooltip color; native
class lookup still needs the grouped-player check.

Do not mark unavailable scenarios as passing. Record client restrictions and
exact symptoms in PROJECT_STATUS.md before expanding supported contexts.
