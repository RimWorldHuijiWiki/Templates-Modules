local StuffCategoryDef = {}
local base = require("Module:RW_Def")

function StuffCategoryDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    return self
end

-- of
StuffCategoryDefOf = {}
function StuffCategoryDef.of(defName)
    local def = StuffCategoryDefOf[defName]
    if def == nil then
        def = StuffCategoryDef:new("Core:Defs_StuffCategoryDef_" .. defName)
        StuffCategoryDefOf[defName] = def
    end
    return def
end

return StuffCategoryDef