local addon={}
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass",addon)
local owner,ownedTarget,api
local combat=false
local player={map=1,x=0,y=0,facing=0}
InCombatLockdown=function() return combat end
issecretvalue=function(v) return v=="SECRET" end
local hooks=0
hooksecurefunc=function(t,k,fn)
    hooks=hooks+1
    local original=t[k]
    t[k]=function(...) local result=original(...);fn(...);return result end
end
addon.Routing={Provider=function()return api end,Destination=function()return ownedTarget end}
addon.Tracking={PlayerState=function()return player end}
addon.Waypoints={WorldPosition=function(map,x,y)return x*100,y*100,map end}
assert(loadfile("GroupCompass/Destinations.lua"))("GroupCompass",addon)
local d=addon.Destinations
assert(#d.Sample()==0)
api={CurrentStop=function(who)return owner==who and 1 or nil end,
 NavigateRoute=function(who)owner=who;return true end,RenameStop=function()return true end}
d.Refresh();assert(hooks==2)
for i=1,10 do d.Refresh()end;assert(hooks==2,"hooks must not accumulate")
local stop={map=1,x=.5,y=0,title="Step 22",hold=true}
api.NavigateRoute("RestedXP",{stop})
local a=d.Sample();assert(#a==1 and a[1].label=="[RXP] Step 22" and a[1].distance==50)
stop.x=.9;assert(d.Sample()[1].distance==50,"request must be copied, not retained by reference")
player.facing=math.pi/2;assert(d.Sample()[1].angle>1);player.facing=0
api.RenameStop("RestedXP",1,"RXP_FRIENDLY_NPC_|Bob")
assert(d.Sample()[1].label=="[RXP] Bob")
api.NavigateRoute("RestedXP",{{map=1,x=.2,y=0,title="Next",hold=true}})
assert(d.Sample()[1].distance==20,"guide target advances")
-- Malformed/rejected and secret input must not overwrite the valid target.
for _,s in ipairs({{map=1,x=2,y=0,hold=true},{map=1,x=.8,y=0,title=123,hold=true},
 {map=1,x="SECRET",y=0,hold=true},{map=1,x=.8,y=0,hold=true,tooltip={}}}) do
 api.NavigateRoute("RestedXP",{s});assert(d.Sample()[1].distance==20)
end
combat=true;api.NavigateRoute("RestedXP",{{map=1,x=.9,y=0,hold=true}})
assert(d.Sample()[1].distance==20);combat=false
owner=nil;assert(#d.Sample()==0,"ending guide must clear its marker")
owner="RestedXP";assert(#d.Sample()==0,"never resurrect a cached guide target")
ownedTarget={mapID=1,x=.6,y=0,name="Friend snapshot",source="route"}
owner="GroupCompass";a=d.Sample();assert(a[1].label=="[Route] Friend snapshot")
player.map=0;assert(#d.Sample()==0 and d.Status():find("another world"));player.map=1
player=nil;assert(#d.Sample()==0);player={map=1,x=0,y=0,facing=0}
ownedTarget=nil
local prior=api;api=nil;assert(#d.Sample()==0)
prior.NavigateRoute("RestedXP",{{map=1,x=.3,y=0,hold=true}})
assert(#d.Sample()==0,"a replaced provider must not inject stale coordinates")
print("PASS: copied public RXP request observation, rename/advance, hooks, own destinations, secrets, combat, world/owner/provider clearing")
