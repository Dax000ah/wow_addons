local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
addon.Settings.Initialize()
assert(loadfile("GroupCompass/MarkerStyle.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Compat.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Projection.lua"))("GroupCompass", addon)
local mapMembers, requestedMap, mapSamples = {}, nil, 0
addon.Tracking = { MapMembers = function(id)
    requestedMap, mapSamples = id, mapSamples + 1
    return mapMembers
end }
local function near(actual, expected) assert(math.abs(actual - expected) < 0.000001) end
local function region()
    return {
        SetAllPoints = function() end, SetPoint = function() end,
        ClearAllPoints = function() end, SetWordWrap = function() end,
        GetFont = function() return "test-font", 10, "" end, SetFont = function() end,
        SetWidth = function() end,
        GetStringWidth = function(self) return #(self.text or "") * 6 end,
        SetShown = function(self, value) self.shown = value end,
        Hide = function(self) self.shown = false end,
        Show = function(self) self.shown = true end,
        SetSize = function(self, w, h) self.width, self.height = w, h end,
        SetTexture = function(self, texture) self.texture = texture end,
        SetVertexColor = function(self, ...) self.color = {...} end,
        SetAlpha = function(self, value) self.alpha = value end,
        SetBlendMode = function() end,
        SetColorTexture = function(self, ...) self.color = {...} end,
        SetText = function(self, text) self.text = text end,
        SetTextColor = function() end,
    }
end
local minimapFrames, allocations = {}, 0
local function frame()
    return {
        shown = false, scripts = {},
        SetSize = function(self, w, h) self.width, self.height = w, h end, CreateTexture = region, CreateFontString = region,
        HookScript = function(self, event, fn) self.hooks = self.hooks or {}; self.hooks[event] = fn end,
        SetFrameLevel = function() end, EnableMouse = function() end,
        SetMouseClickEnabled = function(self, value) self.clickEnabled = value end, ClearAllPoints = function() end,
        SetPoint = function(self, ...) self.point = {...} end,
        SetAlpha = function(self, alpha) self.alpha = alpha end,
        SetScript = function(self, event, fn) self.scripts[event] = fn end,
        Show = function(self) self.shown = true end,
        SetShown = function(self, value) if value then self:Show() else self:Hide() end end,
        RegisterEvent = function() end,
        Hide = function(self)
            self.shown = false
            if self.scripts.OnHide then self.scripts.OnHide(self) end
            if self.hooks and self.hooks.OnHide then self.hooks.OnHide(self) end
        end,
    }
end
CreateFrame = function()
    allocations = allocations + 1
    local marker = frame(); minimapFrames[#minimapFrames + 1] = marker; return marker
end
local radius, rotating, ignored, minimapShown = 100, false, false, true
Minimap = {
    IsShown = function() return minimapShown end,
    GetWidth = function() return 200 end, GetHeight = function() return 200 end,
    GetFrameLevel = function() return 5 end,
}
C_Minimap = {
    GetViewRadius = function() return radius end,
    IsRotateMinimapIgnored = function() return ignored end,
}
GetCVarBool = function(name) assert(name == "rotateMinimap"); return rotating end
GameTooltip = {
    IsOwned = function(self, marker) return self.owner == marker end,
    SetOwner = function(self, marker) self.owner = marker end,
    SetText = function(self, text, ...) self.text = text; self.color = {...} end,
    AddLine = function(self, text) self.line = text end,
    Show = function() end, Hide = function(self) self.owner = nil end,
}
CreateFromMixins = function(...)
    local result = {}
    for _, mixin in ipairs({...}) do for k,v in pairs(mixin) do result[k] = v end end
    return result
end
MapCanvasPinMixin = {OnReleased = function(self) self.released = true end}
MapCanvasDataProviderMixin = {
    OnAdded = function(self, map) self.map = map end,
    GetMap = function(self) return self.map end,
    OnRemoved = function(self) self.map = nil end,
}
assert(loadfile("GroupCompass/Maps.lua"))("GroupCompass", addon)
local member = {unit = "party1", slot = 1, name = "Ally", color = {0.3, 0.8, 1},
    north = 25, west = 0, facing = math.pi / 2, distance = 25, x = 0.2, y = 0.7}
addon.Maps.Update({member}, true) -- World map is not loaded yet.
assert(#minimapFrames == 1 and minimapFrames[1].shown)
local marker = minimapFrames[1]
near(marker.point[4], 0); near(marker.point[5], 25)
assert(marker.fill.texture:find("person.tga", 1, true) and marker.fill.color[1] == 0.3 and marker.width == 20)
assert(not marker.clickEnabled, "party markers must pass map clicks through")
marker.scripts.OnEnter(marker)
assert(GameTooltip.text == "[1] Ally")
assert(GameTooltip.color[1] == member.color[1] and GameTooltip.color[3] == member.color[3])
addon.Maps.Update({member}, true)
assert(allocations == 1 and GameTooltip.owner == marker, "hover should persist while updating")
rotating = true; addon.Maps.Update({member}, true)
near(marker.point[4], 25); near(marker.point[5], 0)
ignored = true; addon.Maps.Update({member}, true)
near(marker.point[4], 0); near(marker.point[5], 25)
member.north = 200; member.distance = 200
addon.Maps.Update({member}, true)
assert(marker.edge and marker.alpha == 0.75)
near(marker.point[5], 100 - 20 / math.sqrt(2) - 2)
radius = 0; addon.Maps.Update({member}, true)
assert(not marker.shown and GameTooltip.owner == nil)
radius = 100; addon.Maps.Update({member}, true)
assert(marker.shown)
minimapShown = false; addon.Maps.Update({member}, true); assert(not marker.shown)
minimapShown = true

-- Classic has no modern radius API or IsRotateMinimapIgnored namespace method.
local modernMinimap = C_Minimap
C_Minimap = nil
GetBuildInfo = function() return "1.15.9", "70003", "Sep 23 2026", 11509 end
GetCVar = function(name) return name == "minimapZoom" and "0" or "1" end
Minimap.GetZoom = function() return 0 end
rotating = false; member.north = 25; member.distance = 25
addon.Maps.Update({member}, true)
assert(marker.shown)
near(marker.point[5], 25 / ((466 + 2/3) / 2) * 100)
C_Minimap = modernMinimap

local pins, acquired, removed, inactive, created = {}, 0, 0, {}, 0
local map = {shown = true, id = 123}
map.IsShown = function(self) return self.shown end
map.GetMapID = function(self) return self.id end
map.AddDataProvider = function(self, provider)
    assert(not self.provider, "duplicate data provider")
    self.provider = provider; provider:OnAdded(self); provider:RefreshAllData()
end
map.AcquirePin = function(_, template, data)
    assert(template == "GroupCompassWorldPinTemplate")
    local pin = table.remove(inactive)
    if not pin then
        pin = frame()
        for key, value in pairs(GroupCompassWorldPinMixin) do pin[key] = value end
        pin.UseFrameLevelType = function() end
        pin.SetScalingLimits = function() end
        pin.SetPosition = function(self, x, y) self.x, self.y = x, y end
        -- Blizzard's frame pool resets a newly created pin BEFORE AcquirePin
        -- calls OnLoad. This is not an initialized marker yet.
        pin:Hide(); pin:ClearAllPoints(); pin:OnReleased()
        assert(not pin.fill and not pin.glow and not pin.outline)
        pin:OnLoad()
        created = created + 1
    end
    pin:Show(); pin:OnAcquired(data)
    pins[pin] = true; acquired = acquired + 1
    return pin
end
map.RemovePin = function(_, pin)
    assert(pins[pin], "removing an unowned pin")
    pins[pin] = nil; pin:Hide(); pin:ClearAllPoints(); pin:OnReleased()
    inactive[#inactive + 1] = pin
    removed = removed + 1
end
map.RemoveAllPinsByTemplate = function(self, template)
    assert(template == "GroupCompassWorldPinTemplate")
    for pin in pairs(pins) do self:RemovePin(pin) end
end
WorldMapFrame = map; mapMembers = {member}
addon.Maps.Update({member}, true)
assert(requestedMap == 123 and acquired == 1)
local pin = next(pins)
assert(pin.x == 0.2 and pin.y == 0.7 and pin.width == 24)
assert(not pin.clickEnabled, "party pins should not intercept map clicks")
addon.Settings.Set("worldSize", 38); addon.Settings.Set("minimapSize", 30)
addon.Settings.Set("colorMode", "gold"); addon.Settings.Set("icon", "shield")
addon.Maps.Refresh()
assert(pin.width == 38 and marker.width == 30 and pin.fill.texture:find("shield.tga", 1, true))
assert(pin.fill.color[1] == 1 and marker.fill.color[1] == 1)
pin:OnMouseEnter(); assert(GameTooltip.text == "[1] Ally" and GameTooltip.color[1] == 1)
member.x = 0.6; addon.Maps.Update({member}, true)
assert(acquired == 1 and pin.x == 0.6, "pins should be reused, not reacquired each tick")
map.id = 456; mapMembers = {}; map.provider:RefreshAllData()
assert(requestedMap == 456 and not next(pins) and removed == 1 and GameTooltip.owner == nil)
mapMembers = {member}; addon.Maps.Update({member}, true)
assert(next(pins) == pin and pin.shown and pin.member == member and created == 1,
    "released pins must be reused with artwork and member data intact")
map.provider:OnHide(); assert(not next(pins))
map.shown = false; local before = mapSamples
addon.Maps.Update({member}, true); assert(mapSamples == before)
map.shown = true; addon.Maps.Update({member}, true)
addon.Maps.Update({}, false)
assert(not next(pins) and not marker.shown, "off/demo must remove all custom markers")
addon.Maps.Update({member}, true)
addon.Maps.Update({}, true); mapMembers = {}; map.provider:RefreshAllData()
assert(not marker.shown and not next(pins), "no stale roster markers")
map.provider:OnRemoved(map); map.provider = nil
addon.Maps.Update({member}, true); assert(map.provider, "provider should reattach after removal")
print("PASS: lazy map loading, pin lifecycle, minimap markers, zoom/range, rotation, hover and cleanup")
addon.Maps.Update({}, false); mapMembers = {}
local tomtomPoint={source="tomtom",kind="waypoint",north=25,west=0,facing=0,color={1,.78,.25},slot=1000001,name="TomTom"}
addon.Maps.Update({tomtomPoint},true)
assert(not marker.shown and not next(pins), "TomTom's own pins must not be duplicated")
addon.Maps.Update({tomtomPoint,member},true)
assert(marker.shown and marker.member==member, "filtering provider points must retain contiguous member markers")
io.write("PASS: TomTom points are excluded from custom maps; party pins and click pass-through remain intact\n")

-- Compose the actual compass with the map provider: first party-pin allocation
-- must not abort the refresh before the member's name is drawn on the bar.
addon.Maps.Update({}, false)
inactive = {} -- The next party refresh must construct a fresh pooled pin.
local core, names = nil, {}
CreateFrame = function(_, name)
    local result = frame()
    if name == "GroupCompassFrame" then
        core = result
        result.CreateFontString = function()
            local text = region(); names[#names + 1] = text; return text
        end
    end
    return result
end
UIParent, SlashCmdList = {}, {}
addon.Options = {Initialize = function() end}
addon.WaypointUI = {Refresh = function() end}
addon.Waypoints = {Initialize = function() end, Refresh = function() end,
    Sample = function() return {}, 0 end}
addon.Routing = {Refresh = function() end,
    CanStop = function() return false end}
addon.Tracking.Facing = function() return 0 end
addon.Tracking.Sample = function() return mapMembers, "Character facing - center is ahead" end
member.angle = 0
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Layout.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Core.lua"))("GroupCompass", addon)
core.scripts.OnEvent(core, "ADDON_LOADED", "GroupCompass")
for _ = 1, 3 do
    mapMembers = {member}
    core.scripts.OnEvent(core, "GROUP_ROSTER_UPDATE")
    assert(names[2].shown and names[2].text == "[1] Ally" and next(pins),
        "first party pin and compass name must both render on roster update")
    -- OpenMap's zone/world switching refreshes the map data providers.
    map.id = 947; map.provider:RefreshAllData()
    map.provider:OnHide(); assert(not next(pins))
    map.id = 1438
    core.scripts.OnUpdate(core, 0.1)
    assert(names[2].shown and next(pins))
    mapMembers = {}
    core.scripts.OnEvent(core, "GROUP_ROSTER_UPDATE")
    assert(not names[2].shown and not next(pins))
end
io.write("PASS: pre-OnLoad pool reset, pin recycling, party join/leave and actual compass/map refresh composition\n")
