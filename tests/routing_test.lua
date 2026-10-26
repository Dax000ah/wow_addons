local addon = {}
local points = {{id=1,mapID=1438,x=.2,y=.3,name="My Camp"}, {id=2,mapID=1426,x=.5,y=.6,name="Other Camp"}}
addon.Waypoints = {List=function() return points end}
addon.Tracking = {PlayerState=function() return {x=0,y=0,map=0,facing=0} end}
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass",addon)
assert(loadfile("GroupCompass/Routing.lua"))("GroupCompass",addon)
local r = addon.Routing
local combat, ours, active, accepted, cancelAccepted, cancelled, started = false, false, false, true, true, 0, 0
local ended, last, callbackCount = nil, nil, 0
local guidance = {version=1,target={worldMapID=0,north=10,west=0}}
InCombatLockdown=function() return combat end
print=function() end
r.OnChanged=function() callbackCount=callbackCount+1 end
r.OnStarted=function() started=started+1 end
r.Refresh(); assert(r.Status():find("requires") and not r.CanStop())
assert(not r.Start(1)); assert(#r.Sample()==0)
local api = {version=1,
    Navigate=function(owner,map,x,y,name)
        assert(owner=="GroupCompass"); last={map,x,y,name}
        if accepted then ours,active=true,true end
        return accepted
    end,
    CurrentStop=function(owner) assert(owner=="GroupCompass"); return ours and 1 or nil end,
    Active=function() return active end,
    Cancel=function(owner)
        assert(owner=="GroupCompass" and ours); cancelled=cancelled+1
        if cancelAccepted then ours,active=false,false end
        return cancelAccepted
    end,
    Ended=function() return ended end,
}
ShortestPathForever={API=api}; r.Refresh()
assert(r.Status():find("Choose Navigate"), "late provider discovery")
active=true
local ok,reason=r.Start(1); assert(not ok and reason=="replace" and last==nil)
assert(r.Start(1,true)); assert(started==1 and r.CanStop())
assert(last[1]==1438 and last[2]==.2 and last[3]==.3 and last[4]=="My Camp")
assert(#r.Sample()==0 and r.Status():find("next%-turn API unavailable"))
-- Compose the real consumer with our real proposed provider extension. Native
-- user-waypoint and supertracking APIs are absent, as in Tony's Classic probe.
C_Map, C_SuperTrack = nil, nil
assert(loadfile("integrations/ShortestPathForever/GuidanceAPI.lua"))("ShortestPathForever", {
    GuideTargets=function() return {map=0,x=10,y=0} end,
    Corpse={Active=function() return false end}})
assert(r.Sample()[1].distance==10, "consumer and proposed getter must agree on world-coordinate schema")
api.GetGuidance=function(owner) assert(owner=="GroupCompass"); return guidance end
local sample=r.Sample(); assert(#sample==1 and sample[1].angle==0 and sample[1].distance==10)
assert(sample[1].label=="[Route] Next step")
guidance.target.north=20; assert(r.Sample()[1].distance==20)
guidance.target.worldMapID=1; assert(#r.Sample()==0, "no fabricated cross-world bearing")
guidance.target.worldMapID=0
combat=true; assert(#r.Sample()==0 and r.Status():find("combat"))
ok,reason=r.Start(2); assert(not ok and reason=="combat")
combat=false; assert(#r.Sample()==1, "guidance resumes after combat")
active=false; assert(#r.Sample()==0 and r.Status():find("waiting")); active=true
local secret={}; issecretvalue=function(v) return v==secret end
guidance.target.north=secret; assert(#r.Sample()==0)
guidance.target=secret; assert(#r.Sample()==0)
guidance={version=1,target={worldMapID=0,north=30,west=0}}
api.GetGuidance=function() error("provider test failure") end
assert(#r.Sample()==0 and r.Status():find("provider test failure"), "external failures stay visible")
api.GetGuidance=function() return guidance end
assert(#r.Sample()==1)
ours,active,ended=false,false,"arrived"; r.Refresh()
assert(r.Status()=="Destination reached." and not r.CanStop() and #r.Sample()==0)
ours,active=false,true; local old=cancelled
assert(not r.Stop() and cancelled==old, "never cancel another owner's journey")
active=false; accepted=false
assert(not r.Start(1)); assert(r.Status():find("not started")); accepted=true
assert(r.Start(1)); table.remove(points,1); r.Refresh()
assert(cancelled==old+1 and not r.CanStop() and #r.Sample()==0, "removal cancels our route")
assert(r.Status()=="Routed waypoint removed.", "cancelled guidance must not be reported as a foreign journey")
assert(r.Start(2)); cancelAccepted=false
assert(not r.Stop() and r.CanStop() and r.Status():find("did not cancel"))
points={}; assert(#r.Sample()==0 and r.Status():find("could not be stopped"))
cancelAccepted=true; assert(r.Stop())
points={{id=3,mapID=1426,x=.1,y=.2,name="Late Camp"}}
r.Command("3"); assert(ours); r.Command("stop"); assert(not ours)
api.version=2; r.Refresh(); assert(r.Status():find("compatible"))
api.version=1; r.Refresh(); local before=callbackCount; r.Refresh()
assert(callbackCount==before, "unchanged status must not churn UI refreshes")
local getOwner=api.CurrentStop
api.CurrentStop=function() error("ownership test failure") end
local stopped,stopMessage=r.Stop()
assert(not stopped and stopMessage:find("ownership test failure"))
assert(not r.Start(3), "provider ownership failures must block new navigation")
api.CurrentStop=getOwner
io.write("PASS: optional routing API, explicit replacement, owned cancellation, saved coordinates, guidance guards and lifecycle\n")
