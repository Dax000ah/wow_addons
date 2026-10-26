# Group Compass project checkpoints

Date: 2026-10-26.

## Latest checkpoint: local check-in of 0.9.0, 2026-10-26

Tony reports that things look good and explicitly authorized this local check-in.
Includes all accumulated addon, original artwork, regression tests, routing API
research/prototype and project notes since 02e0bbe. Generated ZIPs/logs and local
.test-tools remain ignored. No runtime behavior or installed file changed in this
check-in task. Only this checkpoint, progress note and feedback item were edited.

Checks repeated: python scripts/run_tests.py PASS all 17 Lua 5.1 suites;
python scripts/check_structure.py PASS; git diff --check PASS. Inspected current
status, tracked diff and every untracked candidate; no credential-pattern matches
in source/test/docs/scripts/integrations. Git staging review/check precedes commit.
Use git log for the resulting commit ID. This request authorizes a local commit;
no remote push was requested. The detailed file list and implementation checks
remain in the previous checkpoint below.

Tony's feedback is broad, not a claim that every native acceptance scenario ran.
GC-212 remains open for the detailed in-game matrix; SPF Hardcore compatibility
and actual next-turn/golden routes remain separate GC-105/106/210. Next priority:
record specific native checks as they are completed, then continue routing work.

## Previous checkpoint: TomTom shared waypoints and options help 0.9.0, 2026-10-26

Completed: switched live waypoint creation/storage/map pins to TomTom, and reads
its existing/native-created points for our shared compass. No duplicate map pins.
New points enable live display and leave demo; nearest 20 locatable points enter
the bar, filtered to the forward half. Group tracking/appearance stays independent.

Menus: cyan launcher > Waypoints & help shows the configured map modifier (default
Alt + right-click), numbered creation steps, automatic bar sync and character-facing
visibility note. Both main and waypoint menus link to native TomTom settings.
The retained Edit window supplies name and ten texture choices missing from its
context menu. Save/Enter commits, Cancel/X/Escape discards. Keep current preserves
native theme/custom texture/portrait. TomTom handles its own themes, map sizes and
profile persistence; group-member glow/flash/class colors do not style its points.

Removed independent waypoint live CRUD, Alt-left-click handler, custom waypoint
map projection/renderer, map-pin Edit handlers and dead style branches. Legacy
GroupCompassWaypointsDB records are retained unchanged for once-only confirmed
API import, not a second live store. Imported deletions are not resurrected. Without
TomTom, group tracking works and waypoint help says enable/restart; no new fallback.

Bridge details: optional dependency and capability guards; exposed waypoints/UID
layout read for enumeration (a provider coupling, not a dedicated list API). No
private frame/profile-key mutation. API Add/Remove owns registry changes. Since
titles form TomTom's keys and no Rename method exists, rename adds/validates first,
rejects existing UID/key collisions and removes original last. Same-name icon edits
refresh the same UID via ClearWaypoint/SetWaypoint and restore options on failure.
Callbacks/persistence/unknown fields and reload arrow option are preserved. A public
SetCrazyArrow post-hook tracks known arrow references; if an existing active arrow
is unknown, rename explicitly asks to clear it first. Other-addon-owned points are
read-only here. Session IDs can change on TomTom reload/profile changes; routes
remain session-only. No copies of TomTom code/artwork were redistributed or edited.

Files created this task:

- GroupCompass/TomTomBridge.lua; tests/tomtom_test.lua;
  scripts/check_tomtom_offline.py;
  docs/research/tomtom-integration-2026-10-26.json; generated dist/GroupCompass-0.9.0.zip.

Files modified this task (earlier uncommitted work preserved):

- GroupCompass/Waypoints.lua, WaypointUI.lua, Core.lua, Maps.lua, Routing.lua,
  Options.lua, MarkerStyle.lua and GroupCompass.toc.
- tests/waypoints_test.lua, waypoint_ui_test.lua, maps_test.lua, options_test.lua,
  style_test.lua, core_test.lua and classic_test.lua; scripts/check_structure.py.
- README.md, docs/TESTING.md, docs/PROJECT_STATUS.md.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-26_COMPLETED.md and drive-manifest.json.

Checks run:

- python scripts/run_tests.py: PASS all 17 Lua 5.1 suites. Covers configured help,
  settings links, external addition detection, real facade/editor interactions,
  names/UTF-8, shared CRUD, cancellation, icons/portrait preservation, collisions,
  failed add/icon restoration, foreign ownership, arrow references, nearest cap,
  unavailable/secret data, migration/removal/no-resurrection and unchanged groups.
- python scripts/check_tomtom_offline.py with the installed Classic TomTom path:
  PASS, actual TomTom.lua Add/Remove/registry/persistence methods; UI pins doubled.
  The version guard initially caught an external v4.3.12-to-v4.3.13 update. Re-audit
  found identical TomTom.lua hash and the same dependent icon/settings contracts;
  final v4.3.13 composition passes. Not a native renderer/HBD/map-click/gameplay test.
- python scripts/build_zip.py: PASS structure, Classic/Forever TOC order, XML,
  artwork, no orphan runtime files and ZIP integrity/entries/source bytes.
- git diff --check: PASS. Reviewed task changes against start-of-task contents and
  tracked diff; searched callers for deleted HookMap/MapMembers/pin Edit paths.
  No competing waypoint subsystem remains. Existing unrelated work left intact.
- Authorized exact-target clean install: PASS version 0.9.0, all 29 installed files
  match source SHA-256. No backup; TomTom, other addons and WTF untouched. No Git
  stage/commit/push. Provider fingerprint evidence is in docs/research JSON.

Tony's native check (GC-212): fully restart, confirm /gcompass status 0.9.0, then
cyan button > Waypoints & help. Press M and Alt + right-click a zone-map spot (or
the displayed configured shortcut). Face the point with the character; it should
appear automatically in our list/bar. Edit its name/icon, Cancel a draft, open
TomTom settings, reload and remove. Check migration and no duplicate pins. Other
worlds/behind/over nearest-20 cap omit bearings. Detailed steps: docs/TESTING.md.

Remaining: native WoW layout/click/focus/HBD/bar/persistence/migration acceptance
is unverified. GC-108 implementation archived as GC-019; GC-208/211 superseded by
GC-212 rather than claimed passed. Next priority is that gameplay check, fixing
any observed issue, then the separately pending SPF Hardcore compatibility and
supported next-turn contract (GC-105/106/210). No live golden route was enabled.

## Previous checkpoint: waypoint editor 0.8.1, 2026-10-26

Completed: name and ten-icon editing for personal waypoints. Alt-click map creation
opens the editor; later left-click either map icon or use Waypoints > Edit. Save/
Enter commits, Cancel/X/Escape discards edits. New points remain saved as default
pins when cancelled. Names update both map tooltips and bar; shapes update both maps.
ID/location/unknown fields and character storage are preserved. Invalid stored
icons fall back; invalid updates reject without mutation. No route restart or new
provider capability. Existing member styles/sizes/effects remain usable.

Root cause: map creation supplied no name input, the list had no edit action and
Waypoints.marker hardcoded pin. Reused shared sanitation and existing icon catalog;
added one editor to WaypointUI and public Find/Icon/Update helpers. MapCanvas uses
its native OnClick callback; minimap waypoint markers accept inside left-release,
party markers pass clicks through. Full native behavior remains a manual gate.

Files changed this task (prior 0.6.x–0.8.0 work preserved):

- GroupCompass/Waypoints.lua, WaypointUI.lua, Maps.lua, GroupCompass.toc.
- tests/waypoints_test.lua, waypoint_ui_test.lua, maps_test.lua, classic_test.lua.
- README.md, docs/TESTING.md, docs/PROJECT_STATUS.md.
- docs/project-memory/00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md,
  archive/2026-10-26_COMPLETED.md and drive-manifest.json.
- Generated dist/GroupCompass-0.8.1.zip; no runtime modules/assets/dependencies added.

Checks actually run:

- Focused Lua 5.1 execution via project-local lupa for waypoint, editor and map
  suites: PASS. Real editor/storage and lazy map-first composition, all ten tiles,
  Save/Cancel/Enter/Escape, draft isolation, deletion, reload, UTF-8, empty names,
  edit at capacity, legacy/bad icon fallback, invalid choice rejection, map events
  and party-marker reuse/pass-through are covered.
- python scripts/run_tests.py: PASS all 16 Lua 5.1 suites. Final added lazy-entry
  case also passed its focused suite. WoW frame/map/API behavior is simulated.
- python scripts/build_zip.py: PASS structure/TOC/XML/artwork and ZIP integrity,
  entries and byte-for-byte source match.
- git diff --check: PASS; reviewed task-specific source/test diff against starting
  contents, final tracked diff and affected callers. No duplicate editor or orphan.
- Exact-target PowerShell clean install: PASS, version 0.8.1 and all 28 files
  SHA-256 match source. No backup; other addons and WTF untouched. No Git mutation.

Tony's verification: /reload then /gcompass status (0.8.1; restart if metadata is
stale). Press M, open zone, Alt-left-click; name Camp, choose Star, Save. Reopen from
world pin/minimap/list Edit, try Cancel/Enter/Escape, then reload for persistence.
Check readable palette/layout/focus and unchanged ordinary map/group behavior.
Detailed steps: docs/TESTING.md. Native gate GC-211 is open; implementation GC-107
is recorded in completed archive GC-018. No native 0.8.1 gameplay claim.

Remaining/next: Tony's native editor test first; resolve any observed errors, then
resume provider-local Hardcore routing compatibility GC-105/106/210. Golden routes
and next-turn navigation remain unavailable in the current Hardcore provider setup.

## Previous checkpoint: native probe and optional routing bridge 0.8.0, 2026-10-26

Confirmed screenshot output: SPF: function function nil nil. canaccessvalue and
C_EncodingUtil.DecompressString exist; C_Map.GetUserWaypoint and
C_SuperTrack.GetHighestPrioritySuperTrackingType are unavailable. This does not
establish namespace absence, decode success, remaining API availability or client
build. SPF v1.22.4 still has unguarded uses in JourneyGuide.lua; unchanged native
guidance cannot run here. No further chat probe needed for this initial finding.

Implemented GroupCompass/Routing.lua, optional public API v1 discovery and saved
point Navigate/Replace/Stop/status. New same-baseline cyan next step consumes only
the proposed GetGuidance result; validates version, world space and readable finite
data. Clear on combat/lost ownership/inactive/missing data. Keep route-turn points
out of party/map samplers. Missing provider/getter and external errors remain visible.
Off/demo/removal stop only our owned route; cancellation refusal remains visible.
Route selection is session-only. New optional TOC dependency; no new library/data.

Created GroupCompass/Routing.lua, tests/routing_test.lua,
docs/CLASSIC_ROUTING_COMPATIBILITY.md, docs/research/classic-routing-probe-2026-10-26.png
(copy of Tony's supplied image), its JSON sidecar, and
 docs/project-memory/archive/2026-10-26_COMPLETED.md. Modified Core.lua, WaypointUI.lua,
GroupCompass.toc; tests/classic_test.lua, core_test.lua, waypoint_ui_test.lua;
scripts/check_structure.py; README.md, docs/TESTING.md, ROUTING_FEASIBILITY.md,
ROUTING_TEST_RESULTS.md, integrations/ShortestPathForever/README.md, this file,
five active memory Markdown files and drive-manifest.json. Built dist/GroupCompass-0.8.0.zip.
Prior 0.6.x/0.7.0 uncommitted changes preserved; no staging/commit/push. No SPF edit.

Verification: focused routing/core checks PASS; python scripts/run_tests.py PASS
all 16 Lua 5.1 suites. Actual consumer + proposed getter composition passes with
C_Map/C_SuperTrack absent, alongside missing/version/late provider, normalized named
input, explicit replacement, cancellation refusal, removed point, foreign ownership,
provider errors/rejection, combat resume, remote/secret clearing and window controls.
python scripts/build_zip.py PASS, structure/TOC/XML/artwork + ZIP integrity/paths/source
bytes. git diff --check PASS. Reviewed final tracked diff and new Routing module.
No duplicate pathfinder, fake native globals or orphan runtime module introduced.

Final clean replacement of only the exact authorized Classic GroupCompass directory
passed all 28 file SHA-256 matches; no backup. Other addons and WTF untouched. An
initial preflight ZIP was preserved locally before final removed-route status cleanup;
only final 0.8.0 is installed/current package. No further runtime edit after final install.

Manual GC-209: fully restart, /gcompass waypoints, check Navigate/Replace/Stop/status
and safe missing-provider behavior; /gcompass route status gives same status. Existing
saved pins, demo, class colors and maps must remain usable. No live golden route or
native next-step test is available in current unported Hardcore. Provider GetGuidance
remains an uninstalled/unadopted draft; full Classic port and native provider navigation
are open GC-105/106/210. No live 0.8.0 UI/provider validation was claimed.

Next: native controls/fallback review, provider-local non-native guidance adaptation
and remaining Classic API/data audit, supported getter/build, then full Forever route
and transport/cross-continent acceptance. Detailed evidence: docs/CLASSIC_ROUTING_COMPATIBILITY.md.

## Previous checkpoint: guidance prototype and testing, 2026-10-24; installed 0.7.0

Tony selected reuse of the optional SPF public API and accepts combat deferrals
for waypoint routing. Existing no-auto-pause party/member behavior stays unchanged.
Prepared an additive provider-side GetGuidance(owner) prototype returning copied
current/next-turn, step-end and destination world coordinates. It declines foreign
ownership, combat, corpse-run borrowing, inactive and invalid targets. No private
frames/hooks or duplicate pathfinder. Not installed or accepted upstream; public
route controls and our top-bar consumer remain open as GC-104/105.

New files: integrations/ShortestPathForever/GuidanceAPI.lua and README.md,
tests/guidance_api_test.lua, scripts/check_spf_offline.py,
docs/ROUTING_TEST_RESULTS.md and docs/research/spf-offline-results-2026-10-24.json.
Created generated dist/GroupCompass-Routing-Research-2026-10-24.zip; seven entries
passed integrity and source-byte checks. This is a research artifact, not a release.
Modified docs/ROUTING_FEASIBILITY.md, this checkpoint, five active memory Markdown
files, archive/2026-10-24_COMPLETED.md and drive-manifest.json. Prior source/tests/
artwork worktree changes preserved. No installed-addon edits, third-party source
copy, dependency, stage, commit or push; source/package/installed addon remains 0.7.0.

Checks: focused guidance test via project-local lupa.lua51 PASS; then
python scripts/run_tests.py PASS all 15 Lua 5.1 suites (14 existing plus prototype).
python scripts/check_structure.py PASS. git diff --check PASS. Reviewed new source,
contract tests, runtime exclusion, fingerprints and changed documentation. No new
runtime file or obsolete implementation was introduced. No release rebuild/install
needed because the provider prototype is outside GroupCompass.toc and package.

Real-engine command: python scripts/check_spf_offline.py <installed SPF directory>
PASS, with actual installed v1.22.4 terrain and search modules loaded read-only.
Shadowglen/Dolanaar-area: 9 points, searched cost 720.98 yd; Coldridge/Kharanos-area:
23 points, 1198.37 yd; Goldshire/Stormwind: 17 points, 1073.48 yd. Missing terrain
returned nodata. Real transport planner produced a 5-leg intercontinental boat
plan; endpoint walking legs estimated, no known flight paths or live boat clocks.
Raw output/source hashes saved. This does not prove native path safety, timing,
UI, API.Navigate or client compatibility. Development runtime reuses existing
Lupa plus Python standard base64/zlib; these adapters cannot run inside WoW.

Blizzard confirms beta closed October 23, name creation October 27, world launch
November 4. No public Forever gameplay test realm was established. Recommend
offline engine coverage plus existing Classic UI checks now. Full provider port
is plausible but unproven: encoding, native waypoint/supertracking/navigation and
other client APIs require live inventory before scope is known. A four-API
read-only WoW chat probe was requested asynchronously; output is still pending.
No quick-port claim or promise that another WoW version proves Forever is made.

Next: implement owner-scoped Navigate/Stop adapter, establish/load the supported
getter and bar consumer, use the pending probe to bound any Classic test adapter,
then execute local/cross-continent and combat-resume acceptance in native Forever.
Completed prototype/offline work is GC-016; native/consumer gates remain active.

## Previous checkpoint: routing feasibility, 2026-10-24; installed 0.7.0 unchanged

Completed the requested installed-addon inspection. Found Shortest Path Forever
v1.22.4 in the Forever AddOns folder (interface 16001). It already accepts arbitrary
map destinations and plans local/cross-continent travel. Public API.Navigate can
accept our existing saved point coordinates. Recommended an optional Navigate/Stop
adapter; a complete standalone engine is a separate architecture decision.

Two material limits remain: next-turn coordinates/geometry are not exposed in the
public API, and searches/progress/map refresh defer in combat. Classic Hardcore
compatibility is not established. No runtime feature, third-party source copy,
installed-addon edit, dependency, build/version bump or Git mutation this task.
Existing uncommitted 0.6.x/0.7.0 source/tests/artwork changes were preserved.

Created docs/ROUTING_FEASIBILITY.md and
 docs/project-memory/archive/2026-10-24_COMPLETED.md (GC-015 completed research).
Updated this checkpoint, project-memory 00_START_HERE.md, 01_PRD.md, 02_DESIGN.md,
03_ACTIONS_AND_TODOS.md, 04_PROGRESS_AND_DECISIONS.md, and drive-manifest.json.
GC-104/105/106 track proposed integration, next-target API and combat/client policy.
No completed-implementation claim follows from the completed investigation.

Checks: read-only Python source probe PASS, installed API v1/minor1, Navigate
signature, ten public functions, no exported GuideTargets; 27 navigation Lua files,
11,882,769 bytes. python scripts/check_structure.py PASS. git diff --check PASS.
Final documentation diff reviewed; no new runtime/duplicate implementation created.
No Lua suite rerun or package/install was needed for documentation-only changes;
prior 14-suite release evidence remains historical. Initial git status in the
non-repository parent failed, then succeeded in the active checkout; missing search
paths were corrected using the installed TOC. No unresolved check failure.

Tony's next native check: in Forever, Shift-click a nearby zone-map point (use
/path way instead if another addon intercepts clicks), then a zone-map point on
the other continent, to exercise the existing provider before integration. Record
actual available legs and combat behavior. No exact starter-to-continent itinerary
was executed here. Prioritize the optional adapter after the dependency/continuity
tradeoff is selected, then supported next-target output, then native route coverage.

## Previous checkpoint: personal waypoints, version 0.7.0

Implemented personal waypoints on the world map, minimap and shared horizontal
compass bar. Gold pins and [Wnumber] names distinguish waypoints from members.
Alt-left-click a zone map, save the current location in the Waypoints window, or
use /gcompass waypoint here Camp. /gcompass waypoints opens the list/removal UI;
/gcompass waypoint 45 60 Camp uses percentages in the player's current zone.
Up to 20 points persist per character. Adding a real point exits demo, enables
live views and refreshes immediately; removing points refreshes all views.

Created GroupCompass/Waypoints.lua, GroupCompass/WaypointUI.lua,
tests/waypoints_test.lua and tests/waypoint_ui_test.lua. Modified Core.lua,
Maps.lua, MarkerStyle.lua, Options.lua, GroupCompass.toc, scripts/check_structure.py,
tests/classic_test.lua, core_test.lua, maps_test.lua, style_test.lua and
options_test.lua. Updated README.md, docs/TESTING.md, FEASIBILITY.md, this file,
six core project-memory Markdown files and drive-manifest.json. Built
 dist/GroupCompass-0.7.0.zip. Earlier 0.6.x work remains uncommitted and preserved;
no staging, commits, push, dependencies or unrelated cleanup this task.

Native C_Map conversions supply world-space bearings and cross-map projections;
no guessed positions or cross-continent bearings. Same-map pins use their saved
normalized coordinates during transient conversion failure. Unsupported maps or
unreadable coordinates are rejected or unavailable. Points behind the character
are outside the bar's existing forward-facing view. No waypoint sharing yet.

Checks: python scripts/run_tests.py PASS, all 14 Lua 5.1 suites;
python scripts/check_structure.py PASS (TOC order, XML, assets and runtime orphans);
python scripts/build_zip.py PASS (integrity, paths and source-byte agreement);
git diff --check PASS. Reviewed waypoint modules, affected callers, persistence,
map projection, input hooks, UTF-8 labels, sampler ownership and task diff.
Coverage includes CRUD/reload/character DB, conversion/facing/turn/walk, map input,
missing data, UI, gold pin override, demo recovery and merged-array isolation.
Clean-installed 27 runtime/art files in the exact authorized Classic GroupCompass
directory; all match source by SHA-256. No backup; other addons/WTF untouched.

Manual gate GC-208 remains open: fully restart WoW for new TOC/modules/character
SavedVariables. Save Camp with /gcompass waypoint here Camp, walk away, turn toward
it and inspect both maps plus the top bar. Alt-click a zone map, remove a point,
/reload and verify persistence and character isolation. Check mixed party markers,
combat/instances and unavailable coordinates. Automated Lua stubs do not verify
native client rendering/API behavior. Forever is still unverified. Prioritize
this native smoke test, then the existing appearance and live-party checks.

## Previous checkpoint: colored minimap launcher, version 0.6.1

Tony requested color instead of the white-looking launcher. Previous tint was
pale gold. Options.lua now tints the head-and-shoulders icon saturated cyan
(0.1, 0.8, 1), over dark teal (0.02, 0.16, 0.22), keeping the gold rim.

Changed this task: GroupCompass/Options.lua, GroupCompass/GroupCompass.toc,
tests/classic_test.lua (version fixture), README.md, docs/TESTING.md, this checkpoint,
six core project-memory Markdown files and drive-manifest.json. Built
dist/GroupCompass-0.6.1.zip. All prior 0.6.0 changes/notes were preserved; no new
dependencies, staging, commits or push. No new behavior test mirrors the RGB literals.

Verification: python scripts/run_tests.py PASS, all 12 Lua 5.1 suites;
python scripts/check_structure.py PASS; python scripts/build_zip.py PASS, archive
integrity/paths/source bytes; git diff --check PASS. Reviewed the scoped RGB/version
edits against the already-reviewed options implementation. Final clean install
contains 25 files matching source by SHA-256; no backup. Initial install attempt
was not executed because automatic approval review hit a usage limit. Tony asked
to continue; the normal approved retry succeeded. Native color/contrast review is
still open under GC-207. Run /reload to inspect the launcher.

## Previous checkpoint: marker options and default person, version 0.6.0

Tony selected head & shoulders and requested a minimap-border button opening
simple icon/size/effect/color options. Implemented a one-page 430x490 panel with
live minimap/world-map previews, ten original marker styles, separate 12–40 size
sliders, None/Glow/Slow flash, Class/Party/Gold/Cyan/Pink/White colors, reset, close
and Escape. Defaults are person, minimap 20, world 24, no effect and class colors.
GroupCompassDB saves appearance and draggable border-button angle across reload.
/gcompass, options and config open the panel without enabling a hidden compass.
Map tooltip identity remains available; compass names keep class colors.

Added runtime modules GroupCompass/Settings.lua, MarkerStyle.lua and Options.lua;
twelve original 32-bit TGA assets under GroupCompass/Textures; generator
scripts/build_icons.py; tests/settings_test.lua, style_test.lua, options_test.lua.
Modified Core.lua, GroupCompass.toc, Maps.lua and Projection.lua; size-aware inset
retains large markers. Maps use pooled styles and stop flash on hide/release.
Modified scripts/build_zip.py and check_structure.py, tests/classic_test.lua,
core_test.lua, maps_test.lua and projection_test.lua. Updated README.md,
docs/FEASIBILITY.md, TESTING.md, this checkpoint, six project-memory Markdown files
and drive-manifest.json. Generated dist/GroupCompass-0.6.0.zip. Pre-existing
uncommitted marker-exploration notes in 02_DESIGN.md were preserved and contextualized.
No new dependencies, staging, commits, pushes, or unrelated source cleanup.

Checks: python scripts/run_tests.py PASS, all 12 Lua 5.1 suites. New UI regression
caught first-click menu logic comparing two nils; fixed and retested. Coverage
includes saved reload/reset/invalid settings, menu choices, live previews, independent
sizes/colors, border dragging/hiding, effects without per-tick restart, hide/release
cleanup and larger minimap edge clearance. python scripts/build_icons.py PASS;
python scripts/check_structure.py PASS, texture headers/alpha/paths/TOC/XML/orphans.
python scripts/build_zip.py PASS, runtime/artwork ZIP paths, integrity and source
byte agreement. Texture contact sheet visually inspected via a standard-library
PNG renderer after optional Pillow proved unavailable; no dependency was added.
git diff --check PASS. Tracked diff and untracked modules/tests reviewed directly.

Final installation: clean-replaced only the authorized Classic GroupCompass folder;
25 runtime/artwork files match source by SHA-256; no backup. A preflight ZIP was
retained locally under a distinct name before final drag-hide cleanup was packaged.

Native verification remains GC-207: fully restart WoW for TOC/SavedVariables/TGA,
click the gold person minimap-border button (fallback /gcompass options), check
previews, all controls, actual grouped map markers, saved reload, dragging, Escape,
animation/pin reuse, UI scale and addon skins. Local mocks do not prove native UI
appearance, combat frame behavior or Forever compatibility. No synthetic markers
were placed onto maps. Saved appearance is account-wide; compass layout unchanged.

Memory closeout: native project Doc updated through 21 scoped paragraph groups
with revision guard; readback verified all 193 expected paragraphs, heading styles
and list membership. Six Markdown mirrors, checkpoint and manifest updated in place.
0.6.0 package stored in Work; 0.5.2 moved to Archive with verified parent metadata.

## Previous checkpoint: initial local check-in of 0.5.2

Tony requested "check in our code now" on 2026-10-23. This authorizes staging and
a local commit. No remote push was requested. Initial repository has no prior
commits on main; origin is Dax000ah/wow_addons. Existing Git author/committer
configuration is available. No implementation changes were needed for check-in.

Included: addon runtime source/XML/TOC, nine Lua suites, three Python scripts,
development requirements, .gitignore, AGENTS.md, README, engineering docs and
project memory/design assets. Generated release ZIPs, logs, .test-tools and Python
caches remain ignored. Source is 0.5.2; marker styles are proposals only.

Re-ran python scripts/run_tests.py: PASS, all nine Lua 5.1 suites. Re-ran python
scripts/check_structure.py: PASS. Credential-pattern scan of nonignored source/
documentation found no private-key/token pattern matches (not a comprehensive
security audit). Staged inventory/diff and whitespace checks are the final commit
gate. git log -1 and git status --short identify the final commit and clean tree.
Project-memory edits for this check-in affect the index, active actions, progress
record and this checkpoint. Native combat/instance/map/Forever checks stay open.
No addon reinstall is needed for this Git-only checkpoint.

## Previous checkpoint: continuous tracking, version 0.5.2

Tony explicitly requested no automatic combat/instance pause. Root cause: two
blanket checks in Tracking.PlayerState and Tracking.MapMembers disabled otherwise
valid data. Removed both gates; all existing coordinate/secret/offline checks stay.
Compass, demo and map sampling continue when data is valid. Missing coordinates
clear affected markers and recover on the next refresh; remote-label behavior is
preserved. No attempt to bypass client restrictions or invent unavailable data.

Files changed: GroupCompass/Tracking.lua, GroupCompass/GroupCompass.toc,
tests/tracking_test.lua, tests/demo_test.lua, tests/core_test.lua, tests/classic_test.lua, README.md,
docs/TESTING.md, docs/FEASIBILITY.md, this checkpoint, the six core memory Markdown
files and drive-manifest.json. Added dist/GroupCompass-0.5.2.zip. Unrelated source
and old packages preserved. No dependencies or Git state-changing operations.

Checks: new combat/instance assertions first failed against old implementation.
python scripts/run_tests.py then passed all nine Lua 5.1 suites. Tests cover valid
tracking in combat/instances, missing-data clearing/recovery in those contexts,
map sampling, demo anchor retention, remote members and Classic startup. Commands
python scripts/check_structure.py and python scripts/build_zip.py passed: runtime
references/order/XML, no orphans, ZIP integrity and source-byte agreement. Exact
Classic folder clean-installed: ten files verified by SHA-256, no backup created.
Git status remains all untracked; tracked diff/check cannot assess untracked code,
so affected implementations and callers/tests were reviewed directly.

Native test remains GC-204: /reload, confirm 0.5.2 with /gcompass status, verify
valid tracking through combat and a shared instance and unavailable-data recovery.
An instance/client may still withhold coordinates, and different coordinate spaces
cannot produce a valid shared bearing. Map frame behavior during native combat
requires client verification. Remaining native layout/map/Forever checks stay open.

Project-closeout and Google Drive/Docs skills applied. Local and Drive memory
record this policy change; completed implementation GC-010 is archived separately
from the pending native verification.

Drive closeout: 15 scoped native Doc edits with revision guard, readback text and
native heading/list membership verified. Updated six Markdown mirrors, manifest
and checkpoint in place. Uploaded 0.5.2 to Work and moved 0.5.1 to Archive with
parent readback verified. Local and Drive records remain dated mirrors.

## Previous checkpoint: remote-member labels, version 0.5.1

Tony confirmed his unavailable member was on another continent and approved a
name/continent label. The previous implementation combined all missing world
coordinates and world-ID mismatches into one generic unavailable count.

Tracking now resolves player/party UI-map ancestry to a named continent. Different
known continents identify a remote member even without world coordinates. Known
world-ID mismatches use "Different world area" if no continent name is available.
Offline/unknown states stay unavailable. No remote bearings/distances are invented;
normal tracking resumes without stale labels. Existing strip hover/status displays
these messages; mixed groups keep local markers and remote text in hover/status.

Changed: GroupCompass/Tracking.lua, GroupCompass/GroupCompass.toc,
tests/tracking_test.lua, tests/classic_test.lua, README.md, docs/TESTING.md,
docs/FEASIBILITY.md, docs/PROJECT_STATUS.md, all six core project-memory Markdown
files and drive-manifest.json. Generated dist/GroupCompass-0.5.1.zip. Unrelated
implementation files and prior release packages were preserved. No dependencies,
Git staging, commits or pushes.

Verification: new remote-label regression initially failed against the old code.
python scripts/run_tests.py passes all nine Lua 5.1 suites after implementation
and updating the old mismatch assertion to the approved behavior. Coverage includes
missing world/API data, known continents, unknown/offline distinction, cyclic
map ancestry, secret values, raid API boundary, mixed groups and local resumption.
python scripts/check_structure.py and python scripts/build_zip.py passed; package
entries/integrity/source-byte checks passed. Clean-installed exactly ten runtime
files in the authorized Classic folder; SHA-256 source matches passed, no backup.
All project files remain untracked; tracked diff/check commands show no tracked
changes, so implementation/tests were reviewed directly. No runtime orphan added.

Native validation remains open as GC-206: /reload, /gcompass status with the current
distant member, inspect remote label and then meet in the same world area to test
resumption. Continent names depend on actual Classic API data; no lookup result
means the safe fallback or unavailable state. Existing movement/map/Forever checks
remain open. Project-closeout and Google Drive/Docs skills were applied.

Memory closeout: native Doc updated in place with a revision guard and verified
against all expected paragraph text, heading styles and list membership. Six
Markdown mirrors, manifest and this checkpoint updated in place; 0.5.1 package
stored in Work, 0.5.0 moved to Archive with parent metadata readback verified.

## Previous checkpoint: shared horizontal baseline, version 0.5.0

Tony supplied annotated and clean Enshrouded HUD references and explicitly asked
for every person to share the same horizontal plane. The old Core.lua stagger
formula assigned each member a different Y. A new regression assertion reproduced
that mismatch before changing the code.

Implemented a 620-by-46 UI-unit strip (previously 620-by-130), positioned closer
to the top with a subtle background and center cue. Every bearing tick shares
one Y and retains its true X. Names share one row; distances share one row. Removed
the large normal-state title/status block. Empty/paused/behind-only text fits in
the same strip. Label collisions use deterministic center/distance/slot priority;
no bearing is moved to fake separation. Full class-colored names and distances
remain available on hover, including all members at a coincident bearing. Exact
coincident ticks can overlay. Native clipping, mouse behavior and appearance still
need Tony's client review. These references do not imply waypoint integration.

Files changed in this task:

- Added `GroupCompass/Layout.lua` and `tests/layout_test.lua`.
- Modified `GroupCompass/Core.lua`, `GroupCompass/GroupCompass.toc`,
  `tests/core_test.lua`, `tests/classic_test.lua`, `scripts/check_structure.py`,
  `README.md`, `docs/FEASIBILITY.md`, `docs/TESTING.md`, and this checkpoint.
- Updated the six core Markdown memory files under `docs/project-memory/` and
  `drive-manifest.json`; added local reference assets
  `assets/enshrouded-hud-annotated.png` and `assets/enshrouded-hud-clean.png`.
- Generated `dist/GroupCompass-0.5.0.zip`. Prior packages and unrelated files
  were preserved. No dependency, staging, commit or push changes.

Checks completed:

- `python scripts/run_tests.py`: PASS, nine Lua 5.1 suites. Coverage includes the
  previously failing shared-baseline requirement, fixed strip dimensions, identical
  tick/name/distance Y positions, single-row collision rules, full-name hover at
  coincident bearings, Classic startup, movement demo, live data and maps.
- `python scripts/check_structure.py`: PASS, interfaces, TOC order, XML template,
  runtime paths and absence of orphan runtime files.
- `python scripts/build_zip.py`: PASS, 0.5.0 archive integrity, paths and exact
  runtime source-byte agreement.
- Clean-installed 0.5.0 in Tony's exact Classic GroupCompass directory, after
  resolving/validating the path and rejecting links. Exactly ten runtime files
  match source by SHA-256; no new backup or unrelated addon change occurred.
- Git inspection: all project files remain untracked, so tracked diff commands
  provide no untracked-file validation. Source/call paths were reviewed directly.

Memory update: retain the supplied Enshrouded references in Drive Design and local
assets, update current requirements/design/progress, and archive GC-008's completed
implementation only. GC-101/GC-103 remain active for native validation; further
styling and minimap collision work remain open. The local memory files and Drive
Doc are dated mirrors, not a background sync service.

Drive closeout: updated the existing native Doc in 23 scoped paragraph groups
with a revision guard. Readback matches all 170 expected paragraphs, native
heading styles and bullet membership. Uploaded both Enshrouded reference images
to Design and the 0.5.0 package to Work; moved the prior 0.4.1 package to Archive.
The six Markdown mirrors, checkpoint and manifest were updated in place.

Next verification: restart WoW for Layout.lua, run `/gcompass demo reset`, and
check that A/B/C share one horizontal marker line with one common name row and
one common distance row. Turn/walk, hover, then test crowded real members. Native
appearance/hover, real-party map behavior and Forever remain unverified.

## Previous checkpoint: moving solo demo and class colors, version 0.4.1

Tony confirmed native Classic static-demo rendering in a screenshot, then reported
that it did not move. The root cause was the prototype's hardcoded sample angles
and distances. Version 0.4.0 replaced those with fixed simulated world locations,
using current player state and shared bearing math. Turning moves labels; walking
changes distances. `/gcompass demo reset` reseeds samples. World-space changes
reseed automatically; unavailable data/combat/instances pause without fabricated
readings. Samples are A/B/C so names stay valid after changing relative direction.

Version 0.4.1 implements Tony's next preference: real members use class colors by
default with their names on the compass and in map/minimap hover labels. Modern
and Classic class-color APIs are supported, with slot colors as a safe fallback.
Demo colors remain synthetic. Existing map behavior is retained.

Tony also requested a thin horizontal slice and nicer presentation. That design
requirement is recorded in project memory and the active queue, not implemented.
The current installed overlay remains the tall prototype.

Changed in this combined follow-up: added `GroupCompass/Demo.lua`,
`tests/demo_test.lua`, `AGENTS.md`, and the following local project-memory files:
`docs/project-memory/00_START_HERE.md`, `01_PRD.md`, `02_DESIGN.md`,
`03_ACTIONS_AND_TODOS.md`, `04_PROGRESS_AND_DECISIONS.md`,
`archive/2026-10-23_COMPLETED.md`, and `drive-manifest.json`. Preserved design
references locally as `assets/classic-tall-prototype.png` and
`assets/earlier-compass-concept-fragment.html` under that memory directory.
Modified `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`, `GroupCompass/Maps.lua`,
`GroupCompass/GroupCompass.toc`, `tests/core_test.lua`, `tests/classic_test.lua`,
`tests/tracking_test.lua`, `tests/maps_test.lua`, `scripts/check_structure.py`,
`README.md`, `docs/FEASIBILITY.md`, `docs/TESTING.md`, and this checkpoint.
Generated versioned 0.4.0 and 0.4.1 ZIPs; earlier artifacts and unrelated files
were preserved. No new runtime or test dependencies were added.

Verification:

- `python scripts/run_tests.py`: passed all eight Lua 5.1 suites, including solo
  world anchors/turning/walking/reset, unchanged live tracking, class-color API
  variants, unavailable/secret data, map lifecycle and class-colored hover names.
- `python scripts/check_structure.py`: passed interfaces, TOC order, XML declaration,
  runtime-file presence and no orphan runtime files.
- `python scripts/build_zip.py`: passed for both new versions; current 0.4.1 archive
  integrity, entry paths and byte-for-byte source matching verified.
- Clean-installed 0.4.1 into the exact named Classic GroupCompass folder. All nine
  installed runtime files match source SHA-256 hashes. No backup created; no other
  addon folder touched. No stage, commit or push performed.
- Native moving-demo, real-party class/name/map behavior and Forever remain
  unverified. API-double tests and installed-file hashes are not native validation.

Project memory lives in Google Drive `ChatGPTStorage / Development / Group Compass`
with a native project-memory Doc and Requirements/Design/Work/Archive areas.
The Drive folder and Doc links, confirmed requirements and working preferences
are indexed in `docs/project-memory/00_START_HERE.md`. Local Markdown mirrors are
offline-readable snapshots; remote synchronization/offline Google Docs settings
are not automatically enabled by connector writes. Existing Wow Forever Drive
notes were preserved.

Drive closeout: readback of the native project-memory Doc exactly matched the
authored text, with named headings and native list items. Folder listings verified
the root Doc/index, Requirements PRD, Design brief and reference assets, Work queue,
progress/checkpoint/current package, and Archive completed records plus releases
0.1.0–0.4.0. Local `drive-manifest.json` records observed file/folder IDs for future
in-place updates. This is a dated memory snapshot, not a background sync service.

Next: Tony restarts the client, runs `/gcompass demo`, turns the character, walks
and tests reset. Then implement/review the thinner horizontal layout and validate
real-party behavior with a second player. Keep the open native tests on the active
queue even though their implementation work has been archived as locally checked.

## Previous checkpoint: Classic Hardcore startup support, version 0.3.0

Installation follow-up: at Tony's explicit request, cleared the contents of
`C:\Program Files (x86)\World of Warcraft\_classic_era_\Interface\AddOns\GroupCompass`
and installed exactly eight 0.3.0 runtime files: `GroupCompass.toc`, `Compat.lua`,
`Direction.lua`, `Projection.lua`, `Tracking.lua`, `Maps.lua`, `Maps.xml`, and
`Core.lua`. Resolved the exact target and checked for links before clearing it;
file count and SHA-256 comparisons against project source all passed. No other
addon folders were touched. Tony requests clean replacement of this exact addon
directory without new backups for subsequent installs in this task. An archive
created before that instruction remains in project `dist/`; it was not deleted.
Client restart and live verification are still required. No runtime source changes
were made during this installation follow-up.

Tony's screenshots identify Classic 1.15.9/build 70003/interface 11509, show the
old addon as out of date, and show an unrecognized `/gcompass demo` command.
The old manifest advertised only Forever's 16001 interface. That mismatch is
confirmed; the native client's exact refusal/abort reason was not captured.
`/console scriptErrors 1` normally gives no chat confirmation and is not itself
evidence of a failure. No other installed addons were changed.

Implemented: the manifest advertises both 11509 and 16001; client metadata works
through either API generation; successful startup announces the installed addon
version and solo-demo command. Classic minimap geometry has an Era-only fallback
using documented zoom/diameter constants, with mode detection, caching, original
zoom restoration, and a guard against synchronous probe-event reentry. Native
radius APIs remain preferred. Existing demo and tracking behavior are preserved.

Files in this follow-up:

- Added `GroupCompass/Compat.lua`, `tests/classic_test.lua`, `tests/compat_test.lua`.
- Modified `GroupCompass/GroupCompass.toc`, `GroupCompass/Core.lua`,
  `GroupCompass/Maps.lua`, `tests/core_test.lua`, `tests/maps_test.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/FEASIBILITY.md`,
  `docs/TESTING.md`, and this checkpoint.
- Generated ignored `dist/GroupCompass-0.3.0.zip`. Earlier archives, parent-folder
  copies, unrelated files, and installed game files were preserved. No dependencies
  added, staging, commit, or push performed.

Checks:

- New Classic startup test initially failed against 0.2.0 because the manifest
  lacked 11509. It now executes all TOC Lua files with Classic-style globals and
  verifies startup notice, slash registration, demo, and status for build 70003.
- `python scripts/run_tests.py`: passed all seven Lua 5.1 suites. Coverage includes
  Classic API absence, legacy/modern metadata, native radius priority, all six
  Classic zoom levels in both modes, probe restoration/cache/reentry, and the
  existing compass/map/projection/tracking regressions.
- `python scripts/check_structure.py`: passed both interfaces, full load order,
  runtime paths, XML template declaration and absence of orphan runtime files.
- `python scripts/build_zip.py`: passed; 0.3.0 archive integrity, exact paths,
  and byte-for-byte runtime source agreement verified.
- Git status/diff review: files remain untracked, so tracked diff commands cannot
  assess the changes. Changed source was reviewed directly. Native client startup
  and rendering are not verified by the API doubles or XML syntax check.

Next required verification: Tony must fully exit WoW, install the 0.3.0 archive
over the existing GroupCompass addon folder in the active Classic installation,
restart, and check for `Group Compass 0.3.0 loaded` in chat. Run `/gcompass demo`
and `/gcompass status`. If no loaded notice appears, capture the addon loader
information using the commands in README plus any Lua error text. Then complete
the live tests with a grouped player. Neither Classic live party functionality
nor Forever compatibility is declared verified at this checkpoint.

## Current checkpoint: map/minimap integration, version 0.2.0

Implemented numbered, matching-color compass labels, custom world-map party pins,
and custom minimap party/raid badges. World-map names appear on hover; minimap
tooltips also report horizontal distance and clamped edge status. Minimap placement
uses the current view radius, map size, rotation setting, and player facing.
An inset keeps square badge corners within the default round minimap.

World-map sampling is independent of world coordinates/facing and uses normalized
positions for the displayed UI map, with its own data provider and virtual pin
template. Pins are reused and removed through Blizzard's map-canvas lifecycle.
No native dots or other addons' markers are removed. Native and custom markers
can overlap. Demo mode intentionally places no synthetic locations on real maps.
`off` clears our markers from all views. Shared combat/instance restrictions and
unavailable/offline handling remain in place.

Current checks:

- `python scripts/run_tests.py`: passed all five suites (core, direction, maps,
  projection, tracking), using Lua 5.1 and API doubles. Map tests include lazy
  loading, current-map selection, normalized bounds, nil/secret placeholders,
  pin reuse/removal, minimap rotation/zoom/edge geometry, hover preservation,
  map visibility, provider reattachment, and off/demo/roster cleanup.
- `python scripts/check_structure.py`: passed runtime files, TOC order, interface,
  XML syntax/template declaration, and orphan-file checks.
- `python scripts/build_zip.py`: passed; created `dist/GroupCompass-0.2.0.zip`.
  ZIP integrity, exact entry paths, and source-byte agreement verified. The
  previous 0.1.0 archive was preserved.
- Final Git status/diff inspection: project files remain untracked; no tracked
  diff exists. Runtime files were reviewed directly, including API callers,
  map-provider cleanup, template order, and unaffected compass behavior.
- Live Forever verification: not run. API doubles cannot validate native secret
  values, XML/mixin initialization, map rendering, phasing/floors, minimap addons,
  or client position availability. Custom world-map pins are party-only because
  the documented map-coordinate API does not promise raid-member support.

Files changed in this integration:

- Added `GroupCompass/Projection.lua`, `GroupCompass/Maps.lua`,
  `GroupCompass/Maps.xml`, `tests/projection_test.lua`, and `tests/maps_test.lua`.
- Modified `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`,
  `GroupCompass/GroupCompass.toc`, `tests/core_test.lua`, `tests/tracking_test.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/FEASIBILITY.md`,
  `docs/TESTING.md`, and this checkpoint.
- Generated ignored `dist/GroupCompass-0.2.0.zip`. No dependencies were added.
  Parent-folder backups, the existing direction module/test, prior ZIP, build/test
  runners, and unrelated files were preserved. No staging, commit, or push occurred.

Next: install 0.2.0 and run the map/minimap section of TESTING.md, recording the
client build and `/gcompass status` output. Resolve client-specific failures before
calling this release verified. Crowded-group label/badge overlap and persistent
settings remain future work after client validation.

The records below describe the earlier prototype checkpoints.

## Completed

- Located public GitHub repository `Dax000ah/wow_addons` through the GitHub connector.
- Researched the Forever API surface and documented conditional feasibility.
- Created a dependency-free addon prototype, installation guide, Lua math tests,
  structure validator, and client test checklist.
- Kept runtime files together in the installable `GroupCompass` directory.
- Copied the starter files into Tony's successfully cloned `wow_addons-checkout`.
- Executed direction, tracking, and UI logic tests under Lua 5.1. Reproduced and
  fixed position sampling for offline members; they now count as unavailable.
- Added immediate roster/zone/combat event refresh, `/gcompass status`, and demo
  activation while hidden. Behind-member text preserves unavailable-member counts.
- Added local test tooling and an installable ZIP builder. Existing addon research
  identified MateCompass as a close advertised match; see README for source links.

## Repository state

Initial clone attempts from the sandbox failed to connect to GitHub. Tony then
successfully cloned the empty remote into `wow_addons-checkout`. Its origin is
`https://github.com/Dax000ah/wow_addons.git`. The checkout initially contained only
`.git`; starter files were copied without overwriting any existing files. The
original copies in the parent folder were preserved. Use this checkout for future
development; the parent copies are retained backups, not additional runtime files.
No staging, commits, or pushes were performed.

## Verification record

- `python scripts/check_structure.py`: passed; required files, interface number,
  TOC paths/load order, and absence of orphan addon Lua files validated.
- `python scripts/run_tests.py`: passed all three Lua 5.1 suites (direction,
  tracking, and core UI logic). The new offline test initially failed against the
  prototype and passed after the connection guard was added. Tests use API doubles;
  native WoW restrictions, opaque secret values, and UI rendering remain unverified.
- `python scripts/build_zip.py`: passed. Created `dist/GroupCompass-0.1.0.zip`
  containing exactly the TOC and three runtime Lua files under `GroupCompass/`.
  ZIP integrity, entry paths, and byte-for-byte source agreement passed.
- Forever startup/UI/API validation: not run; no live client was operated.
- Git inspection uses a command-scoped `safe.directory` for this exact checkout
  because the sandbox account differs from Tony's Windows account. No global Git
  configuration was changed. New starter files are untracked, so ordinary
  `git diff` has no tracked changes to display; their contents were reviewed directly.
- Manual source review: checked TOC load order, addon namespace, frame ownership,
  slash commands, marker clearing, coordinate-space checks, and scope boundaries.
  No duplicate runtime modules or unused placeholder folders were introduced.

## Files changed in the tested prototype follow-up

- Modified `.gitignore`, `GroupCompass/Tracking.lua`, `GroupCompass/Core.lua`,
  `scripts/check_structure.py`, `README.md`, `docs/TESTING.md`, and this status file.
- Created `requirements-dev.txt`, `scripts/run_tests.py`, `scripts/build_zip.py`,
  `tests/tracking_test.lua`, and `tests/core_test.lua`.
- Created ignored local test tooling in `.test-tools/` and the generated ZIP in
  `dist/`. Neither belongs in the game addon folder.
- Preserved the existing direction implementation/test, TOC, feasibility document,
  and original parent-folder copies. Git still reports the project files as
  untracked because the remote repository has no initial commit. `git diff --check`
  and `git diff --name-only` ran but contain no tracked changes to assess; direct
  source review and executed tests provide the verification for these files.

## Next steps in priority order

1. Install the ZIP and run the Forever checklist in TESTING.md. Record
   `/gcompass status` output. Coordinate availability and orientation are the main
   release gates. Lua regression suites now pass locally.
2. When Tony requests it, commit and push the starter files from this checkout.
3. After client validation, address label collisions and decide whether persistent
   settings and a richer compass UI are worthwhile. Do not promise instance or
   camera-relative support without new API evidence.
