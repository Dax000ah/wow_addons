local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass", addon)
local points, available, changed, counter = {}, true, {}, 0
local secret, conversionMissing, positionMissing = {}, false, false
issecretvalue=function(value) return value==secret end
CreateVector2D=function(x,y) return {GetXY=function() return x,y end} end
C_Map={GetBestMapForUnit=function() return 10 end,
    GetPlayerMapPosition=function() return not positionMissing and CreateVector2D(.5,.5) or nil end,
    GetMapInfo=function(map) return {name=map==30 and "Stormwind" or "Darnassus",mapType=3,parentMapID=0} end,
    GetWorldPosFromMapPos=function(map,p)
        if conversionMissing then return end
        local x,y=p:GetXY(); return map==30 and 2 or 1,CreateVector2D(1000-y*1000,2000-x*1000)
    end}
local player={x=500,y=1500,map=1,facing=0}
assert(loadfile("GroupCompass/Tracking.lua"))("GroupCompass",addon)
addon.Tracking.PlayerState=function() return player end
addon.TomTomBridge={Provider=function() return available and addon.TomTomBridge or nil end,
    List=function() return points end, MapShortcut=function() return "Alt + right-click" end,
    Add=function(map,x,y,name,icon)
        counter=counter+1
        local p={id=1000000+counter,mapID=map,x=x,y=y,name=name,icon=icon or "tomtom",source="tomtom",tag="T"..counter}
        p.label="["..p.tag.."] "..name; points[#points+1]=p; return p
    end,
    Update=function(p,name,icon) p.name,p.icon,p.label=name,icon,"["..p.tag.."] "..name; return p end,
    Remove=function(p) for i,item in ipairs(points) do if item==p then table.remove(points,i); return true end end end}
assert(loadfile("GroupCompass/Waypoints.lua"))("GroupCompass",addon)
GroupCompassWaypointsDB={points={},nextID=77,future="keep"}
local w=addon.Waypoints; w.Initialize(); w.OnChanged=function(action) changed[#changed+1]=action end
local camp=assert(w.Add(10,.5,.4," Camp |home "))
assert(camp.name=="Camp home" and GroupCompassWaypointsDB.nextID==77 and #GroupCompassWaypointsDB.points==0)
local entries,unavailable=w.Sample()
assert(#entries==1 and unavailable==0 and entries[1].distance==100 and entries[1].angle==0)
assert(entries[1].north==100 and entries[1].west==0 and entries[1].source=="tomtom")
assert(w.Update(camp.id,"  New |Camp\n ","star") and camp.name=="New Camp" and camp.icon=="star")
assert(w.Sample()[1].label=="[T1] New Camp")
assert(not w.Update(camp.id,"Discard","../bad") and camp.name=="New Camp")
assert(not w.Update(999,"Missing","face"))
local unicode=string.rep(string.char(195,169),50)
assert(w.Update(camp.id,unicode,"face") and camp.name==string.rep(string.char(195,169),48))
assert(w.Update(camp.id,"Camp","tomtom"))
local east=assert(w.Add(10,.6,.5,"East"))
entries=w.Sample(); assert(math.abs(entries[2].angle-math.pi/2)<.00001)
player.facing=-math.pi/2; entries=w.Sample(); assert(math.abs(entries[2].angle)<.00001)
player.facing=0
assert(w.Add(30,.5,.4,"Other continent"))
local remote
entries,unavailable,remote=w.Sample(); assert(#entries==2 and unavailable==1)
assert(#remote==1 and remote[1]=="[T3] Other continent - Stormwind")
C_Map.GetMapInfo=nil; entries,unavailable,remote=w.Sample()
assert(remote[1]:find("Different world area",1,true),"missing map names must not lose known remote points")
C_Map.GetMapInfo=function() return secret end
assert(select(3,w.Sample())[1]:find("Different world area",1,true))
assert(w.AddHere("Here")); positionMissing=true; assert(not w.AddHere()); positionMissing=false
for _,value in ipairs({-.1,1.1,math.huge,0/0,secret}) do assert(not w.Add(10,value,.5)) end
assert(not w.Add(0,.5,.5))
conversionMissing=true; entries,unavailable=w.Sample(); assert(#entries==0 and unavailable==#points)
conversionMissing=false
assert(#select(3,w.Sample())==1,"remote points must clear when removed / relocated")
local messages={}; print=function(value) messages[#messages+1]=value end
w.Command("Here Mixed CASE"); assert(points[#points].name=="Mixed CASE")
w.Command("45 60 Coordinate Camp"); assert(points[#points].name=="Coordinate Camp")
w.Command("list"); assert(messages[#messages]:find("Coordinate Camp",1,true))
w.Command("remove "..camp.id); assert(not w.Find(camp.id))
w.Refresh(); local count=#changed; w.Refresh(); assert(#changed==count)
addon.TomTomBridge.Add(10,.2,.3,"External"); w.Refresh(); assert(changed[#changed]=="add", "external creation enables live display")
player=nil; entries,unavailable=w.Sample(); assert(#entries==0 and unavailable==#points)
-- UI-map ancestry can still identify remote waypoints without player facing/world projection.
C_Map.GetMapInfo=function(map)
    if map==10 then return {name="Darnassus",mapType=3,parentMapID=100} end
    if map==30 then return {name="Stormwind",mapType=3,parentMapID=200} end
    if map==100 or map==200 then return {name=map==100 and "Kalimdor" or "Eastern Kingdoms",mapType=2,parentMapID=0} end
end
conversionMissing=true
assert(select(3,w.Sample())[1]:find("Stormwind",1,true),"remote notice must not require facing or projection when continents are known")
conversionMissing=false
available=false; assert(#w.List()==0 and not w.Add(10,.2,.3,"Missing"))
assert(GroupCompassWaypointsDB.future=="keep" and GroupCompassWaypointsDB.nextID==77)
assert(not w.MapMembers and not w.HookMap, "obsolete independent waypoint map implementation removed")
io.write("PASS: TomTom waypoint facade, names/UTF-8, directions, commands, missing/secret data, external additions and retained legacy records\n")
