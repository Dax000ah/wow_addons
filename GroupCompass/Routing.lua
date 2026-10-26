local _, addon = ...
addon.Routing = {}
local routing = addon.Routing
local owner, api, selected, owned, active = "GroupCompass", nil, nil, false, false
local message, outcome, fault, guidanceError = "Routing requires Shortest Path Forever.", nil, nil, nil
local cyan = {0.1, 0.8, 1}
local function publish(value)
    if value == message then return end
    message = value
    if routing.OnChanged then routing.OnChanged() end
end
local function point(id)
    for _, item in ipairs(addon.Waypoints.List()) do if item.id == id then return item end end
end
local function label(saved) return saved.label or "[W" .. saved.id .. "] " .. saved.name end
local function call(method, ...)
    local ok, value, reason = pcall(api[method], ...)
    if not ok then
        fault = "Shortest Path " .. method .. " failed: " .. tostring(value)
        return nil
    end
    return value, reason
end
local function inCombat() return InCombatLockdown and InCombatLockdown() end
function routing.Refresh()
    fault = nil
    local candidate = type(ShortestPathForever) == "table" and ShortestPathForever.API or nil
    local available = type(candidate) == "table" and candidate.version == 1
    for _, name in ipairs({"Navigate", "Cancel", "CurrentStop", "Active"}) do
        available = available and type(candidate[name]) == "function"
    end
    candidate = available and candidate or nil
    if candidate ~= api then
        api, selected, outcome, guidanceError = candidate, nil, nil, nil
    end
    owned, active = false, false
    if not api then publish("Routing requires a compatible Shortest Path Forever API v1."); return end
    owned = call("CurrentStop", owner) ~= nil
    if fault then owned = false; publish(fault); return end
    active = call("Active") == true
    if fault then publish(fault); return end
    if selected and not point(selected) then
        if owned and not call("Cancel", owner) then
            selected, guidanceError = nil, nil
            outcome = fault or "Waypoint removed; the provider route could not be stopped."
            publish(outcome); return
        end
        if fault then publish(fault); return end
        selected, owned, guidanceError = nil, false, nil
        outcome = "Routed waypoint removed."
        active = call("Active") == true
    end
    if selected and not owned then
        local reason = type(api.Ended) == "function" and call("Ended", owner) or nil
        selected, guidanceError = nil, nil
        outcome = reason == "arrived" and "Destination reached." or "Route ended or was replaced."
    end
    if fault then publish(fault)
    elseif owned and not selected and outcome then publish(outcome)
    elseif owned and inCombat() then publish("Route paused during combat.")
    elseif owned and not active then publish("Route selected; waiting for guidance or no route available.")
    elseif owned and guidanceError then publish(guidanceError)
    elseif owned and type(api.GetGuidance) ~= "function" then publish("Route on maps; provider next-turn API unavailable.")
    elseif owned then
        local saved = selected and point(selected)
        publish(saved and "Routing to " .. label(saved) or outcome or "A Group Compass route is active.")
    elseif active then publish("Another journey is active. Navigate will ask before replacing it.")
    else publish(outcome or "Choose Navigate beside a saved waypoint.") end
end
function routing.Status() return message end
function routing.CanStop() return owned end
function routing.Start(id, replace)
    routing.Refresh()
    local saved = point(id)
    if not saved then return false, "missing", "Saved waypoint not found." end
    if not api or fault then return false, "unavailable", message end
    if inCombat() then return false, "combat", "Start routing after combat ends." end
    if active and not owned and not replace then
        return false, "replace", "Another journey is active. Click Replace to route here instead."
    end
    local accepted = call("Navigate", owner, saved.mapID, saved.x, saved.y, saved.name)
    if not accepted then
        outcome = fault or "Route not started. Check Shortest Path's Journeys setting and player location."
        publish(outcome)
        return false, "rejected", outcome
    end
    selected, outcome, guidanceError = id, nil, nil
    routing.Refresh()
    if routing.OnStarted then routing.OnStarted() end
    return true, nil, "Route requested for " .. label(saved)
end
function routing.Stop()
    routing.Refresh()
    if fault then return false, message end
    if not api or not owned then return false, "No Group Compass route to stop." end
    local stopped = call("Cancel", owner)
    if not stopped then
        local value = fault or "Shortest Path did not cancel the route."
        publish(value); return false, value
    end
    selected, outcome, guidanceError = nil, "Route stopped.", nil
    routing.Refresh()
    return true, "Route stopped."
end
local function number(value)
    return not (issecretvalue and issecretvalue(value)) and type(value) == "number"
        and value == value and value > -math.huge and value < math.huge
end
function routing.Sample()
    routing.Refresh()
    if not api or not selected or not owned or not active or fault or inCombat() or type(api.GetGuidance) ~= "function" then return {} end
    local guidance = call("GetGuidance", owner)
    if fault then guidanceError = fault; publish(fault); return {} end
    guidanceError = nil
    if (issecretvalue and issecretvalue(guidance)) or type(guidance) ~= "table"
        or not number(guidance.version) or guidance.version ~= 1 then return {} end
    local target = guidance.target
    if (issecretvalue and issecretvalue(target)) or type(target) ~= "table"
        or not number(target.worldMapID) or target.worldMapID < 0 or target.worldMapID % 1 ~= 0 or not number(target.north)
        or not number(target.west) then return {} end
    local player = addon.Tracking.PlayerState()
    if not player or target.worldMapID ~= player.map then return {} end
    local angle, distance = addon.Direction.Calculate(player.x, player.y, target.north, target.west, player.facing)
    return {{kind = "route", unit = "route:next", slot = 1000000, name = "Next step",
        label = "[Route] Next step", color = cyan, angle = angle, distance = distance}}
end
function routing.Command(text)
    local action, rest = text:lower():match("^%s*(%S*)%s*(.-)%s*$")
    local result
    if action == "stop" then local _, value = routing.Stop(); result = value
    elseif action == "" or action == "status" then routing.Refresh(); result = routing.Status()
    else
        local id = tonumber(action == "replace" and rest or action)
        if id and (action == "replace" or rest == "") then
            local _, _, value = routing.Start(id, action == "replace"); result = value
        else result = "/gcompass route ID | replace ID | stop | status" end
    end
    print("Group Compass: " .. result)
end
