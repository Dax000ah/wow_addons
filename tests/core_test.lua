-- A small API double validates display logic, not the actual WoW renderer.
local addon = {}
local optionsToggled, initialized = 0, false
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
local initialize = addon.Settings.Initialize
addon.Settings.Initialize = function() initialize(); initialized = true end
addon.Options = {Initialize = function() end, Toggle = function() optionsToggled = optionsToggled + 1 end}
local waypointEntries, waypointCommands, waypointToggled = {}, {}, 0
addon.Waypoints = {Refresh = function() end, Initialize = function() end, Sample = function() return waypointEntries, 0 end,
    Command = function(value) waypointCommands[#waypointCommands + 1] = value end}
addon.WaypointUI = {Refresh = function() end, Toggle = function() waypointToggled = waypointToggled + 1 end}
local routeEntries, routeCommands, routeStops, routeRefreshes = {}, {}, 0, 0
addon.Routing = {Refresh=function() routeRefreshes=routeRefreshes+1 end, Status=function() return "Route status" end,
    CanStop=function() return #routeEntries > 0 end, Sample=function() error("Core must not request unsupported turn guidance") end,
    Stop=function() routeStops=routeStops+1; routeEntries={}; return true end,
    Command=function(value) routeCommands[#routeCommands+1]=value end}
local frame, texts, messages, textures = nil, {}, {}, {}
local members, message = {}, "No locatable group members"
local mapMembers, mapsEnabled
local mapUpdates = 0
addon.Maps = { Update = function(items, enabled)
    mapMembers, mapsEnabled = items, enabled; mapUpdates = mapUpdates + 1
end }
addon.Tracking = { Sample = function() return members, message end }
addon.Tracking.PlayerState = function() return {x = 0, y = 0, map = 1, facing = 0} end
local facing = 0
addon.Tracking.Facing = function() return facing end
addon.Tracking.Color = function() return {1, 1, 1} end
local function region()
    return {
        SetAllPoints = function() end, SetColorTexture = function() end,
        SetWidth = function(self, width) self.width = width end, ClearAllPoints = function() end,
        SetSize = function() end, SetWordWrap = function() end,
        GetStringWidth = function(self) return #(self.text or "") * (self.fontSize or 10) * .6 end,
        GetFont = function() return "test-font", 10, "OUTLINE" end,
        SetFont = function(self, path, size, flags) self.fontSize = size; self.fontPath = path; self.flags = flags end,
        SetShown = function(self, shown) self.shown = shown end,
        SetTextColor = function() end,
        SetPoint = function(self, ...) self.point = {...} end,
        SetText = function(self, text) self.text = text end,
        Hide = function(self) self.shown = false end,
        Show = function(self) self.shown = true end,
    }
end
UIParent = {}
local cursorX = 500
GetCursorPosition = function() return cursorX, 0 end
GameTooltip = {
    IsOwned = function(self, owner) return self.owner == owner end,
    SetOwner = function(self, owner) self.owner = owner end,
    SetText = function(self, text) self.text = text; self.lines = {} end,
    AddLine = function(self, text) self.lines[#self.lines + 1] = text end,
    Show = function() end, Hide = function(self) self.owner = nil end,
}
CreateFrame = function()
    frame = { shown = true, scripts = {}, events = {} }
    frame.SetSize = function(self, w, h) self.width, self.height = w, h end
    frame.SetPoint = function() end
    frame.CreateTexture = function()
        local texture = region(); textures[#textures + 1] = texture; return texture
    end
    frame.CreateFontString = function()
        local text = region(); texts[#texts + 1] = text; return text
    end
    frame.SetScript = function(self, event, callback) self.scripts[event] = callback end
    frame.RegisterEvent = function(self, event) self.events[event] = true end
    frame.SetShown = function(self, shown)
        self.shown = shown
        if not shown and self.scripts.OnHide then self.scripts.OnHide(self) end
    end
    frame.EnableMouse = function() end
    frame.SetMouseClickEnabled = function() end
    frame.GetCenter = function() return 500, 500 end
    frame.GetEffectiveScale = function() return 1 end
    return frame
end
SlashCmdList = {}
GetBuildInfo = function() return "1.60.1", "test-build", "test-date", 16001 end
print = function(text) messages[#messages + 1] = text end
assert(loadfile("GroupCompass/Compat.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Layout.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Demo.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Core.lua"))("GroupCompass", addon)
local command = SlashCmdList.GROUPCOMPASS
local status = texts[1]
frame.scripts.OnEvent(frame, "ADDON_LOADED", "GroupCompass")
assert(initialized)
command("options"); command(""); command("config"); assert(optionsToggled == 3)
command("Waypoints"); command("Waypoint Here My Camp")
assert(waypointToggled == 1 and waypointCommands[1] == "Here My Camp")
command("Route 1"); assert(routeCommands[1]=="1")
local function visible()
    local count = 0
    for i = 2, 123, 2 do if texts[i].shown then count = count + 1 end end
    return count
end
assert(SLASH_GROUPCOMPASS1 == "/groupcompass" and SLASH_GROUPCOMPASS2 == "/gcompass")
frame.scripts.OnUpdate(frame, 0.1)
assert(status.text == message and visible() == 0)
command("  OFF "); assert(not frame.shown)
assert(not mapsEnabled and #mapMembers == 0)
command("demo"); assert(frame.shown and visible() == 3 and status.text:find("DEMO"))
assert(not mapsEnabled and #mapMembers == 0, "demo must not put fake locations on maps")
assert(frame.height == 46 and frame.width == 620, "strip must stay compact")
assert(texts[2].point[4] < 0 and texts[4].point[4] == 0 and texts[6].point[4] > 0)
assert(texts[2].point[5] == texts[4].point[5] and texts[4].point[5] == texts[6].point[5],
    "member labels must share one horizontal baseline")
assert(textures[4].point[5] == textures[5].point[5] and textures[5].point[5] == textures[6].point[5],
    "bearing markers must share one horizontal baseline")
assert(texts[3].point[5] == texts[5].point[5] and texts[5].point[5] == texts[7].point[5])
assert(not status.shown, "normal tracking must not reserve a large status area")
command("status")
assert(messages[#messages - 1]:find("16001") and messages[#messages - 1]:find("demo on"))
assert(messages[#messages]:find("Live tracking:") and messages[#messages]:find(message))
command("demo"); assert(visible() == 0)
command("demo reset"); assert(frame.shown and visible() == 3 and not mapsEnabled)
command("demo"); assert(visible() == 0)
members = { {name = "Ahead", slot = 1, color = {1,1,1}, angle = 0, distance = 12} }
frame.scripts.OnEvent(frame, "GROUP_ROSTER_UPDATE")
assert(visible() == 1 and texts[2].text == "[1] Ahead" and texts[3].text == "~12 yd")
assert(mapsEnabled and mapMembers == members)
members[2] = {name = "Second member full name", slot = 2, color = {1,1,1}, angle = 0, distance = 20}
frame.scripts.OnEvent(frame, "GROUP_ROSTER_UPDATE")
assert(visible() == 1 and textures[4].shown and textures[5].shown,
    "colliding labels should not hide bearing markers")
frame.scripts.OnEnter(frame)
assert(#GameTooltip.lines == 2 and GameTooltip.lines[2]:find("Second member full name", 1, true),
    "hover must retain every identity at an overlapping bearing")
members = { {name = "Behind", slot = 1, color = {1,1,1}, angle = math.pi, distance = 12} }
message = "Character facing (1 unavailable)"
frame.scripts.OnEvent(frame, "GROUP_ROSTER_UPDATE")
assert(visible() == 0 and status.text:find("behind") and status.text:find("1 unavailable"))
members = {}; message = "Player position or facing unavailable"
frame.scripts.OnEvent(frame, "PLAYER_REGEN_DISABLED")
assert(status.text == message and visible() == 0)
command("off"); command("status"); assert(not frame.shown and GameTooltip.owner == nil)
command("on"); assert(frame.shown)
local updatesBeforeProbe = mapUpdates
local probe = addon.Compat.IsProbingMinimap
addon.Compat.IsProbingMinimap = function() return true end
frame.scripts.OnEvent(frame, "MINIMAP_UPDATE_ZOOM")
assert(mapUpdates == updatesBeforeProbe, "probe events must not trigger nested map refreshes")
addon.Compat.IsProbingMinimap = probe
frame.scripts.OnEvent(frame, "MINIMAP_UPDATE_ZOOM")
assert(mapUpdates == updatesBeforeProbe + 1)
assert(frame.events.PLAYER_ENTERING_WORLD and frame.events.GROUP_ROSTER_UPDATE
    and frame.events.PLAYER_REGEN_DISABLED and frame.events.PLAYER_REGEN_ENABLED
    and frame.events.ZONE_CHANGED_NEW_AREA)
io.write("PASS: compact strip, aligned names/markers/distances, collision hover, commands and lifecycle\n")
members = {}; message = "No locatable group members"
waypointEntries = {{kind = "waypoint", waypointId = 1, slot = 41, name = "My Camp",
    label = "[W1] My Camp", color = {1,0.78,0.25}, angle = 0, distance = 42}}
command("on"); assert(visible() == 1 and texts[2].text == "[W1] My Camp")
assert(#members == 0 and #mapMembers == 1, "merging must not mutate party samples")
frame.scripts.OnUpdate(frame, .1); assert(#mapMembers == 1, "no duplicated waypoints on refresh")
command("demo"); assert(#mapMembers == 0 and visible() == 3)
addon.Waypoints.OnChanged("add")
assert(#mapMembers == 1 and visible() == 1 and mapsEnabled, "adding a real waypoint exits demo")
command("off"); addon.Waypoints.OnChanged("add")
assert(frame.shown and #mapMembers == 1, "adding a waypoint enables its views")
waypointEntries = {}; addon.Waypoints.OnChanged()
assert(visible() == 0 and #mapMembers == 0, "removing a waypoint clears compass/minimap data")
local previousRefreshes=routeRefreshes
frame.scripts.OnUpdate(frame,.1)
assert(routeRefreshes>previousRefreshes,"ownership status must still poll without a next-turn getter")
routeEntries={{kind="route",name="Unsupported turn"}}
addon.Routing.OnStarted()
assert(visible()==0 and #mapMembers==0 and status.text=="Route status",
    "stock API has no next-turn getter; never fabricate a turn marker")
command("demo"); assert(routeStops>0 and visible()==3)
command("off"); assert(not frame.shown)

-- All headings share the members' angular scale, stay in their own row, and
-- remain useful without a party. Positive facing is west, not east.
members, waypointEntries, routeEntries = {}, {}, {}
local n,e,s,w=texts[124],texts[125],texts[126],texts[127]
local function near(value,expected) assert(math.abs(value-expected)<1e-6) end
local function turn(value) facing=value; frame.scripts.OnUpdate(frame,.1) end
command('demo') -- leave the demo enabled by the preceding route lifecycle test
command('on')
assert(n.text=='N' and e.text=='E' and s.text=='S' and w.text=='W')
assert(status.shown and textures[2].shown and textures[3].shown)
near(n.point[4],0); near(e.point[4],240); near(w.point[4],-240); assert(not s.shown)
turn(math.pi/2); near(w.point[4],0); near(n.point[4],240); near(s.point[4],-240); assert(not e.shown)
turn(math.pi); near(s.point[4],0); assert(not n.shown)
turn(3*math.pi/2); near(e.point[4],0); assert(not w.shown)
turn(2*math.pi-.1); near(n.point[4],-.1/(math.pi/2)*240)
assert(n.point[5]==-15 and status.point[3]==-3, 'empty message must stay above heading row')
turn(nil); assert(not n.shown and not e.shown and not s.shown and not w.shown)
assert(not textures[2].shown and not textures[3].shown, 'no stale heading without readable facing')
turn(0); command('demo'); assert(n.shown and visible()==3)
assert(n.point[5]<texts[2].point[5] and n.point[5]>textures[4].point[5])
command('off'); assert(not frame.shown)
io.write('PASS: N/E/S/W headings, four turns, wrap, solo/demo, independent row, missing-facing clearing and off\n')

-- Compose real Settings/Layout/Core. Geometry, fonts and hover hit boxes must
-- change together, even after hidden updates and resets.
addon.Settings.OnChanged = addon.Compass.RefreshAppearance
command('demo') -- live, empty
members={{name='A very long member name',slot=1,color={1,1,1},angle=math.pi/4,distance=12}}
turn(0); addon.Settings.Set('compassWidth',1000)
local g=addon.Layout.Compass(addon.Settings.Get())
near(texts[2].point[4],g.span/2); near(e.point[4],g.span)
assert(frame.width==1000 and frame.height==46)
addon.Settings.Set('textSize',20)
assert(frame.height==76 and texts[2].fontSize==20 and n.fontSize==20 and status.fontSize==20)
assert(texts[2].fontPath=='test-font' and texts[2].flags=='OUTLINE')
addon.Settings.Set('compassHeight',120)
assert(frame.height==120 and texts[3].point[5]<-33)
assert(texts[2].point[5]>n.point[5] and n.point[5]>textures[4].point[5]
    and textures[4].point[5]>texts[3].point[5], 'rows must remain ordered')
g=addon.Layout.Compass(addon.Settings.Get())
cursorX=500+g.span/2; frame.scripts.OnEnter(frame)
assert(GameTooltip.lines[1]:find('A very long member name',1,true), 'resized hover matches displayed bearing')
command('off'); addon.Settings.Set('compassWidth',320)
assert(not frame.shown and frame.width==320, 'size changes must not enable a hidden bar')
command('on'); assert(frame.shown and frame.width==320)
addon.Settings.Reset(); assert(frame.width==620 and frame.height==46 and texts[2].fontSize==10)
io.write('PASS: saved-size core composition, live width/height/fonts, scaled bearings/hover, hidden updates and reset\n')
