local BiomeDef = {}
local base = require("Module:RW_Def")
setmetatable(BiomeDef, base)
BiomeDef.__index = BiomeDef

-- toboolean

function toboolean(s)
    return (s ~= nil and string.lower(s) == "true")
end

-- require

local SMW = require("Module:SMW")
local Textures = require("Module:Textures")
local ColorUtility = require("Module:ColorUtility")

local Collapse = require("Module:RT_Collapse")

local SimpleCurve = require("Module:AC_SimpleCurve")
local GenText = require("Module:AC_GenText")

--------------------------------

-- BiomeWorker

local BiomeWorker = {
    BiomeWorker_AridShrubland = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.temperature < -10) then
                return 0
            end
            if (tile.rainfall < 600 or tile.rainfall >= 2000) then
                return 0
            end
            return 22.5 + (tile.temperature - 20) * 2.2 + (tile.rainfall - 600) / 100
        end
    },
    BiomeWorker_BorealForest = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.temperature < -10) then
                return 0
            end
            if (tile.rainfall < 600) then
                return 0
            end
            return 15
        end
    },
    BiomeWorker_Desert = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.rainfall >= 600) then
                return 0
            end
            return tile.temperature + 0.0001
        end
    },
    BiomeWorker_ExtremeDesert = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.rainfall >= 340) then
                return 0
            end
            return tile.temperature * 2.7 - 13 - tile.rainfall * 0.14
        end
    },
    BiomeWorker_IceSheet = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            return -20 + (-tile.temperature) * 2
        end
    },
    BiomeWorker_Ocean = {
        getScore = function(tile)
            if (not tile.WaterCovered) then
                return -100
            end
            return 0
        end
    },
    BiomeWorker_SeaIce = {
        getScore = function(tile)
            if (not tile.WaterCovered) then
                return -100
            end
            return -20 + (-tile.temperature) * 2 - 23
        end
    },
    BiomeWorker_TemperateForest = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.temperature < -10) then
                return 0
            end
            if (tile.rainfall < 600) then
                return 0
            end
            return 15 + (tile.temperature - 7) + (tile.rainfall - 600) / 180
        end
    },
    BiomeWorker_TropicalRainforest = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            if (tile.temperature < -15) then
                return 0
            end
            if (tile.rainfall < 2000) then
                return 0
            end
            return 28 + (tile.temperature - 20) * 1.5 + (tile.rainfall - 600) / 165
        end
    },
    BiomeWorker_Tundra = {
        getScore = function(tile)
            if (tile.WaterCovered) then
                return -100
            end
            return -tile.temperature
        end
    }
}


--------------------------------

-- BiomeDef

function BiomeDef:new(data)
    local def = base:new(data)
    setmetatable(def, self)
    -- fields
    def.workerClass = SMW.show(data, "BiomeDef.workerClass")
    -- def.implemented = toboolean(SMW.show(data, "BiomeDef.implemented", "true"))
    -- def.canBuildBase = toboolean(SMW.show(data, "BiomeDef.canBuildBase", "true"))
    -- def.allowRoads = toboolean(SMW.show(data, "BiomeDef.allowRoads", "true"))
    -- def.allowRivers = toboolean(SMW.show(data, "BiomeDef.allowRivers", "true"))
    def.animalDensity = tonumber(SMW.show(data, "BiomeDef.animalDensity")) or 0
    def.plantDensity = tonumber(SMW.show(data, "BiomeDef.plantDensity")) or 0
    def.diseaseMtbDays = tonumber(SMW.show(data, "BiomeDef.diseaseMtbDays")) or 60
    def.factionBaseSelectionWeight = tonumber(SMW.show(data, "BiomeDef.factionBaseSelectionWeight")) or 1
    def.impassable = toboolean(SMW.show(data, "BiomeDef.impassable"))
    def.hasVirtualPlants = toboolean(SMW.show(data, "BiomeDef.hasVirtualPlants", "true"))
    -- postLoad
    def.pathCost = SMW.show(data, "BiomeDef.pathCost")
    def.baseWeatherCommonalities = SMW.show(data, "BiomeDef.baseWeatherCommonalities")
    def.terrainsByFertility = SMW.show(data, "BiomeDef.terrainsByFertility")
    -- def.soundsAmbient = SMW.show(data, "BiomeDef.soundsAmbient")
    def.terrainPatchMakers = SMW.show(data, "BiomeDef.terrainPatchMakers")
    def.wildPlants = SMW.show(data, "BiomeDef.wildPlants")
    def.wildAnimals = SMW.show(data, "BiomeDef.wildAnimals")
    def.diseases = SMW.show(data, "BiomeDef.diseases")
    -- def.allowedPackAnimals = SMW.show(data, "BiomeDef.allowedPackAnimals")
    def.texture = SMW.show(data, "BiomeDef.texture")
    def:postLoad(data)
    return def
end

function BiomeDef:postLoad(data)

    if self.pathCost ~= nil then
        self.pathCost = SimpleCurve:new(SMW.show(data, "BiomeDef.pathCost.points"))    
    end

    if self.baseWeatherCommonalities ~= nil then
        self.baseWeatherCommonalities = BiomeDef.getCommonalityRecord("weather", self.baseWeatherCommonalities)
    end

    if self.wildPlants ~= nil then
        self.wildPlants = BiomeDef.getCommonalityRecord("plant", self.wildPlants)
    end

    if self.wildAnimals ~= nil then
        self.wildAnimals = BiomeDef.getCommonalityRecord("animal", self.wildAnimals)
    end

    if self.diseases ~= nil then
        self.diseases = BiomeDef.getCommonalityRecord("diseaseInc", self.diseases)
    end

end

function BiomeDef.getCommonalityRecord(fieldName, sourceString)
    local list = mw.text.split(sourceString, ";")
    for i, item in pairs(list) do
        local temp = mw.text.split(item, ",")
        item = {}
        item[fieldName] = temp[1]:sub(2, -2)
        item.commonality = tonumber(temp[2]:sub(2, -2))
        list[i] = item
    end
    return list
end

function BiomeDef:get_Worker()
    if self.workerInt == nil then
        self.workerInt = BiomeWorker[self.workerClass]
    end
    return self.workerInt
end

-- show

function BiomeDef:showBasicArgs()
    return Collapse.ctable({
        id = self.defName .. "-basicArgs",
        title = "基础参数",
        headers = {{
            text = "参数",
            width = "40%"
        },{
            text = "值",
            width = "30%"
        },{
            text = "显示",
            width = "30%"
        }},
        rows = {{
            cols = {"动物密度", self.animalDensity, ""}
        },{
            cols = {"植被密度", self.plantDensity, ""}
        },{
            cols = {"疾病最大间隔时间（天）", self.diseaseMtbDays, ""}
        },{
            cols = {"派系基地选择权重", self.factionBaseSelectionWeight, ""}
        },{
            cols = {
                "可否放牧动物",
                self.hasVirtualPlants,
                GenText.booleanToIcon(self.hasVirtualPlants)
            }
        },{
            cols = {
                "贴图",
                {
                    text = "[[:File:" .. Textures.getFileName(self.texture) .. "|" .. self.texture .. "]]",
                    span = 2
                }
            }
        }}
    })
end

function BiomeDef:showECharts()
    if not self.baseWeatherCommonalities 
        and not self.wildPlants
        and not self.wildAnimals
        and not self.diseases then
        return ""
    end
    
    text = "<hr/>"

    if self.wildPlants then
        local series1_data = {}
        local count = 0
        for i, record in pairs(self.wildPlants) do
            series1_data[i] = {
                name = SMW.show("Core:Defs_ThingDef_" .. record.plant, "ThingDef.label.zh-cn"),
                value = record.commonality
            }
            count = i
        end
        local option = Collapse.newOptionPie(ColorUtility.colorSet(count))
        option.title.text = "植被密度：" .. self.plantDensity
        option.series[1].data = series1_data
        text = text .. Collapse.echarts({
            id = self.defName .. "-wildPlants",
            title = "生态区 " .. self.label_zhcn .. " 的野生植物",
            option = option
        })
    end

    if self.wildAnimals then
        local series1_data = {}
        local count = 0
        for i, record in pairs(self.wildAnimals) do
            series1_data[i] = {
                name = SMW.show("Core:Defs_PawnKindDef_" .. record.animal, "PawnKindDef.label.zh-cn"),
                value = record.commonality
            }
            count = i
        end
        local option = Collapse.newOptionPie(ColorUtility.colorSet(count))
        option.title.text = "动物密度：" .. self.animalDensity
        option.series[1].data = series1_data
        text = text .. Collapse.echarts({
            id = self.defName .. "-wildAnimals",
            title = "生态区 " .. self.label_zhcn .. " 的野生动物",
            option = option
        })
    end

    if self.diseases then
        local series1_data = {}
        local count = 0
        for i, record in pairs(self.diseases) do
            series1_data[i] = {
                name = SMW.show("Core:Defs_IncidentDef_" .. record.diseaseInc, "IncidentDef.label.zh-cn"),
                value = record.commonality
            }
            count = i
        end
        local option = Collapse.newOptionPie(ColorUtility.colorSet(count))
        option.title.text = "疾病最大间隔时间（天）：" .. self.diseaseMtbDays
        option.series[1].data = series1_data
        text = text .. Collapse.echarts({
            id = self.defName .. "-wildAnimals",
            title = "生态区 " .. self.label_zhcn .. " 的疾病",
            option = option
        })
    end

    return text
end

function BiomeDef:getButton()
    text = "<div class=\"rw-lbtn\">"
        .. "<div class=\"rw-lbtn-icon clip-hexagon-64\">\n"
        .. "<div class=\"rw-biome\">[[File:" .. Textures.getFileName(self.texture) .. "|link=]]</div>\n"
        .. "</div>\n"
        .. "<div class=\"rw-lbtn-label\">" .. self.label_zhcn .. "</div>\n"
        .. "<div class=\"rw-lbtn-link\">[[Biomes_" .. self.defName .. "|&nbsp;]]</div>\n"
        .. "</div>\n"
    return text
end

BiomeDefOf = {}
function BiomeDef.of(defName)
    local def = BiomeDefOf[defName]
    if def == nil then
        def = BiomeDef:new("Core:Defs_BiomeDef_" .. defName)
        BiomeDefOf[defName] = def
    end
    return def
end

return BiomeDef