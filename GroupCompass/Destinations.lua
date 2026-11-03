local _, addon = ...
addon.Destinations = {}
local destinations = addon.Destinations
local provider, guide, message
local hooked = setmetatable({}, {__mode="k"})
local function readable(value) return not (issecretvalue and issecretvalue(value)) end
local function number(value)
    return readable(value) and type(value)=="number" and value==value and math.abs(value)<math.huge
end
local function title(value)
    if not readable(value) or type(value)~="string" then return "RestedXP" end
    value=value:gsub("|", ""):gsub("RXP_[A-Z_]+_", ""):gsub("%c", " ")
    local chars={}
    for char in value:gmatch("[^\128-\191][\128-\191]*") do
        chars[#chars+1]=char; if #chars==48 then break end
    end
    return #chars>0 and table.concat(chars) or "RestedXP"
end
local function current(api)
    local ok, index=pcall(api.CurrentStop, "RestedXP")
    if not ok then message="RestedXP destination unavailable: "..tostring(index); return end
    return index
end
local function observe(api, owner, stops)
    -- This observes the existing upstream RXP adapter's public API request.
    -- It never reads RXP frames, provider namespaces or SavedVariables.
    if api~=provider or not readable(owner) or owner~="RestedXP"
        or (InCombatLockdown and InCombatLockdown()) then return end
    if not readable(stops) or type(stops)~="table" or #stops~=1 then return end
    local stop=stops[1]
    if not readable(stop) or type(stop)~="table" or not readable(stop.hold) or stop.hold~=true then return end
    if stop.title~=nil and (not readable(stop.title) or type(stop.title)~="string") then return end
    -- Only the canonical request made by the stock RXP integration is observed.
    for key in pairs(stop) do
        if not readable(key) then return end
        if key~="map" and key~="x" and key~="y" and key~="title" and key~="hold" then return end
    end
    if not (number(stop.map) and stop.map>0 and stop.map%1==0
        and number(stop.x) and stop.x>=0 and stop.x<=1
        and number(stop.y) and stop.y>=0 and stop.y<=1) then return end
    if current(api)~=1 then return end
    guide={mapID=stop.map,x=stop.x,y=stop.y,name=title(stop.title),source="rxp"}
end
function destinations.Refresh()
    local api=addon.Routing.Provider()
    if api~=provider then provider,guide=api,nil end
    message="RXP: enable Shortest Path > Follow RestedXP guides, then Resume guide."
    if not api then guide=nil; return end
    if not hooked[api] and hooksecurefunc and type(api.NavigateRoute)=="function" then
        hooked[api]=true
        hooksecurefunc(api,"NavigateRoute",function(owner,stops) observe(api,owner,stops) end)
        if type(api.RenameStop)=="function" then
            hooksecurefunc(api,"RenameStop",function(owner,index,name)
                if api==provider and readable(owner) and owner=="RestedXP"
                    and readable(index) and index==1 and readable(name) and type(name)=="string"
                    and guide and current(api)==1 then
                    guide.name=title(name)
                end
            end)
        end
    end
    if current(api)~=1 then guide=nil end
end
function destinations.Status() return message end
function destinations.Sample()
    destinations.Refresh()
    local point=addon.Routing.Destination() or guide
    if not point then return {} end
    local player=addon.Tracking.PlayerState()
    if not player then return {} end
    local x,y,map=addon.Waypoints.WorldPosition(point.mapID,point.x,point.y)
    if not x or map~=player.map then
        message="Route destination is in another world or unavailable on this client."
        return {}
    end
    local prefix=point.source=="rxp" and "[RXP] " or "[Route] "
    local angle,distance=addon.Direction.Calculate(player.x,player.y,x,y,player.facing)
    message=prefix..point.name.." (destination bearing, not next turn)"
    return {{unit="destination:"..point.source,kind="destination",source=point.source,
        slot=61,name=point.name,label=prefix..point.name,waypointId=point.waypointId,
        color=point.source=="rxp" and {0.7,0.65,1} or {0.25,0.85,1},
        angle=angle,distance=distance,north=x-player.x,west=y-player.y,facing=player.facing}}
end
