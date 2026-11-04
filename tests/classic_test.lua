-- Startup smoke test with Classic-style globals; not the native addon loader.
local toc = assert(io.open("GroupCompass/GroupCompass.toc")):read("*a")
local interfaces = toc:match("## Interface:%s*([^\r\n]+)")
assert(interfaces:find("11509", 1, true), "manifest must advertise Tony's Classic interface 11509")
assert(interfaces:find("16001", 1, true), "Forever interface must remain supported")
local addon, texts, frames, messages = {}, {}, {}, {}
local function region()
    return {
        SetAllPoints = function() end, SetColorTexture = function() end,
        SetWidth = function() end, SetTextColor = function() end,
        SetSize = function() end, SetWordWrap = function() end,
        GetFont = function() return 'test-font',10,'' end, SetFont = function() end,
        GetStringWidth = function(self) return #(self.text or "") * 6 end,
        SetShown = function(self, shown) self.shown = shown end,
        SetPoint = function() end, ClearAllPoints = function() end,
        SetText = function(self, value) self.text = value end,
        Hide = function(self) self.shown = false end,
        Show = function(self) self.shown = true end,
    }
end
UIParent = {}
CreateFrame = function()
    local frame = {scripts = {}, events = {}}
    frames[#frames + 1] = frame
    frame.SetSize = function() end; frame.SetPoint = function() end
    frame.CreateTexture = region
    frame.CreateFontString = function()
        local text = region(); texts[#texts + 1] = text; return text
    end
    frame.RegisterEvent = function(self, event) self.events[event] = true end
    frame.SetScript = function(self, event, fn) self.scripts[event] = fn end
    frame.SetShown = function(self, value) self.shown = value end
    frame.EnableMouse = function() end; frame.SetMouseClickEnabled = function() end
    return frame
end
SlashCmdList = {}
C_Minimap, C_AddOns, issecretvalue = nil, nil, nil
GetAddOnMetadata = function(name, field)
    assert(name == "GroupCompass" and field == "Version"); return toc:match("## Version:%s*([^\r\n]+)")
end
GetBuildInfo = function() return "1.15.9", "70003", "Sep 23 2026", 11509 end
IsInInstance = function() return false end
InCombatLockdown = function() return false end
IsInRaid = function() return false end
GetNumSubgroupMembers = function() return 0 end
UnitIsConnected = function() return true end
UnitPosition = function() return 100, 200, 0, 1 end
GetPlayerFacing = function() return 0 end
print = function(value) messages[#messages + 1] = value end
GameTooltip = {IsOwned = function() return false end}
for line in toc:gmatch("[^\r\n]+") do
    if line:match("%.lua$") then assert(loadfile("GroupCompass/" .. line))("GroupCompass", addon) end
end
assert(SlashCmdList.GROUPCOMPASS, "slash handler missing after all TOC Lua files loaded")
local core = frames[#frames]
core.scripts.OnEvent(core, "ADDON_LOADED", "SomeOtherAddon")
assert(#messages == 0, "must not announce other addons")
core.scripts.OnEvent(core, "ADDON_LOADED", "GroupCompass")
assert(messages[1]:find("0.11.5 loaded", 1, true))
SlashCmdList.GROUPCOMPASS("demo")
assert(texts[1].text:find("DEMO") and texts[2].shown and texts[4].shown and texts[6].shown)
SlashCmdList.GROUPCOMPASS("status")
assert(messages[#messages - 2]:find("11509") and messages[#messages - 2]:find("70003"))
SlashCmdList.GROUPCOMPASS("demo")
assert(texts[1].text:find("No locatable"))
io.write("PASS: Classic 11509 manifest, full Lua load order, startup notice, demo and status without modern-only globals\n")
