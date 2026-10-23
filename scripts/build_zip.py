"""Create an installable addon ZIP; refuse to overwrite an existing archive."""
from pathlib import Path
import runpy
from zipfile import ZipFile, ZIP_DEFLATED

root = Path(__file__).resolve().parents[1]
runpy.run_path(str(root / "scripts/check_structure.py"), run_name="__main__")
addon = root / "GroupCompass"
toc = addon / "GroupCompass.toc"
lines = toc.read_text(encoding="utf-8").splitlines()
version = next(line.split(":", 1)[1].strip() for line in lines if line.startswith("## Version:"))
files = [toc] + [addon / line.strip() for line in lines if line.strip() and not line.startswith("#")]
output = root / "dist" / f"GroupCompass-{version}.zip"
output.parent.mkdir(exist_ok=True)
with ZipFile(output, "x", ZIP_DEFLATED) as archive:
    for path in files:
        archive.write(path, path.relative_to(root).as_posix())
with ZipFile(output) as archive:
    assert archive.testzip() is None, "ZIP integrity check failed"
    assert set(archive.namelist()) == {p.relative_to(root).as_posix() for p in files}
    for path in files:
        assert archive.read(path.relative_to(root).as_posix()) == path.read_bytes()
print(f"PASS: installable ZIP paths, integrity, and byte-for-byte source match: {output}")
