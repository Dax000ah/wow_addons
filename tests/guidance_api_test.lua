local owned, active, combat, corpse = true, true, false, false
local target = {map = 0, x = 100, y = -50}
local nextTarget = {map = 0, x = 110, y = -60}
local goal = {map = 1, x = 9000, y = 1000}
local ns = {GuideTargets = function() return target, nextTarget, target, goal end,
    Corpse = {Active = function() return corpse end}}
ShortestPathForever = {API = {version = 1,
    CurrentStop = function(owner) return owned and owner == "GroupCompass" and 1 or nil end,
    Active = function() return active end}}
InCombatLockdown = function() return combat end
local secret = {}
issecretvalue = function(value) return value == secret end
canaccessvalue = function(value) return value ~= secret end
local loadExtension = assert(loadfile("integrations/ShortestPathForever/GuidanceAPI.lua"))
loadExtension("ShortestPathForever", ns)
local get = ShortestPathForever.API.GetGuidance
local result = assert(get("GroupCompass"))
assert(result.version == 1 and result.target.worldMapID == 0)
assert(result.target.north == 100 and result.target.west == -50)
assert(result.destination.worldMapID == 1, "destination may be in a different world")
result.target.north = -900
result.stepEnd.west = -900
assert(target.x == 100 and target.y == -50, "snapshots must not expose provider-owned points")
assert(get("OtherAddon") == nil)
owned = false; local point, reason = get("GroupCompass"); assert(not point and reason == "not-owned")
owned = true; combat = true
point, reason = get("GroupCompass"); assert(not point and reason == "combat")
combat = false; corpse = true
point, reason = get("GroupCompass"); assert(not point and reason == "corpse")
corpse = false; active = false
point, reason = get("GroupCompass"); assert(not point and reason == "inactive")
active = true; target = nil
point, reason = get("GroupCompass"); assert(not point and reason == "no-target")
target = {map = 1, x = secret, y = 0}; assert(get("GroupCompass") == nil)
target = {map = 1, x = 0/0, y = 0}; assert(get("GroupCompass") == nil)
target = {map = -1, x = 0, y = 0}; assert(get("GroupCompass") == nil)
target = {map = 1, x = 10, y = 20}; nextTarget = {map = 1, x = math.huge, y = 20}
result = assert(get("GroupCompass")); assert(result.nextTarget == nil)
target = {map = 0, x = 200, y = 300}
result = assert(get("GroupCompass")); assert(result.target.north == 200, "read the updated bend each time")
loadExtension("ShortestPathForever", ns)
assert(ShortestPathForever.API.GetGuidance == get, "loading twice must preserve the getter")
loadExtension("ShortestPathForever", {})
assert(ShortestPathForever.API.GetGuidance == get, "a future provider getter needs no private namespace")
io.write("PASS: proposed guidance API snapshots, ownership, combat, corpse, invalid data and advancing targets\n")
