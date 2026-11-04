"""Read-only launcher composition using installed TomTom or Leatrix shared libraries."""
from pathlib import Path
import hashlib
import os
import re
import sys

root = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(root / ".test-tools"))
from lupa.lua51 import LuaRuntime

provider = Path(sys.argv[1]).resolve()
runtime = LuaRuntime()
if provider.is_file():
    # Read the upstream's explicitly delimited embedded standard libraries. No
    # copied files or runtime private APIs; native UI and the collector are doubled.
    source = provider.read_text(encoding="utf-8-sig")
    chunks = []
    for marker in ("LibStub", "Callback", "DataBroker", "LibDBIcon"):
        matches = re.findall(r"-- " + marker + r"Start\s*\n(.*?)\n-- " + marker + "End", source, re.S)
        assert len(matches) == 1, "Re-audit the embedded library boundaries"
        chunks.append(matches[0])
    paths = [provider]
    runtime.globals().LAUNCHER_LIBRARY_CHUNKS = runtime.table_from(chunks)
else:
    library_root = provider / "libs"
    paths = [library_root / "LibStub/LibStub.lua", library_root / "LibDataBroker-1.1/LibDataBroker-1.1.lua",
             library_root / "LibDBIcon-1.0/LibDBIcon-1.0.lua"]
    callback = library_root / "CallbackHandler-1.0/CallbackHandler-1.0.lua"
    if not callback.is_file():
        callback = library_root / "HereBeDragons/CallbackHandler-1.0/CallbackHandler-1.0.lua"
    paths.append(callback)
    runtime.globals().LAUNCHER_LIBRARY_ROOT = library_root.as_posix()
before = {p: hashlib.sha256(p.read_bytes()).hexdigest() for p in paths}
os.chdir(root)
runtime.execute((root / "tests/launcher_test.lua").read_text(encoding="utf-8"))
assert all(hashlib.sha256(p.read_bytes()).hexdigest() == digest for p, digest in before.items())
print("PASS: actual installed shared libraries unchanged; native frames and collector filter doubled")
