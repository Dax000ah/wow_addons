# Completed implementation — 2026-11-02

## GC-032 — Private Hardcore rendering diagnostics, hc-test.9

Existing /path report now captures actual route point count, measured/error,
world/minimap strokes, visibility/alpha, coordinate spaces, first stroke geometry,
paint revisions and last16 route updates. Detached plain capture saved via the
existing character DB; WoW flushes on /reload/logout. No GC runtime/public API,
engine, terrain, unrelated addons or Forever changes. Seven private suites and
real terrain/repeated searches pass;116 installed source hashes match.

Only diagnostic implementation is archived. GC-218/HC-010 remains OPEN for native
capture/root cause/fix. Prior hc-test.8 did not resolve Tony's both-map symptom.
See private DIAGNOSTICS_CLOSEOUT_2026-11-02.md for inventory/commands/limits.

## GC-033 — Exact capture replay established

Native saved snapshot read without execution. Exact player/goal returns unreachable
and a settled no-plan search; nearby points yield4/11-point paths. Regression
assertions preserve refusal and confirm valid control. Seven suites pass; current
Forever engine/14 Nav1 files byte-identical. This records completed investigation,
not a native rendering fix. GC-218/HC-011 valid-control test remains OPEN.
