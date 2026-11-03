# Completed Implementation and Evidence Archive — 2026-10-27

## GC-022 — Private provider synchronous planner watchdog fix

Reproduced excessive synchronous hazard/map work along the actual JourneySearch
Start > Planner > Hazards path from Tony's RXP-triggered timeout. hc-test.3 moves
initial preview, reused-batch proof and timer plans to existing notification jobs;
adds zone checkpoints; preserves FIFO, cancellation, revision guards and callback
priority. Timer replans coalesce. Original hazard penalties, terrain/path algorithms
and RXP integration remain enabled and unchanged in meaning.

Private verify.py passes three suites, including watchdog reproduction before the
fix and bounded simulated work afterward, cancelled yielded previews, rapid goal
replacement, combat pause, reused proof, timer topology rebuild and visible errors.
Three cold asynchronous real terrain searches match synchronous costs and map
geometry checks pass. Four owned addon files replaced; all 117 installed SHA-256
values match. Group Compass runtime and Forever unchanged; no Git mutations.
Only implementation/offline checks are archived. Native response/routes/turns,
transports and launch verification remain open as HC-001–HC-005 and GC-109/210.

## GC-023 — N/E/S/W compass labels, 0.9.1

Implemented headings on the member bearing scale, separate row within the
unchanged 620-by-46 strip, solo display and coordinate-independent guarded
facing. Member rows remain shared. Regression coverage includes four directions,
wrap, solo/demo/off, missing/secret/nonfinite facing and existing member behavior.
All 17 Lua 5.1 suites, actual TomTom API composition, structure/ZIP/source checks
and 29 installed SHA-256 matches pass. Native appearance/movement remains GC-213.

## GC-024 — Private missing waypoint/quest map-art fix, hc-test.4

Tony confirmed the minimap golden line, then hit a nil-atlas error opening the
world map. Reproduced with actual Art/StopPin modules and strict missing-atlas
fixtures. Goals/rings use the shipped gold dot when absent; numbered stops use
contrasting font numerals when button art is absent. Native art/aspect/grid and
pooled reuse remain covered. Four private suites plus three existing terrain/map
geometry cases pass; 117 installed SHA-256 matches. Forever remains byte-identical.
Native world-map recovery HC-006 and remaining routing gates stay active.

Both installs used changed-file copies after automatic approval review blocked
directory clearing. Full file/hash checks found no stale files. No backups or
Git mutations. See the October 27 cardinals/map-art closeout for changed files.

## GC-025 — Compass appearance sliders, 0.9.2

Compass/Map markers tabs, saved live width/height/text sizing, visible bounds,
readable font-dependent height minimum, shared bearing scale/rows and resized
collision/hover behavior implemented. Existing map controls remain in their tab.
Defaults stay 620/46/10. All 17 suites pass with persistent settings, invalid/bounds,
78 extreme geometry cases, range callback reentrancy, real Settings/Core, hover,
off/reset coverage. Actual TomTom API, structure/package/source and 29 installed
SHA-256 checks pass; private provider's four consumer suites pass. Five owned
files copied without backups; no provider runtime or Git mutation. Native slider,
UI-scale and persistence verification remains GC-214. Closeout:
docs/CLOSEOUT_2026-10-27_COMPASS_APPEARANCE.md.

## GC-026 — Private XML atlas-loading fix, hc-test.5

Both-map gold lines confirmed by Tony. Repeated outer-glow warnings came from
six XML atlas attributes resolved before Lua. Those now initialize through
checked dock/flight callbacks or existing checked goal-stop acquisition. Native
art is retained; existing Classic ring/goal fallback art handles absent entries.
Five private suites pass, including failing old XML, actual callbacks, 19 repeated
pins, missing/native art, anchors/visibility and fault propagation. All 117
installed SHA-256 hashes match, original Forever unchanged. Group Compass runtime
unchanged at 0.9.2. Only implementation archived; native warning-free main-map
reopen/zoom/hover remains HC-007 / GC-113. See private XML_ART_CLOSEOUT_2026-10-27.md.

## GC-027 — Route-source explanation and settings entry, 0.9.3

Added public-API detection for known RestedXP/TomTom journeys and a native Route
settings entry. Unknown sources are not guessed. Existing owned-point deletion
cancels the owned route; foreign guide journeys remain protected. Screenshot
owner remains unconfirmed, with RestedXP a likely source. All 17 suites, actual
TomTom API, five private consumer suites, package and 29 installed hashes pass.
Native source/settings/deletion review remains GC-215. No provider preference,
SavedVariables, private runtime or Git change. Detailed task closeout:
docs/CLOSEOUT_2026-10-27_ROUTE_SOURCE.md.
