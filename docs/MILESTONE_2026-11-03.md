# Group Compass0.10.2 milestone — November3,2026

Tony requested a milestone check-in because working functionality is now
confirmed. Commit current project work since44f46dc, including existing compass
controls, N/E/S/W, map-pin lifecycle fix, stock-API-only routing/source menu,
regression checks and project memory. This checkpoints partial working behavior;
full native Forever acceptance remains open. No private provider code is part
of the Group Compass repository/package. No push requested.

## Current task changes

Added docs/NAVIGATION_GUIDE.md with simple arrow roles, current behavior and
optional existing visibility/follow settings. Linked from README.md. Updated
index/design/actions/progress/PROJECT_STATUS.md, completed archive and Drive
manifest. Added this milestone closeout. No new runtime change or install in
this task; previously reviewed project changes are included in the milestone.
The final commit's file list is available with git show --stat HEAD.

## Checks run for the milestone

- python scripts/run_tests.py: PASS17 Lua5.1 suites.
- python scripts/check_structure.py: PASS TOC/XML/interfaces/art/no orphan runtime.
- python scripts/check_spf_api.py FOREVER_SPF: PASS actual unmodifiedv1.22.18 API.
- python scripts/check_tomtom_offline.py FOREVER_TOMTOM: PASS actualv4.3.13 registry.
- python scripts/check_spf_journeys.py FOREVER_SPF and PINNED_ORIGINAL_v1.22.9:
  PASS five alternating actual API/GC/engine requests each; rejected saved target
  has no plan, valid target recovers. Client/driver/projection are doubled.
- Existing GroupCompass0.10.2 ZIP/source hash check and git diff --check: PASS.
- Reviewed runtime routing/controls/map lifecycle and associated regression changes;
  removed private getter and tests are intentional, replaced by stock API tests.
  No injected source/next-turn API remains. Secret scan of research/memory/new
  harness found no credential markers. Tests/data remain project-related.
- Screenshot labels checked in RXP map.lua, TomTom_CrazyArrow.lua, GC Routing.lua,
  and SPF Route/Arrow source. Blue Step22 is RXP, gold yards/stars arrow TomTom;
  our strip is the group-bearing display. Selecting a member calls SPF Navigate
  without changing the other two arrow selections. Cyan map line is boat travel.

## Manual verification and remaining work

Tony confirms member selection and fresh TomTom point route in Hardcore. Direct
long control rendered on both maps. The older exact point also fails natively;
its detailed terrain refusal is unknown. General repeated A/B/A routes and
native Forever tests remain open. GC is not installed in Forever yet; install
only our folder and use the current stock addon set per FOREVER_LAUNCH_CHECKLIST.
Private HC basev1.22.9 remains behind stockv1.22.18. Do not require its patches.

Optional next step for clarity: hide TomTom's floating arrow through its own
settings when using SPF for route guidance. No arrow settings were changed.
Commit is created after these checks/documents; use git log -1 for its exact
identifier. Final worktree/status check follows the commit. Cloud memory records
its hash without adding a self-referential follow-up repository edit.
