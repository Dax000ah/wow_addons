local _, addon = ...
addon.Waypoints = {}
local waypoints = addon.Waypoints
local db = {points = {}}
local bridge, lastSignature, migrating, importMessage, importProvider = addon.TomTomBridge, nil, false, nil, nil
local lastIDs = {}
waypoints.Limit = 20
local gold = {1, 0.78, 0.25}
local utf8Character = "[^" .. string.char(128) .. "-" .. string.char(191) .. "]["
    .. string.char(128) .. "-" .. string.char(191) .. "]*"

local function readable(value) return not (issecretvalue and issecretvalue(value)) end
local function number(value)
    return readable(value) and type(value) == "number" and value == value
        and value > -math.huge and value < math.huge
end
local function coordinate(value) return number(value) and value >= 0 and value <= 1 end
local function id(value) return number(value) and value > 0 and value % 1 == 0 and value < 2147483647 end
local function valid(point)
    return type(point) == "table" and id(point.id) and id(point.mapID)
        and coordinate(point.x) and coordinate(point.y) and type(point.name) == "string"
end
local function validIcon(value)
    if not readable(value) or type(value) ~= "string" then return false end
    for _, choice in ipairs(addon.Settings.Icons) do if value == choice[1] then return true end end
    return false
end
local function cleanName(name, pointID)
    name = type(name) == "string" and name:gsub("|", ""):gsub("%c", " "):match("^%s*(.-)%s*$") or ""
    local characters = {}
    for character in name:gmatch(utf8Character) do
        if #characters == 48 then break end
        characters[#characters + 1] = character
    end
    name = table.concat(characters)
    return name ~= "" and name or "Waypoint " .. pointID
end
local function notify(action) if waypoints.OnChanged then waypoints.OnChanged(action) end end
local function worldPosition(mapID, x, y)
    if not C_Map or not C_Map.GetWorldPosFromMapPos or not CreateVector2D then return end
    local worldID, position = C_Map.GetWorldPosFromMapPos(mapID, CreateVector2D(x, y))
    if not number(worldID) or worldID < 0 or not readable(position) or not position then return end
    -- Native C_Map vector axes match UnitPosition: north first, west second.
    local north, west = position:GetXY()
    if number(north) and number(west) then return north, west, worldID end
end
local function marker(point)
    return {unit = "waypoint:" .. point.id, kind = "waypoint", waypointId = point.id,
        slot = 40 + point.id, name = point.name, label = point.label, source = point.source,
        color = gold, icon = waypoints.Icon(point)}
end
function waypoints.Icon(point) return point.icon or "tomtom" end
function waypoints.UsesTomTom() return bridge and bridge.Provider() ~= nil end
function waypoints.MapShortcut() return bridge.MapShortcut() end
function waypoints.OpenSettings()
    if not waypoints.UsesTomTom() or not SlashCmdList or type(SlashCmdList.TOMTOM) ~= "function" then
        return false, "Enable TomTom, then use /tomtom to open its settings."
    end
    local ok, err = pcall(SlashCmdList.TOMTOM, "")
    return ok, not ok and "TomTom settings failed: " .. tostring(err) or nil
end
function waypoints.Status()
    return waypoints.UsesTomTom() and (importMessage or "TomTom owns waypoint pins and saves. Use its map shortcut or /way.")
        or "Enable TomTom in AddOns and restart WoW. Your old points are retained for import."
end
local function importLegacy()
    if migrating or not waypoints.UsesTomTom() then return end
    local provider = bridge.Provider()
    if importProvider == provider then return end
    importProvider, importMessage = provider, nil
    migrating = true
    if type(db.tomtomImported) ~= "table" then db.tomtomImported = {} end
    for _, point in ipairs(db.points) do
        if valid(point) and not db.tomtomImported[point.id] then
            local imported, err = bridge.Add(point.mapID, point.x, point.y, point.name, validIcon(point.icon) and point.icon or "pin")
            if imported then db.tomtomImported[point.id] = true
            else importMessage = "Legacy waypoint import pending: " .. err; break end
        end
    end
    migrating = false
end
function waypoints.Initialize()
    -- Retain legacy saved records unchanged; TomTom is the sole live store.
    if type(GroupCompassWaypointsDB) ~= "table" then GroupCompassWaypointsDB = {} end
    db = GroupCompassWaypointsDB
    if type(db.points) ~= "table" then db.points = {} end
    importProvider = nil
    importLegacy()
end
function waypoints.List()
    if waypoints.UsesTomTom() then importLegacy(); return bridge.List() end
    return {}
end
function waypoints.Find(pointID)
    for _, point in ipairs(waypoints.List()) do if point.id == pointID then return point end end
end
function waypoints.Update(pointID, name, icon)
    local point = waypoints.Find(pointID)
    if not point then return nil, "Waypoint no longer exists." end
    if not validIcon(icon) and not (point.source == "tomtom" and icon == "tomtom") then return nil, "Choose an icon from the palette." end
    local updated, err = bridge.Update(point, cleanName(name, point.id), icon)
    if not updated then return nil, err end
    notify("edit")
    return updated, err or "Saved " .. updated.label
end
function waypoints.Add(mapID, x, y, name)
    if not id(mapID) or not coordinate(x) or not coordinate(y) then return nil, "Use map coordinates from 0 to 100." end
    if waypoints.UsesTomTom() then
        local point, err = bridge.Add(mapID, x, y, cleanName(name, "(TomTom)"))
        if point then notify("add"); return point, "Added " .. point.label end
        return nil, err
    end
    return nil, waypoints.Status()
end
function waypoints.AddHere(name)
    if not C_Map or not C_Map.GetBestMapForUnit or not C_Map.GetPlayerMapPosition then
        return nil, "Player map position API unavailable."
    end
    local mapID = C_Map.GetBestMapForUnit("player")
    if not id(mapID) then return nil, "Player map unavailable." end
    local position = C_Map.GetPlayerMapPosition(mapID, "player")
    if not readable(position) or not position then return nil, "Player map position unavailable." end
    local x, y = position:GetXY()
    return waypoints.Add(mapID, x, y, name)
end
function waypoints.Remove(pointID)
    local item = waypoints.Find(pointID)
    if item and item.source == "tomtom" then
        local removed, err = bridge.Remove(item)
        if removed then notify("remove") end
        return removed, err
    end
    return false, "TomTom waypoint not found."
end
function waypoints.Sample()
    local points, entries = waypoints.List(), {}
    if #points == 0 then return entries, 0 end
    local player = addon.Tracking.PlayerState()
    if not player then return entries, #points end
    for _, point in ipairs(points) do
        local north, west, worldID = worldPosition(point.mapID, point.x, point.y)
        if north and worldID == player.map then
            local entry = marker(point)
            entry.angle, entry.distance = addon.Direction.Calculate(player.x, player.y, north, west, player.facing)
            entry.north, entry.west, entry.facing = north - player.x, west - player.y, player.facing
            entries[#entries + 1] = entry
        end
    end
    table.sort(entries, function(a, b)
        if a.distance ~= b.distance then return a.distance < b.distance end
        return a.slot < b.slot
    end)
    while #entries > waypoints.Limit do table.remove(entries) end
    return entries, #points - #entries
end
function waypoints.Refresh()
    local points, signature = waypoints.List(), {waypoints.UsesTomTom() and "tomtom" or "missing"}
    for _, point in ipairs(points) do
        signature[#signature + 1] = table.concat({point.id, point.mapID, point.x, point.y, point.name, point.icon or "pin"}, "\031")
    end
    signature = table.concat(signature, "\030")
    if signature ~= lastSignature then
        local added, ids = false, {}
        for _, point in ipairs(points) do ids[point.id] = true; if not lastIDs[point.id] then added = true end end
        lastSignature, lastIDs = signature, ids
        notify(added and "add" or "sync")
    end
end
function waypoints.Command(command)
    local action, rest = command:match("^(%S*)%s*(.-)$")
    action = action:lower()
    if action == "" or action == "list" then
        local points = waypoints.List()
        print("Group Compass: " .. #points .. " waypoints. " .. waypoints.Status())
        for _, point in ipairs(points) do
            print(string.format("%s (ID %d) - map %d, %.1f %.1f", point.label or "[W" .. point.id .. "] " .. point.name, point.id, point.mapID, point.x * 100, point.y * 100))
        end
        return
    elseif action == "remove" then
        local removed, err = waypoints.Remove(tonumber(rest))
        print("Group Compass: " .. (removed and "waypoint removed." or err or "waypoint not found."))
        return
    elseif action == "here" then
        local _, message = waypoints.AddHere(rest); print("Group Compass: " .. message); return
    end
    local x, y, name = command:match("^(%S+)%s+(%S+)%s*(.-)$")
    x, y = tonumber(x), tonumber(y)
    if x and y and C_Map and C_Map.GetBestMapForUnit then
        local _, message = waypoints.Add(C_Map.GetBestMapForUnit("player"), x / 100, y / 100, name)
        print("Group Compass: " .. message)
    else print("Group Compass: /gcompass waypoint here [name] | X Y [name] | list | remove ID") end
end
