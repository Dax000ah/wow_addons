"""Load the provider's unmodified public API with Group Compass (no client UI)."""
import argparse
import hashlib
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".test-tools"))
from lupa.lua51 import LuaRuntime

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("provider", type=Path)
args = parser.parse_args()
source = (args.provider / "Core/API.lua").resolve(strict=True)
before = source.read_bytes()
lua = LuaRuntime()
os.chdir(ROOT)
lua.globals().PROVIDER_API = source.as_posix()
lua.execute((ROOT / "tests/fixtures/stock_spf_api.lua").read_text(encoding="utf-8"))
assert source.read_bytes() == before
print("PASS: unmodified Core/API.lua composition; SHA256 " + hashlib.sha256(before).hexdigest())
print("Limits: journey execution and client services doubled; native WoW test remains open.")
