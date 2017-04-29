local WeatherView = {}
local WeatherDef = require("Module:RW_WeatherDef")

local SMW = require("Module:SMW")

function WeatherView.view(frame)
    local def = WeatherDef:new(frame.args[1])
    local text = def:getSummary()
    text = text .. "\n\n"
    text = text .. def:getInfoBase()
    return text
end

return WeatherView