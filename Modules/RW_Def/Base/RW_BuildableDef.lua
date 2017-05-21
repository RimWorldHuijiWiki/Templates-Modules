local BuildableDef = {}
local base = require("Module:RW_Def")
setmetatable(BuildableDef, base)
BuildableDef.__index = BuildableDef

local SMW = require("Module:SMW")
local Collapse

local ThingDef
local StatDef
local StuffCategoryDef

function BuildableDef.init(ThingDefClass, StatDefClass, StuffCategoryDefClass, CollapseClass)
    ThingDef = ThingDefClass
    StatDef = StatDefClass
    StuffCategoryDef = StuffCategoryDefClass
    Collapse = CollapseClass
end

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

function BuildableDef:new(data)
    def = base:new(data)
    setmetatable(def, self)
    -- fields
    local prop = def.defType .. "."
    -- list
    def.statBases = SMW.show(data, prop .. "statBases")
    def.passability = SMW.show(data, prop .. "passability")
    def.pathCost = tonumber(SMW.show(data, prop .. "pathCost")) or 0
    def.pathCostIgnoreRepeat = toboolean(SMW.show(data, prop .. "pathCostIgnoreRepeat", "true"))
    def.fertility = tonumber(SMW.show(data, prop .. "fertility")) or -1
    -- list
    def.costList = SMW.show(data, prop .. "costList")
    def.costStuffCount = tonumber(SMW.show(data, prop .. "costStuffCount")) or -1
    -- list
    def.stuffCategories = tonumber(SMW.show(data, prop .. "stuffCategories"))
    def.terrainAffordanceNeeded = SMW.show(data, prop .. "terrainAffordanceNeeded") or "Light"
    -- list
    def.researchPrerequisites = SMW.show(data, prop .. "researchPrerequisites")
    def.resourcesFractionWhenDeconstructed = SMW.show(data, prop .. "resourcesFractionWhenDeconstructed") or 0.75
    def.uiIconPath = SMW.show(data, prop .. "uiIconPath")
    def.altitudeLayer = SMW.show(data, prop .. "altitudeLayer") or "Item"
    def.menuHidden = toboolean(SMW.show(data, prop .. "menuHidden"))
    def.specialDisplayRadius = tonumber(SMW.show(data, prop .. "specialDisplayRadius")) or 0
    def.designationCategory = SMW.show(data, prop .. "designationCategory")
    def.designationHotKey = SMW.show(data, prop .. "designationHotKey")
    def:postLoad()
    return def
end

function BuildableDef:postLoad()
    
    if self.statBases ~= nil then
        local statBases = {}
        local dictTemp = mw.text.split(self.statBases, ";")
        for i, kvp in pairs(dictTemp) do
            kvp = mw.text.split(kvp, ",")
            statBases[i] = {
                stat = string.sub(kvp[1], 2, -2),
                value = tonumber(string.sub(kvp[2], 2, -2))
            }
        end
        self.statBases = statBases
    end

    if self.costList ~= nil then
        local costList = {}
        local dictTemp = mw.text.split(self.costList, ";")
        for i, kvp in pairs(dictTemp) do
            kvp = mw.text.split(kvp, ",")
            costList[i] = {
                thingDef = string.sub(kvp[1], 2, -2),
                count = tonumber(string.sub(kvp[2], 2, -2))
            }
        end
        self.costList = costList
    end

    if self.stuffCategories ~= nil then
        local categories = {}
        for i, cate in pairs(mw.text.split(self.stuffCategories, ",")) do
            categories[i] = string.sub(cate, 2, -2)
        end
        self.stuffCategories = categories
    end

    if self.researchPrerequisites ~= nil then
        local researches = {}
        for i, project in pairs(mw.text.split(self.researchPrerequisites, ",")) do
            researches[i] = string.sub(project, 2, -2)
        end
        self.researchPrerequisites = researches
    end

end

function BuildableDef:madeFromStuff()
    return (self.stuffCategories ~= nil and #(self.stuffCategories) > 0)
end

-- Custom

function BuildableDef:prepareCost()
    if self.isPreparedCost then
        return self
    end
    if self.costList ~= nil then
        for i, thingCount in pairs(self.costList) do
            thingCount.thingDef = ThingDef.of(thingCount.thingDef)
        end
    end
    if self.stuffCategories ~= nil then
        for i, cate in pairs(self.stuffCategories) do
            cate = StuffCategoryDef.of(cate)
        end
    end
    self.isPreparedCost = true
    return self
end

function BuildableDef:showStats(showMarketValueForTerrain)
    if self.statBases ~= nil or showMarketValueForTerrain then
        local rows = {}
        local flagMarketValue = false;
        if self.statBases ~= nil then
            for i, mod in pairs(self.statBases) do
                if mod.stat == "MarketValue" then
                    flagMarketValue = true
                end
                local stat = StatDef.of(mod.stat)
                rows[#rows + 1] = {
                    cols = {
                        "[[Stats_" .. mod.stat .. "|" .. stat.label_zhcn .. "]]",
                        mod.value,
                        stat:valueToString(mod.value)
                    }
                }
            end
        end
        if showMarketValueForTerrain and not flagMarketValue then
            self:prepareCost()
            local StatExtension = require("Module:AC_StatExtension")
            local marketValueStat = StatDef.of("MarketValue")
            local marketValue = StatExtension.getStatValueAbstract(self, marketValueStat)
            rows[#rows + 1] = {
                cols = {
                    "[[Stats_" .. marketValueStat.defName .. "|" .. marketValueStat.label_zhcn .. "]]" .. "<br/>（根据材料与工作量计算得到）",
                    marketValue,
                    marketValueStat:valueToString(marketValue)
                }
            }
        end
        Collapse = Collapse or require("Module:RT_Collapse")
        return Collapse.ctable({
            id = def.defName .. "-statBases",
            title = "属性基础值",
            headers = {{
                text = "属性",
                width = "40%"
            },{
                text = "值",
                width = "30%"
            },{
                text = "显示",
                width = "30%"
            }},
            rows = rows
        })
    end
    return ""
end

function BuildableDef:showCost()
    self:prepareCost()
    local rows = {}
    if self.costList ~= nil then
        local costs = ""
        for i, thingCount in pairs(self.costList) do
            costs = costs
                .. "<span class=\"item\">[[Stuffs_"
                .. thingCount.thingDef.defName
                .. "|"
                .. thingCount.thingDef.label_zhcn
                .. "]] × "
                .. thingCount.count
                .. "</span>"
        end
        rows[#rows + 1] = {
            cols = {
                "固定材料",
                {
                    text = costs,
                    span = 2
                }
            }
        }
    end
    if self.costStuffCount > 1 then
        local categories = ""
        for i, cate in pairs(self.stuffCategories) do
            categories = categories
                .. "<span class=\"item\">[[StuffsCategories_"
                .. cate.defName
                .. "|"
                .. cate.label_zhcn
                .. "]]</span>"
        end
        categories = categories .. "<span class=\"item\">数量：" .. self.costStuffCount .. "</span>"
        rows[#rows + 1] = {
            cols = {
                "可变材料（材料分类）",
                {
                    text = categories,
                    span = 2
                }
            }
        }
    end
    if self.defType == "TerrainDef" or (self.defType == "ThingDef" and self.category == "Building") then
        rows[#rows + 1] = {
            cols = {
                "建造所需的地面用途预设",
                self.terrainAffordanceNeeded,
                ""
            }
        }
        rows[#rows + 1] = {
            cols = {
                "拆除后返回资源比",
                self.resourcesFractionWhenDeconstructed,
                self.resourcesFractionWhenDeconstructed * 100 .. "%"
            }
        }
        rows[#rows + 1] = {
            cols = {
                "命令分类",
                self.designationCategory or "",
                (self.designationCategory and ("[[Designation#Categories-" .. self.designationCategory .. "|" .. SMW.show("Core:Defs_DesignationCategoryDef_" .. self.designationCategory, "DesignationCategoryDef.label.zh-cn") .. "]]") or "")
            }
        }
        rows[#rows + 1] = {
            cols = {
                "命令快捷键",
                self.designationHotKey or "",
                (self.designationHotKey and ("[[KeyBindings#" .. self.designationHotKey .. "|" .. SMW.show("Core:Defs_KeyBindingDef_" .. self.designationHotKey, "KeyBindingDef.label.zh-cn") .. "]]") or "")
            }
        }
    end
    if self.researchPrerequisites ~= nil then
        local researches = ""
        for i, project in pairs(self.researchPrerequisites) do
            researches = researches
                .. "<span class=\"item\">[[Researches#"
                .. project
                .. "|"
                .. SMW.show("Core:Defs_ResearchProjectDef_" .. project, "ResearchProjectDef.label.zh-cn")
                .. "]]</span>"
        end
        rows[#rows + 1] = {
            cols = {
                "所需研究",
                {
                    text = researches,
                    span = 2
                }
            }
        }
    end
    if #rows > 0 then
        Collapse = Collapse or require("Module:RT_Collapse")
        return Collapse.ctable({
            id = def.defName .. "-buildArgs",
            title = "建造/制造参数",
            headers = {{width = "40%"},{width = "30%"},{width = "30%"}},
            rows = rows
        })
    end
    return ""
end



return BuildableDef