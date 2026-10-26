local _, addon = ...
addon.MarkerStyle = {}
local style = addon.MarkerStyle
style.Path = "Interface\\AddOns\\GroupCompass\\Textures\\"

function style.Color(member)
    local mode = addon.Settings.Get().colorMode
    if mode == "party" then return addon.Tracking.Color(member.slot) end
    return addon.Settings.Palette[mode] or member.color
end
function style.Stop(marker)
    if marker.flash then marker.flash:Stop() end
    marker.fill:SetAlpha(1)
    marker.gcEffect = nil
end
function style.Decorate(marker)
    marker.glow = marker:CreateTexture(nil, "BACKGROUND")
    marker.glow:SetPoint("CENTER")
    marker.glow:SetTexture(style.Path .. "glow.tga")
    marker.glow:SetBlendMode("ADD")
    marker.outline = marker:CreateTexture(nil, "ARTWORK")
    marker.outline:SetPoint("CENTER")
    marker.outline:SetVertexColor(0.04, 0.06, 0.04, 1)
    marker.fill = marker:CreateTexture(nil, "OVERLAY")
    marker.fill:SetPoint("CENTER")
    marker:HookScript("OnHide", function(self) style.Stop(self) end)
end
function style.Apply(marker, member, mapKind)
    local db = addon.Settings.Get()
    local size = mapKind == "world" and db.worldSize or db.minimapSize
    local color, texture = style.Color(member), style.Path .. db.icon .. ".tga"
    marker.gcColor = color
    marker:SetSize(size, size)
    marker.outline:SetSize(size + 2, size + 2)
    marker.outline:SetTexture(texture)
    marker.fill:SetSize(size, size)
    marker.fill:SetTexture(texture)
    marker.fill:SetVertexColor(unpack(color))
    marker.glow:SetSize(size * 1.8, size * 1.8)
    marker.glow:SetVertexColor(unpack(color))
    marker.glow:SetAlpha(db.effect == "glow" and 0.75 or 0)
    if marker.gcEffect ~= db.effect then
        style.Stop(marker)
        marker.gcEffect = db.effect
        if db.effect == "flash" then
            if not marker.flash then
                marker.flash = marker.fill:CreateAnimationGroup()
                marker.flash:SetLooping("REPEAT")
                for order = 1, 2 do
                    local alpha = marker.flash:CreateAnimation("Alpha")
                    alpha:SetOrder(order)
                    alpha:SetDuration(0.8)
                    alpha:SetFromAlpha(order == 1 and 1 or 0.35)
                    alpha:SetToAlpha(order == 1 and 0.35 or 1)
                end
            end
            marker.flash:Play()
        end
    end
end
