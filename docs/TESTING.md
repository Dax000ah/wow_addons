# Current target: unmodified Forever — November3

See [FOREVER_LAUNCH_CHECKLIST.md](FOREVER_LAUNCH_CHECKLIST.md) for the current
versions, API/engine checks and native gates. Hardcore checkpoints below are
historical secondary checks, not launch acceptance. GC menu versus working
Alt-click still needs exact saved-goal comparison; GC-218 remains open.

# Stock API integration 0.10.2 / hc-test.8 — native GC-217 / HC-008, GC-218 OPEN

1. Fully exit/reopen Hardcore. Confirm GC 0.10.2 and SPF v1.22.9-hc-test.8.
   The two old provider app-support files are unreferenced and must not load.
2. Alt + right-click a nearby road to save a TomTom point. Right-click the cyan
   icon > TomTom waypoints > select its name. No second map click is required.
3. Check gold lines on both maps; walk to another position, select a second saved
   point and return to the first. Retry resubmits our current destination. This
   is the reported intermittent sequence and remains unverified in the client.
4. Select a nearby party member; verify a current-position snapshot, not pursuit.
   Retry and Stop affect only our route. Other sources use the provider's controls.
5. RestedXP guide settings... opens /path. Guidance > Follow RestedXP guides, then
   RestedXP guide > Resume guide. Automatic followers remain user-configured;
   disable Follow RestedXP guides there if only manual targets are wanted.
6. Blizzard tracked quest explains the missing Hardcore destination lookup.
   TomTom and RestedXP still have their own routing inputs. No next-turn marker
   is invented on our bar; use the provider's native arrow/compass.
7. hc-test.8 fixes the independently reproduced SPF/OpenMap world-yard projection
   bug. Reopen the same Teldrassil map and check main map AND minimap separately.
   Native report received from hc-test.7; exact successful retest remains open.
8. If the yellow-dot-only state returns, open Route report or /path report BEFORE
   changing the target. Paste it and indicate map Alt-left-click versus menu
   selection. No Lua error was reported; the exact cause remains unconfirmed.

Offline checks: python scripts/run_tests.py; python scripts/check_spf_api.py
PROVIDER_DIRECTORY; python scripts/check_tomtom_offline.py TOMTOM_DIRECTORY;
python scripts/build_zip.py (new archive only). The sibling provider verify.py
and check_engine.py include real Search/Walks/Nav repeated/moved-target checks.
UI/projection services are doubled; these do not establish native compatibility.

# First party-pin lifecycle 0.9.4 — native gate GC-216

1. /reload; confirm Group Compass 0.9.4 in chat or /gcompass status. If demo is
   on, /gcompass demo toggles it off. /gcompass on enables live display.
2. Join a friend nearby outdoors on the same continent. Face them with your
   character: their name/class color/distance should appear on the bar. Members
   behind you intentionally disappear until you turn toward them.
3. With OpenMapClassic enabled, open/close the world map, zoom between zone and
   world views and pan. Check party pins on both maps and continued compass
   updates, with no new nil-fill error. Leave/rejoin the party and repeat.
4. If absent, report /gcompass status and any fresh Lua error. A different
   continent or client-withheld coordinates still cannot yield a true bearing.

Automated: corrected pool reset-before-OnLoad regression reproduced the original
MarkerStyle.lua:13 error before the fix. All 17 suites pass afterward, including
pin recycling and real Core/Maps composition through three join/leave cycles.
Installed TomTom API composition and ZIP/source checks pass; all 29 installed
files match SHA-256. These are offline checks; native GC-216 remains open.

# Route source clarity 0.9.3 — native gate GC-215

1. /reload, open Waypoints & help with no TomTom points. If another journey is
   active, check the new status: RestedXP, TomTom arrow, or unknown separate journey.
   The screenshot's actual source is not yet confirmed; RestedXP is a likely cause.
2. Click Route settings. For a RestedXP-owned route, uncheck Follow RestedXP guides
   if you want only manual routes. Verify that guide path clears, then add a point
   and Navigate: manual routing should still work. Guide progress is unaffected.
3. Delete that routed TomTom point: our owned route should clear. With another
   addon's route active, deleting unrelated points must preserve it and Stop route
   stays disabled. Provider ownership and settings errors must remain visible.

# Compass appearance 0.9.2 — native gate GC-214

1. /reload; click the cyan minimap button or /gcompass options. The Compass tab
   opens first. Move Bar width (horizontal), Bar height (vertical), and Text size.
   Check immediate changes in the actual bar and visible values/limits.
2. Width is 320–1200 UI pixels. Height is 40–160, with its minimum also enforcing
   3 * text size + 16 (46 at default size 10; 76 at size 20). Text is 8–20.
   Check that increasing text updates both the height slider's lower limit and
   the actual bar when necessary. Reducing text does not discard chosen spacing.
3. /gcompass demo. Try smallest width with largest text, then largest width/height.
   Turn and hover: names/headings/ticks/distances keep shared rows and correct
   bearings; crowded names may hide but hover must retain identities. No clipping
   past the frame or overlapping rows. Review at your own UI scale.
4. Map markers tab: previous shape, map sizes, effect, colors and previews remain
   usable. Waypoints & help / TomTom settings and Done/X/Escape still work.
5. Choose custom sizes, /reload and reopen options: values and bar should persist.
   /gcompass off, change a slider, confirm it stays hidden; /gcompass on restores
   the chosen layout. Reset defaults restores 620/46/10 and existing map defaults.

Automated: 17 Lua 5.1 suites pass, including Settings/Core composition, callback
reentrancy when a slider's range clamps its value, persistent defaults/bounds,
78 geometry combinations, resized hover and off/reset behavior. Native UI remains
unverified. Package/source checks and 29 installed SHA-256 matches pass.

# Compass headings 0.9.1 — native gate GC-213

1. /reload, then /gcompass on. N/E/S/W should remain visible without a party.
2. Turn the character through a full circle. The direction faced moves to center;
   facing north shows W left and E right. Camera-only rotation should not move it.
3. /gcompass demo: headings and demo members move together. All names share one
   row, ticks another and distances another; headings have their own row. Check
   readability at your UI scale. The frame remains 620 by 46 units.
4. Toggle demo off, check a real waypoint/member, then /gcompass off/on. Missing
   facing should clear heading labels; missing coordinates alone should not.

For the separate hc-test.4 provider: /reload and reopen the map that failed with
StopPin.lua:107. Verify gold world-map lines plus a destination mark; close/reopen,
zoom and try a multi-stop guide. Tony has confirmed minimap gold lines; world-map
appearance, further timeout checks and movement/arrival remain open.

# TomTom integration 0.9.0 — current native gate GC-212

1. Fully restart WoW (new TOC module/dependency), enable TomTom and Group Compass;
   /gcompass status should report 0.9.1 (includes the 0.9.0 integration).
2. Cyan launcher > Waypoints & help: verify clear creation instructions, configured
   modifier, facing/visibility note, Open world map and TomTom settings. /tomtom
   remains the native settings shortcut. Compare displayed shortcut to its settings.
3. On a zone map, Alt + right-click terrain (default). Exactly TomTom's pin should
   appear; its point should enter our list and the top bar automatically. New points
   exit demo/enable live display. Face the point with the character and walk/turn.
4. Try /way 45 60 Camp and Save my location. No extra Group Compass map pin or
   Alt-left-click handler should interfere. Party map icons/hover still work.
5. Edit from our list: rename Camp and choose a shape, Save/Enter. Both TomTom map
   icons and hover names should update; the bar name follows. Cancel/X/Escape keeps
   saved values. Keep current icon preserves native themes/custom icons/portraits.
6. Test icon-only edits, renamed point and another active TomTom arrow. Arrow
   references should persist when known; an unidentified pre-existing arrow produces
   an explicit clear-before-rename message. Collisions retain the original point.
7. /reload and switch TomTom profile: saved points/edits and native profile scope
   should behave normally. Existing Group Compass records import once; deleting an
   imported point must not resurrect it on reload. Legacy records are retained.
8. Remove points through TomTom or our list: bar/list clear. Another addon's points
   are visible but read-only here. Invalid/missing data cannot leave stale bearings.
9. With over 20 local points, show nearest 20 only on bar; list all. Points behind
   or in another world do not get false bearings. Native window/palette sizing,
   scrolling and keyboard focus need review at Tony's UI scale.
10. Disable TomTom and restart: waypoint help explains enabling it, controls do not
    silently create a second store, and ordinary member/demo tracking still works.

Automated: python scripts/run_tests.py PASS 17 Lua 5.1 suites; read-only
scripts/check_tomtom_offline.py against installed TomTom v4.3.13 PASS. It executes
actual TomTom.lua registry/API/persistence methods with doubled UI pins. Structure,
package/ZIP checks and 29 installed SHA-256 comparisons pass. Gameplay is unverified.
Source fingerprints: docs/research/tomtom-integration-2026-10-26.json.

The following checks record earlier builds. Their independent waypoint placement
and custom waypoint map rendering are superseded; use GC-212 above for 0.9.0.

# Historical waypoint editor 0.8.1 — superseded by GC-212

1. /reload; /gcompass status should report 0.8.1. Restart if the manifest version
   has not refreshed. No party or routing provider is needed.
2. Press M, open a zone map, Alt + left-click terrain: one point is saved and its
   editor opens above the map, with name selected and ten gold icon previews.
3. Name it Camp, select Star, Save. Check the star on the world map/minimap,
   Camp in both hover labels and [WID] Camp on the compass when ahead/same world.
4. Left-click its world-map pin, then its minimap pin. Both reopen the same saved
   point. Right-click must not edit; releasing outside a minimap marker must not edit.
5. Options > Waypoints > Edit opens the same point. Try all ten tiles; selected
   outline must be clear, names readable, and Save/Cancel reachable at your UI scale.
6. Cancel, X and Escape discard name/icon changes. Enter saves. Cancelling a newly
   placed point retains its default saved pin; remove it through the list if unwanted.
7. Save my location with a name, then Edit its row. Remove a point and ensure it
   disappears from maps/bar. Keep Navigate/Replace/Stop behavior usable.
8. /reload: custom names/icons persist. Legacy points stay as gold pins until edited.
   Reset member appearance must preserve them. Edits must not change coordinates/IDs.
9. Verify normal map clicks, pan/zoom, group-marker hover and an actual grouped
   player remain usable; reused party markers must not open waypoint editors.

Automated: all 16 Lua 5.1 suites, structure/XML/artwork and ZIP checks pass.
Native editor layout/click/focus, other-addon interaction and reload need gameplay
confirmation. Golden routes/next turns still require the separate compatible provider.

# Routing API bridge 0.8.0 — native gates open

1. Fully restart WoW; /gcompass status should report 0.8.0.
2. /gcompass waypoints: verify Navigate/Replace, Stop route and routing status;
   absent provider should report it clearly and keep ordinary waypoints usable.
3. /gcompass route status and route ID should report the missing provider safely
   in the current Hardcore install. No live golden route is promised there.
4. With compatible SPF in Forever: request a route to a saved point; map routes
   belong to SPF. Active foreign guidance needs a second Replace click. Stop only
   cancels Group Compass ownership; /gcompass off/demo and removal stop our route.
5. Base SPF v1.22.4 has no GetGuidance: status must say next-turn API unavailable.
   With a supported getter/build, verify cyan next step, turn/walk, boarding,
   cross-world clearing, combat hide/resume, cancel/arrival/replacement/error and
   unchanged party data/shared bar baselines. Do not display a stale bend.
6. Reload preserves points/appearance; no automatic session-route restart.
7. 16 local suites and package/install hashes pass; actual provider navigation,
   native UI and full Classic provider compatibility remain unverified.

# Historical personal waypoints 0.7.0 — superseded by GC-212

1. Fully restart WoW; verify the current version with /gcompass status. No party required.
2. On a zone map, Alt + left-click terrain: one gold waypoint pin should appear
   without navigating/zooming. Plain clicks retain native navigation behavior.
3. Face toward the point: its gold [W1] name/distance should occupy the same marker
   baseline as members. Turn/walk; check distance, front/behind filtering, and hover.
4. Check minimap placement, rotation and edge clamping at different zooms. World-map
   pan/zoom and switching to a continent/another zone must not create wrong-map pins.
5. Options > Waypoints opens a scrollable personal list. Save my location with a
   name, use Enter/Escape, Remove, Done and Open world map. Remove clears all views.
6. Test /gcompass waypoint here My Camp and waypoint 45 60 Coordinate Camp. Names
   preserve case and UTF-8. Verify IDs/list/remove and the 20-point creation limit.
7. Reload: points persist for this character. Another character starts its own list.
   Reset appearance: points stay. Creating a point exits demo and enables live views.
8. Different continent/instance, nil/secret coordinates and unavailable APIs must
   omit invalid bearings; stored-zone world pins can remain visible. No stale pins.
9. Group with a real player: both people and waypoints appear, with distinct identities;
   crowded hover, roster changes, off/demo and world-pin reuse should stay correct.

14 Lua 5.1 suites and structure/package checks pass locally. Native map click hooks,
C_Map return values, artwork, UI and Forever still need in-game confirmation.

# Version 0.6.1 appearance settings — native checks pending

1. Fully restart WoW; confirm 0.6.1 with /gcompass status. A cyan head-and-shoulders
   minimap-border button should open options. /gcompass options is a fallback.
2. No party is needed for the two menu previews. Change all ten icons; check
   recognizable artwork, especially the default head-and-shoulders outline.
3. Change minimap/world-map sizes independently, including extremes (12/40).
   Join a real party to confirm actual markers resize and stay within the minimap.
4. Try None/Glow/Slow flash and every color mode. Changing away from flash must
   stop animation. Compass names remain class-colored; map hover uses chosen color.
5. Open/close the menu by button, Done, X and Escape. Open each dropdown twice;
   choosing an item closes it. Dropdowns should fit at Tony's UI scale.
6. Drag the border button, including hiding the minimap while dragging. Verify
   dragging stops and the button remains clickable. Reload: settings/position persist.
7. Reset defaults: person, 20 minimap, 24 world, None, Class colors, default position.
8. Party/zone changes, off/demo, map hiding and pin reuse must clear old markers,
   stop hidden animation and resume the selected effect when shown again.

All 12 Lua 5.1 suites pass locally. Native artwork/UI/combat behavior still needs
Tony's client; mocked UI tests do not establish native visual compatibility.

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
