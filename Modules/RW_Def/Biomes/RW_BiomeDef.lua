local BiomeDef = {}
local base = require("Module:RW_Def")

-- toboolean

function toboolean(s)
    return (s ~= nil and string.lower(s) == "true")
end

-- require

local SMW = require("Module:SMW")
local Textures = require("Module:Textures")
local Collapse = require("Module:RT_Collapse")

local GenText = require("Module:AC_GenText")
local SimpleCurve = require("Module:AC_SimpleCurve")

--------------------------------



--------------------------------

-- BiomeDef

function BiomeDef:new(data)
    setmetatable(self, base)
    local def = base:new(data)
    setmetatable(def, self)
    self.__index = self
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
            cols = {"植物密度", self.plantDensity, ""}
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

end

return BiomeDef