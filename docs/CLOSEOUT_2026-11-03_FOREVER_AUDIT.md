# Forever audit and routing checkpoint — November 3, 2026

Completed: reaffirmed Forever as the primary release target, checked24 installed
addon folders, tested GC against unmodified current provider APIs, and added a
repeatable real API/engine switching regression. No runtime/provider edits or
installation. GC0.10.2 remains installed only on Hardcore; no Git mutations.
The menu-versus-map-click issue remains OPEN pending a working-click capture.

## Confirmed evidence and limits

Forever has SPFv1.22.18, TomTomv4.3.13, OpenMapv0.7.5-beta/API4, RXPv4.11.29,
Questie12.4.0. Private hc-test.9 still has a v1.22.9 base:24 upstream files differ,
2 are new. It was not upgraded in this task and is not a complete current
simulation. Core/API.lua still matches. GC only calls supported API methods;
no private module/API dependency exists. The30-file0.10.2 ZIP matches source.

Tony's direct long route visibly passed Hardcore on both maps:9 measured points,
14mini/8world strokes,103s, ownerplayer. Later GC-owned request settled2rounds
with no plan/geometry/guidance. Read saved capture as text only: playerworld1
(10335.7001953125,820.7000122070312), goal(10742.2080078125,579.92578125).
TomTom UID is map1414(0.4480097267300475,0.08387378695540161), not the report's
rounded map1438 location. The new fixture preserves the actual UID and exact
saved world answer, doubles native projection/driver/time, and runs real API,
GC Routing, Nav, Planner, Search, Walks. Five alternating selections on each
unmodified provider reproduce no plan for the saved target and successful
measured paths again for the valid control. Initial valid geometry can have11
points, later9; every valid case passes. Native2settle-round count is not claimed
reproduced by the one-round fixture.

Tony subsequently says Alt+left-click works where GC does not. The working click
may have different exact coordinates or reveal a missing driver/UI condition;
no cause is assumed. Requested working /path report then /reload for comparison.
The file still held the failed target at last inspection. No native GC menu
success, full Forever pass or universal route fix is claimed.

## Files changed in this task

- GC AGENTS.md; private AGENTS.md: permanent target/compatibility boundary.
- scripts/check_spf_journeys.py and tests/fixtures/stock_spf_journeys.lua: new
  read-only actual API/GC/engine regression, no private compatibility modules.
- docs/research/forever-audit-2026-11-03.json and
  stock-journeys-v1.22.9-2026-11-03.json / stock-journeys-v1.22.18-2026-11-03.json:
  inventory, immutable-source hashes, native reports and replay results.
- README.md, integrations/ShortestPathForever/README.md, docs/TESTING.md,
  docs/CLASSIC_ROUTING_COMPATIBILITY.md, docs/FOREVER_LAUNCH_CHECKLIST.md.
- docs/PROJECT_STATUS.md; project-memory00_START_HERE,01_PRD,02_DESIGN,
  03_ACTIONS_AND_TODOS,04_PROGRESS_AND_DECISIONS,drive-manifest.json and
  archive/2026-11-03_COMPLETED.md. Private README.md/STATUS.md; this closeout.

Pre-existing runtime/uncommitted changes were preserved. No new obsolete runtime
modules or copied engine/terrain code introduced. Historical check_spf_offline.py
still pinsv1.22.4; preserved as historical tooling, not used as current acceptance.

## Checks run

- python scripts/run_tests.py: PASS17 Lua5.1 suites.
- python scripts/check_structure.py: PASS interfaces11509/16001,TOC/XML,art and
  no orphan runtime files.
- python scripts/check_spf_api.py FOREVER_SPF: PASS actual unmodifiedv1.22.18 API.
- python scripts/check_tomtom_offline.py FOREVER_TOMTOM: PASS actualv4.3.13 registry.
- python scripts/check_spf_journeys.py PROVIDER --output RESULT: PASS for actual
  Foreverv1.22.18 and originalv1.22.9. Five GC selections each, owner retained,
  failed target0points/no plan, valid targets recover9/11points. Loaded source
  hashes verified unchanged, including API/Search/Hazards/Walks. Client doubled.
- python -m py_compile scripts/check_spf_journeys.py: PASS.
- Private python tools/verify.py --lua-tools ../wow_addons-checkout/.test-tools
  --consumer-project ../wow_addons-checkout --openmap-addon FOREVER_OPENMAP:
  PASS7 suites and115 original hashes,116 source files/18 existing deltas.
  This uses the patched HC adapter; it does NOT verify stock world-map rendering.
- Existing ZIP integrity and all30 files versus source: PASS; archive preserved.
- All2811 files in Forever SPF/TomTom/OpenMap/RXP tree snapshots unchanged across
  audit. Other addons inventoried only, not gameplay tested.
- git diff --check: PASS, existing CRLF normalization warnings only. git status
  and task diff reviewed. No git state-changing operation.
- An exploratory raw synchronous full-terrain probe was interrupted for excessive
  runtime without a result. One later silent replay attempt was also interrupted;
  final instrumented fixture runs pass on both versions. No native performance
  guarantee; no errors or terrain failures were suppressed. Actual journey-search
  replay above replaced the broad raw probe.

## Tony's next verification and priority

1. Save the WORKING Alt+left-click route: /path report, close, /reload, reply
   working click saved. Compare exact world goal/start/geometry to failed capture
   before changing runtime code. GC-218 remains OPEN.
2. Secondary control: /tway55.9 57.8 GC route test (space after /tway), select via
   GC cyan right-click > TomTom waypoints. Stay still15s and check both maps.
3. Install only GC into Forever and complete the launch checklist with stock
   dependencies. The stock SPF OpenMap conversion remains a separately identified
   concern; private success cannot bypass native acceptance. No third-party patch.
4. If Hardcore work continues, separately rebase/re-audit its private baseline.
   Do not introduce a GC dependency on that work or claim it already happened.

## Follow-up: working capture, cyan route, native exact-point failure

## November 3 — same saved point also fails without GC; cyan means boat

Read working capture as text: rev584, map1457(Darnassus),12 measured/drawn walk
points,13mini/16world strokes. Playerworld1(9948.900390625,2091.60009765625),
goal(10082.162109375,2041.90234375). Both start and goal differ from failed GC
TomTom case; goals are about1604yd apart. Snapshot has no owner field.
Tony confirms member selection through GC menu works. Screenshot's cyan curve
is stock SPF's boat-leg color, not member class color; GC sends coordinates/name
only. Gold walking, green flight. No color, runtime or installed-addon edits.

Exact-point control: Tony ran `/path way #1414 44.800972673 8.387378696 Exact
saved point` (the stored TomTom UID, bypassing GC) and confirms NO route appears.
This case is therefore not menu-specific: the provider cannot currently plan
to that saved destination. Combined with stock-engine replay, do not patch GC
or a provider to hide the refusal. This is not proof of physical inaccessibility
or the precise terrain defect. Suggest a fresh uniquely named TomTom point on
a known road where map-click navigation works, then select it in GC's menu.
No user waypoint was deleted or changed. GC-218's exact saved-point case is
explained; general native repeated TomTom selections and unmodified Forever
acceptance remain open. Evidence: working-click-comparison-2026-11-03.json.

Checks this follow-up: git status inspected; text-only scalar extraction and differing-start/goal assertions PASS; provider color table and GC Navigate arguments inspected. No new implementation, so no additional runtime suite rerun. Files changed: six status/design/action/progress mirrors above, working-click-comparison JSON, this closeout, launch checklist and drive-manifest.json. Prior runtime work preserved. General TomTom native repeatability and Forever acceptance remain open.

## Acceptance follow-up: fresh TomTom selection passed

## November 3 — fresh TomTom point through GC menu PASSED

Tony confirms the suggested fresh road waypoint works when selected through GC.
Record HC-013 / GC-035 as a native single-waypoint selection pass. No new report,
coordinates or stroke counts supplied; do not invent them. Member selection was
also user-confirmed working earlier. The old saved point fails via the native
provider command too, so that specific case is not a GC menu handoff defect.
No runtime/provider/install changes were needed. General repeated A/B/A routes,
precise cause of the old point's refusal, and unmodified Forever acceptance are
separate remaining checks. GC0.10.2 is still not installed in Forever. No new
runtime tests run for this documentation-only acceptance update.

Files changed this follow-up: five active/status mirrors listed above, completed archive, launch checklist, comparison evidence JSON, drive manifest and this closeout. Git status inspected and diff --check run; no runtime changes or new runtime test execution. Previous implementation edits preserved. Next priority: install only GC in Forever and perform the stock-addon launch checklist; repeat A/B/A as a separate check.
