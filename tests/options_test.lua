local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
addon.Settings.Initialize()
local updates, applied = 0, {}
local compassUpdates = 0
addon.Compass = {RefreshAppearance=function() compassUpdates=compassUpdates+1 end}
local waypointsOpened = 0
local routesOpened = 0
addon.RouteMenu = {Toggle = function(anchor) assert(anchor == GroupCompassMinimapButton); routesOpened = routesOpened + 1 end}
addon.WaypointUI = {Toggle = function() waypointsOpened = waypointsOpened + 1 end}
local opened,openError={}
addon.Waypoints={OpenSettings=function() opened[#opened+1]="tomtom";return not openError,openError end}
addon.Routing={OpenSettings=function(section)opened[#opened+1]=section;return not openError,openError end}
SlashCmdList={ACECONSOLE_RXP=function(input)assert(input=="");opened[#opened+1]="rxp" end}
addon.Maps = {Refresh = function() updates = updates + 1 end}
addon.MarkerStyle = {Path = "test/", Decorate = function() end, Apply = function(frame, _, kind)
    applied[kind] = addon.Settings.Get()[kind == "world" and "worldSize" or "minimapSize"]
end}
local frames, sliders = {}, {}
local function region()
    return {SetPoint = function() end, SetAllPoints = function() end, SetColorTexture = function() end,
        SetTexture = function() end, SetVertexColor = function() end, SetSize = function() end,
        SetHeight = function() end, SetWidth = function() end, SetText = function(self, value) self.text = value end}
end
CreateFrame = function(kind, name, parent)
    local f = {kind = kind, name = name, parent = parent, shown = true, scripts = {}}
    frames[#frames + 1] = f
    if name then _G[name] = f end
    f.SetSize = function(self, w, h) self.width, self.height = w, h end
    f.SetPoint = function(self, ...) self.point = {...} end
    f.ClearAllPoints = function() end; f.CreateTexture = region; f.CreateFontString = region
    f.SetAllPoints = function() end
    f.SetEnabled = function(self, enabled) self.enabled = enabled end
    f.SetMinMaxValues = function(self, low, high)
        self.minimum,self.maximum=low,high
        if self.value and (self.value<low or self.value>high) then
            self:SetValue(math.max(low,math.min(high,self.value)))
        end
    end
    f.SetChecked=function(self,value) self.checked=value end
    f.GetChecked=function(self) return self.checked end
    f.SetText = function(self, value) self.text = value end
    f.SetScript = function(self, key, value) self.scripts[key] = value end
    f.HookScript = f.SetScript
    f.Show = function(self) self.shown = true; if self.scripts.OnShow then self.scripts.OnShow(self) end end
    f.Hide = function(self) self.shown = false; if self.scripts.OnHide then self.scripts.OnHide(self) end end
    f.IsShown = function(self) return self.shown end
    f.SetShown = function(self, value) if value then self:Show() else self:Hide() end end
    for _, method in ipairs({"SetFrameStrata", "EnableMouse", "SetClampedToScreen", "SetBackdrop",
        "SetBackdropColor", "SetBackdropBorderColor", "SetFrameLevel", "RegisterForClicks", "RegisterForDrag",
        "SetOrientation", "SetValueStep", "SetObeyStepOnDrag", "SetThumbTexture"}) do
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
GameTooltip = {IsOwned=function(self,owner)return self.owner==owner end,
    SetOwner=function(self,owner)self.owner=owner end,SetText=function(self,value)self.title=value end,
    AddLine=function(self,value,_,_,_,wrap)self.help=value;self.wrap=wrap end,
    Show=function()end,Hide=function(self)self.owner=nil end}
assert(loadfile("GroupCompass/Options.lua"))("GroupCompass", addon)
addon.Options.Initialize(); addon.Options.Initialize()
assert(#frames == 1 and GroupCompassMinimapButton.width == 30, "one border button, lazy panel")
GroupCompassMinimapButton.scripts.OnClick(GroupCompassMinimapButton, "RightButton")
assert(routesOpened == 1 and not GroupCompassOptions, "right click opens routing without opening options")
GroupCompassMinimapButton.scripts.OnClick()
assert(GroupCompassOptions.shown and UISpecialFrames[1] == "GroupCompassOptions")
local function click(label)
    for _, frame in ipairs(frames) do
        if frame.text == label then frame.scripts.OnClick(frame); return frame end
    end
    error("button not found: " .. label)
end
assert(#sliders==5 and sliders[1].parent.shown and not sliders[4].parent.shown)
local mapBefore=updates
sliders[1]:SetValue(1000); sliders[3]:SetValue(20)
assert(GroupCompassDB.compassWidth==1000 and GroupCompassDB.textSize==20)
assert(GroupCompassDB.compassHeight==76 and sliders[2].minimum==76 and sliders[2].value==76)
assert(compassUpdates==2 and updates==mapBefore, 'compass changes must not rebuild world pins')
sliders[2]:SetValue(120); assert(GroupCompassDB.compassHeight==120)
click('Map markers')
assert(not sliders[1].parent.shown and sliders[4].parent.shown)
assert(applied.minimap == 20 and applied.world == 24)
click("Head & shoulders  v"); click("Star")
assert(GroupCompassDB.icon == "star" and updates == 1)
sliders[4]:SetValue(32); sliders[5]:SetValue(38)
assert(applied.minimap == 32 and applied.world == 38)
click("None  v"); click("Glow"); assert(GroupCompassDB.effect == "glow")
click("Class colors  v"); click("Pink"); assert(GroupCompassDB.colorMode == "pink")
click("Done"); assert(not GroupCompassOptions.shown)
addon.Options.Toggle(); assert(GroupCompassOptions.shown)
local before = updates
GroupCompassMinimapButton.scripts.OnDragStart(GroupCompassMinimapButton)
GroupCompassMinimapButton.scripts.OnClick(GroupCompassMinimapButton, "RightButton")
assert(routesOpened == 1, "drag must suppress route menu too")
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
assert(GroupCompassDB.compassWidth==620 and GroupCompassDB.compassHeight==46 and GroupCompassDB.textSize==10)
click('Compass'); assert(sliders[1].parent.shown and not sliders[4].parent.shown)
assert(sliders[1].value==620 and sliders[2].minimum==46 and sliders[3].value==10)
addon.Options.Toggle(); assert(not GroupCompassOptions.shown)
GroupCompassMinimapButton.scripts.OnClick(); assert(GroupCompassOptions.shown)
click("Waypoints & help"); assert(waypointsOpened == 1 and not GroupCompassOptions.shown)
print("PASS: single draggable minimap button, options toggling, controls, live previews, saving and reset")

local toggle
for _,f in ipairs(frames) do if f.kind=="CheckButton" then toggle=f end end
assert(toggle and toggle.checked==true and toggle.parent==sliders[1].parent)
local mapCount,compassCount=updates,compassUpdates
toggle:SetChecked(false);toggle.scripts.OnClick(toggle)
assert(GroupCompassDB.showElsewhere==false and not toggle.checked)
assert(updates==mapCount and compassUpdates==compassCount+1,"toggle updates only the compass immediately")
addon.Settings.Initialize();addon.Options.Refresh();assert(not toggle.checked)
click("Reset defaults");assert(toggle.checked and GroupCompassDB.showElsewhere)
print("PASS: Compass Elsewhere checkbox, live refresh, persistence, reset and unchanged map pins")

addon.Options.Toggle();click("Other addons")
assert(not sliders[1].parent.shown and not sliders[4].parent.shown)
local pathButton=click("Shortest Path settings")
assert(opened[#opened]=="" and not GroupCompassOptions.shown)
addon.Options.Toggle();click("Other addons");click("RestedXP settings")
assert(opened[#opened]=="rxp" and not GroupCompassOptions.shown)
addon.Options.Toggle();click("Other addons");click("TomTom settings")
assert(opened[#opened]=="tomtom" and not GroupCompassOptions.shown)
addon.Options.Toggle();click("Other addons");local reportButton=click("Route report (diagnostics)")
assert(opened[#opened]=="report" and not GroupCompassOptions.shown)
reportButton.scripts.OnEnter(reportButton)
assert(GameTooltip.wrap and GameTooltip.help:find("does not change the route",1,true))
reportButton.scripts.OnLeave(reportButton);assert(not GameTooltip.owner)
addon.Options.Toggle();click("Other addons");openError="Settings unavailable";click("Shortest Path settings")
assert(GroupCompassOptions.shown,"failed links keep Options open")
openError=nil;SlashCmdList.ACECONSOLE_RXP=nil;click("RestedXP settings")
assert(GroupCompassOptions.shown,"missing RXP settings handler must not throw or close the panel")
click("Compass");assert(sliders[1].parent.shown and not sliders[4].parent.shown)
print("PASS: Other addons tab, native settings/report handoffs, help, missing addons, errors and tab reuse")
