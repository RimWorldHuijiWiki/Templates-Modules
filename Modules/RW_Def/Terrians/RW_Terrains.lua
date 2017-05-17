local Terrains = {}

function Terrains.view(frame)

    local Note = require("Module:RT_Note")
    local TerrainButton = require("Module:RW_TerrainButton")

    local defs = {{
        label = "地板",
        children = {{
            label = "综合",
            list = {
                "Concrete",
                "PavedTile",
                "WoodPlankFloor",
                "MetalTile",
                "SilverTile",
                "GoldTile",
                "SterileTile"
            }
        },{
            label = "地毯",
            list = {
                "CarpetRed",
                "CarpetGreen",
                "CarpetBlue",
                "CarpetCream",
                "CarpetDark"
            }
        }}
    },{
        label = "岩石地砖",
        children = {{
            label = "地砖",
            list = {
                "TileSandstone",
                "TileGranite",
                "TileLimestone",
                "TileSlate",
                "TileMarble"
            }
        },{
            label = "石板",
            list = {
                "FlagstoneSandstone",
                "FlagstoneGranite",
                "FlagstoneLimestone",
                "FlagstoneSlate",
                "FlagstoneMarble"
            }
        }}
    },{
        label = "自然岩石",
        children = {{
            label = "粗糙的",
            list = {
                "Sandstone_Rough",
                "Granite_Rough",
                "Limestone_Rough",
                "Slate_Rough",
                "Marble_Rough"
            }
        },{
            label = "粗糙砍凿的",
            list = {
                "Sandstone_RoughHewn",
                "Granite_RoughHewn",
                "Limestone_RoughHewn",
                "Slate_RoughHewn",
                "Marble_RoughHewn"
            }
        },{
            label = "光滑的",
            list = {
                "Sandstone_Smooth",
                "Granite_Smooth",
                "Limestone_Smooth",
                "Slate_Smooth",
                "Marble_Smooth"
            }
        }}
    },{
        label = "自然地面",
        list = {
            "Sand",
            "Soil",
            "MarshyTerrain",
            "SoilRich",
            "Mud",
            "Marsh",
            "Gravel",
            "MossyTerrain",
            "Ice"
        }
    },{
        label = "道路",
        list = {
            "BrokenAsphalt",
            "PackedDirt"
        }
    },{
        label = "水面",
        list = {
            "WaterDeep",
            "WaterOceanDeep",
            "WaterMovingDeep",
            "WaterShallow",
            "WaterOceanShallow",
            "WaterMovingShallow"
        }
    },{
        label = "特殊",
        list = {
            "Underwall",
            "BurnedWoodPlankFloor",
            "BurnedCarpet"
        }
    }}
    local text = Note.note("rimworld", "th-large", "地面", "英文 Terrain，是 RimWorld 中的一种定义，包括地板、土地、水面等。")
        .. "<hr/>"
        .. Note.note("primary", "fire-extinguisher", "可燃性", "在 A17 之前，地面是不可燃的，从 A17 开始木地板和地毯会被烧毁。")
        .. Note.note("primary", "bar-chart", "属性", "不同的地面属性各不相同，较常用到的属性有：行走速度、肥沃度、美观度、清洁度和市场价值。[[Terrains/Compare|查看属性对比]]")
    
    for i, group in pairs(defs) do
        text = text .. "<h2>" .. group.label .. "</h2>\n"
        if group.list ~= nil then
            for j, defName in pairs(group.list) do
                text = text .. TerrainButton.button(defName)
            end
        elseif group.children ~= nil then
            for j, child in pairs(group.children) do
                text = text .. "<h3>" .. child.label .. "</h3>\n"
                for k, defName in pairs(child.list) do
                    text = text .. TerrainButton.button(defName)
                end
            end
        end
    end
    
    return text
end

function Terrains.showComparison(frame)
    local Collapse = require("Module:RT_Collapse")

    local TerrainDef = require("Module:RW_TerrainDef")
    local ThingDef = require("Module:RW_ThingDef")
    local StuffCategoryDef = require("Module:RW_StuffCategoryDef")
    local StatUtility = require("Module:AC_StatUtility")

    local Mathf = require("Module:UE_Mathf")

    TerrainDef.init(ThingDef, nil, StuffCategoryDef, nil)

    local allTerrains = {
        TerrainDef.of("Concrete"):prepareCost(),
        TerrainDef.of("PavedTile"):prepareCost(),
        TerrainDef.of("WoodPlankFloor"):prepareCost(),
        TerrainDef.of("MetalTile"):prepareCost(),
        TerrainDef.of("SilverTile"):prepareCost(),
        TerrainDef.of("GoldTile"):prepareCost(),
        TerrainDef.of("SterileTile"):prepareCost(),
        TerrainDef.of("CarpetRed"):prepareCost():setLabel("地毯"),
        TerrainDef.of("TileSandstone"):prepareCost(),
        TerrainDef.of("TileGranite"):prepareCost(),
        TerrainDef.of("TileLimestone"):prepareCost(),
        TerrainDef.of("TileSlate"):prepareCost(),
        TerrainDef.of("TileMarble"):prepareCost(),
        TerrainDef.of("FlagstoneSandstone"):prepareCost(),
        TerrainDef.of("FlagstoneGranite"):prepareCost(),
        TerrainDef.of("FlagstoneLimestone"):prepareCost(),
        TerrainDef.of("FlagstoneSlate"):prepareCost(),
        TerrainDef.of("FlagstoneMarble"):prepareCost(),
        TerrainDef.of("Sandstone_Rough"):prepareCost():setLabel("粗糙的岩石地面"),
        TerrainDef.of("Sandstone_RoughHewn"):prepareCost():setLabel("粗糙砍凿的岩石地面"),
        TerrainDef.of("Sandstone_Smooth"):prepareCost():setLabel("光滑的岩石地面"),
        TerrainDef.of("Sand"):prepareCost(),
        TerrainDef.of("Soil"):prepareCost(),
        TerrainDef.of("MarshyTerrain"):prepareCost(),
        TerrainDef.of("SoilRich"):prepareCost(),
        TerrainDef.of("Mud"):prepareCost(),
        TerrainDef.of("Marsh"):prepareCost(),
        TerrainDef.of("Gravel"):prepareCost(),
        TerrainDef.of("MossyTerrain"):prepareCost(),
        TerrainDef.of("Ice"):prepareCost(),
        TerrainDef.of("BrokenAsphalt"):prepareCost(),
        TerrainDef.of("PackedDirt"):prepareCost(),
        -- TerrainDef.of("WaterDeep"):prepareCost(),
        -- TerrainDef.of("WaterOceanDeep"):prepareCost(),
        -- TerrainDef.of("WaterMovingDeep"):prepareCost(),
        TerrainDef.of("WaterShallow"):prepareCost(),
        TerrainDef.of("WaterOceanShallow"):prepareCost(),
        TerrainDef.of("WaterMovingShallow"):prepareCost(),
        TerrainDef.of("BurnedWoodPlankFloor"):prepareCost(),
        TerrainDef.of("BurnedCarpet"):prepareCost()
    }

    local head = 1
    local tail = #allTerrains
    local temp
    while (head < tail) do
        temp = allTerrains[head]
        allTerrains[head] = allTerrains[tail]
        allTerrains[tail] = temp
        head = head + 1
        tail = tail - 1
    end

    -- 行走速度, 肥沃度, 美观度, 清洁度, 市场价值
    local colors = {"#2e6fe6", "#2ee62e", "#e62ee4", "#2ee6e4", "#e6af2e"}
    local option = Collapse.newOptionPlusminusX(5, colors)
    local yAxis1_data = {}
    local series_speed = {}
    local series_fert = {}
    local series_beauty = {}
    local series_clean = {}
    local series_market = {}
    for i, def in pairs(allTerrains) do
        yAxis1_data[i] = def.label_zhcn
        series_speed[i] = Mathf.roundToInt(13 / (def.pathCost + 13) * 100)
        series_fert[i] = def.fertility * 100
        series_beauty[i] = StatUtility.getStatValueFromList(def.statBases, "Beauty", 0)
        series_clean[i] = StatUtility.getStatValueFromList(def.statBases, "Cleanliness", 0)
        local marketValue = 0
        if def.costList ~= nil then
            for i, thingCount in pairs(def.costList) do
                marketValue = marketValue + thingCount.count * StatUtility.getStatValueFromList(thingCount.thingDef.statBases, "MarketValue", 0)
            end
        end
        series_market[i] = marketValue + StatUtility.getStatValueFromList(def.statBases, "WorkToBuild", 1) * 0.003
    end

    local stats = {"行走速度", "肥沃度", "美观度", "清洁度", "市场价值"}
    option.legend.data = stats
    option.grid.left = "12%"
    local xAxis = option.xAxis
    xAxis[1].name = stats[1]
    xAxis[1].axisLabel.formatter = "{value}%"
    xAxis[1].min = -100
    xAxis[1].max = 100
    xAxis[2].name = stats[2]
    xAxis[2].axisLabel.formatter = "{value}%"
    xAxis[2].min = -140
    xAxis[2].max = 140
    xAxis[3].name = stats[3]
    xAxis[3].min = -6
    xAxis[3].max = 6
    xAxis[4].name = stats[4]
    xAxis[4].min = -2
    xAxis[4].max = 2
    xAxis[5].name = stats[5]
    xAxis[5].axisLabel.formatter = "{value}￥"
    xAxis[5].min = -1000
    xAxis[5].max = 1000
    option.yAxis[1].data = yAxis1_data
    local series = option.series
    series[#series + 1] = {
        name = "行走速度",
        type = "bar",
        xAxisIndex = 0,
        label = {
            normal = {
                show = true,
                formatter = "{c}%",
                position = "right"
            }
        },
        data = series_speed
    }
    series[#series + 1] = {
        name = "肥沃度",
        type = "bar",
        xAxisIndex = 1,
        label = {
            normal = {
                show = true,
                formatter = "{c}%",
                position = "right"
            }
        },
        data = series_fert
    }
    series[#series + 1] = {
        name = "美观度",
        type = "bar",
        xAxisIndex = 2,
        label = {
            normal = {
                show = true,
                position = "right"
            }
        },
        data = series_beauty
    }
    series[#series + 1] = {
        name = "清洁度",
        type = "bar",
        xAxisIndex = 3,
        label = {
            normal = {
                show = true,
                position = "right"
            }
        },
        data = series_clean
    }
    series[#series + 1] = {
        name = "市场价值",
        type = "bar",
        xAxisIndex = 4,
        label = {
            normal = {
                show = true,
                formatter = "{c}￥",
                position = "right"
            }
        },
        data = series_market
    }
    return Collapse.echarts({
        mode = (frame and frame.args[1] or "normal"),
        id = "terrainComparision",
        title = "地面属性对比",
        width = "100%",
        height = "4800px",
        option = option
    })
end

return Terrains