local WeatherView = {}
local WeatherDef = require("Module:RW_WeatherDef")

local SMW = require("Module:SMW")

function WeatherView.view(frame)
    local def = WeatherDef:new(frame.args[1])
    return def:getInfoBase()
end

return WeatherView