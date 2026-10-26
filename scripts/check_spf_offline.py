"""Exercise an installed SPF engine read-only; this is not a native WoW/client test."""
import argparse
import base64
import hashlib
import json
import math
from pathlib import Path
import sys
import time
import xml.etree.ElementTree as ET
import zlib

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / ".test-tools"))
from lupa.lua51 import LuaRuntime


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("provider", type=Path, help="Installed ShortestPathForever directory (read only)")
    args = parser.parse_args()
    provider = args.provider.resolve(strict=True)
    toc = (provider / "ShortestPathForever.toc").read_text(encoding="utf-8")
    assert "## Version: v1.22.4" in toc, "Review this source harness for the installed provider version"
    lua = LuaRuntime(encoding=None, unpack_returned_tuples=True)
    ns = lua.table()
    lua.globals()[b"C_EncodingUtil"] = lua.table_from({
        b"DecodeBase64": lambda value: base64.b64decode(value, validate=True),
        b"DecompressString": lambda value, method: zlib.decompress(value),
    })
    lua.globals()[b"Enum"] = lua.table_from({b"CompressionMethod": lua.table_from({b"Zlib": 1})})
    loaded = []

    def load(relative):
        source = provider / relative
        # No copied modules or writes in the installed addon directory.
        lua.execute(source.read_bytes(), b"ShortestPathForever", ns)
        loaded.append({"path": relative, "sha256": hashlib.sha256(source.read_bytes()).hexdigest()})

    for entry in ET.parse(provider / "Nav/Nav.xml").getroot():
        name = entry.attrib.get("file", "")
        if name.startswith(("Nav0.", "Nav0_", "Nav1.", "Nav1_")):
            load("Nav/" + name)
    for name in ("Routing/PathGrid.lua", "Routing/Path.lua"):
        load(name)
    path = ns[b"Path"]
    cases = [
        # Approximate world anchors, not recorded character spawn positions.
        ("Shadowglen area to Dolanaar area", 1, (10311, 832), (9870, 956)),
        ("Coldridge Valley area to Kharanos area", 0, (-6240, 331), (-5602, -484)),
        ("Goldshire to Stormwind flight master", 0, (-9459, 43), (-8840.56, 489.7)),
    ]
    results = []
    for name, world, start, finish in cases:
        before = time.perf_counter()
        points, cost, expansions = path[b"FindSync"](world,
            lua.table_from({b"x": start[0], b"y": start[1]}),
            lua.table_from({b"x": finish[0], b"y": finish[1]}))
        assert points is not None, (name, cost)
        assert math.isfinite(cost) and cost > 0 and len(points) >= 2
        straight = math.dist(start, finish)
        if name.startswith("Goldshire"):
            assert cost > straight * 1.3, "Terrain route must detour around Stormwind's wall/moat"
        results.append({"scenario": name, "worldMapID": world, "points": len(points),
            "cost_yards": round(cost, 2), "straight_yards": round(straight, 2),
            "expansions": expansions, "seconds": round(time.perf_counter() - before, 3)})
    points, reason, _ = path[b"FindSync"](99999, lua.table_from({b"x": 0, b"y": 0}),
        lua.table_from({b"x": 1, b"y": 1}))
    assert points is None and reason == b"nodata"
    # Exercise the shipped transit planner separately. Endpoint walking costs in
    # this plan are estimates; this does not claim a fully measured journey.
    ns[b"L"] = lua.eval(b"setmetatable({}, {__index=function(_, key) return key end})")
    for name in ("Transport/Model.lua", "Data/Routes.lua", "Data/Transports.lua", "Data/Taxi.lua",
                 "Data/Portals.lua", "Data/Walks.lua", "Routing/Planner.lua"):
        load(name)
    plan = ns[b"Planner"][b"Plan"](lua.table_from({
        b"from": lua.table_from({b"map": 1, b"x": 10311, b"y": 832}),
        b"to": lua.table_from({b"map": 0, b"x": -5602, b"y": -484}),
        b"now": 0, b"walkSpeed": 7, b"faction": b"Alliance", b"otherFaction": False,
        b"docks": ns[b"Docks"], b"routes": ns[b"Routes"],
        b"portals": ns[b"Portals"], b"baked": ns[b"Walks"],
        b"landmasses": ns[b"Landmasses"],
    }))
    assert plan is not None, "No intercontinental plan found"
    legs = [{"mode": leg[b"mode"].decode(), "from_world": leg[b"from"][b"map"],
             "to_world": leg[b"to"][b"map"], "estimated": bool(leg[b"estimated"])}
            for _, leg in plan[b"legs"].items()]
    assert any(leg["mode"] == "boat" and leg["from_world"] != leg["to_world"] for leg in legs)
    report = {"provider": str(provider), "version": "v1.22.4", "result": "PASS",
        "runtime": "project-local Lua 5.1 with Python base64/zlib encoding adapters",
        "limits": "No WoW UI, API navigation, live transport times or client compatibility proven; intercontinental endpoint walks estimated.",
        "walking": results, "intercontinental_plan": {"legs": legs, "taxi_paths": "none supplied",
            "endpoint_walks": "estimated", "live_timetable": False},
        "missing_terrain": "PASS: nodata", "sources": loaded}
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
