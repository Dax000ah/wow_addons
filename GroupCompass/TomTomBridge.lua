local _, addon = ...
-- TomTom v4's exposed waypoint table supplies read-only enumeration. Registry
-- changes use its methods; icon refresh changes documented UID options only.
-- No TomTom frames, saved-profile keys or provider code are copied.
addon.TomTomBridge = {}
local bridge = addon.TomTomBridge
local ids, nextID = setmetatable({}, {__mode = "k"}), 1000000
local hooked, arrow = setmetatable({}, {__mode = "k"}), setmetatable({}, {__mode = "k"})
local path = "Interface\\AddOns\\GroupCompass\\Textures\\"
local function readable(value) return not (issecretvalue and issecretvalue(value)) end
local function number(value)
    return readable(value) and type(value) == "number" and value == value and value > -math.huge and value < math.huge
end
local function valid(uid)
    return readable(uid) and type(uid) == "table" and number(uid[1]) and uid[1] > 0 and uid[1] % 1 == 0
        and number(uid[2]) and uid[2] >= 0 and uid[2] <= 1
        and number(uid[3]) and uid[3] >= 0 and uid[3] <= 1
end
local function call(api, method, ...)
    local ok, result = pcall(api[method], api, ...)
    if not ok then return nil, "TomTom " .. method .. " failed: " .. tostring(result) end
    return result
end
function bridge.Provider()
    local api = readable(TomTom) and type(TomTom) == "table" and TomTom or nil
    if not api or type(api.waypoints) ~= "table" then return end
    for _, method in ipairs({"AddWaypoint", "RemoveWaypoint", "IsValidWaypoint"}) do
        if type(api[method]) ~= "function" then return end
    end
    if not hooked[api] and hooksecurefunc and type(api.SetCrazyArrow) == "function" then
        hooked[api] = true
        hooksecurefunc(api, "SetCrazyArrow", function(_, uid, distance)
            -- A sticky corpse arrow may decline this request.
            if not (arrow[api] and arrow[api].uid and arrow[api].uid.corpse
                and api.db and api.db.profile.arrow.stickycorpse) then arrow[api] = {uid = uid, distance = distance} end
        end)
    end
    return api
end
function bridge.Icon(point)
    local uid = point.uid
    if not readable(uid.worldmap_icon) or not readable(uid.minimap_icon) then return "tomtom" end
    for _, choice in ipairs(addon.Settings.Icons) do
        if uid.worldmap_icon == path .. choice[1] .. ".tga" and uid.minimap_icon == uid.worldmap_icon then return choice[1] end
    end
    return "tomtom"
end
function bridge.MapShortcut()
    local api = bridge.Provider()
    local profile = api and api.db and api.db.profile
    local key = profile and profile.worldmap and profile.worldmap.create_modifier
    local names = {A="Alt", C="Ctrl", S="Shift", AC="Alt + Ctrl", AS="Alt + Shift", CS="Ctrl + Shift", ACS="Alt + Ctrl + Shift"}
    return readable(key) and names[key] and names[key] .. " + right-click" or "TomTom's map shortcut (default: Alt + right-click)"
end
local function point(uid)
    if not ids[uid] then nextID = nextID + 1; ids[uid] = nextID end
    local id = ids[uid]
    local name = readable(uid.title) and type(uid.title) == "string" and uid.title or "TomTom waypoint"
    name = name:gsub("|", ""):gsub("%c", " ")
    local source = readable(uid.from) and type(uid.from) == "string" and uid.from or "?"
    local item = {id = id, mapID = uid[1], x = uid[2], y = uid[3], name = name, uid = uid,
        source = "tomtom", tag = "T" .. (id - 1000000),
        readOnly = source ~= "GroupCompass" and source ~= "?" and not source:match("^TomTom/")}
    item.label = "[" .. item.tag .. "] " .. name
    item.icon = bridge.Icon(item)
    return item
end
function bridge.List()
    local api, list, seen = bridge.Provider(), {}, {}
    if not api then return list end
    for _, zone in pairs(api.waypoints) do
        if readable(zone) and type(zone) == "table" then
            for _, uid in pairs(zone) do
                if valid(uid) and not seen[uid] then
                    seen[uid] = true
                    list[#list + 1] = point(uid)
                end
            end
        end
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    return list
end
local function current(item)
    local api = bridge.Provider()
    if not api or not valid(item.uid) then return nil, "TomTom waypoint is unavailable." end
    local exists, err = call(api, "IsValidWaypoint", item.uid)
    if not exists then return nil, err or "TomTom waypoint no longer exists." end
    return api
end
local function icons(opts, icon)
    if icon == "tomtom" then
        return -- Preserve TomTom's current theme, custom texture or portrait.
    else
        opts.worldmap_icon, opts.minimap_icon = path .. icon .. ".tga", path .. icon .. ".tga"
        opts.worldmap_displayID, opts.minimap_displayID = nil, nil
    end
end
function bridge.Add(mapID, x, y, name, icon)
    local api = bridge.Provider()
    if not api then return nil, "Enable TomTom to use its waypoints." end
    local opts = {title = name, from = "GroupCompass", persistent = true, crazy = false, silent = true}
    if icon and icon ~= "tomtom" then icons(opts, icon) end
    local uid, err = call(api, "AddWaypoint", mapID, x, y, opts)
    if not valid(uid) then return nil, err or "TomTom did not create the waypoint." end
    local exists, validationError = call(api, "IsValidWaypoint", uid)
    if not exists then return nil, validationError or "TomTom did not retain the waypoint." end
    return point(uid)
end
function bridge.Remove(item)
    local api, err = current(item)
    if not api then return false, err end
    if item.readOnly then return false, "This waypoint is managed by another addon. Remove it there." end
    local _, removeError = call(api, "RemoveWaypoint", item.uid)
    if removeError then return false, removeError end
    local exists, validationError = call(api, "IsValidWaypoint", item.uid)
    return not exists and not validationError, validationError or (exists and "TomTom did not remove the waypoint." or "Waypoint removed.")
end
function bridge.Update(item, name, icon)
    local api, err = current(item)
    if not api then return nil, err end
    if item.readOnly then return nil, "This waypoint is managed by another addon. Edit it there." end
    if name == item.name and icon == item.icon then return item end
    local old, opts = item.uid, {}
    for key, value in pairs(old) do if type(key) == "string" then opts[key] = value end end
    opts.title, opts.crazy, opts.silent = name, false, true
    icons(opts, icon)
    if type(api.UIDIsSaved) == "function" then
        local saved, savedError = call(api, "UIDIsSaved", old)
        if savedError then return nil, savedError end
        opts.persistent = saved == true
    end
    if name == old.title then
        -- Icon options are not part of TomTom's key. Refresh this same UID so
        -- existing arrow/callback references remain valid, including persistence.
        if type(api.ClearWaypoint) ~= "function" or type(api.SetWaypoint) ~= "function" then
            return nil, "This TomTom version cannot refresh waypoint icons."
        end
        local prior = {old.worldmap_icon, old.minimap_icon, old.worldmap_displayID, old.minimap_displayID}
        local _, clearError = call(api, "ClearWaypoint", old)
        if clearError then return nil, clearError end
        old.worldmap_icon, old.minimap_icon = opts.worldmap_icon, opts.minimap_icon
        old.worldmap_displayID, old.minimap_displayID = opts.worldmap_displayID, opts.minimap_displayID
        local _, refreshError = call(api, "SetWaypoint", old, old.callbacks, old.minimap, old.world)
        if refreshError then
            old.worldmap_icon, old.minimap_icon, old.worldmap_displayID, old.minimap_displayID = unpack(prior, 1, 4)
            call(api, "ClearWaypoint", old)
            local _, restoreError = call(api, "SetWaypoint", old, old.callbacks, old.minimap, old.world)
            return nil, refreshError .. (restoreError and " Restore failed: " .. restoreError or " Original icon restored.")
        end
        return point(old)
    end
    -- TomTom's title is part of its key and there is no Rename API. Add first;
    -- reject collisions, then remove the original only after validating the new UID.
    local existingUIDs = {}
    for _, other in ipairs(bridge.List()) do
        existingUIDs[other.uid] = true
        if other.uid ~= old and other.mapID == item.mapID and other.x == item.x and other.y == item.y and other.name == name then
            return nil, "A TomTom waypoint already has that name at this location."
        end
    end
    local tracked = arrow[api]
    if type(api.IsCrazyArrowEmpty) == "function" then
        local empty, arrowError = call(api, "IsCrazyArrowEmpty")
        if arrowError then return nil, arrowError end
        if empty then tracked = nil end
        if not empty and not tracked then return nil, "Clear TomTom's waypoint arrow before renaming, then try Save again." end
    end
    local uid, addError = call(api, "AddWaypoint", item.mapID, item.x, item.y, opts)
    if not valid(uid) then return nil, addError or "TomTom did not create the renamed waypoint; original kept." end
    if existingUIDs[uid] then return nil, "TomTom matched an existing waypoint; original kept." end
    local exists, validationError = call(api, "IsValidWaypoint", uid)
    if not exists then return nil, validationError or "TomTom did not retain the renamed waypoint; original kept." end
    local _, removeError = call(api, "RemoveWaypoint", old)
    local remains, checkError = call(api, "IsValidWaypoint", old)
    if removeError or remains or checkError then
        local _, cleanupError = call(api, "RemoveWaypoint", uid)
        return nil, (removeError or checkError or "TomTom kept the original waypoint.")
            .. (cleanupError and " New waypoint cleanup failed: " .. cleanupError or " Original retained.")
    end
    ids[uid] = item.id
    uid.crazy = old.crazy -- Preserve its reload option without changing the current arrow.
    if tracked and tracked.uid == old then
        local _, arrowError = call(api, "SetCrazyArrow", uid, tracked.distance, name)
        if arrowError then return point(uid), "Name saved; TomTom arrow refresh failed: " .. arrowError end
    end
    return point(uid)
end
