local addon = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", addon)
local s = addon.Settings
GroupCompassDB = {icon = "bad", effect = "bad", colorMode = "bad", minimapSize = 0/0,
    worldSize = 1000, buttonAngle = -45, obsolete = true}
s.Initialize()
assert(s.Get().icon == "person" and s.Get().effect == "none" and s.Get().colorMode == "class")
assert(s.Get().minimapSize == 20 and s.Get().worldSize == 40 and s.Get().buttonAngle == 315)
assert(s.Get().obsolete == nil and GroupCompassDB == s.Get())
local changed
s.OnChanged = function(key) changed = key end
s.Set("icon", "body"); assert(changed == "icon" and GroupCompassDB.icon == "body")
s.Set("minimapSize", 11); assert(s.Get().minimapSize == 12)
s.Set("worldSize", 23.7); assert(s.Get().worldSize == 24)
s.Set("worldSize", math.huge); assert(s.Get().worldSize == 24)
s.Set("bad", 5); assert(s.Get().bad == nil)
s.Set("effect", "flash"); s.Set("colorMode", "pink")
local reloaded = {}
assert(loadfile("GroupCompass/Settings.lua"))("GroupCompass", reloaded)
reloaded.Settings.Initialize()
assert(reloaded.Settings.Get().icon == "body" and reloaded.Settings.Get().effect == "flash")
assert(reloaded.Settings.Get().colorMode == "pink")
reloaded.Settings.Reset()
assert(GroupCompassDB.icon == "person" and GroupCompassDB.minimapSize == 20 and GroupCompassDB.worldSize == 24)
assert(GroupCompassDB.effect == "none" and GroupCompassDB.colorMode == "class")
print("PASS: settings defaults, validation, bounds, callbacks, saved reload and reset")
