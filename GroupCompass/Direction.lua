local _, addon = ...
addon.Direction = {}

-- UnitPosition axes: X increases north, Y increases west.
-- Facing: north = 0, west = pi/2. Positive relative angle means right.
function addon.Direction.Calculate(playerX, playerY, memberX, memberY, facing)
    local north, west = memberX - playerX, memberY - playerY
    local distance = math.sqrt(north * north + west * west)
    if distance < 0.01 then
        return 0, 0
    end
    local bearing = math.atan2(west, north)
    local relative = (facing - bearing + math.pi) % (2 * math.pi) - math.pi
    return relative, distance
end
