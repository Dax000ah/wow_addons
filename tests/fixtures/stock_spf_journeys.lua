-- Actual unmodified provider API + engine and GC consumer. No HC support files.
local _, ns, root = ...
local origin = {map=1, x=10335.7001953125, y=820.7000122070312}
GetTime=function() return 100 end
UnitLevel=function() return 4 end
UnitFactionGroup=function() return "Alliance" end
UnitOnTaxi=function() return false end
C_Map={GetMapInfo=function(id) return {name="Zone "..id} end}
ns.Init=function() end
ns.L=setmetatable({}, {__index=function(_, key) return key end})
ns.db={avoidHighZones=true, journey=true}
ns.charDB={}
ns.ZoneMap=function(map,x,y)
    local found, area
    for id, zone in pairs(ns.Zones) do
        if zone.map==map and x>=zone.minX and x<=zone.maxX and y>=zone.minY and y<=zone.maxY then
            local size=(zone.maxX-zone.minX)*(zone.maxY-zone.minY)
            if not area or size<area then found,area=id,size end
        end
    end
    return found
end
local function options(from,to)
    return {from=from,to=to,now=0,walkSpeed=7,faction="Alliance",otherFaction=false,
        docks=ns.Docks,routes=ns.Routes,taxiNodes=ns.TaxiNodes,taxiPaths=ns.TaxiPaths,
        portals=ns.Portals,teleports={},landmasses=ns.Landmasses,baked=ns.Walks}
end
ns.PlanContext={RunSpeed=function() return 7 end,Options=options,Ride=function() end,
    Landmass=function(p) return ns.Planner.Landmass(p,ns.Landmasses) end,
    Places=function() return ns.Planner.Places(options(origin,origin)),"Alliance" end}
ns.NowMs=function() return 0 end
ns.JourneyPosition=function() return origin.x,origin.y,nil,origin.map end
ns.JourneyWaterWalking=function() return false end
ns.UsableTeleports=function() return {},{} end
ns.OnWalk=function() end
for _,name in ipairs({"Journey/Hazards.lua","Journey/JourneySearch.lua","Journey/JourneyWalks.lua"}) do
    assert(loadfile(root.."/"..name))("ShortestPathForever",ns)
end
local search, plan = ns.JourneySearch
local zone=ns.Zones[1438]
local bad={map=1,x=10742.2080078125,y=579.92578125}
local good={map=1,x=zone.maxX-(zone.maxX-zone.minX)*.578,y=zone.maxY-(zone.maxY-zone.minY)*.559}
local function listener(value,why) if why=="route" then plan=value end end
-- Exact TomTom UID from Nandreye's saved registry: a Kalimdor map point,
-- not the rounded Teldrassil location shown by /path report.
local points={{id=1,mapID=1414,x=.4480097267300475,y=.08387378695540161,name="Captured target"},
    {id=2,mapID=1438,x=.559,y=.578,name="Long control"}}
-- These two WorldPoint answers replace the client projection only. GC must
-- supply the exact selected map fractions to receive the corresponding point.
ns.WorldPoint=function(map,x,y)
    local p
    if map==1414 and x==points[1].x and y==points[1].y then p=bad
    elseif map==1438 and x==.559 and y==.578 then p=good end
    assert(p,"GC changed the selected destination")
    return {map=p.map,x=p.x,y=p.y}
end
ns.StopKind=function() end
ns.ItineraryChanged=function() end
ns.RefreshTracker=function() end
ns.SafeCall=function(_,fn,...) return pcall(fn,...) end
ns.IsJourneyGuided=function() return plan~=nil end
local started=0
ns.StartJourney=function(point)
    started=started+1
    plan=nil
    ns.JourneyChanged(point)
    search.Clear(false)
    search.Start(point,nil,{index=1},listener)
    return true
end
ns.ClearJourney=function()
    search.Clear(false); plan=nil; ns.JourneyChanged(nil)
end
assert(loadfile(root.."/Core/API.lua"))("ShortestPathForever",ns)
local api=ShortestPathForever.API
assert(api.GetGuidance==nil and api.SelectRouteSource==nil)
local consumer={Waypoints={List=function() return points end},Tracking={RouteTargets=function() return {} end}}
assert(loadfile("GroupCompass/Routing.lua"))("GroupCompass",consumer)
ns.StockJourneyReplay={}
for _,id in ipairs({2,1,2,1,2}) do
    io.stderr:write("Replay selection ", tostring(#ns.StockJourneyReplay+1), ": ", points[id].name, "\n")
    assert(consumer.Routing.SelectSource("tomtom",id))
    DrainPathQueue()
    local pending,rounds,err,loading=search.Status()
    assert(pending==0 and loading==false and err==nil)
    assert(api.CurrentStop("GroupCompass")==1,"request lost GC ownership")
    local leg=plan and plan.legs[1]
    if id==1 then
        assert(plan==nil and not api.Active(),"captured failed target now routes: re-evaluate this fixture")
    else
        assert(leg and leg.mode=="walk" and leg.measured and #leg.walkPoints>1 and api.Active(),
            "switching back to the reachable point must restore its measured route")
    end
    ns.StockJourneyReplay[#ns.StockJourneyReplay+1]={target=points[id].name,
        requested=true,owner="GroupCompass",plan=plan~=nil,points=leg and #leg.walkPoints or 0,
        pending=pending,rounds=rounds,request_number=started}
end
assert(started==5,"every GC selection must reach the unmodified provider")
assert(consumer.Routing.Stop() and not api.Active())
DrainPathQueue()
