# Group Compass project memory

## Forever is the acceptance target

Tony reaffirmed this boundary on 2026-11-03: Group Compass must work with the
unmodified addons currently installed in `_forever_/Interface/AddOns`. Audit
their current versions after CurseForge updates. Use their existing supported
interfaces; never require injected methods, private compatibility patches or
changes to another addon's code. Any consumer adaptation belongs in Group Compass.
Hardcore and privately patched dependencies are secondary test aids only; a pass
there is not Forever acceptance. Keep those patches outside this repository's
runtime/package and never install them in Forever. Report stale simulation bases
and upstream limitations explicitly. See docs/FOREVER_LAUNCH_CHECKLIST.md.

Follow Tony's personal engineering standards and the current task instructions.
Before resuming project work, read `docs/project-memory/00_START_HERE.md`, the
active actions/design brief, and the latest `docs/PROJECT_STATUS.md` checkpoint.
They contain the verified Drive project links, current implementation, open tests,
user preferences, and prior decisions. Reconcile notes against code before editing.

Keep progress, requirements, design decisions, and actions current after meaningful
work. Archive only completed implementation with its verification evidence; keep
pending client verification active. Drive notes and local Markdown are dated
mirrors, not an automatic synchronization service. If Drive is unavailable, preserve
local updates and report the unsynchronized state rather than claiming a remote write.

Tony requests clean replacement without new backups when an authorized install
targets the exact GroupCompass addon directory recorded in the index. Do not clear
the parent AddOns folder or alter unrelated addons. Inspect Git only; staging,
commits and pushes still require Tony's explicit request.
