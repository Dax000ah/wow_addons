"""Run addon regression tests with a project-local Lua 5.1 runtime."""
import os
from pathlib import Path
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / ".test-tools"))
try:
    from lupa.lua51 import LuaRuntime
except ImportError:
    raise SystemExit(
        "Install test tooling: python -m pip install --target .test-tools -r requirements-dev.txt"
    )

os.chdir(root)
for test in sorted((root / "tests").glob("*_test.lua")):
    print(f"Running {test.name}", flush=True)
    runtime = LuaRuntime()
    assert runtime.eval("_VERSION") == "Lua 5.1"
    runtime.execute(test.read_text(encoding="utf-8"))
print("PASS: all Lua 5.1 regression suites")
