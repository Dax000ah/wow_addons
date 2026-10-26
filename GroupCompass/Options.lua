local _, addon = ...
addon.Options = {}
local options, settings = addon.Options, addon.Settings
local panel, borderButton, openMenu, controls = nil, nil, nil, {}
local previewMember = {slot = 1, color = {0.25, 0.78, 0.92}}
local miniPreview, worldPreview

local function text(parent, value, x, y, template)
    local label = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y); label:SetText(value)
    return label
end
local function button(parent, title, width, x, y, onClick)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24); b:SetPoint("TOPLEFT", x, y); b:SetText(title)
    b:SetScript("OnClick", onClick)
    return b
end
local function closeMenu()
    if openMenu then openMenu:Hide(); openMenu = nil end
end
local function dropdown(title, key, choices, y)
    text(panel, title, 24, y)
    local picker, menu
    picker = button(panel, "", 230, 24, y - 20, function()
        local wasOpen = menu and openMenu == menu
        closeMenu()
        if wasOpen then return end
        if not menu then
            menu = CreateFrame("Frame", nil, panel, "BackdropTemplate")
            menu:SetFrameStrata("FULLSCREEN_DIALOG")
            menu:SetSize(230, #choices * 25 + 12)
            if key == "icon" then menu:SetPoint("TOPLEFT", picker, "BOTTOMLEFT", 0, -2)
            else menu:SetPoint("BOTTOMLEFT", picker, "TOPLEFT", 0, 2) end
            menu:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
            menu:SetBackdropColor(0.07, 0.09, 0.08, 1)
            menu:SetBackdropBorderColor(0.55, 0.5, 0.35, 1)
            for i, choice in ipairs(choices) do
                local value, label = choice[1], choice[2]
                button(menu, label, 218, 6, -6 - (i - 1) * 25, function()
                    closeMenu(); settings.Set(key, value)
                end)
            end
        end
        menu:Show(); openMenu = menu
    end)
    controls[key] = function()
        for _, choice in ipairs(choices) do
            if choice[1] == settings.Get()[key] then picker:SetText(choice[2] .. "  v"); return end
        end
    end
end
local function slider(title, key, y)
    local label = text(panel, title, 24, y)
    local s = CreateFrame("Slider", nil, panel)
    s:SetSize(230, 16); s:SetPoint("TOPLEFT", 24, y - 24)
    s:SetOrientation("HORIZONTAL"); s:SetMinMaxValues(12, 40)
    s:SetValueStep(1); s:SetObeyStepOnDrag(true)
    local track = s:CreateTexture(nil, "BACKGROUND")
    track:SetPoint("LEFT"); track:SetPoint("RIGHT"); track:SetHeight(4)
    track:SetColorTexture(0.3, 0.32, 0.28, 1)
    s:SetThumbTexture("Interface\\Buttons\\UI-SliderBar-Button-Horizontal")
    s:GetThumbTexture():SetSize(24, 24)
    local syncing
    s:SetScript("OnValueChanged", function(_, value)
        if not syncing then settings.Set(key, value) end
    end)
    controls[key] = function()
        syncing = true; s:SetValue(settings.Get()[key]); syncing = false
        label:SetText(title .. ": " .. settings.Get()[key] .. " px")
    end
end
local function updateBorderButton()
    if not borderButton then return end
    local angle = math.rad(settings.Get().buttonAngle)
    local radiusX, radiusY = Minimap:GetWidth() / 2 + 3, Minimap:GetHeight() / 2 + 3
    borderButton:ClearAllPoints()
    borderButton:SetPoint("CENTER", Minimap, "CENTER", math.cos(angle) * radiusX, math.sin(angle) * radiusY)
end
function options.Refresh()
    updateBorderButton()
    if not panel then return end
    for _, refresh in pairs(controls) do refresh() end
    if panel:IsShown() then
        addon.MarkerStyle.Apply(miniPreview, previewMember, "minimap")
        addon.MarkerStyle.Apply(worldPreview, previewMember, "world")
    end
end
local function createPanel()
    panel = CreateFrame("Frame", "GroupCompassOptions", UIParent, "BackdropTemplate")
    panel:SetSize(430, 490); panel:SetPoint("CENTER"); panel:SetFrameStrata("DIALOG")
    panel:EnableMouse(true); panel:SetClampedToScreen(true)
    panel:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
    panel:SetBackdropColor(0.06, 0.08, 0.07, 0.98)
    panel:SetBackdropBorderColor(0.55, 0.5, 0.35, 1)
    text(panel, "Group Compass", 24, -20, "GameFontNormalLarge")
    text(panel, "Group member map markers (waypoints use TomTom)", 24, -46)
    button(panel, "X", 26, 390, -12, function() panel:Hide() end)
    dropdown("Icon", "icon", settings.Icons, -82)
    slider("Minimap size", "minimapSize", -148)
    slider("World map size", "worldSize", -210)
    dropdown("Effect", "effect", settings.Effects, -272)
    dropdown("Marker colors", "colorMode", settings.Colors, -338)
    text(panel, "Preview", 302, -82, "GameFontNormal")
    text(panel, "Minimap", 300, -142)
    text(panel, "World map", 300, -242)
    miniPreview = CreateFrame("Frame", nil, panel)
    miniPreview:SetPoint("CENTER", panel, "TOPLEFT", 332, -115)
    worldPreview = CreateFrame("Frame", nil, panel)
    worldPreview:SetPoint("CENTER", panel, "TOPLEFT", 332, -212)
    addon.MarkerStyle.Decorate(miniPreview); addon.MarkerStyle.Decorate(worldPreview)
    button(panel, "Waypoints & help", 130, 24, -402, function()
        closeMenu(); panel:Hide(); addon.WaypointUI.Toggle()
    end)
    button(panel, "TomTom settings", 130, 172, -402, function() panel:Hide(); addon.WaypointUI.OpenTomTomSettings() end)
    button(panel, "Reset defaults", 130, 24, -445, function() closeMenu(); settings.Reset() end)
    button(panel, "Done", 90, 316, -445, function() panel:Hide() end)
    panel:SetScript("OnHide", closeMenu)
    panel:SetScript("OnShow", options.Refresh)
    UISpecialFrames[#UISpecialFrames + 1] = "GroupCompassOptions"
end
function options.Toggle()
    if not panel then createPanel(); options.Refresh(); return end
    panel:SetShown(not panel:IsShown())
end
function options.Initialize()
    settings.OnChanged = function(key)
        if key == "buttonAngle" then updateBorderButton()
        else options.Refresh(); addon.Maps.Refresh() end
    end
    if borderButton or not Minimap then return end
    borderButton = CreateFrame("Button", "GroupCompassMinimapButton", Minimap)
    borderButton:SetSize(30, 30); borderButton:SetFrameLevel(Minimap:GetFrameLevel() + 20)
    local background = borderButton:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints(); background:SetTexture(addon.MarkerStyle.Path .. "circle.tga")
    background:SetVertexColor(0.02, 0.16, 0.22, 1)
    local ring = borderButton:CreateTexture(nil, "BORDER")
    ring:SetAllPoints(); ring:SetTexture(addon.MarkerStyle.Path .. "ring.tga")
    ring:SetVertexColor(0.85, 0.72, 0.38, 1)
    local icon = borderButton:CreateTexture(nil, "ARTWORK")
    icon:SetPoint("CENTER"); icon:SetSize(19, 19)
    icon:SetTexture(addon.MarkerStyle.Path .. "person.tga"); icon:SetVertexColor(0.1, 0.8, 1, 1)
    borderButton:RegisterForClicks("LeftButtonUp")
    borderButton:RegisterForDrag("LeftButton")
    borderButton:SetScript("OnClick", function()
        if not borderButton.dragged and GetTime() >= (borderButton.suppressClickUntil or 0) then options.Toggle() end
    end)
    borderButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("Group Compass")
        GameTooltip:AddLine("Click for options. Drag around the minimap border.", 1, 1, 1); GameTooltip:Show()
    end)
    borderButton:SetScript("OnLeave", function(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide() end end)
    borderButton:SetScript("OnDragStart", function(self)
        self.dragged = true
        self:SetScript("OnUpdate", function()
            local x, y = GetCursorPosition(); local cx, cy = Minimap:GetCenter()
            if cx and cy then
                local scale = Minimap:GetEffectiveScale()
                settings.Set("buttonAngle", math.deg(math.atan2(y / scale - cy, x / scale - cx)))
            end
        end)
    end)
    borderButton:SetScript("OnDragStop", function(self)
        self:SetScript("OnUpdate", nil); self.dragged = nil; self.suppressClickUntil = GetTime() + 0.15
    end)
    borderButton:HookScript("OnHide", function(self) self:SetScript("OnUpdate", nil); self.dragged = nil end)
    updateBorderButton()
end
