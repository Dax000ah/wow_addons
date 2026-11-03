-- With TOMTOM_SOURCE_PATH this runs the same cases against the installed
-- TomTom.lua registry/Add/Remove/persistence methods; only UI pins are doubled.
local function provider()
    local api = {profile = {persistence = {savewaypoints = true, cleardistance = 0},
        minimap = {enable = true, otherzone = true}, worldmap = {enable = true, otherzone = true},
        arrow = {autoqueue = true, arrival = 10, enablePing = false}, general = {announce = false}}}
    api.db = {profile = api.profile}
    api.waydb = {profile = setmetatable({}, {__index = function(t,k) local v={}; rawset(t,k,v); return v end})}
    if TOMTOM_SOURCE_PATH then
        local hbd = {mapData = {}, GetLocalizedMap = function() return "Test zone" end}
        LibStub = function() return hbd end
        GetBuildInfo = function() return "1.15.9", "70003", "test", 11509 end
        Enum = {UIMapType = {World=1,Zone=2,Micro=3,Orphan=4,Continent=5}}
        StaticPopupDialogs, SlashCmdList = {}, {}
        api.L = setmetatable({}, {__index = function(_,key) return key end})
        if TOMTOM_LAYOUT == "4.4" then
            -- The new upstream splits its registry into this module. Native
            -- settings/callback services are doubled only inside the test.
            api.hbd=hbd
            api.FireMessage=function()end
            api.private={AddSettingsSection=function()end,FireCallback=function()end}
            assert(loadfile(TOMTOM_SOURCE_PATH .. "/core/waypoints.lua"))("TomTom",api)
        else
            assert(loadfile(TOMTOM_SOURCE_PATH .. "/TomTom.lua"))("TomTom",api)
        end
    else
        api.waypoints, api.waypointprofile = {}, api.waydb.profile
        function api:GetKey(uid) return string.format("%d:%.8f:%.8f:%s",uid[1],uid[2],uid[3],tostring(uid.title)) end
        function api:AddWaypoint(map,x,y,opts)
            self.waypoints[map] = self.waypoints[map] or {}
            local uid = {map,x,y}
            for k,v in pairs(opts) do uid[k]=v end
            if uid.minimap==nil then uid.minimap=self.profile.minimap.enable end
            if uid.world==nil then uid.world=self.profile.worldmap.enable end
            if uid.persistent==nil then uid.persistent=self.profile.persistence.savewaypoints end
            uid.callbacks=uid.callbacks or {world={},minimap={},distance={}}
            local key=self:GetKey(uid)
            if self.waypoints[map][key] then return self.waypoints[map][key] end
            self:SetWaypoint(uid,uid.callbacks,uid.minimap,uid.world)
            self.waypoints[map][key]=uid
            if uid.persistent then self.waypointprofile[map][key]=uid end
            return uid
        end
        function api:RemoveWaypoint(uid)
            self:ClearWaypoint(uid)
            self.waypoints[uid[1]][self:GetKey(uid)]=nil
            self.waypointprofile[uid[1]][self:GetKey(uid)]=nil
        end
        function api:IsValidWaypoint(uid) return self.waypoints[uid[1]] and self.waypoints[uid[1]][self:GetKey(uid)]~=nil end
        function api:UIDIsSaved(uid) return self.waypointprofile[uid[1]][self:GetKey(uid)]~=nil end
    end
    api.rendered, api.draws, api.clears = {}, 0, 0
    function api:SetWaypoint(uid,callbacks,mini,world)
        if self.failDraw then self.failDraw=self.failDraw-1; if self.failDraw==0 then self.failDraw=nil end; error("draw failure") end
        self.draws=self.draws+1
        self.rendered[uid]={icon=uid.worldmap_icon,callbacks=callbacks,mini=mini,world=world}
    end
    function api:ClearWaypoint(uid) self.rendered[uid]=nil; self.clears=self.clears+1 end
    function api:SetCrazyArrow(uid,dist,title) self.active,self.activeDistance,self.activeTitle=uid,dist,title end
    function api:IsCrazyArrowEmpty() return not self.active end
    api.GetCurrentPlayerPosition=function() return 10,.5,.5 end
    if TOMTOM_SOURCE_PATH then api:ReloadWaypoints() end
    return api
end
hooksecurefunc=function(api,name,after)
    local original=api[name]
    api[name]=function(...) local result=original(...); after(...); return result end
end
local addon={}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass",addon)
assert(loadfile("GroupCompass/Direction.lua"))("GroupCompass",addon)
assert(loadfile("GroupCompass/TomTomBridge.lua"))("GroupCompass",addon)
local w
assert(loadfile("GroupCompass/Tracking.lua"))("GroupCompass",addon)
addon.Tracking.PlayerState=function() return {x=500,y=1500,map=1,facing=0} end
CreateVector2D=function(x,y) return {GetXY=function() return x,y end} end
C_Map={GetWorldPosFromMapPos=function(map,p)
    local x,y=p:GetXY(); return map==30 and 2 or 1,CreateVector2D(1000-y*1000,2000-x*1000)
end}
GroupCompassWaypointsDB={points={{id=1,mapID=10,x=.5,y=.4,name="Legacy camp",icon="flag",future="keep"}},nextID=2}
assert(loadfile("GroupCompass/Waypoints.lua"))("GroupCompass",addon)
w=addon.Waypoints; w.Initialize()
assert(not w.UsesTomTom() and #w.List()==0 and #GroupCompassWaypointsDB.points==1)
local api=provider(); TomTom=api
local manual=api:AddWaypoint(10,.3,.2,{title="Manual point",from="TomTom/wm",persistent=true})
local changes=0; w.OnChanged=function() changes=changes+1 end
local list=w.List()
assert(#list==2 and w.UsesTomTom() and GroupCompassWaypointsDB.tomtomImported[1])
local imported
for _,p in ipairs(list) do if p.name=="Legacy camp" then imported=p end end
assert(imported and imported.source=="tomtom" and imported.icon=="flag" and imported.id>1000000)
assert(GroupCompassWaypointsDB.points[1].future=="keep", "legacy records are retained")
assert(not w.MapMembers and not w.HookMap, "obsolete placement/map projection handlers must be gone")
assert(w.MapShortcut():find("Alt + right-click",1,true))
local opened=0
SlashCmdList=SlashCmdList or {}
SlashCmdList.TOMTOM=function() opened=opened+1 end
assert(w.OpenSettings() and opened==1)
w.Refresh(); local notified=changes; w.Refresh(); assert(changes==notified, "polling must be stable")
local point=assert(w.Add(10,.6,.5,"New camp"))
assert(api:IsValidWaypoint(point.uid) and api:UIDIsSaved(point.uid) and point.icon=="tomtom")
local oldUID,oldID=point.uid,point.id
api:SetCrazyArrow(oldUID,12,"New camp")
point=assert(w.Update(oldID,"Renamed camp","star"))
assert(point.id==oldID and point.uid~=oldUID and point.uid.title=="Renamed camp")
assert(not api:IsValidWaypoint(oldUID) and api:IsValidWaypoint(point.uid) and api:UIDIsSaved(point.uid))
assert(api.active==point.uid and api.activeDistance==12 and api.activeTitle=="Renamed camp")
assert(point.uid.worldmap_icon:find("star.tga",1,true) and point.uid.minimap_icon==point.uid.worldmap_icon)
assert(api.rendered[point.uid].icon==point.uid.worldmap_icon)
local sameUID,callbacks=point.uid,point.uid.callbacks
point=assert(w.Update(oldID,"Renamed camp","shield"))
assert(point.uid==sameUID and api.active==sameUID and point.uid.callbacks==callbacks and api.rendered[sameUID].icon:find("shield.tga",1,true))
point=assert(w.Update(oldID,"Renamed again","tomtom"))
assert(point.icon=="shield", "keep current icon must preserve a custom shape")
assert(not w.Update(oldID,"Invalid","../bad") and point.uid.title=="Renamed again")
api:AddWaypoint(10,.6,.5,{title="Collision",from="TomTom/way"})
assert(not w.Update(oldID,"Collision","pin") and api:IsValidWaypoint(point.uid), "rename collisions cannot overwrite")
local originalAdd=api.AddWaypoint
local nearCollision=api:AddWaypoint(10,.7,.7,{title="Precision collision",from="TomTom/wm"})
api.AddWaypoint=function() return nearCollision end
assert(not w.Update(oldID,"Rounded key","pin") and api:IsValidWaypoint(point.uid) and api:IsValidWaypoint(nearCollision))
api.AddWaypoint=function() error("injected add failure") end
local failed,message=w.Update(oldID,"Cannot save","pin")
assert(not failed and message:find("injected add failure",1,true) and api:IsValidWaypoint(point.uid))
api.AddWaypoint=originalAdd
api.failDraw=1
failed,message=w.Update(oldID,"Renamed again","face")
assert(not failed and point.uid.worldmap_icon:find("shield.tga",1,true) and api.rendered[point.uid], "failed icon update restores original")
local other=api:AddWaypoint(10,.2,.2,{title="Unrelated",from="TomTom/wm"})
point.uid.crazy=true
api:SetCrazyArrow(other,7,"Unrelated")
point=assert(w.Update(oldID,"Final camp","face")); assert(api.active==other and point.uid.crazy==true, "rename preserves another arrow and original reload preference")
local portrait=api:AddWaypoint(10,.1,.1,{title="Portrait",from="TomTom/wm",worldmap_displayID=123,minimap_displayID=456})
local portraitPoint
for _,p in ipairs(w.List()) do if p.uid==portrait then portraitPoint=p end end
portraitPoint=assert(w.Update(portraitPoint.id,"Portrait renamed","tomtom"))
assert(portraitPoint.uid.worldmap_displayID==123 and portraitPoint.uid.minimap_displayID==456)
local foreign=api:AddWaypoint(10,.8,.8,{title="Quest addon",from="AnotherAddon",persistent=false})
local foreignPoint
for _,p in ipairs(w.List()) do if p.uid==foreign then foreignPoint=p end end
assert(foreignPoint.readOnly and not w.Update(foreignPoint.id,"No","star") and not w.Remove(foreignPoint.id))
assert(api:IsValidWaypoint(foreign))
local before=#w.List()
api:RemoveWaypoint(manual); w.Refresh(); assert(#w.List()==before-1 and changes>notified, "TomTom removals synchronize")
assert(w.Remove(imported.id)); w.Initialize()
for _,p in ipairs(w.List()) do assert(p.name~="Legacy camp", "deleted imported points must not resurrect") end
assert(#GroupCompassWaypointsDB.points==1 and GroupCompassWaypointsDB.points[1].name=="Legacy camp")
for i=1,25 do api:AddWaypoint(10,.5,.5-i/1000,{title="Nearby "..i,from="TomTom/way"}) end
local entries,unavailable=w.Sample()
assert(#entries==20 and unavailable>0 and entries[1].source=="tomtom" and entries[1].label:find("[T",1,true))
for i=2,#entries do assert(entries[i-1].distance<=entries[i].distance) end
local distant=api:AddWaypoint(30,.5,.4,{title="Other continent",from="TomTom/way"})
entries,unavailable=w.Sample(); for _,entry in ipairs(entries) do assert(entry.name~="Other continent") end
local loaded={Settings=addon.Settings,Tracking=addon.Tracking,Direction=addon.Direction,TomTomBridge=addon.TomTomBridge}
assert(loadfile("GroupCompass/Waypoints.lua"))("GroupCompass",loaded)
loaded.Waypoints.Initialize(); assert(#loaded.Waypoints.List()==#w.List())
TomTom=nil
assert(#w.List()==0 and #GroupCompassWaypointsDB.points==1 and not w.Add(10,.2,.3,"No provider"), "missing provider preserves legacy records without a duplicate store")
io.write(TOMTOM_SOURCE_PATH and "PASS: actual installed TomTom registry/API composition (UI pins doubled)\n" or "PASS: TomTom bridge migration, shared CRUD/icons, persistence, failures, ownership, map isolation and nearest-20 cap\n")
