local _, addon = ...
addon.RouteMenu = {}
local menu, scroll, content, status, heading, help
local rows, page = {}, "main"
local function label(parent, value, y)
    local text = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    text:SetPoint("TOPLEFT", 16, y); text:SetWidth(304)
    text:SetText(value)
    return text
end
local function choose(kind, id)
    local ok, message = addon.Routing.SelectSource(kind, id)
    print("Group Compass: " .. message)
    if ok then menu:Hide() else status.explanation = true; status:SetText(message) end
end
local function refresh()
    local sources, why = addon.Routing.Sources()
    status.explanation = nil
    status:SetText(addon.Routing.Detail())
    for _, row in ipairs(rows) do row:Hide() end
    local entries = {}
    local function add(text, action, reason)
        entries[#entries + 1] = {text = text, action = action, reason = reason}
    end
    local function open(value) page = value; refresh() end
    if page == "main" then
        heading:SetText("Golden path targets")
        help:SetText("Selected destinations appear on our bar. Guide following stays in Shortest Path. * Click for details.")
        local unavailable = not sources and why or sources.combat and "Change routes after combat ends." or nil
        add("RestedXP guide settings...", function() choose("restedxp") end,
            unavailable or not sources.restedxp and "Enable Shortest Path to open its guide settings." or nil)
        add("Blizzard tracked quest", function() choose("quest") end,
            unavailable or not sources.quest and sources.questReason or nil)
        add("Party members  >", function() open("party") end, unavailable)
        add("TomTom waypoints  >", function() open("tomtom") end, unavailable)
        add("Retry current route", function() choose("retry") end,
            unavailable or not sources.retry and "Select a Group Compass target first." or nil)
        add("Stop Group Compass route", function() choose("stop") end, unavailable or not sources.owned and "Use Shortest Path controls to stop a journey owned by another source." or nil)
        add("Shortest Path settings", function()
            local ok, err = addon.Routing.OpenSettings()
            if ok then menu:Hide() else status:SetText(err) end
        end)
        add("Route report", function()
            local ok, err = addon.Routing.OpenSettings("report")
            if ok then menu:Hide() else status.explanation = true; status:SetText(err) end
        end)
    else
        heading:SetText(page == "party" and "Route to a party member" or "Route to a TomTom waypoint")
        help:SetText(page == "party" and "Routes to their current location. Select again after they move."
            or "Select a saved point directly to request its path. No second map click needed.")
        add("<  Back to sources", function() open("main") end)
        local targets = page == "party" and addon.Tracking.RouteTargets() or addon.Waypoints.List()
        if #targets == 0 then add(page == "party" and "No party members" or "No saved TomTom waypoints", nil) end
        for _, target in ipairs(targets) do
            local item = target
            add(item.name, function() choose(page == "party" and "party" or "tomtom", item.id) end,
                page == "party" and item.reason or nil)
        end
    end
    for i, entry in ipairs(entries) do
        local row = rows[i]
        if not row then
            row = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
            row:SetSize(286, 25); row:SetPoint("TOPLEFT", 0, -(i - 1) * 29)
            row:SetScript("OnClick", function(self)
                if self.entry.reason then status.explanation = true; status:SetText(self.entry.reason)
                elseif self.entry.action then self.entry.action() end
            end)
            row:SetScript("OnEnter", function(self)
                if self.entry.reason then
                    GameTooltip:SetOwner(self, "ANCHOR_LEFT")
                    GameTooltip:SetText(self.entry.reason); GameTooltip:Show()
                end
            end)
            row:SetScript("OnLeave", function(self)
                if GameTooltip:IsOwned(self) then GameTooltip:Hide() end
            end)
            rows[i] = row
        end
        row.entry = entry
        row:SetText(entry.reason and entry.text .. " *" or entry.text)
        row:Show()
    end
    content:SetHeight(math.max(1, #entries * 29))
    scroll:SetVerticalScroll(0)
end
function addon.RouteMenu.Toggle(anchor)
    if menu and menu:IsShown() then menu:Hide(); return end
    if not menu then
        menu = CreateFrame("Frame", "GroupCompassRouteMenu", UIParent, "BackdropTemplate")
        menu:SetSize(340, 390); menu:SetFrameStrata("DIALOG"); menu:SetClampedToScreen(true)
        menu:SetBackdrop({bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 16,
            insets = {left = 4, right = 4, top = 4, bottom = 4}})
        menu:SetBackdropColor(0.04, 0.07, 0.08, 0.98)
        heading = label(menu, "", -15)
        help = label(menu, "", -38); help:SetHeight(34)
        status = label(menu, "", -76); status:SetHeight(54)
        menu:SetScript("OnUpdate", function(self, elapsed)
            self.elapsed = (self.elapsed or 0) + elapsed
            if self.elapsed >= 1 then
                self.elapsed = 0
                if not status.explanation then status:SetText(addon.Routing.Detail()) end
            end
        end)
        scroll = CreateFrame("ScrollFrame", nil, menu, "UIPanelScrollFrameTemplate")
        scroll:SetPoint("TOPLEFT", 18, -134); scroll:SetSize(286, 210)
        content = CreateFrame("Frame", nil, scroll); content:SetSize(286, 1)
        scroll:SetScrollChild(content)
        local done = CreateFrame("Button", nil, menu, "UIPanelButtonTemplate")
        done:SetSize(90, 24); done:SetPoint("BOTTOMRIGHT", -16, 14); done:SetText("Done")
        done:SetScript("OnClick", function() menu:Hide() end)
        UISpecialFrames[#UISpecialFrames + 1] = "GroupCompassRouteMenu"
    end
    page = "main"
    menu:ClearAllPoints(); menu:SetPoint("TOPRIGHT", anchor, "BOTTOMRIGHT", 0, -4)
    refresh(); menu:Show()
end
