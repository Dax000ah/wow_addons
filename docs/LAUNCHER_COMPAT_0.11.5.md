# Minimap tooltip compatibility 0.11.5 — closeout

The screenshot is Leatrix Plus's generic replacement tooltip for custom minimap
buttons. Source: its CreateBadButton / MakeButtons path replaces visible named
non-LibDBIcon buttons and supplies that warning instead of our OnEnter help.
This reproduced the protocol mismatch; no RXP guidance change was requested after
Tony clarified that its help was visible. Only fix the minimap launcher here.

GC now registers a standard LibDataBroker launcher and LibDBIcon button through
existing public shared libraries. Leatrix recognizes LibDBIcon10_GroupCompass and
keeps its OnTooltipShow and click dispatch. Icon remains cyan; left-click opens
Options and right-click opens navigation choices anchored at the actual icon.
Drag clicks are suppressed. Stored position migrates from buttonAngle to the
standard minimapPos key; both stay compatible. Regular appearance refreshes do not
force library-managed placement/visibility. Explicit Reset refreshes its position.

Dependency decision: add Leatrix_Plus to OptionalDeps to ensure its bundled shared
libraries exist before registration, including when TomTom is disabled. This does
not require installing Leatrix or any new addon. TomTom's existing OptionalDep also
supplies the standard libraries. No third-party code copied/bundled. The custom
launcher remains intentionally as a tested standalone fallback without suppliers;
click and tooltip logic are shared rather than duplicated. RestedXP menu/help is
unchanged per Tony's correction. No third-party provider/collector file or setting
was changed; no private widgets, settings or callbacks touched.

Changed files:

- GroupCompass/Options.lua — standard launcher, shared handlers, placement ownership.
- GroupCompass/Settings.lua — canonical saved minimap position and migration/aliases.
- GroupCompass/GroupCompass.toc —0.11.5 and optional Leatrix load order.
- tests/launcher_test.lua — registration/tooltip/dispatch/drag/migration/collector regression.
- scripts/check_launcher_offline.py — actual installed shared-library composition.
- scripts/check_structure.py — required test/script and optional dependency contract.
- tests/options_test.lua — native callback self and fallback saved-position check.
- tests/settings_test.lua — migration/finite values/persistence/alias/reset checks.
- tests/classic_test.lua — startup version.
- README.md; docs/NAVIGATION_GUIDE.md; docs/PROJECT_STATUS.md;
  docs/project-memory/00_START_HERE.md,01_PRD.md,02_DESIGN.md,
  03_ACTIONS_AND_TODOS.md,04_PROGRESS_AND_DECISIONS.md,
  archive/2026-11-03_COMPLETED.md,drive-manifest.json; this closeout.

Verification:

- python scripts/run_tests.py: PASS all19 Lua5.1 suites. Both standard protocol and
  no-library fallback tested, including safe clicks and reset/persisted position.
- python scripts/check_launcher_offline.py <TomTom folder>: PASS for both Hardcore
  and Forever library copies; executes actual LibStub/CallbackHandler/LDB/LibDBIcon.
- Same command <Leatrix_Plus_Library.lua>: PASS for both game folders; executes
  upstream's explicitly delimited library sections in memory without copying files.
- Shared-library fixture exercises registration BEFORE PLAYER_LOGIN, true native
  library tooltip/click/drag handlers, SavedVariables position and collector-owned
  hiding. Native frames and the Leatrix collector predicate are DOUBLED; the full
  manager is not executed. Source hashes checked unchanged after each run.
- python scripts/build_zip.py: PASS structure/TOC/XML/art, no orphan runtime files,
 31-file ZIP integrity and byte-for-byte source match. GroupCompass-0.11.5.zip.
- Both exact GroupCompass folders installed with31 source-matching files each.
  No backups or SavedVariables writes; all26 Leatrix files unchanged during install
  and the original4,756 dependency hashes still match the earlier capture.
- git diff --check PASS; final affected paths reviewed. Clean basebed6dcb before
  edits; this fix is not committed/pushed. No unrelated cleanup.

GC-224 native check OPEN: /reload then hover cyan Group Compass inside Leatrix's
button group. Expect friendly Group Compass title and separate wrapped Left-click,
Right-click and Left-drag help, without the custom-button warning. Check left-click
Options, right-click navigation, one visible icon, cyan color and saved drag
position. If stale icon remains, fully exit/restart WoW once for metadata/load
order. No Leatrix configuration changes needed. Standalone mode without TomTom/
Leatrix should keep working through the fallback. Native collector appearance and
unmodified Forever gameplay acceptance still need verification; don't call offline
frames a native pass. GC-220/221/222/223 earlier gates/limits remain documented.

## November 4 — native launcher tooltip confirmed

Tony reloaded and confirmed that the cyan Group Compass icon inside Leatrix
shows Group Compass with left-click, right-click and drag help. This closes the
reported GC-224 tooltip failure; saved-drag and standalone/Forever gameplay gates
are not inferred from that confirmation. All 19 Lua 5.1 suites, structure check,
actual Forever TomTom launcher-library composition and git diff --check pass
again before the requested checkpoint. No provider or SavedVariables edits.
