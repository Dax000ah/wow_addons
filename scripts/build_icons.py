"""Generate original, antialiased 32-bit TGA marker masks; standard library only."""
from pathlib import Path
import math
import struct

ROOT = Path(__file__).resolve().parents[1] / "GroupCompass" / "Textures"
ROOT.mkdir(exist_ok=True)


def disk(x, y, cx, cy, r):
    return (x-cx)**2 + (y-cy)**2 <= r*r


def polygon(x, y, points):
    inside = False
    for (ax, ay), (bx, by) in zip(points, points[1:] + points[:1]):
        if (ay > y) != (by > y) and x < (bx-ax)*(y-ay)/(by-ay)+ax:
            inside = not inside
    return inside


def segment(x, y, ax, ay, bx, by, width=2):
    t = max(0, min(1, ((x-ax)*(bx-ax)+(y-ay)*(by-ay))/((bx-ax)**2+(by-ay)**2)))
    return disk(x, y, ax+t*(bx-ax), ay+t*(by-ay), width/2)


def shape(name, x, y):
    if name == "person":
        head = disk(x, y, 16, 9, 5) and not disk(x, y, 16, 9, 2.6)
        shoulders = (18 <= y <= 28 and 6 <= x <= 26 and
                     (abs(((x-16)/10)**2+((y-28)/10)**2-1) < .3 or y >= 25.5))
        return head or shoulders
    if name == "body":
        return disk(x, y, 16, 5, 3) or any(segment(x, y, *line, 2.8) for line in
            [(16, 11, 16, 21), (8, 13, 24, 13), (16, 21, 10, 29), (16, 21, 22, 29)])
    if name == "face":
        r = math.hypot(x-16, y-16)
        return 10.5 <= r <= 13 or disk(x, y, 12, 12, 1.5) or disk(x, y, 20, 12, 1.5) or (
            18 <= y <= 23 and 5 <= math.hypot(x-16, y-16) <= 7)
    if name == "diamond": return abs(x-16)+abs(y-16) <= 13
    if name == "pin":
        return (disk(x, y, 16, 12, 9) or polygon(x, y, [(8, 16), (24, 16), (16, 30)])) and not disk(x, y, 16, 12, 3.5)
    if name == "shield": return polygon(x, y, [(4, 3), (28, 3), (26, 19), (23, 24), (16, 30), (9, 24), (6, 19)])
    if name == "star":
        points = [(16+math.cos(i*math.pi/5-math.pi/2)*(14 if i%2 == 0 else 6),
                   16+math.sin(i*math.pi/5-math.pi/2)*(14 if i%2 == 0 else 6)) for i in range(10)]
        return polygon(x, y, points)
    if name == "flag": return 5 <= x <= 8 and 3 <= y <= 30 or polygon(x, y, [(8, 4), (28, 4), (22, 12), (28, 20), (8, 20)])
    if name == "circle": return disk(x, y, 16, 16, 14)
    if name == "square": return 4 <= x <= 28 and 4 <= y <= 28
    if name == "ring": return 12 <= math.hypot(x-16, y-16) <= 14.5
    if name == "glow": return max(0, math.exp(-((x-16)**2+(y-16)**2)/85)-.045)/.955
    raise ValueError(name)


for name in ["person", "body", "face", "diamond", "pin", "shield", "star", "flag", "circle", "square", "ring", "glow"]:
    data = bytearray(struct.pack("<BBBHHBHHHHBB", 0, 0, 2, 0, 0, 0, 0, 0, 32, 32, 32, 0x28))
    for y in range(32):
        for x in range(32):
            alpha = sum(float(shape(name, x+(sx+.5)/4, y+(sy+.5)/4))
                        for sy in range(4) for sx in range(4))/16
            data.extend((255, 255, 255, round(alpha*255)))
    (ROOT / (name + ".tga")).write_bytes(data)
print("PASS: generated 12 original 32x32 RGBA TGA textures")
