local BuildableDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

function BuildableDef:new(data)
    setmetatable(BuildableDef, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    local defType = def.defType
    def.statBases = 
    return def
end

return BuildableDef