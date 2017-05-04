local StatCategoryDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

function StatCategoryDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    return def
end

return StatCategoryDef