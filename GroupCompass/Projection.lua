local _, addon = ...
addon.Projection = {}

-- Pixel offsets from minimap center. Elliptical inset keeps the entire badge
-- inside a circular minimap, including at non-square sizes and at distant edges.
function addon.Projection.Minimap(north, west, facing, rotating, viewRadius, width, height, markerSize)
    local inset = markerSize and math.max(14, markerSize / math.sqrt(2) + 2) or 14
    if viewRadius <= 0 or width <= inset * 2 or height <= inset * 2 then return end
    local east, up = -west, north
    if rotating then
        east = north * math.sin(facing) - west * math.cos(facing)
        up = north * math.cos(facing) + west * math.sin(facing)
    end
    local x, y = east / viewRadius * width / 2, up / viewRadius * height / 2
    -- A square badge's corner needs more inset than its half-width.
    local length = math.sqrt((x / (width / 2 - inset)) ^ 2 + (y / (height / 2 - inset)) ^ 2)
    local edge = length > 1
    if edge then x, y = x / length, y / length end
    return x, y, edge
end
