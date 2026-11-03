local _, addon = ...
addon.Options = {}
local options, settings = addon.Options, addon.Settings
local panel, borderButton, openMenu, controls = nil, nil, nil, {}
local previewMember = {slot = 1, color = {0.25, 0.78, 0.92}}
local miniPreview, worldPreview
local compassPage, mapPage, otherPage, compassTab, mapTab, otherTab

local function text(parent, value, x, y, template)
    local label = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
    label:SetPoint("TOPLEFT", x, y); label:SetText(value)
    return label
end
local function button(parent, title, width, x, y, onClick, helpText)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24); b:SetPoint("TOPLEFT", x, y); b:SetText(title)
    b:SetScript("OnClick", onClick)
    if helpText then
        b:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(title)
            GameTooltip:AddLine(helpText, 1, 1, 1, true); GameTooltip:Show()
        end)
        b:SetScript("OnLeave", function(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide() end end)
    end
    return b
end
local function closeMenu()
    if openMenu then openMenu:Hide(); openMenu = nil end
end
local function dropdown(title, key, choices, y)
    text(mapPage, title, 24, y)
    local picker, menu
    picker = button(mapPage, "", 230, 24, y - 20, function()
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
local function slider(title, key, y, parent)
    local label = text(parent, title, 24, y)
    local range = settings.Ranges[key]
    local low = text(parent, tostring(range[1]), 24, y - 48)
    text(parent, tostring(range[2]), 224, y - 48)
    local s = CreateFrame("Slider", nil, parent)
    s:SetSize(230, 16); s:SetPoint("TOPLEFT", 24, y - 24)
    s:SetOrientation("HORIZONTAL"); s:SetMinMaxValues(unpack(range))
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
        syncing = true
        local minimum = key == "compassHeight" and settings.MinimumHeight() or range[1]
        s:SetMinMaxValues(minimum, range[2]); low:SetText(tostring(minimum))
        s:SetValue(settings.Get()[key]); syncing = false
        label:SetText(title .. ": " .. settings.Get()[key] .. " px")
    end
end
local function selectPage(page)
    closeMenu()
    compassPage:SetShown(page == "compass"); mapPage:SetShown(page == "map"); otherPage:SetShown(page == "other")
    compassTab:SetEnabled(page ~= "compass"); mapTab:SetEnabled(page ~= "map"); otherTab:SetEnabled(page ~= "other")
    options.Refresh()
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
    if panel:IsShown() and mapPage:IsShown() then
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
    button(panel, "X", 26, 390, -12, function() panel:Hide() end)
    compassTab = button(panel, "Compass", 110, 24, -53, function() selectPage("compass") end)
    mapTab = button(panel, "Map markers", 110, 146, -53, function() selectPage("map") end)
    otherTab = button(panel, "Other addons", 120, 268, -53, function() selectPage("other") end)
    compassPage = CreateFrame("Frame", nil, panel); compassPage:SetAllPoints()
    mapPage = CreateFrame("Frame", nil, panel); mapPage:SetAllPoints()
    otherPage = CreateFrame("Frame", nil, panel); otherPage:SetAllPoints()
    text(compassPage, "Compass appearance — changes apply immediately", 24, -90)
    slider("Bar width (horizontal)", "compassWidth", -128, compassPage)
    slider("Bar height (vertical)", "compassHeight", -218, compassPage)
    slider("Text size", "textSize", -308, compassPage)
    local toggle = CreateFrame("CheckButton", nil, compassPage, "UICheckButtonTemplate")
    toggle:SetSize(24, 24); toggle:SetPoint("TOPLEFT", 22, -371)
    text(compassPage, "Show Elsewhere line (remote members and points)", 50, -377)
    toggle:SetScript("OnClick", function(self) settings.Set("showElsewhere", self:GetChecked() == true) end)
    controls.showElsewhere = function() toggle:SetChecked(settings.Get().showElsewhere) end
    text(mapPage, "Member icons (waypoints use TomTom)", 24, -90)
    dropdown("Icon", "icon", settings.Icons, -112)
    slider("Minimap size", "minimapSize", -168, mapPage)
    slider("World map size", "worldSize", -224, mapPage)
    dropdown("Effect", "effect", settings.Effects, -280)
    dropdown("Marker colors", "colorMode", settings.Colors, -336)
    text(mapPage, "Preview", 302, -112, "GameFontNormal")
    text(mapPage, "Minimap", 300, -172)
    text(mapPage, "World map", 300, -272)
    miniPreview = CreateFrame("Frame", nil, mapPage)
    miniPreview:SetPoint("CENTER", mapPage, "TOPLEFT", 332, -145)
    worldPreview = CreateFrame("Frame", nil, mapPage)
    worldPreview:SetPoint("CENTER", mapPage, "TOPLEFT", 332, -242)
    addon.MarkerStyle.Decorate(miniPreview); addon.MarkerStyle.Decorate(worldPreview)
    button(panel, "Waypoints & help", 130, 24, -402, function()
        closeMenu(); panel:Hide(); addon.WaypointUI.Toggle()
    end)
    text(otherPage, "Settings and troubleshooting — hover for help", 24, -90)
    local otherMessage = text(otherPage, "Resume guide: /path > Guidance > RestedXP guide > Resume guide.\nThis bottom red button refreshes [RXP] after a reload.", 24, -280)
    otherMessage:SetWidth(380); otherMessage:SetHeight(92)
    local function openOther(kind)
        local ok, err
        if kind == "tomtom" then ok, err = addon.Waypoints.OpenSettings()
        elseif kind == "restedxp" then
            local command = SlashCmdList and SlashCmdList.ACECONSOLE_RXP
            if type(command) == "function" then
                ok, err = pcall(command, "")
            else err = "Enable RestedXP, then open Options > AddOns > RestedXP Guides." end
        else ok, err = addon.Routing.OpenSettings(kind == "report" and "report" or "") end
        if ok then panel:Hide()
        else otherMessage:SetText(err or "Could not open this addon's controls.") end
    end
    button(otherPage, "Shortest Path settings", 230, 24, -126, function() openOther("path") end,
        "Open /path. Guidance controls guide following and Resume guide; Interface controls its own direction arrow and compass.")
    button(otherPage, "RestedXP settings", 230, 24, -162, function() openOther("restedxp") end,
        "Open /rxp. General > Features > Hide waypoint arrow hides its arrow. Keep Show all Enabled Frames checked.")
    button(otherPage, "TomTom settings", 230, 24, -198, function() openOther("tomtom") end,
        "Open /tomtom. Waypoint Arrow > Enable floating waypoint arrow controls its arrow without deleting saved points.")
    button(otherPage, "Route report (diagnostics)", 230, 24, -234, function() openOther("report") end,
        "Open /path report for troubleshooting a missing or incorrect route. It shows the active target, planning and drawing details. It does not change the route or send a report automatically.")
    button(panel, "Reset defaults", 130, 24, -445, function() closeMenu(); settings.Reset() end)
    button(panel, "Done", 90, 316, -445, function() panel:Hide() end)
    panel:SetScript("OnHide", closeMenu)
    panel:SetScript("OnShow", options.Refresh)
    UISpecialFrames[#UISpecialFrames + 1] = "GroupCompassOptions"
    selectPage("compass")
end
function options.Toggle()
    if not panel then createPanel(); options.Refresh(); return end
    panel:SetShown(not panel:IsShown())
end
function options.Initialize()
    settings.OnChanged = function(key)
        if key == "buttonAngle" then updateBorderButton()
        else
            options.Refresh()
            if not key or key == "compassWidth" or key == "compassHeight" or key == "textSize" or key == "showElsewhere" then
                addon.Compass.RefreshAppearance()
            end
            if not key or (key ~= "compassWidth" and key ~= "compassHeight" and key ~= "textSize" and key ~= "showElsewhere") then
                addon.Maps.Refresh()
            end
        end
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
    borderButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    borderButton:RegisterForDrag("LeftButton")
    borderButton:SetScript("OnClick", function(_, mouseButton)
        if not borderButton.dragged and GetTime() >= (borderButton.suppressClickUntil or 0) then
            if mouseButton == "RightButton" then addon.RouteMenu.Toggle(borderButton)
            else options.Toggle() end
        end
    end)
    borderButton:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT"); GameTooltip:SetText("Group Compass")
        GameTooltip:AddLine("Left-click: Open options for the compass, map markers and other addon settings.", 1, 1, 1, true)
        GameTooltip:AddLine("Right-click: Open navigation choices for RestedXP guide controls, party members and TomTom waypoints.", 1, 1, 1, true)
        GameTooltip:AddLine("Left-drag: Move this icon around the minimap.", 0.8, 0.8, 0.8, true)
        GameTooltip:Show()
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
