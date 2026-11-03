local _, addon = ...
addon.Settings = {}
local settings = addon.Settings

settings.Icons = {
    {"person", "Head & shoulders"}, {"body", "Standing person"}, {"face", "Face"},
    {"diamond", "Diamond"}, {"pin", "Map pin"}, {"shield", "Shield"},
    {"star", "Star"}, {"flag", "Flag"}, {"circle", "Circle"}, {"square", "Square"},
}
settings.Effects = {{"none", "None"}, {"glow", "Glow"}, {"flash", "Slow flash"}}
settings.Colors = {
    {"class", "Class colors"}, {"party", "Party colors"}, {"gold", "Gold"},
    {"cyan", "Cyan"}, {"pink", "Pink"}, {"white", "White"},
}
settings.Palette = {gold = {1, 0.78, 0.25}, cyan = {0.25, 0.85, 1},
    pink = {1, 0.45, 0.75}, white = {1, 1, 1}}
local defaults = {icon = "person", minimapSize = 20, worldSize = 24,
    effect = "none", colorMode = "class", buttonAngle = 225,
    compassWidth = 620, compassHeight = 46, textSize = 10}
settings.Ranges = {minimapSize = {12, 40}, worldSize = {12, 40},
    compassWidth = {320, 1200}, compassHeight = {40, 160}, textSize = {8, 20}}
local db = {}
for key, value in pairs(defaults) do db[key] = value end

local function validChoice(value, choices)
    for _, choice in ipairs(choices) do if choice[1] == value then return true end end
end
local function finite(value)
    return type(value) == "number" and value == value and value > -math.huge and value < math.huge
end
local function sanitize(key, value)
    local choices = key == "icon" and settings.Icons or key == "effect" and settings.Effects
        or key == "colorMode" and settings.Colors
    if choices then return validChoice(value, choices) and value or defaults[key] end
    local range = settings.Ranges[key]
    if range then
        return finite(value) and math.floor(math.max(range[1], math.min(range[2], value)) + 0.5) or defaults[key]
    end
    if key == "buttonAngle" then return finite(value) and value % 360 or defaults[key] end
end
function settings.MinimumHeight()
    return 3 * db.textSize + 16
end
function settings.Initialize()
    local saved = type(GroupCompassDB) == "table" and GroupCompassDB or {}
    db = {}
    for key in pairs(defaults) do db[key] = sanitize(key, saved[key]) end
    db.compassHeight = math.max(db.compassHeight, settings.MinimumHeight())
    GroupCompassDB = db
end
function settings.Get() return db end
function settings.Set(key, value)
    if defaults[key] == nil then return end
    db[key] = sanitize(key, value)
    db.compassHeight = math.max(db.compassHeight, settings.MinimumHeight())
    if settings.OnChanged then settings.OnChanged(key) end
end
function settings.Reset()
    for key, value in pairs(defaults) do db[key] = value end
    if settings.OnChanged then settings.OnChanged() end
end
