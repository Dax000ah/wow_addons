local addon = {}
assert(loadfile("GroupCompass/Compat.lua"))("GroupCompass", addon)
local compat = addon.Compat
GetAddOnMetadata = function(name, field)
    assert(name == "GroupCompass" and field == "Version"); return "legacy-version"
end
assert(compat.Version() == "legacy-version")
C_AddOns = {GetAddOnMetadata = function() return "modern-version" end}
assert(compat.Version() == "modern-version")
GetAddOnMetadata, C_AddOns = nil, nil; assert(compat.Version() == "unknown")
local interface, mode, zoom, outdoors, indoors = 11509, "outdoor", 0, 0, 0
GetBuildInfo = function() return "1.15.9", "70003", "Sep 23 2026", interface end
C_Minimap = {GetViewRadius = function() return 123 end}
assert(compat.MinimapRadius() == 123)
C_Minimap.GetViewRadius = function() return nil end
assert(compat.MinimapRadius() == nil, "do not override an unavailable native radius")
C_Minimap = nil
local probes = 0
Minimap = {
    GetZoom = function() return zoom end,
    SetZoom = function(_, value)
        assert(compat.IsProbingMinimap(), "only temporary probes may change native zoom")
        zoom = value; probes = probes + 1
        if mode == "outdoor" then outdoors = value else indoors = value end
        assert(compat.MinimapRadius() == nil, "probe must not recurse")
    end,
}
GetCVar = function(name) return tostring(name == "minimapZoom" and outdoors or indoors) end
local function near(actual, expected) assert(math.abs(actual - expected) < 0.000001) end
near(compat.MinimapRadius(), (466 + 2/3) / 2)
assert(zoom == 0 and outdoors == 0 and indoors == 0 and probes == 2, "probe must restore both settings")
compat.MinimapRadius(); assert(probes == 2, "unchanged modes should not be probed each tick")
mode = "indoor"; compat.InvalidateMinimapRadius()
near(compat.MinimapRadius(), 150)
assert(zoom == 0 and outdoors == 0 and indoors == 0 and probes == 4)
outdoors, indoors, zoom = 0, 3, 3; near(compat.MinimapRadius(), 60)
outdoors, indoors, zoom = 2, 0, 2; near(compat.MinimapRadius(), (333 + 1/3) / 2)
local expected = {
    outdoor = {[0] = 466 + 2/3, 400, 333 + 1/3, 266 + 2/6, 200, 133 + 1/3},
    indoor = {[0] = 300, 240, 180, 120, 80, 50},
}
for _, activeMode in ipairs({"outdoor", "indoor"}) do
    mode = activeMode
    for level = 0, 5 do
        outdoors, indoors, zoom = level, level, level
        compat.InvalidateMinimapRadius()
        near(compat.MinimapRadius(), expected[mode][level] / 2)
        assert(zoom == level and outdoors == level and indoors == level)
    end
end
interface = 16001; assert(compat.MinimapRadius() == nil, "fallback is limited to Classic Era")
interface = 11509; zoom = 99; assert(compat.MinimapRadius() == nil)
Minimap = nil; assert(compat.MinimapRadius() == nil)
print("PASS: metadata APIs, native radius, Classic radius/zoom modes, probe restoration/cache and reentrancy")
