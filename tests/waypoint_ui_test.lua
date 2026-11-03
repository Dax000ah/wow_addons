local addon, points, frames = {}, {}, {}
local opened, settingsOpened = 0, 0
local routeSettingsOpened = 0
local regions = {}
local attempts, force, stops = 0, nil, 0
addon.Routing = {Status=function() return "Provider status" end, CanStop=function() return true end,
    OpenSettings=function() routeSettingsOpened=routeSettingsOpened+1; return true end,
    Refresh=function() end, Stop=function() stops=stops+1; return true,"Stopped" end,
    Start=function(id,replace)
        attempts=attempts+1; force=replace
        if not replace then return false,"replace","Confirm replacement" end
        return true,nil,"Requested"
    end}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Tracking.lua"))("GroupCompass",addon)
addon.Tracking.PlayerState = function() return {x=500,y=1500,map=1,facing=0} end
addon.MarkerStyle = {Path = "Interface\\AddOns\\GroupCompass\\Textures\\"}
CreateVector2D = function(x,y) return {GetXY = function() return x,y end} end
C_Map = {
    GetBestMapForUnit = function() return 10 end,
    GetPlayerMapPosition = function() return CreateVector2D(.3,.4) end,
    GetWorldPosFromMapPos = function() return 1,CreateVector2D(600,1700) end,
    GetMapInfo = function() return {name="Test zone"} end,
}
addon.TomTomBridge={Provider=function() return addon.TomTomBridge end,
    MapShortcut=function() return "Alt + right-click" end,
    List=function() return points end,
    Add=function(map,x,y,name,icon)
        local p={id=#points+1,mapID=map,x=x,y=y,name=name,icon=icon or "tomtom",source="tomtom",tag="T"..(#points+1)}
        p.label="["..p.tag.."] "..name; points[#points+1]=p; return p
    end,
    Update=function(p,name,icon) p.name,p.icon,p.label=name,icon,"["..p.tag.."] "..name; return p end,
    Remove=function(p) for i,item in ipairs(points) do if item==p then table.remove(points,i); return true end end end}
assert(loadfile("GroupCompass/Waypoints.lua"))("GroupCompass", addon)
addon.Waypoints.Initialize()
addon.Waypoints.OnChanged = function() points=addon.Waypoints.List(); addon.WaypointUI.Refresh() end
local function region()
    local r = {SetPoint = function() end, SetText = function(self, text) self.text = text end,
        SetWidth = function() end, SetWordWrap = function() end, SetHeight=function() end,
        SetSize=function() end, SetTexture=function(self,path) self.path=path end, SetVertexColor=function() end}
    regions[#regions+1]=r; return r
end
CreateFrame = function(kind, name, parent)
    local f = {kind = kind, name = name, shown = true, scripts = {}, parent = parent, text = ""}
    frames[#frames+1] = f; if name then _G[name] = f end
    f.SetSize = function(self,w,h) self.width,self.height = w,h end
    f.SetHeight = function(self,h) self.height = h end
    f.SetPoint = function() end; f.CreateFontString = region
    f.CreateTexture = function(self) self.texture=region(); return self.texture end
    f.SetBackdropBorderColor = function(self,...) self.border={...} end
    f.SetFocus = function(self) self.focus=true end; f.ClearFocus = function(self) self.focus=false end
    f.HighlightText = function(self) self.highlighted=true end
    f.SetText = function(self,t) self.text = t end; f.GetText = function(self) return self.text end
    f.SetScript = function(self,key,fn) self.scripts[key] = fn end
    f.Show = function(self) self.shown = true; if self.scripts.OnShow then self.scripts.OnShow(self) end end
    f.Hide = function(self) self.shown = false; if self.scripts.OnHide then self.scripts.OnHide(self) end end
    f.SetShown = function(self,v) if v then self:Show() else self:Hide() end end
    f.IsShown = function(self) return self.shown end
    f.SetEnabled = function(self,value) self.enabled=value end
    for _,key in ipairs({"SetFrameStrata","EnableMouse","SetClampedToScreen","SetBackdrop","SetBackdropColor",
        "SetAutoFocus","SetMaxLetters","SetScrollChild","RegisterForClicks"}) do f[key] = function() end end
    return f
end
UIParent, UISpecialFrames = {}, {}
GameTooltip = {IsOwned = function() return false end}
ToggleWorldMap = function()
    opened = opened + 1; WorldMapFrame = {IsShown = function() return true end}
end
SlashCmdList={TOMTOM=function() settingsOpened=settingsOpened+1 end}
print = function() end
assert(loadfile("GroupCompass/WaypointUI.lua"))("GroupCompass", addon)
addon.WaypointUI.Toggle(); assert(GroupCompassWaypointWindow.shown and UISpecialFrames[1] == "GroupCompassWaypointWindow")
local function click(title)
    for _,frame in ipairs(frames) do if frame.kind == "Button" and frame.text == title then frame.scripts.OnClick(); return end end
    error("missing button: " .. title)
end
local input
for _,frame in ipairs(frames) do if frame.kind == "EditBox" then input = frame end end
input:SetText("Camp"); click("Save my location")
assert(#points == 1 and points[1].name == "Camp" and input:GetText() == "")
click("Navigate"); assert(attempts==1 and not force)
click("Replace"); assert(attempts==2 and force)
click("Stop route"); assert(stops==1)
click("Route settings"); assert(routeSettingsOpened==1 and not GroupCompassWaypointWindow.shown)
addon.WaypointUI.Toggle()
click("Edit")
local editor = GroupCompassWaypointEditor
assert(editor.shown and UISpecialFrames[2] == "GroupCompassWaypointEditor")
local editInput
for _,frame in ipairs(frames) do if frame.kind=="EditBox" and frame.parent==editor then editInput=frame end end
assert(editInput:GetText()=="Camp" and editInput.focus and editInput.highlighted)
local function icon(value)
    for _,frame in ipairs(frames) do
        if frame.parent==editor and frame.texture and frame.texture.path:find(value..".tga",1,true) then return frame end
    end
    error("missing icon "..value)
end
for _,choice in ipairs(addon.Settings.Icons) do assert(icon(choice[1])) end
assert(icon("pin").border[1]~=1 and icon("star").border[1]~=1)
editInput:SetText("  Home |base  "); icon("star").scripts.OnClick()
assert(points[1].name=="Camp" and points[1].icon=="tomtom", "editing drafts must not change saved data")
click("Cancel"); assert(not editor.shown and points[1].name=="Camp" and points[1].icon=="tomtom")
click("Edit"); assert(editInput:GetText()=="Camp" and icon("pin").border[1]~=1)
editInput:SetText("  Home |base  "); icon("star").scripts.OnClick(); click("Save")
assert(not editor.shown and points[1].name=="Home base" and points[1].icon=="star")
assert(points[1].id==1 and points[1].mapID==10 and points[1].x==.3 and points[1].y==.4)
assert(addon.Waypoints.Sample()[1].label=="[T1] Home base")
click("Edit"); assert(icon("star").border[1]==1)
editInput:SetText("Discard"); editInput.scripts.OnEscapePressed(); assert(not editor.shown and points[1].name=="Home base")
click("Edit"); editInput:SetText("By Enter"); icon("flag").scripts.OnClick(); editInput.scripts.OnEnterPressed()
assert(points[1].name=="By Enter" and points[1].icon=="flag" and not editor.shown)
click("Edit"); click("Remove"); assert(#points==0 and not editor.shown, "deletion must close the stale editor")
local allocations=#frames; addon.WaypointUI.Edit(1); assert(#frames==allocations and not editor.shown)
input:SetText("Inn"); input.scripts.OnEnterPressed(); assert(points[1].name == "Inn")
input.scripts.OnEscapePressed(input); assert(not GroupCompassWaypointWindow.shown)
addon.WaypointUI.Toggle(); click("Open world map")
assert(not GroupCompassWaypointWindow.shown and opened == 1 )
addon.WaypointUI.Toggle(); click("Open world map"); assert(opened == 1, "Open map must not close an already-open map")
addon.WaypointUI.Toggle(); click("Done"); assert(not GroupCompassWaypointWindow.shown)
-- TomTom-created points appear in the list; Edit opens the shared point.
local mapPoint=addon.TomTomBridge.Add(10,.6,.7,"Map point")
addon.Waypoints.Refresh()
addon.WaypointUI.Edit(mapPoint.id)
assert(editor.shown and editInput:GetText()=="Map point")
editInput:SetText("Map camp"); icon("shield").scripts.OnClick(); click("Save")
assert(mapPoint.name=="Map camp" and mapPoint.icon=="shield" and mapPoint.x==.6 and mapPoint.y==.7)
addon.Waypoints.Initialize()
addon.WaypointUI.Edit(mapPoint.id)
assert(editInput:GetText()=="Map camp" and icon("shield").border[1]==1)
editInput:SetText("Ignored"); click("Cancel"); assert(mapPoint.name=="Map camp")
addon.WaypointUI.Toggle(); click("TomTom settings"); assert(settingsOpened==1)
local instructions, facing=false,false
for _,r in ipairs(regions) do
 if r.text and r.text:find("Alt + right-click",1,true) and r.text:find("automatically",1,true) then instructions=true end
 if r.text and r.text:find("Face the point with your character",1,true) then facing=true end
end
assert(instructions and facing,"options must explain creation, automatic bar sync and character facing")
-- Map editing must work before the saved-point list has ever been opened.
local fresh={Settings=addon.Settings,Waypoints=addon.Waypoints,MarkerStyle=addon.MarkerStyle}
assert(loadfile("GroupCompass/WaypointUI.lua"))("GroupCompass",fresh)
addon.Waypoints.OnChanged=fresh.WaypointUI.Refresh
fresh.WaypointUI.Edit(mapPoint.id)
local freshEditor=GroupCompassWaypointEditor
local freshInput,save
for _,frame in ipairs(frames) do
    if frame.parent==freshEditor and frame.kind=="EditBox" then freshInput=frame end
    if frame.parent==freshEditor and frame.text=="Save" then save=frame end
end
freshInput:SetText("From map first"); save.scripts.OnClick()
assert(mapPoint.name=="From map first" and not freshEditor.shown)
-- The same editor works over a provider facade, including its non-palette icon.
local providerPoint={id=1000001,mapID=10,x=.3,y=.4,name="TomTom camp",source="tomtom",tag="T1",icon="tomtom"}
local applied
local providerUI={Settings=addon.Settings,MarkerStyle=addon.MarkerStyle,Waypoints={
    Find=function(id) return id==providerPoint.id and providerPoint end,
    Icon=function(p) return p.icon end,
    Update=function(id,name,icon) applied={id,name,icon}; return providerPoint,"Saved" end}}
assert(loadfile("GroupCompass/WaypointUI.lua"))("GroupCompass",providerUI)
providerUI.WaypointUI.Edit(providerPoint.id)
local providerEditor=GroupCompassWaypointEditor
local currentButton,providerInput,providerSave
for _,frame in ipairs(frames) do
    if frame.parent==providerEditor and frame.kind=="EditBox" then providerInput=frame end
    if frame.parent==providerEditor and frame.text=="Current (selected)" then currentButton=frame end
    if frame.parent==providerEditor and frame.text=="Save" then providerSave=frame end
end
assert(currentButton and currentButton.shown and providerInput:GetText()=="TomTom camp")
providerInput:SetText("Renamed in TomTom"); providerSave.scripts.OnClick()
assert(applied[1]==1000001 and applied[2]=="Renamed in TomTom" and applied[3]=="tomtom")
providerPoint.readOnly=true
providerUI.WaypointUI.Edit(providerPoint.id); assert(not providerEditor.shown, "managed addon points are read-only")
io.write("PASS: TomTom waypoint editor Save/Cancel/Enter/Escape, external creation, help/settings, deletion and routing/list controls\n")
