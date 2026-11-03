# Unified compass0.11.0 — setup and implementation closeout

Group Compass's strip now combines member bearings, saved TomTom points and one
supported route/guide destination. Floating arrows can be hidden through their
own addon's settings. No third-party code, private frame reader or custom API
extension is required.

## What appears

| Label | Meaning |
| --- | --- |
| Member name/class color | Live member position, when available |
| [T1] Name | Saved TomTom point, as before |
| [Route] Name | Destination selected through GC's waypoint/member/quest menu |
| [Route] [T1] Name | The selected TomTom point, merged into one marker |
| [RXP] Step/name | Current guide destination sent by SPF's native RXP integration |

These are direct destination bearings with horizontal distance. A route to a
member is a snapshot. Turning/walking updates positions every0.1s. Guide targets
advance when the upstream integration submits its next step. Markers behind
you or on another continent/world are hidden, as existing bearings are.

## Install and test

1. Fully restart WoW after this TOC/new-module update. Check /gcompass status
   reports0.11.0. Turn demo off for real destinations.
2. Right-click the cyan launcher > TomTom waypoints or Party members > select a
   reachable target on your current continent. Face it: look for [Route]. A
   selected TomTom point should show a single combined label, not two.
3. For RXP, cyan right-click > RestedXP guide settings; in /path enable Guidance
   > Follow RestedXP guides, then use RestedXP guide > Resume guide in that page.
   Have a guide active in RXP. Face the current guide target to see [RXP]. Advance
   a step and check its label/location changes. The stock integration hides the
   RXP arrow while it owns the route. After /reload, Resume guide or change a step
   so the observer receives a fresh request; it cannot retrieve old private goals.
4. For a bar-only view, use /tomtom > arrow settings > disable Enable floating
   waypoint arrow. In RXP settings, Hide waypoint arrow controls its own arrow.
   In /path, Show direction arrow controls Shortest Path's floating direction
   marker. Change these through their native settings; GC does not change them.
   Keep the guide itself enabled. Recheck RXP step advancement after hiding it.
5. Stop/replace a route or disable the guide and confirm stale labels clear.
   Group/waypoint map pins should stay as before. Demo remains compass-only and
   excludes all real route/guide markers.

Automatic RXP following may replace a manually chosen member route on a later
step. Disable Follow RestedXP guides when keeping a manual member/waypoint route.

## Important scope

The stock SPF API exposes no destination getter or next-bend getter. This build
shows our own accepted requests and future native RXP requests through its public
API, not arbitrary journeys started directly with Alt-click or /path way. No
boat-dock or turn-by-turn point is invented. To follow every bend, use the map
route or SPF's own arrow/compass. Cross-continent final targets cannot provide a
local bearing; native SPF guidance can still lead to the relevant boat dock.
RXP without SPF's Follow RestedXP guides integration is not observed.

## Implementation and verification

New GroupCompass/Destinations.lua watches canonical public RXP requests and title
changes, copies values, validates ownership/numbers/secrets and projects with the
existing waypoint conversion. Routing.lua exposes only our cached accepted target
and validated public provider handle. Core.lua adds the marker after map updates,
copies its input list, merges a selected TomTom marker and excludes navigation
from custom map pins/demo. Version/load order and diagnostics/help updated.

Files changed: those runtime files, GroupCompass.toc, Waypoints.lua/RouteMenu.lua;
new tests/destinations_test.lua, core/classic tests; stock_spf_api fixture and
scripts/check_spf_api.py; structure checker; README, navigation/integration docs,
this closeout, PROJECT_STATUS and designated project-memory files/manifest/archive.
No unrelated source, SavedVariables or provider code changes. New work remains
uncommitted after milestone9cfb3e1 unless Tony requests another commit.

Checks:18 Lua5.1 suites PASS; structure/TOC/XML PASS. Actual installed Forever
v1.22.18 and Hardcore stock API/RestedXP adapter composition PASS, including guide
advance/rename/disable/resume, member replacement/stop and arrow UI restoration.
Actual Forever TomTom registry/API PASS. Unit guards cover malformed/secret input,
combat, provider/world/owner changes and copied data. Core test covers label
rendering, deduplication, map-input isolation, ended labels and demo. Lua frames,
projection and guide UI are doubled; native gameplay/step progression still
requires Tony's check. No tests were weakened; old turn-getter assertion retained.

Remaining: native test of new bar labels and hidden-arrow settings; unmodified
Forever end-to-end acceptance; repeated A/B/A journey check; private HC base still
v1.22.9 and not a full current simulation. No broad provider fixes claimed.

## Installed artifact and final review

GroupCompass0.11.0 ZIP built and all31 runtime/art files verified against source
and both installed targets:
C:/Program Files (x86)/World of Warcraft/_classic_era_/Interface/AddOns/GroupCompass
and _forever_/Interface/AddOns/GroupCompass. Existing targets had no unexpected
files, so copied the exact clean source set in place; no backup or user data
removal. No third-party addon folders or SavedVariables were written.
Git diff reviewed; diff --check passes. New runtime file is included in TOC and
structure checks; no orphan or superseded runtime module introduced. The module
uses only documented public method signatures plus standard secure post-hooks;
canonical RXP request fields are version-tested against the stock adapter.
Native visibility/step progression remains GC-220. The source package is ready
and installed, but no native success is claimed before Tony tests it.
