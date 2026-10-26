local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
addon.Settings.Initialize()
local updates, applied = 0, {}
local waypointsOpened = 0
addon.WaypointUI = {Toggle = function() waypointsOpened = waypointsOpened + 1 end}
addon.Maps = {Refresh = function() updates = updates + 1 end}
addon.MarkerStyle = {Path = "test/", Decorate = function() end, Apply = function(frame, _, kind)
    applied[kind] = addon.Settings.Get()[kind == "world" and "worldSize" or "minimapSize"]
end}
local frames, sliders = {}, {}
local function region()
    return {SetPoint = function() end, SetAllPoints = function() end, SetColorTexture = function() end,
        SetTexture = function() end, SetVertexColor = function() end, SetSize = function() end,
        SetHeight = function() end, SetText = function(self, value) self.text = value end}
end
CreateFrame = function(kind, name, parent)
    local f = {kind = kind, name = name, parent = parent, shown = true, scripts = {}}
    frames[#frames + 1] = f
    if name then _G[name] = f end
    f.SetSize = function(self, w, h) self.width, self.height = w, h end
    f.SetPoint = function(self, ...) self.point = {...} end
    f.ClearAllPoints = function() end; f.CreateTexture = region; f.CreateFontString = region
    f.SetText = function(self, value) self.text = value end
    f.SetScript = function(self, key, value) self.scripts[key] = value end
    f.HookScript = f.SetScript
    f.Show = function(self) self.shown = true; if self.scripts.OnShow then self.scripts.OnShow(self) end end
    f.Hide = function(self) self.shown = false; if self.scripts.OnHide then self.scripts.OnHide(self) end end
    f.IsShown = function(self) return self.shown end
    f.SetShown = function(self, value) if value then self:Show() else self:Hide() end end
    for _, method in ipairs({"SetFrameStrata", "EnableMouse", "SetClampedToScreen", "SetBackdrop",
        "SetBackdropColor", "SetBackdropBorderColor", "SetFrameLevel", "RegisterForClicks", "RegisterForDrag",
        "SetOrientation", "SetMinMaxValues", "SetValueStep", "SetObeyStepOnDrag", "SetThumbTexture"}) do
        f[method] = function() end
    end
    f.GetThumbTexture = region
    f.SetValue = function(self, value) self.value = value; self.scripts.OnValueChanged(self, value) end
    if kind == "Slider" then sliders[#sliders + 1] = f end
    return f
end
UIParent, UISpecialFrames = {}, {}
Minimap = {GetWidth = function() return 200 end, GetHeight = function() return 200 end,
    GetFrameLevel = function() return 5 end, GetCenter = function() return 500, 500 end,
    GetEffectiveScale = function() return 1 end}
GetCursorPosition = function() return 600, 500 end
local time = 10
GetTime = function() return time end
GameTooltip = {IsOwned = function() return false end}
assert(loadfile("GroupCompass/Options.lua"))("GroupCompass", addon)
addon.Options.Initialize(); addon.Options.Initialize()
assert(#frames == 1 and GroupCompassMinimapButton.width == 30, "one border button, lazy panel")
GroupCompassMinimapButton.scripts.OnClick()
assert(GroupCompassOptions.shown and UISpecialFrames[1] == "GroupCompassOptions")
assert(applied.minimap == 20 and applied.world == 24)
local function click(label)
    for _, frame in ipairs(frames) do
        if frame.text == label then frame.scripts.OnClick(frame); return frame end
    end
    error("button not found: " .. label)
end
click("Head & shoulders  v"); click("Star")
assert(GroupCompassDB.icon == "star" and updates == 1)
sliders[1]:SetValue(32); sliders[2]:SetValue(38)
assert(applied.minimap == 32 and applied.world == 38)
click("None  v"); click("Glow"); assert(GroupCompassDB.effect == "glow")
click("Class colors  v"); click("Pink"); assert(GroupCompassDB.colorMode == "pink")
click("Done"); assert(not GroupCompassOptions.shown)
addon.Options.Toggle(); assert(GroupCompassOptions.shown)
local before = updates
GroupCompassMinimapButton.scripts.OnDragStart(GroupCompassMinimapButton)
GroupCompassMinimapButton.scripts.OnUpdate()
GroupCompassMinimapButton.scripts.OnDragStop(GroupCompassMinimapButton)
assert(GroupCompassDB.buttonAngle == 0 and updates == before, "dragging must not refresh world pins")
assert(GroupCompassMinimapButton.scripts.OnUpdate == nil)
GroupCompassMinimapButton.scripts.OnDragStart(GroupCompassMinimapButton)
GroupCompassMinimapButton.scripts.OnHide(GroupCompassMinimapButton)
assert(not GroupCompassMinimapButton.dragged and GroupCompassMinimapButton.scripts.OnUpdate == nil)
time = 11; click("Reset defaults")
assert(GroupCompassDB.icon == "person" and GroupCompassDB.effect == "none" and GroupCompassDB.colorMode == "class")
assert(applied.minimap == 20 and applied.world == 24)
addon.Options.Toggle(); assert(not GroupCompassOptions.shown)
GroupCompassMinimapButton.scripts.OnClick(); assert(GroupCompassOptions.shown)
click("Waypoints & help"); assert(waypointsOpened == 1 and not GroupCompassOptions.shown)
print("PASS: single draggable minimap button, options toggling, controls, live previews, saving and reset")
