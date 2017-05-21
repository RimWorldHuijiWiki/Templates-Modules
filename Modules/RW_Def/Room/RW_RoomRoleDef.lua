local RoomRoleDef = {}
local base = require("Module:RW_Def")
setmetatable(RoomRoleDef, base)
RoomRoleDef.__index = RoomRoleDef

-- require

local SMW = base.SMW
local Note = require("Module:RT_Note")

-- RoomRoleDef

function RoomRoleDef:new(data)
    local def = base.ctor("RoomRoleDef", data, {
        texts = {
            "workerClass", "relatedStats"
        }
    })
    setmetatable(def, self)
    def:postLoad()
    return def
end

function RoomRoleDef:postLoad()
    if self.relatedStats then
        local relatedStats = {}
        for i, rs in pairs(mw.text.split(self.relatedStats, ",")) do
            relatedStats[i] = string.sub(rs, 2, -2)
        end
        self.relatedStats = relatedStats
    end
end

-- show

function RoomRoleDef:showRelatedStats()
    if self.relatedStats == nil then
        return ""
    end
    local relatedStats = {}
    for i, rs in pairs(self.relatedStats) do
        relatedStats[i] = "[[RoomStats_" .. rs .. "|" .. SMW.show("Core:Defs_RoomStatDef_" .. rs, "RoomStatDef.label.zh-cn") .. "]]"
    end
    return Note.note("rimworld", "link", "关联的房间属性", table.concat(relatedStats, "、"))
end

-- of

RoomRoleDefOf = {}
function RoomRoleDef.of(defName)
    local def = RoomStatDefOf[defName]
    if def == nil then
        def = RoomRoleDef:new("Core:Defs_RoomRoleDef_" .. defName)
        RoomRoleDefOf[defName] = def
    end
    return def
end


return RoomRoleDef