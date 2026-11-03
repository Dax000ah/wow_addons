local addon = {}
local points = {{id=1,mapID=1438,x=.2,y=.3,name="Camp"}, {id=2,mapID=1426,x=.5,y=.6,name="Other"}}
addon.Waypoints = {List=function() return points end}
addon.Tracking = {RouteTargets=function() return {{id="friend",name="Friend",mapID=1438,x=.4,y=.5}} end}
assert(loadfile("GroupCompass/Routing.lua"))("GroupCompass",addon)
local r=addon.Routing
local combat, ours, active, accepted, cancelAccepted, cancelled, started = false,false,false,true,true,0,0
local ended, last, foreignOwner, requests = nil,nil,nil,0
InCombatLockdown=function() return combat end
print=function() end
r.OnStarted=function() started=started+1 end
r.Refresh(); assert(r.Status():find("requires") and not r.Start(1))
local methods={version=1,
 Navigate=function(owner,map,x,y,name)
    assert(owner=="GroupCompass"); requests=requests+1; last={map,x,y,name}
    if accepted then ours,active=true,true end
    return accepted
 end,
 CurrentStop=function(owner) return (owner=="GroupCompass" and ours or owner==foreignOwner) and 1 or nil end,
 Active=function() return active end,
 Cancel=function(owner)
    assert(owner=="GroupCompass" and ours); cancelled=cancelled+1
    if cancelAccepted then ours,active=false,false end
    return cancelAccepted
 end,
 Ended=function() return ended end}
-- Fail on ANY unsupported API access, including allegedly optional extensions.
local api=setmetatable({}, {__index=function(_,key) assert(methods[key]~=nil,"Non-upstream API: "..key); return methods[key] end})
ShortestPathForever={API=api}; r.Refresh(); assert(r.Sources())
active=true
local ok,reason=r.Start(1); assert(not ok and reason=="replace" and last==nil)
assert(r.Start(1,true) and r.CanStop() and started==1)
assert(last[1]==1438 and last[2]==.2 and last[3]==.3 and last[4]=="Camp")
assert(r.Status():find("Navigation requested"),"acceptance is not proof that terrain routing succeeded")
-- Repeated selection/retry always calls Navigate, even to the same existing point.
assert(r.SelectSource("tomtom",1) and requests==2)
points[1].x=.25; assert(r.SelectSource("retry") and last[2]==.25 and requests==3)
combat=true; ok,reason=r.Start(2); assert(not ok and reason=="combat")
assert(not r.SelectSource("party","friend")); combat=false
assert(r.SelectSource("party","friend") and last[1]==1438 and last[4]:find("snapshot"))
assert(not r.SelectSource("party","stale"))
assert(r.SelectSource("retry") and last[2]==.4)
assert(r.Stop() and not ours)
ours,active,foreignOwner=false,true,"RestedXP"; r.Refresh()
local before=cancelled
assert(r.Status():find("RestedXP guide route active") and not r.Stop() and cancelled==before)
assert(not r.SelectSource("retry"),"never retry or cancel a foreign owner's route")
foreignOwner="TomTom"; r.Refresh(); assert(r.Status():find("following TomTom's arrow",1,true))
foreignOwner=nil; r.Refresh(); assert(r.Status():find("separate Shortest Path journey"))
local opened
SlashCmdList={SHORTESTPATHFOREVER=function(section) opened=section end}
assert(r.SelectSource("restedxp") and opened=="" and active and not ours,
    "RestedXP action opens native settings without modifying provider settings or ownership")
assert(r.OpenSettings("report") and opened=="report")
SlashCmdList.SHORTESTPATHFOREVER=function() error("settings fault") end
local ok,why=r.OpenSettings(); assert(not ok and why:find("settings fault"))
C_SuperTrack,C_QuestLog=nil,nil
local sources=r.Sources(); assert(not sources.quest and sources.questReason:find("selected quest destination"))
assert(not r.SelectSource("quest"))
C_SuperTrack={GetSuperTrackedQuestID=function() return 77 end}
C_QuestLog={GetNextWaypoint=function(id) assert(id==77); return 1438,.6,.7 end}
assert(r.Sources().quest and r.SelectSource("quest") and last[2]==.6)
C_QuestLog.GetNextWaypoint=function() return 1438,1.2,.7 end
assert(not r.SelectSource("quest") and ours,"invalid quest must preserve previous route")
assert(r.SelectSource("tomtom",1)); table.remove(points,1); r.Refresh()
assert(not ours and r.Status()=="Routed waypoint removed.")
assert(r.Start(2)); cancelAccepted=false
assert(not r.Stop() and r.CanStop() and r.Status():find("did not cancel"))
points={}; r.Refresh(); assert(r.Status():find("could not be stopped"))
r.Refresh(); assert(r.Status():find("could not be stopped"), "failed deletion cancellation must remain visible on the next UI poll")
cancelAccepted=true; assert(r.Stop())
points={{id=3,mapID=1426,x=.1,y=.2,name="Late camp"}}
accepted=false; assert(not r.Start(3) and r.Status():find("not started")); accepted=true
assert(r.Start(3)); ours,active,ended=false,false,"arrived"; r.Refresh()
assert(r.Status()=="Destination reached.")
local query=methods.CurrentStop
methods.CurrentStop=function() error("ownership fault") end
assert(not r.Start(3) and not r.Stop() and r.Status():find("ownership fault"))
methods.CurrentStop=query
methods.version=2; r.Refresh(); assert(not r.Sources())
methods.version=1; r.Command("3"); assert(ours); r.Command("stop"); assert(not ours)
io.write("PASS: stock API allowlist, repeated requests, owned cancellation, snapshots, quest capability and native settings handoff\n")
