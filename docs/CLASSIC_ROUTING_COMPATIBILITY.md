# Classic routing compatibility and API bridge — 2026-10-26

## Confirmed native probe

Tony's screenshot prints SPF: function function nil nil, in the exact command order:

| Function checked | Result |
| --- | --- |
| canaccessvalue | function exists |
| C_EncodingUtil.DecompressString | function exists |
| C_Map.GetUserWaypoint | unavailable |
| C_SuperTrack.GetHighestPrioritySuperTrackingType | unavailable |

Evidence is preserved at docs/research/classic-routing-probe-2026-10-26.png and
its JSON sidecar. The probe does not prove all encoding works, that either entire
namespace is absent, or that other APIs are available. No more chat commands are
needed for this initial finding. Current exact client build was not re-queried.

Installed SPF v1.22.4 calls GetUserWaypoint in Journey/JourneyGuide.lua's ownership,
start and restore paths, and calls GetHighestPrioritySuperTrackingType in
RememberTracking/SameTracking. These are unguarded calls. UI/Arrow.lua also uses
C_Navigation.GetFrame. The installed provider cannot use its current guidance path
unchanged on this client. Missing native tracking APIs are presentation/ownership
integration gaps, not evidence its terrain search is impossible.

## Implemented now: Group Compass 0.8.0

GroupCompass/Routing.lua optionally discovers public SPF API v1. It sends the
selected saved uiMapID, normalized x/y and case-preserved name through Navigate.
It uses CurrentStop/Active/Ended and owner-scoped Cancel, with explicit replacement
of an active foreign journey. No provider means a readable unavailable state;
party/member and saved-waypoint features continue. External API failures remain
visible in status instead of silently clearing the error.

The saved-waypoint window now has Navigate, a second-click Replace action, a
routing status and Stop route (disabled without an owned route). Commands:
/gcompass route ID, route replace ID, route stop, route status. Adding a waypoint
does not automatically start navigation. Starting an accepted route exits demo and
enables the display. Off/demo and removing a routed point cancel only our route.
Provider refusal to cancel remains visible and preserves access to Stop route.
Saved points/appearance are preserved; active route selection is session-only.

With only the existing public API, SPF provides the two map routes and our status
explains that next-turn output is unavailable. With the proposed GetGuidance API,
the top bar consumes its version-1 copied world-space target as a cyan [Route]
Next step, using existing angle/distance math and the same horizontal baseline.
That distance is to the next point, not total route length. It omits targets in a
different world or with unavailable/secret data. The turn is bar-only: our map
renderer does not duplicate SPF's route/turn markers or mutate party samples.
Combat suppresses the route-turn marker while members/ordinary waypoints stay live.

The original proposed provider-side extension remains in integrations/ShortestPathForever.
It is not installed or an adopted upstream API. No SPF file or native global API
was changed/faked. The consumer and extension were composed in regression tests
with C_Map and C_SuperTrack absent. This proves their contract in a test double,
not that the whole SPF addon runs on Classic.

## Verification and install

Focused routing/core tests PASS. python scripts/run_tests.py PASS all 16 Lua 5.1
suites; this includes ownership/replacement/cancel, removed waypoints, provider
errors/rejection/missing/version/late loading, combat resume, remote/secret target
clearing, real getter/consumer composition, shared bar and UI controls. Existing
15 suites pass. python scripts/build_zip.py PASS, structure/order/XML/artwork and
archive integrity/paths/source bytes. git diff --check PASS. Final diff and source
review completed. No dependencies or Git mutations.

Clean-installed only the authorized Classic GroupCompass folder: 28 runtime/art
files match source by SHA-256, no backup. Package: dist/GroupCompass-0.8.0.zip.
WTF saved data and other addons are untouched. No native 0.8.0 UI or provider route
execution was observed; these remain open tests.

## What Tony can test now

Fully restart WoW, then /gcompass waypoints. Save Camp if the list is empty. The
list should include Navigate and Stop route; with no compatible SPF provider it
must say routing requires that provider, without breaking the list or map/compass
waypoints. /gcompass route status reports the same state. Test Remove, saved reload,
options and existing movement demo normally. No golden route or real next-turn
tracking is promised on the current Hardcore installation.

A Classic test provider remains additional work. It should implement provider-local
non-native guidance ownership and custom rendering, plus audit the remaining
encoding/minimap/quest/spell/item/taxi/UI calls and data coverage. Do not install
fake global C_Map/C_SuperTrack functions that make the addon think native tracking
succeeded. Standard Era uses the same client family, so a different ruleset alone
does not provide these missing methods. Prefer a limited test adapter over a full
second-client UI fork if the remaining compatibility work is proportionate.

Next gates: GC-209 for the installed window/commands and fallback; GC-105 for a
supported provider guidance getter/build and actual next-turn output; GC-106 for
native Classic provider compatibility; GC-210 for full provider routing in Forever.
No engine duplication or full Classic port is claimed. Offline real terrain and
estimated intercontinental evidence remains recorded separately in ROUTING_TEST_RESULTS.md.
