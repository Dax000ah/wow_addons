"""Read-only composition check against Tony's installed TomTom API implementation."""
from pathlib import Path
import hashlib
import os
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / ".test-tools"))
from lupa.lua51 import LuaRuntime

source = Path(sys.argv[1]).resolve()
toc = (source / "TomTom.toc").read_text(encoding="utf-8")
version = next(line.split(":", 1)[1].strip() for line in toc.splitlines() if line.startswith("## Version:"))
assert version in {"v4.3.12-release", "v4.3.13-release", "v4.4.0-release"}, "Re-audit the provider before testing a different version"
os.chdir(root)
runtime = LuaRuntime()
runtime.globals().TOMTOM_SOURCE_PATH = source.as_posix()
runtime.globals().TOMTOM_LAYOUT = "4.4" if version == "v4.4.0-release" else "4.3"
registry = source / ("core/waypoints.lua" if version == "v4.4.0-release" else "TomTom.lua")
before = registry.read_bytes()
runtime.execute((root / "tests/tomtom_test.lua").read_text(encoding="utf-8"))
assert registry.read_bytes() == before
print("Read-only provider:", version, registry.name, hashlib.sha256(before).hexdigest())
print("Not a native WoW frame, HBD projection, map-click or gameplay test.")
