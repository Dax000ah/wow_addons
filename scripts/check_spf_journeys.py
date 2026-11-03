"""Read-only real SPF API/engine + GC switching replay of the November 3 capture."""
import argparse
import base64
import hashlib
import json
import os
from pathlib import Path
import sys
import xml.etree.ElementTree as ET
import zlib

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".test-tools"))
from lupa.lua51 import LuaRuntime


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("provider", type=Path)
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    provider = args.provider.resolve(strict=True)
    lua = LuaRuntime(encoding=None, unpack_returned_tuples=True)
    ns = lua.table()
    loaded = {}
    lua.globals()[b"C_EncodingUtil"] = lua.table_from({
        b"DecodeBase64": lambda value: base64.b64decode(value, validate=True),
        b"DecompressString": lambda value, method: zlib.decompress(value),
    })
    lua.globals()[b"Enum"] = lua.table_from({
        b"CompressionMethod": lua.table_from({b"Zlib": 1}),
    })

    def load(relative):
        source = (provider / relative).read_bytes()
        loaded[relative] = hashlib.sha256(source).hexdigest()
        lua.execute(source, b"ShortestPathForever", ns)

    for entry in ET.parse(provider / "Nav/Nav.xml").getroot():
        name = entry.attrib.get("file", "")
        if name.startswith(("Nav0.", "Nav0_", "Nav1.", "Nav1_")):
            load("Nav/" + name)
    for name in ("Routing/PathGrid.lua", "Routing/Path.lua"):
        load(name)
    lua.execute(b"""
        local queue = {}
        C_Timer = {After=function(_, fn) queue[#queue+1] = fn end}
        InCombatLockdown = function() return false end
        geterrorhandler = function() return error end
        canaccessvalue = function() return true end
        function DrainPathQueue()
            local count = 0
            while #queue > 0 do
                count = count + 1
                assert(count < 40000, 'Replay did not settle')
                table.remove(queue, 1)()
            end
            return count
        end
    """)
    for name in ("Routing/PathJobs.lua", "Transport/Model.lua", "Data/Routes.lua",
                 "Data/Transports.lua", "Data/Taxi.lua", "Data/Portals.lua",
                 "Data/Walks.lua", "Data/Zones.lua", "Routing/Planner.lua"):
        load(name)
    for name in ("Journey/Hazards.lua", "Journey/JourneySearch.lua",
                 "Journey/JourneyWalks.lua", "Core/API.lua"):
        loaded[name] = hashlib.sha256((provider / name).read_bytes()).hexdigest()
    # No private Hardcore implementation is loaded. The fixture doubles the
    # client/driver, not API ownership, transport planning or terrain searching.
    os.chdir(ROOT)
    lua.execute((ROOT / "tests/fixtures/stock_spf_journeys.lua").read_bytes(),
                b"ShortestPathForever", ns, provider.as_posix().encode())
    for relative, digest in loaded.items():
        assert hashlib.sha256((provider / relative).read_bytes()).hexdigest() == digest
    toc = (provider / "ShortestPathForever.toc").read_text(encoding="utf-8-sig")
    version = next(line.split(":", 1)[1].strip() for line in toc.splitlines()
                   if line.startswith("## Version:"))
    results = [{key.decode(): value.decode() if isinstance(value, bytes) else value
                for key, value in row.items()} for _, row in ns[b"StockJourneyReplay"].items()]
    report = {"result": "PASS", "provider_version": version,
              "cases": results, "loaded_source_sha256": loaded,
              "limits": "Client position/projection/time and Journey driver doubled; actual API, GC routing, Nav, Planner, Search and Walks. Not native rendering. Good target uses approximate zone bounds; failed target/player are exact saved world coordinates."}
    body = json.dumps(report, indent=2) + "\n"
    if args.output:
        args.output.resolve().write_text(body, encoding="utf-8")
    print(body)


if __name__ == "__main__":
    main()
