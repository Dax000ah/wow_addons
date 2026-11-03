# Menu help 0.11.2 — closeout and quick reference

Right-click the cyan minimap icon to choose navigation targets. Hover a button
for a title and wrapped explanation; targets also explain their snapshot/waypoint
behavior. Other settings/report links are in left-click > Other addons, or
/gcompass options > Other addons. Navigation menu height follows its entries.

| Action | What it does |
| --- | --- |
| Resume RestedXP guide... | Opens native /path controls; choose Guidance > RestedXP guide > Resume guide, the bottom red button. Does not resume automatically. |
| Party members > Name | Routes to a current-location snapshot. Select again after they move. |
| TomTom waypoints > Name | Requests a route to the saved point, without a second map click or retargeting TomTom's independent arrow. |
| Selected Blizzard quest | Routes to Blizzard's selected quest when the client supplies coordinates. Hidden on the tested Hardcore client; this is not a RestedXP error. |
| Recalculate this route | Resubmits our remembered destination. For a member, keeps the old snapshot; reselect them to refresh it. Visible only for our applicable route. |
| Stop this route | Cancels our route only. Does not delete a point, stop a separate guide or hide TomTom's arrow. Automatic following can later start another route. |
| Route report (diagnostics) | Under Options > Other addons. Opens /path report for target, planner, drawing/version details. Does not change routing or send anything automatically. |

Other addons tab also opens native Shortest Path, RestedXP and TomTom settings.
Its buttons have hover help; failed/missing handlers leave the panel open with
an explanation. Keep Follow RestedXP guides ON / Follow TomTom's arrow OFF for
guide navigation, and use Resume after reload to refresh [RXP].

Direct one-click Resume is unavailable in stock Shortest Path's public API and
slash parser. The safe implemented shortcut is explicitly described as a handoff.
No provider modification, private namespace/widget call or new support API was
introduced. API, ownership and provider settings remain untouched.

Files changed for this task (earlier uncommitted0.11.1 work retained separately):

- GroupCompass/RouteMenu.lua — labels, wrapped tooltips, conditional rows and height.
- GroupCompass/Options.lua — third tab, native settings/report handoffs and help.
- GroupCompass/Routing.lua — truthful native Resume-handoff message.
- GroupCompass/GroupCompass.toc — version0.11.2.
- tests/route_menu_test.lua — labels, hiding, help wrapping, sizing and source actions.
- tests/options_test.lua — tab, all links/help, errors, missing addons and reuse.
- tests/classic_test.lua — expected startup version.
- README.md and docs/NAVIGATION_GUIDE.md — usage/reference.
- docs/PROJECT_STATUS.md; docs/project-memory/00_START_HERE.md,01_PRD.md,
  02_DESIGN.md,03_ACTIONS_AND_TODOS.md,04_PROGRESS_AND_DECISIONS.md,
  archive/2026-11-03_COMPLETED.md and drive-manifest.json — requirements/progress.
- docs/MENU_HELP_0.11.2.md — this closeout.

Checks run and limitations:

- python scripts/run_tests.py: PASS18 Lua5.1 suites, including all new behavior.
- python scripts/build_zip.py: PASS structure/TOC/XML/art, no orphan runtime files,
 31-file ZIP integrity and exact source match. Artifact dist/GroupCompass-0.11.2.zip.
- python scripts/check_spf_api.py against unmodified Forever ShortestPathForever:
 PASS actual stock API/RXP adapter composition. Native client services are doubled.
- git diff --check: PASS. Reviewed changed runtime/callers/tests; old menu settings
 actions removed, no duplicate new settings UI or private Resume workaround.
- Installed only the two exact GroupCompass folders (Hardcore/Forever);31 source
 hashes match each. No backup, SavedVariables or third-party writes. All4,756
 dependency files still match captured hashes. No commit/push: checkpoint313f893
 is preserved; earlier0.11.1 and new0.11.2 changes remain uncommitted.

Manual checks (GC-222 OPEN): /reload, confirm0.11.2. Right-click and hover each
button; verify smaller menu, no Hardcore Blizzard quest action, and no recalculate/
stop while RestedXP owns the journey. Resume shortcut should open native settings;
finish Guidance > Resume guide and verify[RXP]. Choose a TomTom/member destination
and verify own recalculate/stop appear. Recalculate must retain member snapshot;
reselection takes a fresh one. Left-click > Other addons: check each settings link,
report action and hover help. Native tooltip layout/frames and unmodified Forever
end-to-end acceptance still need gameplay verification. GC-221 Elsewhere and
GC-220 guide-step/hidden-arrow checks remain pending.

## 0.11.3 follow-up — launcher click help

Added three wrapped hover lines to GroupCompassMinimapButton: Left-click opens
options (compass/map/other addons); Right-click opens navigation choices (guide
controls/members/TomTom); Left-drag moves the icon. No action behavior changes.

Native Resume guide calculates/displays the planned route to RXP's current
navigation destination, which may be an NPC, objective or travel step. It does
not restart the guide or alter quest progress. The GC menu shortcut only opens
the provider controls; choose Guidance > Resume guide. Direct one-click Resume
is unavailable through stock API/CLI. The0.11.4 follow-up below renames the shortcut to describe its controls handoff;
no automatic-resume claim or provider modification is made.

Changed this follow-up: GroupCompass/Options.lua, GroupCompass/GroupCompass.toc,
tests/classic_test.lua, README.md (loaded version), docs/NAVIGATION_GUIDE.md,
docs/PROJECT_STATUS.md, docs/project-memory/00_START_HERE.md,
03_ACTIONS_AND_TODOS.md,04_PROGRESS_AND_DECISIONS.md,drive-manifest.json and this
closeout supplement. Earlier0.11.1/0.11.2 changes were retained. No new tests were
written for this low-impact tooltip copy; existing dispatch/hover tests were run.

Checks: python scripts/run_tests.py PASS all18 suites; python scripts/build_zip.py
PASS structure,31-file ZIP integrity/source bytes; focused Lua Options composition
check PASS three separate wrapped launcher rows and close-on-leave. Both exact GC
install folders match all31 source hashes.4,756 dependency files unchanged. No
backup/SavedVariables/provider writes. git diff --check PASS. Native tooltip layout
remains unverified: /reload, hover cyan icon and check the three lines.0.11.3 is
installed; dist/GroupCompass-0.11.3.zip built. No new commit/push after313f893.

## 0.11.4 final clarification — guide-controls label

Renamed the navigation item to RestedXP guide controls...; adjusted route menu test
expectations and version/load notice (TOC,classic test,README). Updated index,
status,actions,progress,navigation guide,manifest and this supplement. Earlier work
remains unchanged/uncommitted.31-file0.11.4 ZIP and both installed GC copies match;
all18 suites, structure/build and diff checks pass;4,756 dependency hashes unchanged.
No provider or SavedVariables writes/backups. Native layout still unverified.

User asks for a direct button click/API call instead of digging through settings.
Reviewed the current stock API, slash parser, Resume initializer and tracker menu:
Resume is an internal namespace function; the settings initializer uses an anonymous
callback and supplies no stable named button or /click target. No supported direct
action exists. GC-223 remains an upstream API limitation; do not scrape callbacks,
widgets or private namespaces, or inject a provider support method. Existing native
shortcut: right-click Shortest Path journey tracker heading > Resume RestedXP guide.
This native action plans the golden route to the current guide navigation target;
it does not restart guide or quest progress. Our controls shortcut does not resume.

Manual check: /reload, confirm0.11.4; hover the cyan minimap icon for left-click,
right-click and left-drag help; right-click it and verify RestedXP guide controls...
label and hover explanation. Direct one-click GC Resume remains unavailable.

## Approved checkpoint — November3

Tony approved the current0.11.4 visuals/work and requested check-in of Elsewhere
and the associated menu/help changes. Included in milestone 'Milestone: Elsewhere
indicators and navigation help'. Earlier uncommitted-state notes are historical.
Re-ran all18 suites, structure, stock SPF API/RXP and both audited TomTom registry
checks: PASS. Diff check PASS. No new runtime/install changes or push. Full native
Forever acceptance and detailed manual checks remain open; direct GC Resume still
requires upstream public support. Inspect git log for this checkpoint's hash.
