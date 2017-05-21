local RoomRoleView = {}

local RoomRoleDef = require("Module:RW_RoomRoleDef")

function RoomRoleView.view(frame)
    local def = RoomRoleDef:new(frame.args[1])
    local text = def:getInfoBase()
        .. def:showRelatedStats()
    return text
end

return RoomRoleView