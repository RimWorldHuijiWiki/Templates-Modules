local RoomStatView = {}

local RoomStatDef = require("Module:RW_RoomStatDef")

function RoomStatView.view(frame)
    local def = RoomStatDef:new(frame.args[1])
    local text = def:showIsHidden()
        .. def:getInfoBase()
        .. def:showStages()
        .. def:showECharts()
    return text
end

return RoomStatView