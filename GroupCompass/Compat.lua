local addonName, addon = ...
addon.Compat = {}
local compat = addon.Compat

function compat.Version()
    local metadata = C_AddOns and C_AddOns.GetAddOnMetadata or GetAddOnMetadata
    return metadata and metadata(addonName, "Version") or "unknown"
end

-- Classic Era minimap diameters in yards, by zoom index. Values are documented
-- in HereBeDragons-Pins-2.0; see docs/FEASIBILITY.md for the primary source.
local diameters = {
    indoor = { [0] = 300, 240, 180, 120, 80, 50 },
    outdoor = { [0] = 466 + 2/3, 400, 333 + 1/3, 266 + 2/6, 200, 133 + 1/3 },
}
local mode, probing

function compat.IsProbingMinimap()
    return probing
end

function compat.InvalidateMinimapRadius()
    mode = nil
end

function compat.MinimapRadius()
    if C_Minimap and C_Minimap.GetViewRadius then return C_Minimap.GetViewRadius() end
    local interface = select(4, GetBuildInfo())
    if type(interface) ~= "number" or math.floor(interface / 100) ~= 115
        or not Minimap or not Minimap.GetZoom or not GetCVar or probing then return end
    local zoom = Minimap:GetZoom()
    local outdoor, indoor = tonumber(GetCVar("minimapZoom")), tonumber(GetCVar("minimapInsideZoom"))
    if not diameters.outdoor[zoom] or not outdoor or not indoor then return end
    if outdoor ~= indoor then
        if zoom == outdoor then mode = "outdoor"
        elseif zoom == indoor then mode = "indoor"
        else return end
    elseif not mode then
        -- Equal zoom settings hide which minimap mode is active. Briefly probe
        -- one adjacent zoom, read the updated CVar, and restore the original.
        -- Core ignores our synchronous zoom events to avoid reentrant refreshes.
        if not Minimap.SetZoom then return end
        probing = true
        local probe = zoom < 5 and zoom + 1 or zoom - 1
        Minimap:SetZoom(probe)
        outdoor, indoor = tonumber(GetCVar("minimapZoom")), tonumber(GetCVar("minimapInsideZoom"))
        Minimap:SetZoom(zoom)
        probing = false
        if outdoor == probe and indoor == zoom then mode = "outdoor"
        elseif indoor == probe and outdoor == zoom then mode = "indoor" end
    end
    if mode then return diameters[mode][zoom] / 2 end
end
