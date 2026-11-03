# Which arrow should I follow?

## Current label —0.11.4

Our menu now says RestedXP guide controls... (formerly Resume RestedXP guide...).
It opens native settings; Guidance > Resume guide calculates the golden route to
the current guide destination. Faster native action: right-click Shortest Path's
journey tracker heading > Resume RestedXP guide. There is no public Resume method,
slash command or stable named button to invoke directly from GC in this version.
Do not add a private widget/callback workaround.0.11.3 launcher hover help remains.


## Launcher help —0.11.3

Hover the cyan minimap icon: separate wrapped lines explain left-click (Options),
right-click (navigation choices) and left-drag (move icon). Native Resume guide
means calculate/show a path to the current RXP navigation destination; it does not
restart guide/quest progress. Our menu shortcut only opens native controls, so
Guidance > Resume guide still requires your click. No direct public Resume API.


## New in0.11.2: clear actions and hover help

Right-click cyan icon: Resume RestedXP guide..., Party members, TomTom waypoints.
Hover each choice for a wrapped explanation. Resume opens Shortest Path controls;
choose Guidance > RestedXP guide > Resume guide (bottom red button). It does not
resume automatically: the stock API/CLI has no public direct Resume action.

Recalculate this route appears for our remembered owned target and resends that
destination. A member route uses its old snapshot; reselect the member to refresh
it. Stop this route appears for our owned route and cancels only that request.
It does not delete points or stop a separate guide or TomTom arrow. Automatic
following can later start another route. Missing Blizzard quest coordinates on
Hardcore hide that menu action; this is not a RestedXP failure.

Cyan LEFT-click > Other addons (or /gcompass options): native Shortest Path,
RestedXP and TomTom settings plus Route report (diagnostics). Hover the buttons.
Report opens /path report to inspect target/planner/drawing/version details when
troubleshooting; it does not change routing or send a report automatically.
See MENU_HELP_0.11.2.md for current checks and instructions.


## New in 0.11.1: remote locations

The Elsewhere row sits below the compass and names remote members and TomTom
points without a direction/distance. It stays visible with local markers. Cyan
left-click > Compass > Show Elsewhere line (remote members and points) toggles it
immediately and saves the choice; default ON. It hides when empty or in demo.
Hover for full names if the row summarizes. See ELSEWHERE_0.11.1.md for native checks.

After /reload, refresh RXP with /path > Guidance > RestedXP guide > Resume guide
(the bottom red button). Follow RestedXP guides ON; Follow TomTom's arrow OFF for
guide navigation. Toggling following also sends a fresh request. Group Compass
cannot retrieve a pre-existing private guide destination from the stock API.
Hide RXP's own arrow in RestedXP settings > General > Features > Hide waypoint
arrow; keep Show all Enabled Frames checked. TomTom's arrow is independent.


## New in0.11.0: use the unified bar

Our strip now adds `[Route]` for a destination requested through our menu and
`[RXP]` for guide destinations received through Shortest Path's stock RestedXP
integration. TomTom points remain visible; routed ones get a combined label.
See [0.11.0 setup and limitations](UNIFIED_COMPASS_0.11.0.md) before hiding arrows.
These markers indicate the final destination, not a route bend or boat dock.

Group Compass, TomTom, RestedXP and Shortest Path have separate jobs. They can
show different destinations at the same time.

| What you see | Addon | Its job |
| --- | --- | --- |
| Horizontal strip with N/E/S/W, member names and waypoint labels | **Group Compass (ours)** | Shows which direction people and saved points are from your character. |
| Blue floating arrow labeled **Step 22** in Tony's screenshot | **RestedXP** | Points toward the current leveling-guide step. |
| Large gold arrow with a name, **yards away** and **\*\*\*** | **TomTom** | Points toward the waypoint selected for TomTom's own arrow. The stars mean it has no travel-time estimate while standing still. |
| Route drawn on the maps, and its navigation arrow when displayed | **Shortest Path** | Plans how to travel to its selected destination, including turns and transport. |

The blue **floating Step arrow** is RestedXP. The blue/cyan **line on the map**
is Shortest Path's boat route. They are different displays from different addons.
Walking sections of Shortest Path's route are gold; flight sections are green.
Colors can vary with addon themes; the labels and role are the better identifiers.

## What selecting someone in our menu does

Right-click our cyan minimap button > Party members > a name requests a Shortest
Path route to that person's location at the moment you selected them. Follow
Shortest Path's route and turn guidance for that trip. Select the member again
after they move; the route is a location snapshot, while our compass tracks live
member positions when the game exposes them.

That choice does not retarget TomTom's floating arrow or change RestedXP's guide
step. It is expected that TomTom still points at its previous waypoint and
RestedXP still points at Step22. Our compass strip remains a direction display;
Group Compass0.10.2 does not create a separate floating route arrow.

Selecting a TomTom point in our menu similarly requests a Shortest Path route to
that saved point. TomTom continues to own its bookmarks, pins and arrow selection.
Stop Group Compass route cancels only the route owned by Group Compass; it does
not clear TomTom's arrow or stop RestedXP's guide.

## A simple way to use them

- **Leveling:** follow RestedXP's Step arrow for the guide.
- **Meeting a friend or visiting a saved place:** select it in our menu and use
  Shortest Path's map route and its arrow, if enabled. Our bar shows bearings.
- **Using a TomTom bookmark directly:** choose it for TomTom's arrow through
  TomTom's own waypoint menu.

To reduce clutter without deleting waypoints, open `/tomtom` and turn off
**Enable floating waypoint arrow** in its arrow settings. TomTom's saved points
and map pins remain available to Group Compass.

Shortest Path has optional **Follow RestedXP guides** and **Follow TomTom's arrow**
settings in `/path`. These make Shortest Path follow those addons' targets; they
do not make Group Compass own their arrows. RestedXP following also hides the
RXP arrow while its integration is active. Guide updates or TomTom arrow changes
can then select later route targets. Leave those automatic followers off when
you want to choose a member/waypoint manually and keep control of that route.

## Verified behavior and remaining checks

On November3, Tony confirmed Hardcore routes to a fresh TomTom road point and a
member through the Group Compass menu. One older point also fails via Shortest
Path's own command. Current stock API tests pass against Foreverv1.22.18, but
native Forever acceptance and repeated A/B/A routes remain open. No third-party
addon edits are needed or included in our milestone.

Identification was checked against RXP `map.lua` (Step title), TomTom
`TomTom_CrazyArrow.lua` (yards/stars), Group Compass `Routing.lua` (Navigate call)
and Shortest Path `UI/Route.lua` / `UI/Arrow.lua` (route colors and turn guidance).
