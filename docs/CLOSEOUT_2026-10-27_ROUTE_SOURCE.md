# Route-source clarity 0.9.3 — October 27

## Completed, with evidence limits

Tony's screenshot shows zero TomTom points and Another journey is active. In the
consumer, this means Shortest Path reports active guidance without GroupCompass
ownership. Its live owner is unconfirmed. RestedXP is likely: provider source
defaults guide-following on and routes guide elements independently of TomTom.
The existing owned-waypoint deletion regression passes. No stale owned route
was reproduced, and no provider preference or foreign journey was changed.

0.9.3 asks the existing public CurrentStop API about RestedXP/TomTom. Known
owners receive specific status/help; unknown owners get an honest generic
explanation. Waypoints & help now has Route settings, opening the provider's
native /path surface with visible errors if unavailable. Existing cancellation
and ownership protections remain. Three changed runtime files installed;
all 29 installed file names/counts/SHA-256 values match source. No backups.

## Files changed in this task

- GroupCompass/Routing.lua — known-owner explanation and native settings entry.
- GroupCompass/WaypointUI.lua — Route settings button.
- GroupCompass/GroupCompass.toc — 0.9.3.
- tests/routing_test.lua — empty-list RestedXP/TomTom/unknown cases, ownership
  protections, settings entry/failures; existing deletion cancellation retained.
- tests/waypoint_ui_test.lua — settings button entry and successful close.
- tests/classic_test.lua — current startup version.
- README.md, docs/TESTING.md, docs/PROJECT_STATUS.md.
- docs/project-memory/00_START_HERE.md, 03_ACTIONS_AND_TODOS.md,
  04_PROGRESS_AND_DECISIONS.md, archive/2026-10-27_COMPLETED.md,
  drive-manifest.json.
- docs/CLOSEOUT_2026-10-27_ROUTE_SOURCE.md — this report.
- dist/GroupCompass-0.9.3.zip — ignored generated package.

Earlier uncommitted work was preserved. No private-provider runtime, other addon,
original Forever, SavedVariables, dependency, Git state or publication change.
No new duplicate/orphan runtime module.

## Checks run

- PASS: focused Lua 5.1 tests/routing_test.lua via project-local lupa — owned
  deletion, foreign preservation, source queries, commands and errors.
- PASS: `python scripts/run_tests.py` — all 17 suites, including UI entry,
  settings, compass, maps, waypoints and existing route lifecycle.
- PASS: `python scripts/build_zip.py` — structure/TOC/XML/art inventory,
  no orphan runtime files, ZIP integrity and exact packaged source bytes.
- PASS: `python scripts/check_tomtom_offline.py "C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\TomTom"`
  — actual installed registry/API composition, doubled UI.
- PASS in private sibling:
  `python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools --consumer-project ../wow_addons-checkout`
  — five suites and actual provider API/consumer composition; originals unchanged.
- PASS: PowerShell complete install count/SHA-256 comparison — 29 matches.
- PASS: `git diff --check`, current runtime/test diff and status review.

No native-game source probe was run. Source identification/settings appearance
and clearing the route are not confirmed; all automated UI services are doubles.

## Tony's next steps

1. `/reload`, cyan button > Waypoints & help; read the new route source status.
2. If it says RestedXP and you want only manual waypoint routes, click Route
   settings and uncheck Follow RestedXP guides. Verify that guide path clears.
   This changes Shortest Path's following preference, not guide progress.
3. Add a TomTom point, Navigate, delete it; our route should clear. Another
   owner's route stays protected. GC-215 remains open for native acceptance.
4. If the source is unknown or the line persists after disabling the identified
   integration, provide the new status; further diagnosis is required.

Implementation archived as GC-027; actual live owner and native clearing remain
open. Prior provider movement/transport/Forever gates are unaffected.
