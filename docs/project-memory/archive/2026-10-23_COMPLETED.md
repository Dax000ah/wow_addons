# Completed Implementation Archive — 2026-10-23

These are completed implementation/organization records. Live verification that
remains open stays in the active queue. All dates are America/Los_Angeles.

## GC-010 — Version 0.5.2: remove combat/instance auto-pause

Removed blanket pause gates in PlayerState and MapMembers at Tony's request.
Compass/demo and custom map views continue with valid data; nil/secret/offline
guards remain. Changed regression expectations reproduced the old pause, then all
nine Lua 5.1 suites passed, including missing-data clearing/recovery. Structure
and package integrity/source checks passed. Clean-installed ten matching files
by SHA-256 without backup. Native verification stays active as GC-204.

## GC-001 — Repository discovery and starter setup

Located Dax000ah/wow_addons. Sandbox clone attempts failed; Tony successfully cloned
the empty remote into wow_addons-checkout. Starter addon, feasibility notes,
installation instructions and a dependency-free structure checker were created.
No stage, commit or push occurred. Parent-folder starter copies were preserved.

## GC-009 — Version 0.5.1: named remote-continent status

Implemented name/continent labels for known remote party locations, including
missing world coordinates with different known UI-map continents. Differing world
IDs without continent information use "Different world area"; offline/unknown
data stays unavailable. No remote bearing or yardage is fabricated. Regression
tests cover missing APIs/data, cyclic parents, secret values, raid restrictions,
mixed local/remote groups and resumed local tracking. All nine Lua 5.1 suites,
structure/package checks and ten-file clean-install hashes passed. No backup,
dependency or Git state changes. Client validation remains active as GC-206.

## GC-002 — Version 0.1.0: initial compass prototype

Implemented direction math, group sampling, display, static demo and slash commands.
Added offline/unavailable member handling, roster/zone/combat refresh, status output,
Lua tests and install-package creation. Initial direction/tracking/core tests passed.
Compatibility was conditional, not client-verified.

## GC-003 — Version 0.2.0: maps and minimap

Added normalized world-map party pins, minimap party/raid projection with edge
clamping, matching slot colors/numbers and hover labels. Added map lifecycle and
projection suites. Five suites plus structure/package validation passed. Native
party and map validation remains active, not archived as complete.

## GC-004 — Version 0.3.0: Classic startup support

Tony identified Classic 1.15.9/build 70003/interface 11509. Added its interface,
Classic metadata/minimap compatibility, startup notice and diagnostic instructions.
Seven suites passed. Direct installation was authorized; Tony then specified
clean replacement without backups. His later screenshot confirms static demo
display. The exact old native loader refusal was not captured; the old manifest's
missing Classic target was confirmed.

## GC-005 — Version 0.4.0: moving solo compass demo

Replaced static bearings with simulated fixed world locations, shared player-state
validation and colors. Character turning and walking update relative bearing and
distance. Added reset and pause/reseed behavior. Eight suites passed; package and
clean installation verified. Current-version native motion remains an active test.

## GC-006 — Version 0.4.1: member class-color defaults

Real member names/colors now use modern or Classic class-color APIs with safe
fallbacks. Map/minimap tooltip names share the member's class color. Extended tests
cover both API generations, missing/secret/invalid data and cross-view identity.
All eight suites, structure and ZIP checks passed. Nine runtime files were
clean-installed and verified by SHA-256. Native grouped validation remains open.

## GC-007 — Project memory organization

Created Development / Group Compass within the existing ChatGPTStorage folder,
with Requirements, Design, Work and Archive areas, a native project-memory Doc,
and local Markdown mirrors. Requirements include the requested thin horizontal
slice, class-color defaults and member names. Existing Wow Forever notes were
not edited or moved. Offline browser availability is a user setting, not enabled
by creating these records; local Markdown is the offline-readable counterpart.

## GC-008 — Version 0.5.0: one horizontal plane

Tony supplied Enshrouded HUD references and clarified that all people must share
one horizontal plane. Reproduced the old stagger as a failing regression. Replaced
the 130-unit panel with a 46-unit strip, aligned every tick/name/distance on its
respective shared baseline, and retained true bearing X positions. Added center
cue, lighter background, deterministic label spacing, and full-name shared hover.
Nine Lua suites and structure/package checks passed. Clean installation verified
ten source hashes; no backup created. Native visual/hover validation remains active.

## Archive policy

Store superseded release packages with their original versioned filenames and
preserve their associated limits. Keep active TODOs out of the completed area.
Do not archive native compact-layout validation, native moving-demo test, live group API tests,
or Forever compatibility as completed until evidence supports them.
