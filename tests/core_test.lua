-- A small API double validates display logic, not the actual WoW renderer.
local addon = {}
local frame, texts, messages, textures = nil, {}, {}, {}
local members, message = {}, "No locatable group members"
local mapMembers, mapsEnabled
local mapUpdates = 0
addon.Maps = { Update = function(items, enabled)
    mapMembers, mapsEnabled = items, enabled; mapUpdates = mapUpdates + 1
end }
addon.Tracking = { Sample = function() return members, message end }
addon.Tracking.PlayerState = function() return {x = 0, y = 0, map = 1, facing = 0} end
addon.Tracking.Color = function() return {1, 1, 1} end
local function region()
    return {
        SetAllPoints = function() end, SetColorTexture = function() end,
        SetWidth = function() end, ClearAllPoints = function() end,
        SetSize = function() end, SetWordWrap = function() end,
        GetStringWidth = function(self) return #(self.text or "") * 6 end,
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
local function visible()
    local count = 0
    for i = 2, #texts, 2 do if texts[i].shown then count = count + 1 end end
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
