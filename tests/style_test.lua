local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
addon.Settings.Initialize()
addon.Tracking = {Color = function(slot) assert(slot == 2); return {0.4, 0.5, 0.6} end}
assert(loadfile("GroupCompass/MarkerStyle.lua"))("GroupCompass", addon)
local function texture()
    local t = {}
    t.SetPoint = function() end; t.SetBlendMode = function() end
    t.SetSize = function(self, w, h) self.width, self.height = w, h end
    t.SetTexture = function(self, value) self.path = value end
    t.SetVertexColor = function(self, ...) self.color = {...} end
    t.SetAlpha = function(self, a) self.alpha = a end
    t.CreateAnimationGroup = function()
        local group = {plays = 0, stops = 0, animations = {}}
        group.SetLooping = function(self, loop) self.loop = loop end
        group.Play = function(self) self.plays = self.plays + 1 end
        group.Stop = function(self) self.stops = self.stops + 1 end
        group.CreateAnimation = function(self, kind)
            assert(kind == "Alpha")
            local a = {}
            a.SetOrder = function(self, v) self.order = v end
            a.SetDuration = function(self, v) self.duration = v end
            a.SetFromAlpha = function(self, v) self.from = v end
            a.SetToAlpha = function(self, v) self.to = v end
            self.animations[#self.animations + 1] = a
            return a
        end
        return group
    end
    return t
end
local marker = {CreateTexture = texture, HookScript = function(self, _, fn) self.onHide = fn end,
    SetSize = function(self, w, h) self.width, self.height = w, h end}
local member = {slot = 2, color = {0.2, 0.7, 0.9}}
local style, settings = addon.MarkerStyle, addon.Settings
style.Decorate(marker); style.Apply(marker, member, "minimap")
assert(marker.width == 20 and marker.fill.path:find("person.tga", 1, true))
assert(marker.fill.color[1] == 0.2 and marker.glow.alpha == 0)
settings.Set("worldSize", 38); style.Apply(marker, member, "world"); assert(marker.width == 38)
settings.Set("colorMode", "party"); style.Apply(marker, member, "world"); assert(marker.fill.color[1] == 0.4)
settings.Set("colorMode", "gold"); settings.Set("icon", "face"); settings.Set("effect", "glow")
style.Apply(marker, member, "world")
assert(marker.glow.alpha == 0.75 and marker.glow.color[1] == 1 and marker.fill.path:find("face.tga", 1, true))
settings.Set("effect", "flash"); style.Apply(marker, member, "world")
assert(marker.flash.plays == 1 and marker.flash.loop == "REPEAT")
assert(marker.flash.animations[1].from == 1 and marker.flash.animations[2].to == 1)
assert(marker.flash.animations[1].duration == 0.8 and marker.flash.animations[2].duration == 0.8)
style.Apply(marker, member, "world"); assert(marker.flash.plays == 1, "refresh must not restart animations")
marker.onHide(marker); assert(marker.flash.stops > 0 and marker.fill.alpha == 1)
style.Apply(marker, member, "world"); assert(marker.flash.plays == 2, "reuse must resume selected effect")
settings.Set("effect", "none"); style.Apply(marker, member, "world")
assert(marker.glow.alpha == 0 and marker.fill.alpha == 1 and marker.gcEffect == "none")
print("PASS: head/shoulders default, separate sizes, colors, glow, flash reuse and stop/reset lifecycle")
