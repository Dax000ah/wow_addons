local addon = {}
assert(loadfile("GroupCompass/Projection.lua"))("GroupCompass", addon)
local function check(north, west, facing, rotating, radius, width, height, ex, ey, edge)
    local x, y, clamped = addon.Projection.Minimap(north, west, facing, rotating, radius, width, height)
    assert(math.abs(x - ex) < 0.000001 and math.abs(y - ey) < 0.000001, "wrong minimap projection")
    assert(clamped == edge, "wrong edge state")
end
check(25, 0, 0, false, 100, 200, 200, 0, 25, false)
check(0, -25, 0, false, 100, 200, 200, 25, 0, false)
check(0, 25, 0, false, 100, 200, 200, -25, 0, false)
check(-25, 0, 0, false, 100, 200, 200, 0, -25, false)
check(0, 25, math.pi / 2, true, 100, 200, 200, 0, 25, false)
check(25, 0, math.pi / 2, true, 100, 200, 200, 25, 0, false)
check(25, 0, math.pi / 2, false, 100, 200, 200, 0, 25, false)
check(200, 0, 0, false, 100, 200, 200, 0, 86, true)
check(25, 0, 0, false, 50, 200, 200, 0, 50, false) -- zoom
check(0, 0, 0, false, 100, 200, 200, 0, 0, false)
local x, y, edge = addon.Projection.Minimap(400, -300, 0, false, 100, 240, 160)
assert(edge and (x / 106)^2 + (y / 66)^2 < 1.000001)
-- The four corners of an edge badge stay inside the round map's mask.
x, y = addon.Projection.Minimap(200, -200, 0, false, 100, 200, 200)
for _, dx in ipairs({-9, 9}) do
    for _, dy in ipairs({-9, 9}) do assert((x + dx)^2 + (y + dy)^2 <= 100^2) end
end
assert(not addon.Projection.Minimap(1, 1, 0, false, 0, 200, 200))
assert(not addon.Projection.Minimap(1, 1, 0, false, 100, 20, 20))
print("PASS: minimap cardinals, rotation, zoom, overlap, clamping, non-square size and invalid dimensions")
