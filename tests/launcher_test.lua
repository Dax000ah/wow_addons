-- LibDBIcon integration; with LAUNCHER_LIBRARY_ROOT, use the actual installed
-- libraries. Native frames and the collector filter are doubled, not providers.
local addon, frames = {}, {}
strmatch,strfind,strlower=string.match,string.find,string.lower
tinsert,tremove=table.insert,table.remove
local function object(kind,name,parent)
    local f={kind=kind,name=name,parent=parent,scripts={},events={},shown=true,lines={}}
    function f:SetScript(key,fn)self.scripts[key]=fn end
    function f:HookScript(key,fn)
        local old=self.scripts[key];self.scripts[key]=function(...)if old then old(...)end;fn(...)end
    end
    function f:GetName()return self.name end
    function f:GetParent()return self.parent end
    function f:SetPoint(...)self.point={...}end
    function f:GetCenter()return 500,500 end
    function f:GetWidth()return self.name=="UIParent" and 1200 or 200 end
    function f:GetHeight()return self.name=="UIParent" and 900 or 200 end
    function f:GetEffectiveScale()return 1 end
    function f:Show()self.shown=true;if self.scripts.OnShow then self.scripts.OnShow(self)end end
    function f:Hide()self.shown=false;if self.scripts.OnHide then self.scripts.OnHide(self)end end
    function f:SetText(t)self.title=t;self.lines={}end
    function f:AddLine(t,r,g,b,wrap)self.lines[#self.lines+1]={text=t,wrap=wrap}end
    function f:SetVertexColor(r,g,b)self.rgb={r,g,b}end
    function f:GetVertexColor()return unpack(self.rgb or {1,1,1})end
    function f:RegisterEvent(e)self.events[e]=true end
    function f:CreateTexture()return object("Texture",nil,self)end
    function f:CreateAnimationGroup()return object("AnimationGroup",nil,self)end
    function f:CreateAnimation()return object("Animation",nil,self)end
    for _,key in ipairs({"SetSize","ClearAllPoints","SetFrameStrata","SetFixedFrameStrata","SetFrameLevel","SetFixedFrameLevel",
        "RegisterForClicks","RegisterForDrag","SetHighlightTexture","SetTexCoord","SetTexture","SetOwner",
        "SetOrder","SetDuration","SetFromAlpha","SetToAlpha","SetStartDelay","SetToFinalAlpha",
        "SetAlpha","Play","Stop","LockHighlight","UnlockHighlight"})do f[key]=function()end end
    return f
end
CreateFrame=function(kind,name,parent)
    local f=object(kind,name,parent);frames[#frames+1]=f;if name then _G[name]=f end;return f
end
UIParent=object("Frame","UIParent")
Minimap=object("Frame","Minimap")
WOW_PROJECT_ID,WOW_PROJECT_MAINLINE=2,1
local time=10
GetTime=function()return time end
GetCursorPosition=function()return 600,500 end
local icons,broker,tip
if LAUNCHER_LIBRARY_ROOT or LAUNCHER_LIBRARY_CHUNKS then
    if LAUNCHER_LIBRARY_CHUNKS then
        for _,chunk in ipairs(LAUNCHER_LIBRARY_CHUNKS)do assert(loadstring(chunk))()end
    else
        local callback="CallbackHandler-1.0/CallbackHandler-1.0.lua"
        local file=io.open(LAUNCHER_LIBRARY_ROOT.."/"..callback)
        if file then file:close() else callback="HereBeDragons/CallbackHandler-1.0/CallbackHandler-1.0.lua" end
        for _,name in ipairs({"LibStub/LibStub.lua",callback,
            "LibDataBroker-1.1/LibDataBroker-1.1.lua","LibDBIcon-1.0/LibDBIcon-1.0.lua"})do
            assert(loadfile(LAUNCHER_LIBRARY_ROOT.."/"..name))()
        end
    end
    icons,broker=LibStub("LibDBIcon-1.0"),LibStub("LibDataBroker-1.1")
    tip=LibDBIconTooltip
else
    broker={NewDataObject=function(self,name,data)assert(not self.object);self.object=data;return data end}
    tip=object("GameTooltip","TestTip")
    icons={Register=function(self,name,data,db)
        assert(not self.button);self.button=CreateFrame("Button","LibDBIcon10_"..name,Minimap)
        self.button.db,self.button.dataObject=db,data
        self.button:SetScript("OnClick",data.OnClick)
        self.button:SetScript("OnEnter",function()data.OnTooltipShow(tip);tip:Show()end)
        self.button:SetScript("OnLeave",function()tip:Hide()end)
    end,GetMinimapButton=function(self)return self.button end,
    Refresh=function(self,name,db)self.refreshes=(self.refreshes or 0)+1;self.button.db=db end}
    LibStub=function(name)return name=="LibDBIcon-1.0" and icons or name=="LibDataBroker-1.1" and broker end
end
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass",addon)
GroupCompassDB={buttonAngle=123};addon.Settings.Initialize()
assert(addon.Settings.Get().minimapPos==123,"legacy custom angle must migrate")
addon.MarkerStyle={Path="Interface/AddOns/GroupCompass/Textures/"}
addon.Compass={RefreshAppearance=function()end};addon.Maps={Refresh=function()end}
assert(loadfile("GroupCompass/Options.lua"))("GroupCompass",addon)
local options,routes=0,0
addon.Options.Toggle=function()options=options+1 end
addon.RouteMenu={Toggle=function(anchor)assert(anchor==icons:GetMinimapButton("GroupCompass"));routes=routes+1 end}
addon.Options.Initialize();addon.Options.Initialize()
if LAUNCHER_LIBRARY_ROOT or LAUNCHER_LIBRARY_CHUNKS then
    for _,f in ipairs(frames)do if f.events.PLAYER_LOGIN then f.scripts.OnEvent(f,"PLAYER_LOGIN")end end
end
local button=assert(icons:GetMinimapButton("GroupCompass"))
assert(button:GetName()=="LibDBIcon10_GroupCompass" and not GroupCompassMinimapButton,
    "no non-standard button may exist for Leatrix to replace")
assert(button.db==GroupCompassDB and button.dataObject.iconB==1 and button.dataObject.iconG==.8)
-- Leatrix's custom-button replacement excludes standard LibDBIcon names.
if not button:GetName():find("LibDBIcon",1,true)then
    button:SetScript("OnEnter",function()tip:SetText("This is a custom button")end)
end
button.scripts.OnEnter(button)
assert(tip.title=="Group Compass" and #tip.lines==3 and tip.lines[1].text:find("Left-click",1,true)
    and tip.lines[2].text:find("Right-click",1,true) and tip.lines[3].text:find("Left-drag",1,true))
for _,line in ipairs(tip.lines)do assert(line.wrap)end
button.scripts.OnLeave(button);assert(not tip.shown)
button.scripts.OnClick(button,"LeftButton");button.scripts.OnClick(button,"RightButton")
assert(options==1 and routes==1)
button.scripts.OnDragStart(button)
button.scripts.OnClick(button,"RightButton");assert(routes==1,"drag must suppress clicks")
if button.scripts.OnUpdate then button.scripts.OnUpdate(button)end
button.scripts.OnDragStop(button)
button.scripts.OnClick(button,"LeftButton");assert(options==1,"drag-stop click must stay suppressed")
time=11;button.scripts.OnClick(button,"LeftButton");assert(options==2)
if LAUNCHER_LIBRARY_ROOT or LAUNCHER_LIBRARY_CHUNKS then assert(GroupCompassDB.minimapPos==0,"library drag writes our saved position")end
local saved=GroupCompassDB.minimapPos
button:Hide();local point=button.point
addon.Options.Refresh();assert(not button.shown and button.point==point,
    "refresh must not unhide/reposition a collector-managed icon")
addon.Settings.Set("compassWidth",900);assert(not button.shown)
addon.Settings.Reset();assert(GroupCompassDB.minimapPos==225 and button.db==GroupCompassDB)
print((LAUNCHER_LIBRARY_ROOT or LAUNCHER_LIBRARY_CHUNKS) and "PASS: actual LibDBIcon/LDB launcher, tooltip, dispatch, drag, saved position and collector ownership (native frames doubled)"
    or "PASS: standard launcher registration, collector tooltip, clicks, drag suppression and position migration")
