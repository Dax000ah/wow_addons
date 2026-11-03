local goal, requests, combat, guided = nil, 0, false, false
local timers = {}
C_Timer={After=function(_,fn) timers[#timers+1]=fn end}
canaccessvalue=function() return true end
GetTime=function() return 100 end
InCombatLockdown=function() return combat end
local ns={L=setmetatable({},{__index=function(_,k) return k end}),db={journey=true},charDB={},
 JourneyPosition=function() return 10,20,nil,1 end,
 WorldPoint=function(map,x,y) return {map=map,x=x*100,y=y*100} end,
 StopKind=function() end, ItineraryChanged=function() end, RefreshTracker=function() end,
 IsJourneyGuided=function() return guided end,
 SafeCall=function(_,fn,...) return pcall(fn,...) end}
ns.StartJourney=function(point)
 requests=requests+1; goal=point; guided=true; ns.JourneyChanged(point); return true
end
ns.ClearJourney=function() goal=nil;guided=false;ns.JourneyChanged(nil) end
assert(loadfile(PROVIDER_API))("ShortestPathForever",ns)
local api=ShortestPathForever.API
assert(api.GetGuidance==nil and api.SelectRouteSource==nil and api.GetRouteSources==nil and api.GetRouteStatus==nil)
local points={{id=1,mapID=1438,x=.3,y=.4,name="Camp"},{id=2,mapID=1438,x=.5,y=.6,name="Road"}}
local consumer={Waypoints={List=function() return points end},
 Tracking={RouteTargets=function() return {{id="guid",mapID=1438,x=.7,y=.8,name="Friend"}} end}}
assert(loadfile("GroupCompass/Routing.lua"))("GroupCompass",consumer)
local routing=consumer.Routing
assert(routing.SelectSource("tomtom",1) and api.CurrentStop("GroupCompass")==1 and goal.x==30)
assert(routing.SelectSource("tomtom",2) and goal.x==50)
assert(routing.SelectSource("tomtom",1) and goal.x==30 and requests==3)
assert(routing.SelectSource("party","guid") and goal.x==70 and requests==4)
assert(routing.SelectSource("retry") and requests==5)
combat=true; assert(not routing.SelectSource("tomtom",1) and requests==5);combat=false
assert(routing.Stop() and not api.Active())
assert(api.Navigate("RestedXP",1438,.1,.2,"Guide") and api.CurrentStop("RestedXP")==1)
assert(not routing.Stop() and api.CurrentStop("RestedXP")==1)
local opened
SlashCmdList={SHORTESTPATHFOREVER=function(value) opened=value end}
assert(routing.SelectSource("restedxp") and opened=="" and api.CurrentStop("RestedXP")==1)
assert(routing.OpenSettings("report") and opened=="report")
io.write("PASS: real upstream API, repeated targets, member snapshot, retry, combat, ownership and native settings handoff\n")
