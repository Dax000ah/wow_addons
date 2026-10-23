# Group Compass project checkpoints

Date: 2026-10-23.

## Latest checkpoint: initial local check-in of 0.5.2

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
