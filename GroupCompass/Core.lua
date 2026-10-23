local addonName, addon = ...
local frame = CreateFrame("Frame", "GroupCompassFrame", UIParent)
frame:SetSize(620, 46)
frame:SetPoint("TOP", 0, -54)
frame:EnableMouse(true)
frame:SetMouseClickEnabled(false)
local background = frame:CreateTexture(nil, "BACKGROUND")
background:SetAllPoints()
background:SetColorTexture(0, 0, 0, 0.22)
local baseline = frame:CreateTexture(nil, "ARTWORK")
baseline:SetSize(600, 1)
baseline:SetPoint("TOP", 0, -23)
baseline:SetColorTexture(0.85, 0.85, 0.75, 0.45)
local center = frame:CreateTexture(nil, "ARTWORK")
center:SetSize(1, 12)
center:SetPoint("TOP", 0, -17)
center:SetColorTexture(1, 0.85, 0.5, 0.9)
local status = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
status:SetPoint("CENTER")
status:SetWidth(600)
local markers = {}
for index = 1, 40 do
    local name = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    name:SetWidth(120)
    name:SetWordWrap(false)
    local distance = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    distance:SetWidth(80)
    distance:SetWordWrap(false)
    local tick = frame:CreateTexture(nil, "OVERLAY")
    tick:SetSize(3, 7)
    markers[index] = {name = name, distance = distance, tick = tick}
end

local enabled, demo, elapsed = true, false, 0
local visibleMembers, displayMessage = {}, "Group Compass"
local function hideDetails()
    if GameTooltip:IsOwned(frame) then GameTooltip:Hide() end
end
local function showDetails()
    local cursorX = GetCursorPosition() / frame:GetEffectiveScale()
    local centerX = frame:GetCenter()
    if not centerX then return end
    local x, found = cursorX - centerX, 0
    GameTooltip:SetOwner(frame, "ANCHOR_BOTTOM")
    GameTooltip:SetText(demo and "Group Compass - DEMO" or "Group Compass")
    for _, item in ipairs(visibleMembers) do
        local hitWidth = item.showLabel and item.width / 2 or 9
        if math.abs(x - item.x) <= hitWidth then
            local member = item.member
            GameTooltip:AddLine(string.format("[%d] %s  ~%.0f yd", member.slot, member.name,
                member.distance), unpack(member.color))
            found = found + 1
        end
    end
    if found == 0 then GameTooltip:AddLine(displayMessage, 1, 1, 1) end
    GameTooltip:Show()
end
frame:SetScript("OnEnter", showDetails)
frame:SetScript("OnLeave", hideDetails)
frame:SetScript("OnHide", hideDetails)
local function refresh()
    for _, marker in ipairs(markers) do
        marker.name:Hide(); marker.distance:Hide(); marker.tick:Hide()
    end
    visibleMembers = {}
    local members, message
    if demo then
        members, message = addon.Demo.Sample()
    else
        members, message = addon.Tracking.Sample()
    end
    -- Never place synthetic demo locations onto actual maps.
    addon.Maps.Update(demo and {} or members, enabled and not demo)
    local visible = 0
    for _, member in ipairs(members) do
        if math.abs(member.angle) <= math.pi / 2 then
            visible = visible + 1
            local marker = markers[visible]
            local x = member.angle / (math.pi / 2) * 240
            marker.name:ClearAllPoints()
            marker.name:SetPoint("TOP", frame, "TOP", x, -3)
            marker.name:SetTextColor(unpack(member.color))
            marker.name:SetText(string.format("[%d] %s", member.slot, member.name))
            marker.distance:ClearAllPoints()
            marker.distance:SetPoint("TOP", frame, "TOP", x, -29)
            marker.distance:SetText(string.format("~%.0f yd", member.distance))
            marker.tick:ClearAllPoints()
            marker.tick:SetPoint("TOP", frame, "TOP", x, -20)
            marker.tick:SetColorTexture(unpack(member.color))
            marker.tick:Show()
            visibleMembers[visible] = {member = member, marker = marker, x = x,
                width = math.max(80, math.min(120, marker.name:GetStringWidth()))}
        end
    end
    if #members > 0 and visible == 0 then
        message = message .. " - Locatable members are behind you"
    end
    addon.Layout.SelectLabels(visibleMembers)
    for _, item in ipairs(visibleMembers) do
        if item.showLabel then item.marker.name:Show(); item.marker.distance:Show() end
    end
    displayMessage = message
    status:SetText(message)
    status:SetShown(visible == 0)
    baseline:SetShown(visible > 0)
    center:SetShown(visible > 0)
    if GameTooltip:IsOwned(frame) then showDetails() end
end

for _, event in ipairs({ "ADDON_LOADED", "PLAYER_ENTERING_WORLD", "GROUP_ROSTER_UPDATE",
    "PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED", "ZONE_CHANGED_NEW_AREA", "MINIMAP_UPDATE_ZOOM" }) do
    frame:RegisterEvent(event)
end
frame:SetScript("OnEvent", function(_, event, name)
    if event == "ADDON_LOADED" then
        if name == addonName then
            print("Group Compass " .. addon.Compat.Version() .. " loaded. /gcompass demo for a solo preview.")
        end
        return
    end
    if addon.Compat.IsProbingMinimap() then return end
    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" or event == "MINIMAP_UPDATE_ZOOM" then
        addon.Compat.InvalidateMinimapRadius()
    end
    if enabled then refresh() end
end)
frame:SetScript("OnUpdate", function(_, delta)
    elapsed = elapsed + delta
    if elapsed >= 0.1 then
        elapsed = 0
        refresh()
    end
end)
SLASH_GROUPCOMPASS1 = "/groupcompass"
SLASH_GROUPCOMPASS2 = "/gcompass"
SlashCmdList.GROUPCOMPASS = function(command)
    command = (command or ""):lower():match("^%s*(.-)%s*$")
    if command == "demo" then
        demo = not demo
        addon.Demo.Reset()
        enabled = true
    elseif command == "demo reset" then
        addon.Demo.Reset()
        demo = true
        enabled = true
    elseif command == "on" then
        enabled = true
    elseif command == "off" then
        enabled = false
    elseif command == "status" then
        local version, build, _, interface = GetBuildInfo()
        local members, message = addon.Tracking.Sample()
        print(string.format("Group Compass %s: WoW %s build %s, interface %s; display %s; demo %s",
            addon.Compat.Version(), tostring(version), tostring(build), tostring(interface),
            enabled and "on" or "off", demo and "on" or "off"))
        print(string.format("Live tracking: %s; %d locatable members", message, #members))
    else
        print("Group Compass: /gcompass on | off | demo | demo reset (place new samples) | status")
    end
    frame:SetShown(enabled)
    if not enabled then addon.Maps.Update({}, false) end
    if enabled then refresh() end
end
