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

s.Initialize()
assert(s.Get().compassWidth==620 and s.Get().compassHeight==46 and s.Get().textSize==10)
for _,key in ipairs({'compassWidth','compassHeight','textSize'}) do
    local range=s.Ranges[key]
    s.Set(key,-100); assert(s.Get()[key]>=range[1])
    s.Set(key,10000); assert(s.Get()[key]==range[2])
    s.Set(key,0/0); assert(s.Get()[key]<=range[2])
    s.Set(key,math.huge); assert(s.Get()[key]<=range[2])
end
s.Reset(); s.Set('textSize',20); assert(s.Get().compassHeight==76 and s.MinimumHeight()==76)
s.Set('compassHeight',40); assert(s.Get().compassHeight==76)
s.Set('compassWidth',713.6); assert(s.Get().compassWidth==714)
s.Initialize(); assert(s.Get().compassWidth==714 and s.Get().textSize==20 and s.Get().compassHeight==76)
GroupCompassDB={textSize=20,compassHeight=40,compassWidth=900}
s.Initialize(); assert(s.Get().compassHeight==76 and s.Get().compassWidth==900)
s.Reset(); assert(s.Get().compassWidth==620 and s.Get().compassHeight==46 and s.Get().textSize==10)
print('PASS: compass sizing bounds, legacy defaults, finite values, rounding, dynamic height minimum, persistence and reset')
