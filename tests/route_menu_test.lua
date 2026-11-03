local addon = {}
local frames, printed = {}, {}
local function object()
    local f = {scripts = {}, shown = true}
    for _, method in ipairs({"SetSize", "SetWidth", "SetHeight", "SetPoint", "ClearAllPoints",
        "SetFrameStrata", "SetClampedToScreen", "SetBackdrop", "SetBackdropColor", "SetScrollChild"}) do
        f[method] = function() end
    end
    function f:SetHeight(v) self.height=v end
    function f:SetVerticalScroll(v) self.scroll = v end
    function f:SetText(v) self.text = v end
    function f:SetScript(k, v) self.scripts[k] = v end
    function f:Show() self.shown = true end
    function f:Hide() self.shown = false end
    function f:IsShown() return self.shown end
    function f:CreateFontString() return object() end
    frames[#frames + 1] = f
    return f
end
CreateFrame = function(_, name) local f = object(); if name then _G[name] = f end; return f end
UIParent, UISpecialFrames = {}, {}
GameTooltip = {
    SetOwner=function(self,owner) self.owner=owner end,
    IsOwned=function(self,owner) return self.owner==owner end,
    SetText=function(self,text) self.title=text end,
    AddLine=function(self,text,_,_,_,wrap) self.help=text;self.wrap=wrap end,
    Show=function(self) self.shown=true end,Hide=function(self)self.shown=false;self.owner=nil end,
}
print = function(text) printed[#printed + 1] = text end
local sources = {restedxp = true, quest = false, questReason = "Native API absent", owned = true, retry = true}
local selected, fail, missing = {}, false, false
local detail = "Finding the fastest route..."
addon.Routing = {Sources = function() return not missing and sources or nil, "Update provider" end,
    Detail = function() return detail end,
    SelectSource = function(kind, id) selected[#selected + 1] = {kind, id}; return not fail, fail and "Provider failed" or "Route requested" end}
local member = {id = "guid-1", name = "Friend", mapID = 1438}
addon.Tracking = {RouteTargets = function() return {member} end}
local points = {{id = 5, name = "Camp"}, {id = 6, name = "Inn"}}
addon.Waypoints = {List = function() return points end}
assert(loadfile("GroupCompass/RouteMenu.lua"))("GroupCompass", addon)
local function click(text)
    for _, f in ipairs(frames) do
        if f.shown and f.text == text and f.scripts.OnClick then f.scripts.OnClick(f); return f end
    end
    error("Missing menu action: " .. text)
end
local function hasText(text)
    for _, f in ipairs(frames) do if f.shown and f.text == text then return true end end
end
local menu = addon.RouteMenu
menu.Toggle({}); assert(GroupCompassRouteMenu.shown and #UISpecialFrames == 1)
detail = "Route ready"; GroupCompassRouteMenu.scripts.OnUpdate(GroupCompassRouteMenu, 1)
assert(hasText("Route ready"), "status must refresh while the menu is open")
assert(GroupCompassRouteMenu.height==325,"five actions should use a compact menu")
assert(not hasText("Selected Blizzard quest"),"unsupported quest action must be hidden on Classic")
assert(not hasText("Shortest Path settings") and not hasText("Route report"),"settings links belong in Options")
local function hover(text)
    for _,f in ipairs(frames) do if f.shown and f.text==text and f.scripts.OnEnter then
        f.scripts.OnEnter(f);assert(GameTooltip.shown and GameTooltip.wrap);return GameTooltip.help
    end end
    error("Missing hover help: "..text)
end
assert(hover("RestedXP guide controls..."):find("does not resume automatically",1,true))
assert(hover("Recalculate this route"):find("old location snapshot",1,true))
assert(hover("Stop this route"):find("does not delete a waypoint",1,true))
assert(hover("Party members  >"):find("select them again",1,true))
assert(hover("TomTom waypoints  >"):find("independent arrow",1,true))
click("RestedXP guide controls..."); assert(selected[1][1] == "restedxp" and not GroupCompassRouteMenu.shown)
menu.Toggle({}); click("Party members  >"); click("Friend")
assert(selected[2][1] == "party" and selected[2][2] == "guid-1")
member.mapID, member.reason = nil, "Member moved away"
menu.Toggle({}); click("Party members  >"); click("Friend *")
assert(#selected == 2 and hasText("Member moved away"))
click("<  Back to sources"); click("TomTom waypoints  >"); click("Inn")
assert(selected[3][1] == "tomtom" and selected[3][2] == 6)
points = {}; menu.Toggle({}); click("TomTom waypoints  >")
click("No saved TomTom waypoints"); assert(#selected == 3)
click("<  Back to sources"); fail = true; click("Recalculate this route")
assert(GroupCompassRouteMenu.shown and hasText("Provider failed"))
fail = false; click("Stop this route"); assert(selected[#selected][1] == "stop")
sources.owned,sources.retry=false,false
menu.Toggle({})
assert(not hasText("Recalculate this route") and not hasText("Stop this route"),"foreign guides must not show our route controls")
assert(GroupCompassRouteMenu.height==267,"three source actions should shrink the menu")
sources.quest=true;menu.Toggle({});menu.Toggle({});click("Selected Blizzard quest")
assert(selected[#selected][1]=="quest")

missing = true; menu.Toggle({}); click("RestedXP guide controls... *")
assert(hasText("Update provider"))
menu.Toggle({}); menu.Toggle({}); assert(#UISpecialFrames == 1)
io.write("PASS: focused target menu, wrapped hover help, Resume handoff, conditional quest/owned actions, snapshots and failures\n")
