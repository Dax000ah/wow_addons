# Completed Implementation — 2026-10-30

## GC-031 — Independent SPF/OpenMap projection regression and private fix

Native report received: player-owned settled66s walk, RXP off, no caught errors.
Approximate report-coordinate replay gives five points/67s. The actual OpenMap
public API composition reproduces SPF's incorrect re-projection of world yards.
Private hc-test.8 passes world coordinates directly. Six private suites including
Route resolver/both-map geometry and 116 installed source hashes pass. Same
faulty adapter in upstream Forever is untouched. Only implementation is archived:
GC-218/HC-009 native retest and unmodified Forever/OpenMap acceptance stay OPEN.

## GC-030 — Stock API boundary correction, 0.10.2 / private hc-test.7

Removed injected guidance/source methods and GC dependency; native RXP settings
handoff replaces unsupported one-click resume. Owned routing, retry and stop use
public API only. Unmodified v1.22.9/v1.22.14 API composition passes, 17 GC and five
private suites pass, actual Search/Walks/Nav passes moved/reused goals. ZIP and
30 GC /116 provider source hashes pass. Two obsolete installed modules remain
unloaded after deletion was blocked; GC-219 cleanup remains active. GC-217/HC-008
native acceptance and GC-218 intermittent route failure remain OPEN.

The GC-029 record below is historical and superseded: its custom source methods
were incorrectly described as optional public APIs; they were not upstream APIs.

## GC-029 — Golden-path target selector, 0.10.0 / private hc-test.6

Right-click target panel, left-click options, party/TomTom sublists, RXP source,
status/Retry/Stop and capability explanations implemented. Group Compass uses
optional provider APIs; no provider engine/settings access is copied into it.
Stable GUID re-resolution prevents stale menu slots routing to another member.
Member locations are snapshots; native quest locations remain unavailable on HC.

18 consumer suites and seven provider suites pass. Actual RXP bridge/selector/
consumer composition proves manual isolation and RXP resume/progression. Real
engine/map checks pass in three areas and retain an approximate offmesh case.
The original v1.22.9 release matches all 115 recorded hashes and is pinned locally
after the live Forever addon independently updated. No live Forever edits.

Only implementation/offline checks are archived. Native controls/source switching
remain GC-217/HC-008; the exact reported dot-only failure remains GC-218. A nearby
offmesh sample is a possible explanation, not confirmation of Tony's live click.
