# Group Compass for WoW Classic Era/Hardcore and Forever

**0.11.2 menu help:** right-click shows navigation choices with hover explanations;
settings/report links are under **Options > Other addons**. **Resume RestedXP guide...**
opens native controls; finish with **Guidance > Resume guide**. Recalculate/Stop
appear only for our applicable route. See [menu help](docs/MENU_HELP_0.11.2.md).


**0.11.1 Elsewhere line:** remote members and TomTom waypoints appear below the
compass even while local markers are visible. Toggle **Show Elsewhere line** in
**Options > Compass**; it defaults on. Hover for names when the row summarizes.
See [setup and checks](docs/ELSEWHERE_0.11.1.md).


**0.11.0 unified bar:** TomTom points stay on the strip; destinations selected
through our menu gain `[Route]`. Enable Shortest Path > Follow RestedXP guides
and Resume guide for an automatically updated `[RXP]` marker. See
[setup and limits](docs/UNIFIED_COMPASS_0.11.0.md). These are destination bearings;
next bends and native Alt-click journeys are not exposed by the stock API.

**Which arrow is ours?** Our display is the horizontal compass strip. The blue
Step arrow is RestedXP; the gold name/distance arrow is TomTom. Shortest Path
draws the travel route. Selecting a member in our menu changes that route while
the other arrows keep their own targets. See [the simple navigation guide](docs/NAVIGATION_GUIDE.md).

**November 3 launch target:** Forever with its unmodified CurseForge addons.
Current installed Shortest Path v1.22.18 API and TomTom v4.3.13 composition pass;
the private Hardcore provider still has a v1.22.9 base and is only a test aid.
See [the launch checklist](docs/FOREVER_LAUNCH_CHECKLIST.md) for exact versions,
offline checks and the remaining native tests. The0.11.0 build adds unified destination markers; native Forever acceptance is still pending.

An experimental addon inspired by Enshrouded's group direction indicator. Turn
your **character** toward a group member and their name moves toward the center
of a compass strip near the top of the screen. The strip shows locatable members
within 90 degrees to either side of your character, with approximate horizontal
distance in yards. Members behind you are omitted; turning around reveals them.

N, E, S and W slide across the same angular scale as you turn your character.
They remain visible while solo, in their own row within the compact strip.
Open /gcompass options > Compass for saved width, height and text-size sliders.
Defaults remain 620 by 46 with size 10 text. Width is 320–1200 UI pixels, height
40–160 and text 8–20. The height minimum rises with text size so rows fit.

Version 0.2.0 also adds **world-map party pins** and **minimap group badges**.
Each real member uses their class color by default across all three views, with
their name on the compass and in map/minimap hover labels. Numbers follow group
slots and can change when the roster is reordered. If a class/color is unavailable,
the display falls back to a slot color. Demo members use clearly synthetic colors.

**Status:** prototype targeting Classic Era/Hardcore 1.15.9 (interface 11509)
and Forever (interface 16001). Neither client has a completed live test. Outdoor tracking is
plausible from the exposed APIs; full camera-relative behavior and unrestricted
dungeon/raid tracking are not promised. Read [feasibility](docs/FEASIBILITY.md)
before treating the prototype as a supported addon.

## Install and use

1. Copy the `GroupCompass` folder into your client's `Interface/AddOns`.
   The final path must be `Interface/AddOns/GroupCompass/GroupCompass.toc`.
   Copy the addon folder, not this entire project.
2. Fully restart the client after installing or updating the manifest. Enable
   Group Compass in AddOns. You should see `Group Compass 0.11.4 loaded` in chat.
3. Use `/gcompass demo` to toggle simulated members, even while solo. They stay
   at fixed world locations, so turning your character moves their labels and
   walking changes the distances. `/gcompass demo reset` places new samples.
4. Turn demo off and join a party outdoors to try live tracking.
5. `/gcompass off` hides the display; `/gcompass on` shows it again.
   `/groupcompass` is an alternate command.
6. `/gcompass status` prints the client build, interface number, display/demo state,
   and live tracking availability. Include this output when reporting a problem.

Running `demo` while hidden shows the display. Roster, zone, and combat events
refresh markers immediately, alongside the regular 0.1-second updates.

## Map and minimap markers

Right-click the cyan minimap button for **Golden path targets**; left-click opens
options. Select a TomTom waypoint or member to request a route through the
unmodified Shortest Path public API v1. No provider patch is required on Forever.
Members are current-location snapshots: reselect after they move. Retry resubmits
our current target; Stop cancels only our route. For other journeys use Shortest
Path's controls. Its automatic guide/arrow followers stay as configured there.

**RestedXP guide settings...** opens Shortest Path settings. Choose Guidance >
Follow RestedXP guides, then RestedXP guide > Resume guide. The upstream API has
no one-click guide-resume or next-turn getter. Use Shortest Path's native arrow/
compass for turns; our bar continues to show members and TomTom destinations.

**Blizzard tracked quest** uses the selected Blizzard quest's destination only
when this client exposes it. That lookup is absent on the tested Hardcore build;
TomTom/RestedXP routing does not depend on it. Starred choices explain the limit.

Alt + right-click saves a TomTom point. Select its name in our target menu to
request the golden route; no second map click is needed. A yellow dot and an
accepted request do not prove a walking path was found. If lines disappear, use
Route report (/path report) and preserve the failed state for diagnosis. The
reported intermittent failure now has a privately repaired SPF/OpenMap projection
bug (hc-test.8); native retest remains open. No GC support API was added, and the
original Forever addon is unchanged. See docs/PROJECT_STATUS.md.

- Open the world map to see class-colored party icons. Hover a pin for the
  member's name. Pins follow the map currently being viewed and its zoom/pan.
- The minimap shows matching configurable icons for locatable party/raid members.
  Hover for their name and horizontal distance. Badges near or beyond the edge
  stay inside the map border and become slightly translucent as direction cues.
  Minimap zoom and the standard rotate-minimap setting are respected.
- `off` clears all custom markers; `on` restores live views. Disconnected members and unavailable positions clear affected custom pins.
  Combat and instances do not automatically disable tracking.
- Demo mode is compass-only: it clears our map badges instead of putting fake
  party locations onto real maps. Turn demo off to try the live maps.
- Blizzard's own group dots remain in place. Our badges are an additional layer.
  No native tracking settings or other addons' markers are changed.

The world-map API documents party support only, so custom world-map pins are
disabled while in a raid. Compass/minimap raid support is retained. World-map
pins use a separate map-coordinate API and can work when world positions or
character facing are missing. Minimap badges require the compass's usable world
coordinates. These behaviors still need testing in Forever, particularly across
zones, floors, minimap replacements, and client updates. The first minimap layout
targets the default round map; other shapes use a conservative inset ellipse.

The current manifest targets interfaces `11509` and `16001`. Confirm your installed
build with `/dump GetBuildInfo()`; update the manifest only after checking that
build's API compatibility. Appearance settings save between sessions. Group members do not
need this addon installed. No external libraries or addon messages are used.

## Project layout

```text
wow_addons-checkout/
  .gitignore
  README.md
  GroupCompass/                 Copy this folder into Interface/AddOns
    GroupCompass.toc            Metadata and Lua load order
    Compat.lua                  Client metadata and Classic minimap-radius fallback
    Direction.lua               Relative bearing and horizontal distance
    Projection.lua              Minimap pixel offsets, rotation, edge clamping
    Layout.lua                  Single-row label spacing without moving bearings
    Tracking.lua                Group sampling and unavailable-data handling
    Demo.lua                    Fixed simulated world locations for solo testing
    Maps.lua                    World-map pin provider and minimap badges
    Maps.xml                    Virtual world-map pin template
    Core.lua                    Display, update loop, slash commands, demo
  docs/
    FEASIBILITY.md              What can work and what remains unconfirmed
    TESTING.md                  Automated and in-game verification
    PROJECT_STATUS.md           Initial checks, limitations, next steps
  scripts/
    check_structure.py          Dependency-free structure/manifest check
    run_tests.py                Execute all regression suites using Lua 5.1
    build_zip.py                Create and validate an installable ZIP
  requirements-dev.txt          Optional local Lua test runtime
  tests/
    direction_test.lua          Bearing regression cases (Lua 5.1)
    tracking_test.lua           Position availability and restriction checks
    core_test.lua               UI/command logic with a small WoW API double
    projection_test.lua         Minimap geometry and edge safety
    maps_test.lua               Map lifecycle, rotation, tooltip and cleanup checks
    classic_test.lua            Classic manifest and full Lua startup smoke test
    compat_test.lua             Client API differences and minimap radius checks
    demo_test.lua               Turning/walking, world anchors, pause and reset
    layout_test.lua             Single-row spacing, stable label priority, crowding
```

## Development

There is no build step. Edit Lua, copy the addon folder, and use `/reload` in-game.
Run `python scripts/check_structure.py` from this project to check packaging.
Install test tooling locally with
`python -m pip install --target .test-tools -r requirements-dev.txt`, then run
`python scripts/run_tests.py`. The development-only Lupa dependency supplies Lua
5.1; it is not shipped with the addon. A standalone Lua 5.1 interpreter can also
run each `tests/*_test.lua` file directly.
Run `python scripts/build_zip.py` to create `dist/GroupCompass-0.8.0.zip`; it
contains only the installable addon folder and refuses to overwrite an existing
archive. Extract that ZIP into your client's `Interface/AddOns` directory.
See [testing](docs/TESTING.md) for the required client checks and limitations.

## Classic Hardcore installation and first test

Tony's reported client is **1.15.9, build 70003, interface 11509**. Version 0.3.0
adds that interface to the manifest and a Classic minimap-radius fallback.
The previous Forever-only packages were not a verified Classic installation.

1. Exit WoW completely. Extract `dist/GroupCompass-0.8.0.zip` into your active
   Classic installation's `Interface/AddOns` directory (normally under
   `_classic_era_`). Update the existing `GroupCompass` folder with the new files;
   don't put the ZIP or a second nested `GroupCompass` folder inside it.
2. Verify `GroupCompass/GroupCompass.toc` says `## Version: 0.8.0` and
   `## Interface: 11509, 16001`, and that `Compat.lua` is alongside it.
3. Start WoW, enable Group Compass in AddOns, and log in. Check for the loaded
   message in chat. This build should no longer be out of date on interface 11509.
4. Run `/console scriptErrors 1` (normally no chat confirmation), followed by
   `/gcompass demo`. Samples A/B/C initially appear left/ahead/right at roughly
   25/40/60 yards. Turn your character, then walk a few steps: bearings/distances
   should change. Camera-only rotation does not move the markers. Samples behind
   you disappear until you turn toward them again. Use `/gcompass demo reset` to
   place new samples after wandering away. They also reset on world-space changes.
   Demo pauses only when player position/facing is unavailable.
   Run `/gcompass status` to confirm version 0.8.0, interface 11509, and build 70003.
5. Run `/gcompass demo` again to return to live mode. Actual party directions
   and map markers need another grouped player, who does not need the addon.

Version 0.4.0 simulates only compass members. It deliberately keeps actual maps
free of invented locations; map/minimap demo views are not implemented. The solo
test validates player movement/facing and compass rendering, not real-party APIs.

## Compact compass strip (0.5.0)

All member bearing ticks share one horizontal line. Names share one row above it;
distances share one row below it. The old three-row stagger is removed. The strip
is 620 by 46 UI units (previously 620 by 130), nearer the top of the screen, with
a subtle background and a center tick for straight ahead. Actual screen pixels
depend on your UI scale. Normal tracking has no large title or status block.

When labels crowd together, the name nearest straight ahead is preferred, with
distance and slot used to break ties. All bearing ticks stay at their true X;
none are shifted into a misleading direction or moved onto another row. Hover
near a bearing to see full class-colored names and distances, including members
whose crowded labels are hidden. Long on-strip names are limited to one line;
their full names remain in the tooltip. Exactly coincident ticks can overlap.
Paused/empty/behind-only states show a message within the same slim strip.

The Enshrouded screenshots guide alignment and visual density. They are design
references, not evidence of new waypoint/quest integration. Final visual polish
and the strip's appearance at Tony's UI scale still need in-game review.

If the loaded message does not appear or `/gcompass` is unrecognized, run:

```text
/dump (C_AddOns and C_AddOns.IsAddOnLoaded or IsAddOnLoaded)("GroupCompass")
/dump (C_AddOns and C_AddOns.GetAddOnInfo or GetAddOnInfo)("GroupCompass")
```

Send those results and any Lua error text. An interface mismatch is confirmed
for the old package; the exact reason it failed to load in Tony's running client
was not captured, so the new startup notice and loader diagnostics are important.

Repository: [Dax000ah/wow_addons](https://github.com/Dax000ah/wow_addons).
Tony cloned the empty repository successfully, and the starter files were copied
into this checkout. No files have been staged, committed, or pushed.

## Project memory

Project memory: [Google Drive project](https://drive.google.com/drive/folders/1FVM0eDJx10nSGpy5s0K5zNwy-Xohecab)
and [local offline index](docs/project-memory/00_START_HERE.md). Requirements,
design feedback, active work, test evidence and completed archives live there.
These are dated mirrors, not a background sync service. Google Docs offline use
still requires enabling offline availability in Tony's browser/Drive setup.

## Similar addons

Research on 2026-10-23 found [MateCompass](https://www.curseforge.com/wow/addons/matecompass),
whose author advertises a horizontal compass for up to four party members on
Forever, with names and distances. It is a close existing match to this idea.
[CompassHUD](https://github.com/BelegCufea/CompassHUD) also advertises party/raid
markers and configurable names; its Forever compatibility was not established
in this review. Neither addon was installed or tested here, and no source from
either was copied into Group Compass.

## Remote members (0.5.1)

Members on a known different continent appear as `Name - Continent` in status
and hover. When only differing world IDs are available, the label says
`Name - Different world area`. Offline or unknown locations remain unavailable.
No cross-continent bearing or distance is invented. `/reload` loads this update.

## Marker options (introduced in 0.6.0)

Click the cyan head-and-shoulders button with a gold rim on the minimap border, or type
`/gcompass options` (also `/gcompass`). Drag the button around the border.
The one-page menu saves changes automatically in `GroupCompassDB`:

- Icon: head & shoulders (default), standing person, face, diamond, map pin,
  shield, star, flag, circle or square. Names and member numbers stay in hover.
- Minimap size and world-map size: separate 12–40 sliders with live previews.
- Effect: None (default), Glow, or Slow flash. Hidden/released markers stop flashing.
- Marker colors: Class colors (default), Party colors, Gold, Cyan, Pink or White.
  These settings affect map markers/tooltips; compass names retain class colors.
- Reset defaults; Done; Escape closes the menu. Settings survive reload/restart.

This version adds Settings.lua, MarkerStyle.lua, Options.lua and twelve original
32-bit TGA textures in GroupCompass/Textures. Rebuild artwork with
`python scripts/build_icons.py`; no extra dependency is needed. The full test suite
now includes settings_test.lua, style_test.lua and options_test.lua (12 suites).
Restart WoW fully for the new manifest, SavedVariables and artwork before testing.

## Waypoints: use TomTom (0.9.0)

1. **Fully restart WoW** after installing 0.9.0; enable both TomTom and Group Compass.
2. Click our cyan minimap button > **Waypoints & help**. Creation instructions and
   TomTom's configured map shortcut are shown there.
3. Press **M**, open a zone and **Alt + right-click** a spot (TomTom's default;
   follow the menu if you configured a different modifier). Or `/way 45 60 Camp`.
4. The TomTom point appears in our list and on the bar automatically. Face toward
   it with your **character**, rather than only rotating the camera. Points behind
   you, in another world or beyond the nearest 20 locatable points are omitted.
5. In **Waypoints & help**, click **Edit** beside the point to set its name and one
   of ten icon textures. Save/Enter commits; Cancel/X/Escape discards edits.
6. **TomTom settings** opens its native options for map/minimap theme and size.
   Our main appearance settings continue to affect group-member markers.

Our Edit window fills a gap in TomTom's installed context menu: it has no rename
or individual-icon picker. TomTom's API supports titles, per-map textures and
portraits. **Keep current icon** preserves its current theme/custom texture/portrait;
our custom textures override its theme on that point. They use their original light
artwork; TomTom does not apply our class-color or glow/flash settings to waypoints.

There is one live waypoint store and one set of waypoint map pins, both owned by
TomTom. Existing TomTom points are read automatically; create/remove/profile changes
synchronize through polling. Names and approximate straight-line bearings appear on
our bar. TomTom controls persistence/profile scope, so its save settings matter.
Group Compass-created points are saved persistently; no party is needed to test.
Old Group Compass points are imported once without deleting their original records;
confirmed deleted imports do not reappear. Missing TomTom disables waypoint features
with instructions while group tracking remains available.

Waypoints created by another addon remain visible but are read-only in our list;
edit/remove them through their owning addon. Rename uses TomTom's API to create the
renamed point before removing the original, preserving settings and rejecting
collisions. If an existing arrow could not be identified, clear it in TomTom and
retry the rename. Icon-only edits preserve the UID/callback/arrow references.

`/gcompass waypoint here Camp`, coordinate creation, list and remove commands remain
API wrappers around TomTom. List reports session IDs for `/gcompass route ID`.
No competing Alt-left-click shortcut, local waypoint CRUD or custom waypoint map
projection/renderer remains. Legacy records are retained solely for import.
Native menu/map behavior still needs in-game confirmation (GC-212).

## Optional route provider (0.8.0)

The saved-waypoint list now offers Navigate, explicit Replace, provider status and
Stop route. /gcompass route ID requests a route; route replace ID confirms replacing
another journey; route stop cancels only ours; route status reports availability.
Shortest Path Forever API v1 is optional and supplies the map routes. Without a
compatible provider, waypoints and party tracking keep working and routing is
explicitly unavailable. Do not expect live route planning on unported Hardcore.

The bar can consume the proposed GetGuidance version-1 target as a cyan next-step
marker on the same baseline. Current SPF v1.22.4 does not export this getter; the
original provider-side draft is not installed or upstream-supported. Combat, lost
ownership, invalid/remote target data and inactive guidance clear that marker.
Off/demo and removal of the routed point stop only our route. Active route selection
is session-only; saved points/appearance persist. No fake native navigation APIs.
See docs/CLASSIC_ROUTING_COMPATIBILITY.md for the observed Classic probe, 16-suite
verification, remaining provider/native gates and exact current test steps.

## Empty waypoint list with a golden route

TomTom points and Shortest Path journeys are separate. An active RestedXP guide
can supply a golden route even with no TomTom points. Version 0.9.3 identifies
RestedXP or TomTom ownership through the provider API when known, and offers
Route settings in Waypoints & help. /path opens the same native settings.

If the status identifies RestedXP and you want only manual waypoint routes,
uncheck Follow RestedXP guides there. This changes Shortest Path's integration,
not RestedXP's guide progress. A different journey source gets its own message.
Deleting a point routed by Group Compass already cancels that owned route;
removing unrelated TomTom points does not cancel another addon's journey.
