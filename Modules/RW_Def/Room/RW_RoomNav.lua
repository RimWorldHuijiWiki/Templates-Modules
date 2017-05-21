local RoomNav = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")

local countRoles = 0
local countStats = 0

function RoomNav.nav(frame)
    return Collapse.navbox({
        id = "RoomNav",
        title = "RimWorld 中的房间分类与属性",
        above = "[[Room|查看房间专题<i class=\"fa fa-arrow-right rw-btn-icon-right\" aria-hidden=\"true\"></i>]]",
        rows = {{
            label = "房间分类",
            list = RoomNav.linksRoomRoleDef(
                "None",
                "Room",
                "Bedroom",
                "PrisonCell",
                "DiningRoom",
                "RecRoom",
                "Hospital",
                "Laboratory",
                "Workshop",
                "Barracks",
                "PrisonBarracks",
                "Kitchen",
                "Tomb",
                "Barn"
            )
        },{
            label = "房间属性",
            list = RoomNav.linksRoomStatDef(
                "Impressiveness",
                "Wealth",
                "Space",
                "Beauty",
                "Cleanliness",
                "InfectionChanceFactor",
                "SurgerySuccessChanceFactor",
                "ResearchSpeedFactor",
                "GraveVisitingJoyGainFactor",
                "FoodPoisonChanceFactor"
            )
        },{
            label = "总计",
            list = {
                countRoles .. "个房间分类",
                countStats .. "个房间属性"
            }
        }}
    })
end

function RoomNav.linksRoomRoleDef(...)
    local args = {...}
    for i, link in pairs(args) do
        args[i] = "[[RoomRoles_" .. link .. "|" .. SMW.show("Core:Defs_RoomRoleDef_" .. link, "RoomRoleDef.label.zh-cn") .. "]]"
        countRoles = countRoles + 1
    end
    return args
end

function RoomNav.linksRoomStatDef(...)
    local args = {...}
    for i, link in pairs(args) do
        args[i] = "[[RoomStats_" .. link .. "|" .. SMW.show("Core:Defs_RoomStatDef_" .. link, "RoomStatDef.label.zh-cn") .. "]]"
        countStats = countStats + 1
    end
    return args
end

return RoomNav