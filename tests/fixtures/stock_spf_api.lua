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

if PROVIDER_RESTEDXP then
    -- Actual stock RXP integration sends its canonical public API request.
    -- Only the RXP UI and client are doubled; no private namespace is read by GC.
    hooksecurefunc=function(t,k,after)
        local original=t[k]
        t[k]=function(...) local result=original(...);after(...);return result end
    end
    local function region()
        return {shown=true,IsShown=function(self)return self.shown end,
            Hide=function(self)self.shown=false end,SetShown=function(self,v)self.shown=v end}
    end
    CreateFrame=function()
        return {RegisterEvent=function()end,UnregisterEvent=function()end,
            SetScript=function(self,k,fn)self[k]=fn end}
    end
    ns.Init=function(fn)fn()end
    local element={zone=1438,x=30,y=40,title="Step 22",arrow=true,step={active=true}}
    local frame={element=element,texture=region(),text=region(),mouse=true,
        EnableMouse=function(self,v)self.mouse=v end,IsMouseEnabled=function(self)return self.mouse end}
    RXP={arrowFrame=frame,currentGuide={},activeWaypoints={element},
        settings={profile={showEnabled=true}},UpdateMap=function()end,UpdateGotoSteps=function()end}
    consumer.Tracking.PlayerState=function()return {x=0,y=0,map=1438,facing=0}end
    consumer.Waypoints.WorldPosition=function(map,x,y)return x*100,y*100,map end
    assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass",consumer)
    assert(loadfile("GroupCompass/Destinations.lua"))("GroupCompass",consumer)
    routing.Refresh();consumer.Destinations.Refresh()
    ns.db.restedxp=true
    assert(loadfile(PROVIDER_RESTEDXP))("ShortestPathForever",ns)
    local marks=consumer.Destinations.Sample()
    assert(#marks==1 and marks[1].label=="[RXP] Step 22" and not frame.texture.shown)
    element.x=50;element.title="Step 23";RXP.UpdateGotoSteps()
    marks=consumer.Destinations.Sample()
    assert(marks[1].name=="Step 23" and goal.x==50,"actual guide update advances destination")
    element.title="New title at same spot";RXP.UpdateMap()
    assert(consumer.Destinations.Sample()[1].name==element.title,"actual RenameStop updates label")
    RXP.settings.profile.showEnabled=false;RXP.UpdateMap()
    assert(#consumer.Destinations.Sample()==0 and frame.texture.shown,"native guide disable clears marker and restores UI")
    RXP.settings.profile.showEnabled=true;ns.ResumeRestedXP()
    assert(#consumer.Destinations.Sample()==1)
    assert(routing.SelectSource("party","guid"));routing.Refresh()
    marks=consumer.Destinations.Sample()
    assert(#marks==1 and marks[1].source=="route" and marks[1].name:find("snapshot"))
    assert(routing.Stop());assert(#consumer.Destinations.Sample()==0)
    io.write("PASS: actual stock RXP/API + destination observer, guide advance/rename/disable/resume, member replacement and stop\n")
end
