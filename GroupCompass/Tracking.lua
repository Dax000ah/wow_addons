local _, addon = ...
addon.Tracking = {}

local function readable(value)
    return not (issecretvalue and issecretvalue(value))
end

local function number(value)
    return readable(value) and type(value) == "number"
        and value == value and value > -math.huge and value < math.huge
end

local colors = {
    { 0.35, 0.80, 1 }, { 1, 0.75, 0.25 }, { 0.65, 1, 0.45 },
    { 1, 0.50, 0.80 }, { 0.80, 0.65, 1 }, { 0.40, 1, 0.85 },
}

function addon.Tracking.Color(slot, unit)
    if unit and UnitClass then
        local _, class = UnitClass(unit)
        if readable(class) and type(class) == "string" then
            local color = C_ClassColor and C_ClassColor.GetClassColor and C_ClassColor.GetClassColor(class)
                or RAID_CLASS_COLORS and RAID_CLASS_COLORS[class]
            if readable(color) and color and number(color.r) and number(color.g) and number(color.b) then
                return {color.r, color.g, color.b}
            end
        end
    end
    return colors[(slot - 1) % #colors + 1]
end

local function roster()
    local members = {}
    local raid = IsInRaid()
    local count = raid and GetNumGroupMembers() or GetNumSubgroupMembers()
    for index = 1, count do
        local unit = (raid and "raid" or "party") .. index
        if not UnitIsUnit(unit, "player") then
            local name = UnitName(unit)
            if not readable(name) or type(name) ~= "string" then name = unit end
            members[#members + 1] = {
                unit = unit, slot = index, name = name,
                color = addon.Tracking.Color(index, unit),
            }
        end
    end
    return members
end

local function position(unit)
    local connected = UnitIsConnected(unit)
    if not readable(connected) or not connected then
        return
    end
    local x, y, z, map = UnitPosition(unit)
    if number(x) and number(y) and number(z) and number(map) then
        return x, y, z, map
    end
end

-- UI-map IDs and UnitPosition world IDs are different namespaces. Resolve the
-- continent through UI-map parents; never use a world ID as a GetMapInfo key.
local function continent(unit)
    if IsInRaid() or not C_Map or not C_Map.GetBestMapForUnit or not C_Map.GetMapInfo then return end
    local id = C_Map.GetBestMapForUnit(unit)
    local seen = {}
    local continentType = Enum and Enum.UIMapType and Enum.UIMapType.Continent or 2
    for _ = 1, 20 do
        if not number(id) or id <= 0 or seen[id] then return end
        seen[id] = true
        local info = C_Map.GetMapInfo(id)
        if not readable(info) or type(info) ~= "table" then return end
        if number(info.mapType) and info.mapType == continentType then
            if readable(info.name) and type(info.name) == "string" and info.name ~= "" then
                return id, info.name
            end
            return
        end
        id = info.parentMapID
    end
end

-- Map coordinates use UI-map IDs and normalized X/Y, never UnitPosition's map ID.
-- This view can work even when facing or world coordinates are unavailable.
function addon.Tracking.MapMembers(uiMapID)
    if IsInRaid() or not number(uiMapID) or not C_Map or not C_Map.GetPlayerMapPosition then
        return {}
    end
    local members = {}
    for _, member in ipairs(roster()) do
        local connected = UnitIsConnected(member.unit)
        if readable(connected) and connected then
            local point = C_Map.GetPlayerMapPosition(uiMapID, member.unit)
            if readable(point) and point then
                local x, y = point:GetXY()
                if number(x) and number(y) and x >= 0 and x <= 1 and y >= 0 and y <= 1 then
                    member.x, member.y = x, y
                    members[#members + 1] = member
                end
            end
        end
    end
    return members
end

-- Heading remains useful while solo or when the client withholds coordinates.
function addon.Tracking.Facing()
    local facing = GetPlayerFacing and GetPlayerFacing()
    if number(facing) then return facing end
end

-- Routing takes a snapshot of a real member's current UI-map location. It does
-- not invent coordinates for offline members or continuously chase a patrol.
function addon.Tracking.RouteTargets()
    local targets = {}
    for _, member in ipairs(roster()) do
        local connected = UnitIsConnected(member.unit)
        member.id = UnitGUID and UnitGUID(member.unit) or member.unit
        if not readable(member.id) then member.id = member.unit end
        if readable(connected) and connected and C_Map and C_Map.GetBestMapForUnit
            and C_Map.GetPlayerMapPosition then
            local map = C_Map.GetBestMapForUnit(member.unit)
            if number(map) and map > 0 then
                local point = C_Map.GetPlayerMapPosition(map, member.unit)
                if readable(point) and point then
                    local x, y = point:GetXY()
                    if number(x) and number(y) and x >= 0 and x <= 1 and y >= 0 and y <= 1 then
                        member.mapID, member.x, member.y = map, x, y
                    end
                end
            end
        end
        member.reason = not member.mapID and "Member location unavailable (offline, another area, or withheld by the client)." or nil
        targets[#targets + 1] = member
    end
    return targets
end

function addon.Tracking.PlayerState()
    -- Combat/instances do not disable the addon. Use only coordinates the client
    -- actually exposes; nil/secret/invalid values still clear affected markers.
    if not UnitPosition or not GetPlayerFacing then
        return nil, "Position or facing API unavailable"
    end
    local facing = addon.Tracking.Facing()
    local px, py, _, playerMap = position("player")
    if not number(facing) or not px then
        return nil, "Player position or facing unavailable"
    end
    return {x = px, y = py, map = playerMap, facing = facing}
end

function addon.Tracking.Sample()
    local player, message = addon.Tracking.PlayerState()
    if not player then return {}, message end
    local members, unavailable, remote = {}, 0, {}
    local playerContinent, continentChecked
    for _, member in ipairs(roster()) do
        local x, y, _, map = position(member.unit)
        if x and map == player.map then
            local angle, distance = addon.Direction.Calculate(player.x, player.y, x, y, player.facing)
            member.angle, member.distance = angle, distance
            member.north, member.west = x - player.x, y - player.y
            member.facing = player.facing
            members[#members + 1] = member
        else
            local connected = UnitIsConnected(member.unit)
            local remoteLabel
            if readable(connected) and connected then
                if not continentChecked then
                    playerContinent = continent("player")
                    continentChecked = true
                end
                local memberContinent, continentName = continent(member.unit)
                local differentContinent = playerContinent and memberContinent
                    and playerContinent ~= memberContinent
                if differentContinent or (x and map ~= player.map) then
                    remoteLabel = member.name .. " - " .. (continentName or "Different world area")
                end
            end
            if remoteLabel then remote[#remote + 1] = remoteLabel
            else unavailable = unavailable + 1 end
        end
    end
    local status = #members == 0 and "No locatable group members" or "Character facing - center is ahead"
    if #remote > 0 then
        status = (#members == 0 and "" or status .. "; ") .. table.concat(remote, "; ")
    end
    if unavailable > 0 then
        status = status .. " (" .. unavailable .. " unavailable)"
    end
    return members, status
end
