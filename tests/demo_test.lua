local addon = {}
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Tracking.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Demo.lua"))("GroupCompass", addon)
local x, y, map, facing = 100, 200, 1, 1.2
local combat, instance, unavailable = false, false, false
IsInInstance = function() return instance end
InCombatLockdown = function() return combat end
UnitIsConnected = function() return true end
GetPlayerFacing = function() return facing end
UnitPosition = function(unit)
    assert(unit == "player", "demo must not sample real members")
    if not unavailable then return x, y, 0, map end
end
GetNumSubgroupMembers = function() error("demo must not need a real party") end
local function near(actual, expected) assert(math.abs(actual - expected) < 0.000001) end
local members, message = addon.Demo.Sample()
assert(#members == 3 and message:find("DEMO"))
near(members[1].angle, -math.pi / 3); near(members[1].distance, 25)
near(members[2].angle, 0); near(members[2].distance, 40)
near(members[3].angle, math.pi / 3); near(members[3].distance, 60)
assert(members[1].color == addon.Tracking.Color(1))
facing = 1.7
members = addon.Demo.Sample()
near(members[2].angle, 0.5); near(members[2].distance, 40)
-- Walk ten yards toward the original ahead anchor, while facing another way.
x, y = x + math.cos(1.2) * 10, y + math.sin(1.2) * 10
members = addon.Demo.Sample(); near(members[2].distance, 30)
members = addon.Demo.Sample(); near(members[2].distance, 30) -- No per-tick reanchoring.
facing = 1.2 + math.pi
members = addon.Demo.Sample(); near(math.abs(members[2].angle), math.pi)
combat = true
members, message = addon.Demo.Sample(); assert(#members == 3 and not message:find("paused"))
near(members[2].distance, 30)
combat = false; unavailable = true
members, message = addon.Demo.Sample(); assert(#members == 0 and message:find("unavailable"))
unavailable = false
members = addon.Demo.Sample(); near(members[2].distance, 30) -- Resume existing anchors.
map, x, y = 2, 500, 600
members = addon.Demo.Sample(); near(members[2].distance, 40); near(members[2].angle, 0)
x = x + 15
addon.Demo.Reset()
members = addon.Demo.Sample(); near(members[2].distance, 40); near(members[2].angle, 0)
instance = true; members = addon.Demo.Sample(); assert(#members == 3)
combat = true; members = addon.Demo.Sample(); assert(#members == 3)
print("PASS: solo world anchors, turning, walking, behind bearings, pause/resume, map changes and reset")
