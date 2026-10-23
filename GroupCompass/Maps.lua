local _, addon = ...
addon.Maps = {}
local maps = addon.Maps
local active, latest, provider, owningMap = false, {}, nil, nil
local minimapMarkers = {}
local template = "GroupCompassWorldPinTemplate"

local function tooltip(marker)
    local member = marker.member
    if not member then return end
    GameTooltip:SetOwner(marker, "ANCHOR_RIGHT")
    GameTooltip:SetText(string.format("[%d] %s", member.slot, member.name), unpack(member.color))
    if member.distance then
        GameTooltip:AddLine(string.format("~%.0f yards (horizontal)", member.distance), 1, 1, 1)
    end
    if marker.edge then GameTooltip:AddLine("Edge indicator: beyond the inset view", 1, 1, 1) end
    GameTooltip:Show()
end

local function hideTooltip(marker)
    if GameTooltip:IsOwned(marker) then GameTooltip:Hide() end
end

local function decorate(marker)
    marker:SetSize(18, 18)
    local border = marker:CreateTexture(nil, "BACKGROUND")
    border:SetAllPoints()
    border:SetColorTexture(0.05, 0.05, 0.05, 1)
    marker.fill = marker:CreateTexture(nil, "ARTWORK")
    marker.fill:SetPoint("TOPLEFT", 2, -2)
    marker.fill:SetPoint("BOTTOMRIGHT", -2, 2)
    marker.label = marker:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    marker.label:SetPoint("CENTER")
    marker.label:SetTextColor(0, 0, 0)
end

local function updateBadge(marker, member)
    marker.member = member
    marker.fill:SetColorTexture(unpack(member.color))
    marker.label:SetText(tostring(member.slot))
    if GameTooltip:IsOwned(marker) then tooltip(marker) end
end

-- XML virtual template combines this with Blizzard's MapCanvasPinMixin.
GroupCompassWorldPinMixin = {}
function GroupCompassWorldPinMixin:OnLoad()
    decorate(self)
    self:UseFrameLevelType("PIN_FRAME_LEVEL_GROUP_MEMBER")
    self:SetScalingLimits(1, 0.8, 1.2)
end
function GroupCompassWorldPinMixin:OnAcquired(member)
    self:UpdateMember(member)
end
function GroupCompassWorldPinMixin:UpdateMember(member)
    updateBadge(self, member)
    self:SetPosition(member.x, member.y)
end
function GroupCompassWorldPinMixin:OnReleased()
    hideTooltip(self)
    self.member = nil
    MapCanvasPinMixin.OnReleased(self)
end
GroupCompassWorldPinMixin.OnMouseEnter = tooltip
GroupCompassWorldPinMixin.OnMouseLeave = hideTooltip

local function clearWorld(self)
    self:GetMap():RemoveAllPinsByTemplate(template)
    self.pins = {}
end

local function refreshWorld(self)
    local map = self:GetMap()
    local members = active and map:IsShown() and addon.Tracking.MapMembers(map:GetMapID()) or {}
    local seen = {}
    self.pins = self.pins or {}
    for _, member in ipairs(members) do
        seen[member.unit] = true
        local pin = self.pins[member.unit]
        if pin then pin:UpdateMember(member)
        else self.pins[member.unit] = map:AcquirePin(template, member) end
    end
    for unit, pin in pairs(self.pins) do
        if not seen[unit] then map:RemovePin(pin); self.pins[unit] = nil end
    end
end

local function attachWorld()
    if provider or not WorldMapFrame or not MapCanvasDataProviderMixin then return end
    owningMap = WorldMapFrame
    provider = CreateFromMixins(MapCanvasDataProviderMixin)
    provider.RefreshAllData = refreshWorld
    provider.RemoveAllData = clearWorld
    provider.OnHide = clearWorld
    provider.OnRemoved = function(self, map)
        clearWorld(self)
        MapCanvasDataProviderMixin.OnRemoved(self, map)
        provider, owningMap = nil, nil
    end
    owningMap:AddDataProvider(provider)
end

local function finite(value)
    return not (issecretvalue and issecretvalue(value)) and type(value) == "number"
        and value == value and value > -math.huge and value < math.huge
end

local function clearMinimap(first)
    for index = first or 1, #minimapMarkers do
        minimapMarkers[index]:Hide()
        hideTooltip(minimapMarkers[index])
    end
end

function maps.Update(members, enabled)
    active, latest = enabled, members
    attachWorld() -- The world-map addon may load long after Group Compass.
    if provider then refreshWorld(provider) end
    if not active or not Minimap or not Minimap:IsShown() then clearMinimap(); return end
    local radius = addon.Compat.MinimapRadius()
    if not finite(radius) or radius <= 0 then clearMinimap(); return end
    local width, height = Minimap:GetWidth(), Minimap:GetHeight()
    if not finite(width) or not finite(height) or width <= 28 or height <= 28 then
        clearMinimap(); return
    end
    local rotating = GetCVarBool("rotateMinimap")
        and not (C_Minimap and C_Minimap.IsRotateMinimapIgnored and C_Minimap.IsRotateMinimapIgnored())
    for index, member in ipairs(latest) do
        local x, y, edge = addon.Projection.Minimap(member.north, member.west,
            member.facing, rotating, radius, width, height)
        if x then
            local marker = minimapMarkers[index]
            if not marker then
                marker = CreateFrame("Frame", nil, Minimap)
                decorate(marker)
                marker:SetFrameLevel(Minimap:GetFrameLevel() + 10)
                marker:EnableMouse(true)
                marker:SetMouseClickEnabled(false)
                marker:SetScript("OnEnter", tooltip)
                marker:SetScript("OnLeave", hideTooltip)
                marker:SetScript("OnHide", hideTooltip)
                minimapMarkers[index] = marker
            end
            marker.edge = edge
            updateBadge(marker, member)
            marker:ClearAllPoints()
            marker:SetPoint("CENTER", Minimap, "CENTER", x, y)
            marker:SetAlpha(edge and 0.75 or 1)
            marker:Show()
        end
    end
    clearMinimap(#latest + 1)
end
