-- Proposed provider-side API extension for Shortest Path Forever v1.22.4.
-- Load last in that addon's TOC, in its namespace. Not part of GroupCompass.toc.
-- Original Group Compass integration code; no SPF routing code is bundled here.
local _, ns = ...
local api = ShortestPathForever and ShortestPathForever.API
if api and api.GetGuidance then return end -- Preserve a provider's future implementation.
assert(api and api.version == 1 and type(ns.GuideTargets) == "function",
    "GuidanceAPI requires Shortest Path Forever API v1 and GuideTargets")

local function readable(value)
    return not (issecretvalue and issecretvalue(value)) and (not canaccessvalue or canaccessvalue(value))
end
local function number(value)
    return readable(value) and type(value) == "number"
        and value == value and value > -math.huge and value < math.huge
end
local function copy(point)
    if not readable(point) or type(point) ~= "table" or not number(point.map) or point.map < 0
        or point.map % 1 ~= 0 or not number(point.x) or not number(point.y) then return end
    -- These are world-space yards, NOT uiMapID/normalized map coordinates.
    return {worldMapID = point.map, north = point.x, west = point.y}
end

function api.GetGuidance(owner)
    if not api.CurrentStop(owner) then return nil, "not-owned" end
    if InCombatLockdown() then return nil, "combat" end
    if ns.Corpse and ns.Corpse.Active() then return nil, "corpse" end
    if not api.Active() then return nil, "inactive" end
    local target, nextTarget, stop, goal = ns.GuideTargets()
    local current = copy(target)
    if not current then return nil, "no-target" end
    return {version = 1, target = current, nextTarget = copy(nextTarget),
        stepEnd = copy(stop), destination = copy(goal)}
end
