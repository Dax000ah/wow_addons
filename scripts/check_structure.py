"""Dependency-free starter structure and TOC validation; does not execute Lua."""
from pathlib import Path
import xml.etree.ElementTree as ET

root = Path(__file__).resolve().parents[1]
required = [
    ".gitignore", "README.md", "docs/FEASIBILITY.md", "docs/TESTING.md",
    "docs/PROJECT_STATUS.md", "GroupCompass/GroupCompass.toc",
    "GroupCompass/Direction.lua", "GroupCompass/Tracking.lua",
    "GroupCompass/Core.lua", "tests/direction_test.lua",
    "tests/tracking_test.lua", "tests/core_test.lua", "requirements-dev.txt",
    "scripts/run_tests.py", "scripts/build_zip.py",
    "GroupCompass/Projection.lua", "GroupCompass/Maps.lua", "GroupCompass/Maps.xml",
    "tests/projection_test.lua", "tests/maps_test.lua",
    "GroupCompass/Compat.lua", "tests/classic_test.lua", "tests/compat_test.lua",
    "GroupCompass/Demo.lua", "tests/demo_test.lua",
    "GroupCompass/Layout.lua", "tests/layout_test.lua",
]
for name in required:
    path = root / name
    assert path.is_file() and path.stat().st_size, f"Missing or empty: {name}"
toc = root / "GroupCompass/GroupCompass.toc"
lines = toc.read_text(encoding="utf-8").splitlines()
assert "## Interface: 11509, 16001" in lines
scripts = [line.strip() for line in lines if line.strip() and not line.startswith("#")]
assert scripts == ["Compat.lua", "Direction.lua", "Projection.lua", "Layout.lua", "Tracking.lua", "Demo.lua", "Maps.lua", "Maps.xml", "Core.lua"], "Incorrect load order"
for name in scripts:
    assert (toc.parent / name).is_file(), f"TOC references missing file: {name}"
assert set(scripts) == {path.name for path in toc.parent.iterdir() if path.suffix in (".lua", ".xml")}, "Orphan runtime file"
xml = ET.parse(toc.parent / "Maps.xml").getroot()
template = xml.find("{http://www.blizzard.com/wow/ui/}Frame")
assert template is not None and template.attrib["name"] == "GroupCompassWorldPinTemplate"
assert template.attrib["virtual"] == "true"
assert template.attrib["mixin"] == "MapCanvasPinMixin, GroupCompassWorldPinMixin"
print("PASS: starter files, Classic/Forever interfaces, TOC paths/order, XML pin template, no orphan runtime files")
