local WeatherDef = {}
local base = require("Module:RW_Def")
setmetatable(WeatherDef, base)
WeatherDef.__index = WeatherDef

-- toboolean

function toboolean(s)
    return (s ~= nil and string.lower(s) == "true")
end

-- require

local SMW = require("Module:SMW")

-- WeatherDef

function WeatherDef:new(data)
    def = base:new(data)
    setmetatable(def, self)
    -- fields
    def.durationRange = SMW.show(data, "WeatherDef.durationRange")
    def.repeatable = toboolean(SMW.show(data, "WeatherDef.repeatable"))
    def.favorability = SMW.show(data, "WeatherDef.favorability")
    def.temperatureRange = SMW.show(data, "WeatherDef.temperatureRange")
    def.commonalityRainfallFactor = SMW.show(data, "WeatherDef.commonalityRainfallFactor")
    def.rainRate = tonumber(SMW.show(data, "WeatherDef.rainRate")) or 0
    def.snowRate = tonumber(SMW.show(data, "WeatherDef.snowRate")) or 0
    def.windSpeedFactor = tonumber(SMW.show(data, "WeatherDef.windSpeedFactor")) or 1
    def.moveSpeedMultiplier = tonumber(SMW.show(data, "WeatherDef.moveSpeedMultiplier")) or 1
    def.accuracyMultiplier = tonumber(SMW.show(data, "WeatherDef.accuracyMultiplier")) or 1
    def.ambientSounds = SMW.show(data, "WeatherDef.ambientSounds")
    def.eventMakers = SMW.show(data, "WeatherDef.eventMakers")
    def.overlayClasses = SMW.show(data, "WeatherDef.overlayClasses")
    def.skyColorsNightMid = SMW.show(data, "WeatherDef.skyColorsNightMid")
    def.skyColorsNightEdge = SMW.show(data, "WeatherDef.skyColorsNightEdge")
    def.skyColorsDay = SMW.show(data, "WeatherDef.skyColorsDay")
    def.skyColorsDusk = SMW.show(data, "WeatherDef.skyColorsDusk")
    return def
end

WeatherDefOf = {}
function WeatherDef.of(defName)
    local def = WeatherDefOf[defName]
    if def == nil then
        def = WeatherDef:new("Core:Defs_WeatherDef_" .. defName)
        WeatherDefOf[defName] = def
    end
    return def
end

return WeatherDef