local WeatherDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

function WeatherDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    return def
end

return WeatherDef