local _, addon = ...
addon.Routing = {}
local routing = addon.Routing
-- Use only upstream API v1. No injected methods, private state or settings writes.
local owner, api, selected, target, owned, active = "GroupCompass", nil, nil, nil, false, false
local message, outcome, fault = "Routing requires Shortest Path Forever.", nil, nil
local function publish(value)
    if value == message then return end
    message = value
    if routing.OnChanged then routing.OnChanged() end
end
local function point(id)
    for _, item in ipairs(addon.Waypoints.List()) do if item.id == id then return item end end
end
local function call(method, ...)
    local ok, value = pcall(api[method], ...)
    if not ok then fault = "Shortest Path " .. method .. " failed: " .. tostring(value); return nil end
    return value
end
local function inCombat() return InCombatLockdown and InCombatLockdown() end
local function number(value)
    return not (issecretvalue and issecretvalue(value)) and type(value) == "number"
        and value == value and math.abs(value) < math.huge
end
local function valid(map, x, y)
    return number(map) and map > 0 and map % 1 == 0 and number(x) and x >= 0 and x <= 1
        and number(y) and y >= 0 and y <= 1
end
local function trackedQuest()
    if not (C_SuperTrack and type(C_SuperTrack.GetSuperTrackedQuestID) == "function"
        and C_QuestLog and type(C_QuestLog.GetNextWaypoint) == "function") then
        return nil, "This client cannot provide Blizzard's selected quest destination. Use a TomTom point or RestedXP guide instead."
    end
    local ok, id = pcall(C_SuperTrack.GetSuperTrackedQuestID)
    if not ok then return nil, "Reading the tracked quest failed: " .. tostring(id) end
    if not number(id) or id <= 0 then return nil, "Select a quest in Blizzard's quest tracker first." end
    local located, map, x, y = pcall(C_QuestLog.GetNextWaypoint, id)
    if not located then return nil, "Reading the quest destination failed: " .. tostring(map) end
    if not valid(map, x, y) then return nil, "The selected quest has no available destination." end
    return {mapID = map, x = x, y = y, name = "Tracked quest " .. id}
end
function routing.Refresh()
    fault = nil
    local candidate = type(ShortestPathForever) == "table" and ShortestPathForever.API or nil
    local available = type(candidate) == "table" and candidate.version == 1
    for _, name in ipairs({"Navigate", "Cancel", "CurrentStop", "Active"}) do
        available = available and type(candidate[name]) == "function"
    end
    candidate = available and candidate or nil
    if candidate ~= api then api, selected, target, outcome = candidate, nil, nil, nil end
    owned, active = false, false
    if not api then publish("Routing requires a compatible Shortest Path Forever API v1."); return end
    owned = call("CurrentStop", owner) ~= nil
    if fault then owned = false; publish(fault); return end
    active = call("Active") == true
    if fault then publish(fault); return end
    if selected and not point(selected) then
        if owned and not call("Cancel", owner) then
            selected, target = nil, nil
            outcome = fault or "Waypoint removed; the provider route could not be stopped."
            publish(outcome); return
        end
        selected, target, owned, outcome = nil, nil, false, "Routed waypoint removed."
        active = call("Active") == true
    elseif target and not owned then
        local reason = type(api.Ended) == "function" and call("Ended", owner) or nil
        selected, target = nil, nil
        outcome = reason == "arrived" and "Destination reached." or "Route ended or was replaced."
    end
    if fault then publish(fault)
    elseif owned and not target and outcome then publish(outcome)
    elseif owned and inCombat() then publish("Route paused during combat.")
    elseif owned then publish("Navigation requested" .. (target and " for " .. target.name or "")
        .. ". Check the maps; Route report has calculation details.")
    elseif active then
        local source
        for _, name in ipairs({"RestedXP", "TomTom"}) do
            if call("CurrentStop", name) ~= nil then source = name; break end
            if fault then publish(fault); return end
        end
        if source == "RestedXP" then publish("RestedXP guide route active. Control guide following in Shortest Path settings.")
        elseif source == "TomTom" then publish("Shortest Path is following TomTom's arrow. Control following in Shortest Path settings.")
        else publish("A separate Shortest Path journey is active. Use its own controls to change or stop it.") end
    else publish(outcome or "Choose Navigate beside a saved waypoint.") end
end
function routing.OpenSettings(section)
    local command = SlashCmdList and SlashCmdList.SHORTESTPATHFOREVER
    if type(command) ~= "function" then return false, "Enable Shortest Path Forever, then use /path for route settings." end
    local ok, err = pcall(command, section or "")
    if not ok then return false, "Shortest Path settings failed: " .. tostring(err) end
    return true
end
function routing.Status() return message end
function routing.Provider() return not fault and api or nil end
-- Our own accepted request, never a provider-private goal/turn getter.
function routing.Destination()
    if not owned or not target or fault then return end
    return {mapID=target.mapID, x=target.x, y=target.y, name=target.name,
        source="route", waypointId=selected}
end
function routing.Detail() routing.Refresh(); return message end
function routing.CanStop() return owned end
local function navigate(saved, id)
    if not valid(saved.mapID, saved.x, saved.y) then return false, "invalid", "The target has no valid map location." end
    if not call("Navigate", owner, saved.mapID, saved.x, saved.y, saved.name) then
        outcome = fault or "Route not started. Check Shortest Path's Journeys setting and player location."
        publish(outcome); return false, "rejected", outcome
    end
    selected, target, outcome = id, {mapID = saved.mapID, x = saved.x, y = saved.y, name = saved.name}, nil
    routing.Refresh()
    if routing.OnStarted then routing.OnStarted() end
    return true, nil, "Navigation requested for " .. saved.name .. ". Guide-following settings stay as configured in Shortest Path."
end
function routing.Start(id, replace)
    routing.Refresh()
    local saved = point(id)
    if not saved then return false, "missing", "Saved waypoint not found." end
    if not api or fault then return false, "unavailable", message end
    if inCombat() then return false, "combat", "Start routing after combat ends." end
    if active and not owned and not replace then return false, "replace", "Another journey is active. Click Replace to route here instead." end
    return navigate(saved, id)
end
function routing.Stop()
    routing.Refresh()
    if fault then return false, message end
    if not api or not owned then return false, "No Group Compass route to stop. Use Shortest Path's controls for other journeys." end
    if not call("Cancel", owner) then
        local value = fault or "Shortest Path did not cancel the route."
        publish(value); return false, value
    end
    selected, target, outcome = nil, nil, "Route stopped."
    routing.Refresh()
    return true, "Route stopped."
end
function routing.Sources()
    routing.Refresh()
    if not api or fault then return nil, message end
    local quest, why = trackedQuest()
    return {quest = quest ~= nil, questReason = why, owned = owned, retry = owned and target ~= nil,
        combat = inCombat(), restedxp = SlashCmdList and type(SlashCmdList.SHORTESTPATHFOREVER) == "function"}
end
function routing.SelectSource(kind, id)
    local sources, err = routing.Sources()
    if not sources then return false, err end
    if kind == "restedxp" then
        local ok, why = routing.OpenSettings()
        return ok, why or "Shortest Path controls opened. Choose Guidance > RestedXP guide > Resume guide (bottom red button). Follow RestedXP guides must be enabled. This shortcut does not resume automatically."
    end
    if kind == "stop" then return routing.Stop() end
    if inCombat() then return false, "Change routes after combat ends." end
    if kind == "tomtom" then local ok, _, why = routing.Start(id, true); return ok, why end
    local saved
    if kind == "party" then
        for _, member in ipairs(addon.Tracking.RouteTargets()) do if member.id == id then saved = member; break end end
        if not saved or not saved.mapID then return false, saved and saved.reason or "Member is no longer in the group." end
        saved = {mapID = saved.mapID, x = saved.x, y = saved.y, name = saved.name .. " (location snapshot)"}
    elseif kind == "quest" then saved, err = trackedQuest()
    elseif kind == "retry" then
        if not owned or not target then return false, "No current Group Compass target to retry. Select a waypoint or member again." end
        if selected then local ok, _, why = routing.Start(selected, true); return ok, why end
        saved = target
    else return false, "Unknown golden-path source." end
    if not saved then return false, err end
    local ok, _, why = navigate(saved)
    return ok, why
end
function routing.Command(text)
    local action, rest = text:lower():match("^%s*(%S*)%s*(.-)%s*$")
    local result
    if action == "stop" then local _, value = routing.Stop(); result = value
    elseif action == "" or action == "status" then routing.Refresh(); result = routing.Status()
    else
        local id = tonumber(action == "replace" and rest or action)
        if id and (action == "replace" or rest == "") then local _, _, value = routing.Start(id, action == "replace"); result = value
        else result = "/gcompass route ID | replace ID | stop | status" end
    end
    print("Group Compass: " .. result)
end
