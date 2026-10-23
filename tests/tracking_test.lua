local addon = {}
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Tracking.lua"))("GroupCompass", addon)
local state
local secret = {} -- Emulates detection, not WoW's opaque secret-value runtime.
issecretvalue = function(value) return value == secret end
IsInInstance = function() return state.instance end
InCombatLockdown = function() return state.combat end
IsInRaid = function() return state.raid end
GetNumGroupMembers = function() return state.count end
GetNumSubgroupMembers = function() return state.count end
UnitIsUnit = function(unit) return unit == state.self end
UnitIsConnected = function(unit) return not state.offline[unit] end
UnitName = function(unit) return state.names[unit] or unit end
local function unitPosition(unit)
    assert(not state.offline[unit], "must not request offline member coordinates")
    local p = state.positions[unit]
    if p then return unpack(p) end
end
local function reset()
    state = { count = 1, names = {}, positions = {
        player = {100, 200, 0, 1}, party1 = {110, 200, 0, 1},
    }, offline = {} }
    UnitPosition = unitPosition
    GetPlayerFacing = function() return state.facing or 0 end
end
local function sample(expected, text)
    local members, message = addon.Tracking.Sample()
    assert(#members == expected, "unexpected number of located members")
    if text then assert(message:find(text, 1, true), message) end
    return members
end
reset()
local members = sample(1)
assert(members[1].angle == 0 and members[1].distance == 10)
assert(members[1].unit == "party1" and members[1].slot == 1 and members[1].color)
assert(members[1].north == 10 and members[1].west == 0 and members[1].facing == 0)
reset(); state.count = 0; sample(0, "No locatable")
reset(); state.instance = true; sample(1, "Character facing")
reset(); state.combat = true; sample(1, "Character facing")
state.instance = true; sample(1, "Character facing")
state.positions.party1 = nil; sample(0, "1 unavailable")
state.positions.party1 = {110, 200, 0, 1}; sample(1)
state.positions.player = nil; sample(0, "Player position")
state.positions.player = {100, 200, 0, 1}; sample(1)
reset(); UnitPosition = nil; sample(0, "API unavailable")
reset(); GetPlayerFacing = nil; sample(0, "API unavailable")
reset(); state.facing = secret; sample(0, "Player position")
reset(); GetPlayerFacing = function() return nil end; sample(0, "Player position")
reset(); state.positions.player = nil; sample(0, "Player position")
reset(); state.positions.party1 = nil; sample(0, "1 unavailable")
reset(); state.positions.party1[4] = 2; sample(0, "Different world area")
reset(); state.positions.party1[1] = secret; sample(0, "1 unavailable")
reset(); state.positions.party1[4] = secret; sample(0, "1 unavailable")
reset(); state.positions.party1[1] = 0 / 0; sample(0, "1 unavailable")
reset(); state.positions.party1[2] = math.huge; sample(0, "1 unavailable")
reset(); state.offline.party1 = true; sample(0, "1 unavailable")
reset(); state.names.party1 = secret; assert(sample(1)[1].name == "party1")
reset(); state.raid = true; state.count = 2; state.self = "raid1"
state.positions.raid2 = {100, 190, 0, 1}
assert(sample(1)[1].angle == math.pi / 2)
state.count = 0; sample(0, "No locatable") -- No cached roster or stale positions.
print("PASS: tracking availability, restrictions, secrets, offline, raid, roster changes")

-- Remote party members may have no UnitPosition at all. UI-map ancestry can
-- identify their continent without inventing coordinates or a compass bearing.
local function remoteMaps()
    C_Map = {
        GetBestMapForUnit = function(unit) return unit == "player" and 100 or 200 end,
        GetMapInfo = function(id)
            local maps = {
                [100] = {name = "Teldrassil", mapType = 3, parentMapID = 10},
                [10] = {name = "Kalimdor", mapType = 2, parentMapID = 1},
                [200] = {name = "Elwynn Forest", mapType = 3, parentMapID = 20},
                [20] = {name = "Eastern Kingdoms", mapType = 2, parentMapID = 1},
            }
            return maps[id]
        end,
    }
end
reset(); remoteMaps(); state.positions.party1 = nil; state.names.party1 = "Keina"
local remoteMembers, remoteStatus = addon.Tracking.Sample()
assert(#remoteMembers == 0 and remoteStatus == "Keina - Eastern Kingdoms",
    "different continents must show a named remote label even without world coordinates")
reset(); remoteMaps(); state.positions.party1[4] = 2
sample(0, "Eastern Kingdoms")
reset(); C_Map = nil; state.positions.party1[4] = 2
sample(0, "party1 - Different world area")
reset(); remoteMaps(); state.offline.party1 = true
C_Map.GetBestMapForUnit = function() error("must not query offline member maps") end
sample(0, "1 unavailable")
reset(); remoteMaps(); state.positions.party1 = nil
C_Map.GetBestMapForUnit = function() return 100 end
sample(0, "1 unavailable") -- Same continent is not evidence of a remote world area.
reset(); remoteMaps(); state.positions.party1 = nil
C_Map.GetBestMapForUnit = function() return secret end
sample(0, "1 unavailable")
reset(); remoteMaps(); state.positions.party1[4] = 2
C_Map.GetMapInfo = function(id) return {name = secret, mapType = 2, parentMapID = 0} end
sample(0, "Different world area")
reset(); remoteMaps(); state.positions.party1[4] = 2
C_Map.GetMapInfo = function(id) return {name = "Cycle", mapType = 3, parentMapID = id} end
sample(0, "Different world area")
reset(); remoteMaps(); state.positions.party1[4] = 2
C_Map.GetMapInfo = function() return secret end
sample(0, "Different world area")
reset(); remoteMaps(); state.positions.party1[4] = 2
C_Map.GetMapInfo = function() return {mapType = 3, parentMapID = secret} end
sample(0, "Different world area")
reset(); C_Map = {}; state.positions.party1[4] = 2
sample(0, "Different world area")
reset(); remoteMaps(); state.raid = true; state.positions.raid1 = {0, 0, 0, 2}
C_Map.GetBestMapForUnit = function() error("API only supports player and party") end
sample(0, "Different world area")
reset(); remoteMaps(); state.count = 2; state.positions.party2 = nil
local mixed, mixedStatus = addon.Tracking.Sample()
assert(#mixed == 1 and mixedStatus:find("party2 - Eastern Kingdoms", 1, true))
state.positions.party2 = {120, 200, 0, 1}
mixed, mixedStatus = addon.Tracking.Sample()
assert(#mixed == 2 and not mixedStatus:find("Eastern Kingdoms", 1, true),
    "remote labels must clear as soon as normal tracking resumes")
C_Map = nil
print("PASS: remote continent labels, unavailable distinction, API fallback and fresh roster state")

local mapCalls, mapID, mapPoint = 0, nil, nil
C_Map = { GetPlayerMapPosition = function(id, unit)
    mapCalls, mapID = mapCalls + 1, id
    assert(unit == "party1")
    return mapPoint
end }
local function point(x, y) return {GetXY = function() return x, y end} end
reset(); mapPoint = point(0.25, 0.75)
members = addon.Tracking.MapMembers(123)
assert(#members == 1 and members[1].x == 0.25 and members[1].y == 0.75 and mapID == 123)
assert(members[1].slot == 1 and members[1].name == "party1")
UnitPosition = nil; GetPlayerFacing = nil
assert(#addon.Tracking.MapMembers(123) == 1, "map must not depend on world/facing APIs")
for _, invalid in ipairs({secret, -0.1, 1.1, math.huge, 0 / 0}) do
    mapPoint = point(invalid, 0.5); assert(#addon.Tracking.MapMembers(123) == 0)
end
mapPoint = nil; assert(#addon.Tracking.MapMembers(123) == 0)
mapPoint = secret; assert(#addon.Tracking.MapMembers(123) == 0)
reset(); mapPoint = point(0.5, 0.5); state.offline.party1 = true
mapCalls = 0; assert(#addon.Tracking.MapMembers(123) == 0 and mapCalls == 0)
reset(); state.combat = true
assert(#addon.Tracking.MapMembers(123) == 1 and mapCalls == 1)
reset(); state.instance = true
assert(#addon.Tracking.MapMembers(123) == 1 and mapCalls == 2)
state.combat = true; mapPoint = nil
assert(#addon.Tracking.MapMembers(123) == 0 and mapCalls == 3)
mapPoint = point(0.5, 0.5)
assert(#addon.Tracking.MapMembers(123) == 1 and mapCalls == 4)
mapCalls = 0
reset(); state.raid = true
assert(#addon.Tracking.MapMembers(123) == 0 and mapCalls == 0)
reset(); assert(#addon.Tracking.MapMembers(secret) == 0 and mapCalls == 0)
C_Map = nil; assert(#addon.Tracking.MapMembers(123) == 0)
print("PASS: independent UI-map sampling, bounds, secrets, missing data, offline and restriction guards")

reset()
UnitClass = function() return "Mage", "MAGE" end
RAID_CLASS_COLORS = { MAGE = {r = 0.25, g = 0.78, b = 0.92} }
local classMember = sample(1)[1]
assert(classMember.name == "party1" and classMember.color[1] == 0.25 and classMember.color[2] == 0.78)
C_Map = {GetPlayerMapPosition = function() return point(0.2, 0.3) end}
local mapMember = addon.Tracking.MapMembers(123)[1]
assert(mapMember.name == classMember.name and mapMember.color[3] == classMember.color[3])
C_ClassColor = {GetClassColor = function(class)
    assert(class == "MAGE"); return {r = 0.1, g = 0.2, b = 0.3}
end}
assert(sample(1)[1].color[1] == 0.1)
local fallback = addon.Tracking.Color(1)
UnitClass = function() return nil, secret end
assert(sample(1)[1].color == fallback, "secret class must not be used as a lookup key")
UnitClass = function() return nil, nil end
assert(sample(1)[1].color == fallback)
C_ClassColor = {GetClassColor = function() return {r = secret, g = 0.2, b = 0.3} end}
UnitClass = function() return "Mage", "MAGE" end
assert(sample(1)[1].color == fallback)
UnitClass, C_ClassColor, RAID_CLASS_COLORS = nil, nil, nil
assert(sample(1)[1].color == fallback)
print("PASS: class-color defaults and member names across compass/map data, legacy/modern APIs and safe fallbacks")
