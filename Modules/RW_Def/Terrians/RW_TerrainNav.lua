local TerrainNav = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")

local countItem = 0

function TerrainNav.nav(frame)
    return Collapse.navbox({
        id = "TerrainNav",
        title = "RimWorld 中的地面",
        above = "[[Terrains|查看地面专题<i class=\"fa fa-arrow-right rw-btn-icon-right\" aria-hidden=\"true\"></i>]]",
        rows = {{
            label = "地板",
            children = {{
                label = "综合",
                list = TerrainNav.links(
                    "Concrete",
                    "PavedTile",
                    "WoodPlankFloor",
                    "MetalTile",
                    "SilverTile",
                    "GoldTile",
                    "SterileTile"
                )
            },{
                label = "地毯",
                list = TerrainNav.links(
                    "CarpetRed",
                    "CarpetGreen",
                    "CarpetBlue",
                    "CarpetCream",
                    "CarpetDark"
                )
            }}
        },{
            label = "岩石地砖",
            children = {{
                label = "地砖",
                list = TerrainNav.links(
                    "TileSandstone",
                    "TileGranite",
                    "TileLimestone",
                    "TileSlate",
                    "TileMarble"
                )
            },{
                label = "石板",
                list = TerrainNav.links(
                    "FlagstoneSandstone",
                    "FlagstoneGranite",
                    "FlagstoneLimestone",
                    "FlagstoneSlate",
                    "FlagstoneMarble"
                )
            }}
        },{
            label = "自然岩石",
            children = {{
                label = "粗糙的",
                list = TerrainNav.links(
                    "Sandstone_Rough",
                    "Granite_Rough",
                    "Limestone_Rough",
                    "Slate_Rough",
                    "Marble_Rough"
                )
            },{
                label = "粗糙砍凿的",
                list = TerrainNav.links(
                    "Sandstone_RoughHewn",
                    "Granite_RoughHewn",
                    "Limestone_RoughHewn",
                    "Slate_RoughHewn",
                    "Marble_RoughHewn"
                )
            },{
                label = "光滑的",
                list = TerrainNav.links(
                    "Sandstone_Smooth",
                    "Granite_Smooth",
                    "Limestone_Smooth",
                    "Slate_Smooth",
                    "Marble_Smooth"
                )
            }}
        },{
            label = "自然地面",
            list = TerrainNav.links(
                "Sand",
                "Soil",
                "MarshyTerrain",
                "SoilRich",
                "Mud",
                "Marsh",
                "Gravel",
                "MossyTerrain",
                "Ice"
            )
        },{
            label = "道路",
            list = TerrainNav.links(
                "BrokenAsphalt",
                "PackedDirt"
            )
        },{
            label = "水面",
            list = TerrainNav.links(
                "WaterDeep",
                "WaterOceanDeep",
                "WaterMovingDeep",
                "WaterShallow",
                "WaterOceanShallow",
                "WaterMovingShallow"
            )
        },{
            label = "特殊",
            list = TerrainNav.links(
                "Underwall",
                "BurnedWoodPlankFloor",
                "BurnedCarpet"
            )
        },{
            label = "总计",
            list = {tostring(countItem)}
        }}
    })
end

function TerrainNav.links(...)
    local args = {...}
    for i, link in pairs(args) do
        args[i] = "[[Terrains_" .. link .. "|" .. SMW.show("Core:Defs_TerrainDef_" .. link, "TerrainDef.label.zh-cn") .. "]]"
        countItem = countItem + 1
    end
    return args
end

return TerrainNav