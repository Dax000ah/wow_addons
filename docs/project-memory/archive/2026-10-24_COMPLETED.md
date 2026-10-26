# Completed Research Archive — 2026-10-24

## GC-015 — Shortest Path Forever routing feasibility

Identified installed v1.22.4 and inspected public API, terrain search, transports,
map rendering and combat gates. Saved Group Compass points match normalized API
inputs. Local/cross-continent routing is feasible in principle, with no native
itinerary proven. Recorded proposed optional Navigate/Stop integration and two
open limits: no public next-target output; provider combat deferrals conflict
with Tony's preference. Code/data embedding would require a separate licensing,
client-compatibility and maintenance decision. No runtime/installed addon changed.
Read-only API probe and structure check passed; details and source fingerprints:
docs/ROUTING_FEASIBILITY.md. GC-104/105/106 remain active, not completed.

## GC-016 — Guidance API prototype and offline engine checks

Tony selected API reuse and accepted route-only combat deferrals. Created original
provider-side GetGuidance prototype, contract tests and a read-only real-engine
harness. All 15 Lua suites pass. Real shipped terrain returned three local paths;
real transit planner returned an intercontinental boat plan with estimated endpoint
walks and no live timetable. Structure/diff checks pass. Beta closure/launch verified
against Blizzard. No provider source copied, installed addon changed, dependency,
commit or push. Prototype is not a supported upstream API or shipped integration;
GC-104/105/106 retain implementation/native gates. Evidence: docs/ROUTING_TEST_RESULTS.md.
