# Upstream integration contract

November3 audit: this contract passes against the actual unmodified Forever
v1.22.18 Core/API.lua. The real engine/API/GC replay switches reachable point →
captured failed point → reachable point twice without any private provider
module. The captured destination settles without a plan; the reachable point
recovers. See docs/FOREVER_LAUNCH_CHECKLIST.md and scripts/check_spf_journeys.py.
This is an offline contract/engine pass, not native Forever rendering acceptance.

Group Compass uses the unmodified ShortestPathForever.API v1: Navigate,
CurrentStop, Active, Cancel, and optional Ended. Settings/report open through
its existing /path slash handler. API source and terrain remain in that addon.

Official contract: https://github.com/cjber/shortest-path-forever/blob/main/docs/api.md

No provider extension is required or shipped. The former GetGuidance prototype
and private source-selection extension were removed on 2026-10-30 at Tony's
explicit direction. Never inject functions, change its DB, or scrape private
frames/namespaces. A next-turn marker cannot be supported through today's API;
use Shortest Path's native arrow/compass. Group Compass still shows destination
waypoints and party bearings independently.

TomTom/party targets use Navigate with owner GroupCompass. Members are location
snapshots. Stop cancels only that owner. Retry resubmits our current destination.
RestedXP uses Shortest Path > Guidance > Follow RestedXP guides > Resume guide;
we open settings and explain these steps. Follow TomTom's arrow remains a native
provider option. Automatic followers may select later guide targets as configured.

Offline API composition: python scripts/check_spf_api.py PROVIDER_DIRECTORY
The harness loads that directory's Core/API.lua unchanged. Journey execution and
client services are doubled; in-game rendering/movement are separate checks.

##0.11.0 public request observer

Destinations.lua observes the existing API.NavigateRoute/ RenameStop methods
through WoW's hooksecurefunc, specifically the stock RXP adapter's canonical
RestedXP single-stop/hold request. It copies scalar map fractions/title and checks
CurrentStop ownership. It does not replace methods, inject an extension, read
private provider/RXP frames or write provider settings. Actual Core/RestedXP.lua
and API.lua composition is included in check_spf_api.py for both installed
Foreverv1.22.18 and the private test's unchanged stock adapter/API.
Our own accepted destination is held in GC Routing; no provider getter needed.

This is destination-only. API input observation cannot recover a journey that
started before our hook, native map-click routes or private next bends. After
reload, Resume guide or advance a guide step to send a fresh RXP request. Guide
following must be enabled in the provider. No standalone RXP frame reader is used.
