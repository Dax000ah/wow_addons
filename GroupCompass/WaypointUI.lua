local _, addon = ...
addon.WaypointUI = {}
local ui, panel, nameBox, rows, content, countText = addon.WaypointUI, nil, nil, {}, nil, nil
local routeText, stopButton
local editor, editName, editTitle, editLocation, editStatus, editingID, selectedIcon
local iconButtons = {}
local currentIconButton, sourceText, helpText, saveLocationButton
local function label(parent, value, x, y, template)
    local text = parent:CreateFontString(nil, "OVERLAY", template or "GameFontHighlightSmall")
    text:SetPoint("TOPLEFT", x, y); text:SetText(value); return text
end
local function button(parent, title, width, x, y, click)
    local b = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    b:SetSize(width, 24); b:SetPoint("TOPLEFT", x, y); b:SetText(title); b:SetScript("OnClick", click); return b
end
function ui.Refresh()
    if editor and editor:IsShown() and not addon.Waypoints.Find(editingID) then editor:Hide() end
    if not panel then return end
    local points = addon.Waypoints.List()
    local tomtom = addon.Waypoints.UsesTomTom()
    countText:SetText(#points .. " TomTom points (nearest 20 on bar)")
    helpText:SetText("1. Open the map (M); " .. addon.Waypoints.MapShortcut() .. " a spot.\n2. The point appears below and on our top bar automatically.\n3. Click Edit below to change its name or icon.")
    sourceText:SetText(addon.Waypoints.Status())
    saveLocationButton:SetEnabled(tomtom)
    routeText:SetText(addon.Routing.Status())
    stopButton:SetEnabled(addon.Routing.CanStop())
    content:SetHeight(math.max(1, #points * 30))
    for _, row in ipairs(rows) do row:Hide() end
    for index, point in ipairs(points) do
        local row = rows[index]
        if not row then
            row = CreateFrame("Frame", nil, content); rows[index] = row
            row:SetSize(378, 28); row:SetPoint("TOPLEFT", 0, -(index - 1) * 30)
            row.text = label(row, "", 0, -6); row.text:SetWidth(142); row.text:SetWordWrap(false)
            row:EnableMouse(true)
            row.edit = button(row, "Edit", 50, 145, 0, function() ui.Edit(row.point.id) end)
            row.navigate = button(row, "Navigate", 82, 201, 0, function()
                local _, reason, message = addon.Routing.Start(row.point.id, row.confirmReplace)
                row.confirmReplace = reason == "replace"
                row.navigate:SetText(row.confirmReplace and "Replace" or "Navigate")
                print("Group Compass: " .. message)
            end)
            row.remove = button(row, "Remove", 70, 290, 0, function()
                local removed, err = addon.Waypoints.Remove(row.point.id)
                if not removed and err then print("Group Compass: " .. err) end
            end)
            row:SetScript("OnEnter", function(self)
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT"); GameTooltip:SetText(self.point.label)
                local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(self.point.mapID)
                GameTooltip:AddLine(string.format("%s - %.1f, %.1f", info and info.name or "Map " .. self.point.mapID,
                    self.point.x * 100, self.point.y * 100), 1, 1, 1)
                if self.point.readOnly then GameTooltip:AddLine("Managed by another addon; edit/remove it there.", 1, 1, 1) end
                GameTooltip:Show()
            end)
            row:SetScript("OnLeave", function(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide() end end)
            row:SetScript("OnHide", function(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide() end end)
        end
        if not row.point or row.point.id ~= point.id then
            row.confirmReplace = false; row.navigate:SetText("Navigate")
        end
        row.point = point
        row.edit:SetEnabled(not point.readOnly); row.remove:SetEnabled(not point.readOnly)
        row.text:SetText(string.format("%s  (%.1f, %.1f)", point.label, point.x * 100, point.y * 100))
        row:Show()
    end
end
function ui.OpenTomTomSettings()
    local ok, message = addon.Waypoints.OpenSettings()
    if not ok then print("Group Compass: " .. message) end
end
local function selectIcon(icon)
    selectedIcon = icon
    if currentIconButton then currentIconButton:SetText(icon == "tomtom" and "Current (selected)" or "Keep current icon") end
    for value, picker in pairs(iconButtons) do
        picker:SetBackdropBorderColor(value == icon and 1 or 0.3, value == icon and 0.78 or 0.32, 0.25, 1)
    end
end
local function createEditor()
    editor = CreateFrame("Frame", "GroupCompassWaypointEditor", UIParent, "BackdropTemplate")
    editor:SetSize(450, 380); editor:SetPoint("CENTER"); editor:SetFrameStrata("FULLSCREEN_DIALOG")
    editor:EnableMouse(true); editor:SetClampedToScreen(true)
    editor:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
    editor:SetBackdropColor(0.06, 0.08, 0.07, 0.98); editor:SetBackdropBorderColor(0.55, 0.5, 0.35, 1)
    editTitle = label(editor, "Edit waypoint", 24, -20, "GameFontNormalLarge")
    editLocation = label(editor, "", 24, -48); editLocation:SetWidth(402)
    button(editor, "X", 26, 410, -12, function() editor:Hide() end)
    label(editor, "Name", 24, -73)
    editName = CreateFrame("EditBox", nil, editor, "InputBoxTemplate")
    editName:SetSize(390, 24); editName:SetPoint("TOPLEFT", 30, -93)
    editName:SetAutoFocus(false); editName:SetMaxLetters(48)
    local function save()
        local point, message = addon.Waypoints.Update(editingID, editName:GetText(), selectedIcon)
        editStatus:SetText(message)
        if point then print("Group Compass: " .. message); editor:Hide() end
    end
    editName:SetScript("OnEnterPressed", save)
    editName:SetScript("OnEscapePressed", function() editor:Hide() end)
    label(editor, "Icon - choose one", 24, -134)
    currentIconButton = button(editor, "Keep current icon", 130, 296, -128, function() selectIcon("tomtom") end)
    for index, choice in ipairs(addon.Settings.Icons) do
        local value, title = choice[1], choice[2]
        local picker = CreateFrame("Button", nil, editor, "BackdropTemplate")
        picker:SetSize(74, 68); picker:SetPoint("TOPLEFT", 24 + ((index - 1) % 5) * 80, -154 - math.floor((index - 1) / 5) * 74)
        picker:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 2})
        picker:SetBackdropColor(0.12, 0.15, 0.13, 1)
        picker:RegisterForClicks("LeftButtonUp")
        picker:SetScript("OnClick", function() selectIcon(value) end)
        local texture = picker:CreateTexture(nil, "ARTWORK")
        texture:SetSize(28, 28); texture:SetPoint("TOP", 0, -6)
        texture:SetTexture(addon.MarkerStyle.Path .. value .. ".tga"); texture:SetVertexColor(1, 0.78, 0.25, 1)
        local caption = label(picker, title, 3, -39)
        caption:SetWidth(68); caption:SetWordWrap(true)
        iconButtons[value] = picker
    end
    editStatus = label(editor, "Save applies the name and icon to both maps.", 24, -306)
    editStatus:SetWidth(402); editStatus:SetHeight(24)
    button(editor, "Save", 90, 238, -340, save)
    button(editor, "Cancel", 90, 336, -340, function() editor:Hide() end)
    editor:SetScript("OnHide", function() editName:ClearFocus(); editingID = nil end)
    UISpecialFrames[#UISpecialFrames + 1] = "GroupCompassWaypointEditor"
end
function ui.Edit(pointID)
    local point = addon.Waypoints.Find(pointID)
    if not point then print("Group Compass: waypoint no longer exists."); return end
    if point.readOnly then print("Group Compass: this waypoint is managed by another addon. Edit it there."); return end
    if not editor then createEditor() end
    editingID = point.id
    editTitle:SetText("Edit TomTom waypoint [" .. point.tag .. "]")
    local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(point.mapID)
    editLocation:SetText(string.format("%s - %.1f, %.1f", info and info.name or "Map " .. point.mapID, point.x * 100, point.y * 100))
    editName:SetText(point.name); selectIcon(addon.Waypoints.Icon(point))
    editStatus:SetText("Save updates this TomTom waypoint on both maps.")
    editor:Show(); editName:SetFocus(); editName:HighlightText()
end
function ui.Toggle()
    addon.Routing.Refresh()
    if panel then panel:SetShown(not panel:IsShown()); return end
    panel = CreateFrame("Frame", "GroupCompassWaypointWindow", UIParent, "BackdropTemplate")
    panel:SetSize(450, 620); panel:SetPoint("CENTER"); panel:SetFrameStrata("DIALOG")
    panel:EnableMouse(true); panel:SetClampedToScreen(true)
    panel:SetBackdrop({bgFile = "Interface\\Buttons\\WHITE8X8", edgeFile = "Interface\\Buttons\\WHITE8X8", edgeSize = 1})
    panel:SetBackdropColor(0.06, 0.08, 0.07, 0.98); panel:SetBackdropBorderColor(0.55, 0.5, 0.35, 1)
    label(panel, "TomTom waypoints", 24, -20, "GameFontNormalLarge")
    button(panel, "X", 26, 410, -12, function() panel:Hide() end)
    label(panel, "How to add a waypoint", 24, -48, "GameFontNormal")
    helpText = label(panel, "", 24, -72); helpText:SetWidth(402); helpText:SetHeight(58)
    local visibility = label(panel, "Face the point with your character. Points behind you or in another world won't show on the bar.", 24, -132)
    visibility:SetWidth(402); visibility:SetHeight(30)
    button(panel, "Open world map", 150, 24, -168, function()
        panel:Hide()
        if ToggleWorldMap and (not WorldMapFrame or not WorldMapFrame:IsShown()) then ToggleWorldMap() end
    end)
    button(panel, "TomTom settings", 150, 184, -168, ui.OpenTomTomSettings)
    label(panel, "Or save where you are now - name (optional)", 24, -205)
    nameBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    nameBox:SetSize(238, 24); nameBox:SetPoint("TOPLEFT", 30, -225)
    nameBox:SetAutoFocus(false); nameBox:SetMaxLetters(48)
    nameBox:SetScript("OnEscapePressed", function(self) self:ClearFocus(); panel:Hide() end)
    local function addHere()
        local point, message = addon.Waypoints.AddHere(nameBox:GetText())
        print("Group Compass: " .. message)
        if point then nameBox:SetText(""); nameBox:ClearFocus() end
    end
    nameBox:SetScript("OnEnterPressed", addHere)
    saveLocationButton = button(panel, "Save my location", 140, 286, -225, addHere)
    sourceText = label(panel, "", 24, -257); sourceText:SetWidth(402); sourceText:SetHeight(30)
    local scroll = CreateFrame("ScrollFrame", nil, panel, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 24, -296); scroll:SetPoint("BOTTOMRIGHT", -42, 120)
    content = CreateFrame("Frame", nil, scroll); content:SetSize(378, 1); scroll:SetScrollChild(content)
    countText = label(panel, "", 24, -515); countText:SetWidth(266); countText:SetWordWrap(false)
    stopButton = button(panel, "Stop route", 125, 300, -509, function()
        local _, message = addon.Routing.Stop(); print("Group Compass: " .. message)
    end)
    routeText = label(panel, "", 24, -542); routeText:SetWidth(402); routeText:SetHeight(28)
    button(panel, "Route settings", 145, 24, -585, function()
        local opened, message = addon.Routing.OpenSettings()
        if opened then panel:Hide() elseif message then print("Group Compass: " .. message) end
    end)
    button(panel, "Done", 90, 336, -585, function() panel:Hide() end)
    panel:SetScript("OnShow", ui.Refresh)
    panel:SetScript("OnHide", function()
        for _, row in ipairs(rows) do row.confirmReplace = false; row.navigate:SetText("Navigate") end
    end)
    UISpecialFrames[#UISpecialFrames + 1] = "GroupCompassWaypointWindow"
    ui.Refresh()
end
