-- Run from the repository root using a Lua 5.1 interpreter.
local addon = {}
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
local function check(x, y, facing, expected, expectedDistance)
    local angle, distance = addon.Direction.Calculate(0, 0, x, y, facing)
    assert(math.abs(angle - expected) < 0.000001, "incorrect relative angle")
    assert(math.abs(distance - expectedDistance) < 0.000001, "incorrect distance")
end
check(10, 0, 0, 0, 10) -- North ahead
check(0, -10, 0, math.pi / 2, 10) -- East right
check(0, 10, 0, -math.pi / 2, 10) -- West left
check(-10, 0, 0, -math.pi, 10) -- South behind
check(0, 10, math.pi / 2, 0, 10) -- Facing west
check(10, 0, 2 * math.pi - 0.1, -0.1, 10) -- Wrap around north
check(0, 0, 0, 0, 0) -- Same location
local angle, distance = addon.Direction.Calculate(100, 200, 103, 204, 0)
assert(math.abs(distance - 5) < 0.000001 and angle < 0)
print("PASS: 8 direction cases")
