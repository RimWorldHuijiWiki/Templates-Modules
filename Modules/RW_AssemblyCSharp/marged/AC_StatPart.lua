local StatPart = {}
local StatPart_Quality = {}
local StatPart_Curve = {}
local StatPart_Health = {}
local StatPart_Mood = {}
local StatPart_BodySize = {}
local StatPart_NaturalNotMissingBodyPartsCoverage = {}
local StatPart_Food = {}
local StatPart_Rest = {}
local StatPart_BedStat = {}
local StatPart_Age = {}
local StatPart_ApparelStatOffset = {}
local StatPart_WorkTableUnpowered = {}
local StatPart_WorkTableTemperature = {}
local StatPart_Outdoors = {}
local StatPart_RoomStat = {}
local StatPart_WornByCorpse = {}
local StatPart_GearAndInventoryMass = {}

local SMW
local Collapse
local Keyed_zhcn
local Mathf

local SimpleCurve
local PawnOrCorpseStatUtility

-- init
function StatPart.init(SMWClass, CollapseClass, Keyed_zhcnClass, PawnOrCorpseStatUtilityClass, SimpleCurveClass, MathfClass)
    SMW = SMWClass
    Collapse = CollapseClass
    Keyed_zhcn = Keyed_zhcnClass
    PawnOrCorpseStatUtility = PawnOrCorpseStatUtilityClass
    SimpleCurve = SimpleCurveClass
    Mathf = MathfClass
end

-- local StatRequest = require("Module:AC_StatRequest")

function toboolean(s)
    return s ~= nil and string.lower(s) == "true"
end

-- StatPart

function StatPart:new()
    local part = {
        parentStat = nil
    }
    setmetatable(part, self)
    self.__index = self
    return part
end

function StatPart:transformValue(req, val)
    return val
end

function StatPart:explainEcharts()
    return "<div sytle=\"display:none;\">StatPart</div>\n"
end

-- function StatPart:explanationPart(req)
--     return ""
-- end

-- StatPart_Quality

function StatPart_Quality:new(statData, index)
    if statData == nil or index == nil then
        return nil
    end
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Quality"
    part.index = index
    local prop = "StatDef.parts." .. index .. "."
    part.factorAwful = tonumber(SMW.show(statData, prop .. "factorAwful")) or 1
	part.factorShoddy = tonumber(SMW.show(statData, prop .. "factorShoddy")) or 1
	part.factorPoor = tonumber(SMW.show(statData, prop .. "factorPoor")) or 1
	part.factorNormal = tonumber(SMW.show(statData, prop .. "factorNormal")) or 1
	part.factorGood = tonumber(SMW.show(statData, prop .. "factorGood")) or 1
	part.factorSuperior = tonumber(SMW.show(statData, prop .. "factorSuperior")) or 1
	part.factorExcellent = tonumber(SMW.show(statData, prop .. "factorExcellent")) or 1
	part.factorMasterwork = tonumber(SMW.show(statData, prop .. "factorMasterwork")) or 1
	part.factorLegendary = tonumber(SMW.show(statData, prop .. "factorLegendary")) or 1
	part.alsoAppliesToNegativeValues = toboolean(SMW.show(statData, prop .. "alsoAppliesToNegativeValues"))
    return part
end

function StatPart_Quality:transformValue(req, val)
    if val < 0 and not self.alsoAppliesToNegativeValues then
        return val
    end
    return val * self:qualityMultiplier(req:get_QualityCategory())
end

function StatPart_Quality:qualityMultiplier(qc)
    if qc == "Awful" then
        return self.factorAwful
    elseif qc == "Shoddy" then
        return self.factorShoddy
    elseif qc == "Poor" then
        return self.factorPoor
    elseif qc == "Normal" then
        return self.factorNormal
    elseif qc == "Good" then
        return self.factorGood
    elseif qc == "Superior" then
        return self.factorSuperior
    elseif qc == "Excellent" then
        return self.factorExcellent
    elseif qc == "Masterwork" then
        return self.factorMasterwork
    elseif qc == "Legendary" then
        return self.factorLegendary
    else
        return 1
    end
end

function StatPart_Quality:explainEcharts()
    local StatsReport_QualityMultiplier = Keyed_zhcn.trans("StatsReport_QualityMultiplier")
    local Quality = Keyed_zhcn.trans("Quality")
    local option = Collapse.newOption("span")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_QualityMultiplier
    option.tooltip.formatter = StatsReport_QualityMultiplier .. "<br/>" .. Quality .. "（{b}）：× {c}%"
    option.xAxis[1].name = Quality
    option.xAxis[1].data = {
        Keyed_zhcn.trans("QualityCategoryShort_Awful"),
        Keyed_zhcn.trans("QualityCategoryShort_Shoddy"),
        Keyed_zhcn.trans("QualityCategoryShort_Poor"),
        Keyed_zhcn.trans("QualityCategoryShort_Normal"),
        Keyed_zhcn.trans("QualityCategoryShort_Good"),
        Keyed_zhcn.trans("QualityCategoryShort_Superior"),
        Keyed_zhcn.trans("QualityCategoryShort_Excellent"),
        Keyed_zhcn.trans("QualityCategoryShort_Masterwork"),
        Keyed_zhcn.trans("QualityCategoryShort_Legendary")
    }
    option.yAxis[1].name = StatsReport_QualityMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
        step = "middle",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = {
            self.factorAwful * 100,
            self.factorShoddy * 100,
            self.factorPoor * 100,
            self.factorNormal * 100,
            self.factorGood * 100,
            self.factorSuperior * 100,
            self.factorExcellent * 100,
            self.factorMasterwork * 100,
            self.factorLegendary * 100
        }
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_QualityMultiplier .. "（片段）",
        above = "是否应用于负数：" .. (self.alsoAppliesToNegativeValues and "是" or "否"),
        option = option
    })
end

-- abstract StatPart_Curve

function StatPart_Curve:new(points)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    part.curve = SimpleCurve:new(points)
    return part
end

function StatPart_Curve:appliesTo(req)
    return false
end

function StatPart_Curve:curveXGetter(req)
    return 1
end

function StatPart_Curve:transformValue(req, val)
    if req:hasThing() and self:appliesTo(req) then
        return val * self.curve:evaluate(self:curveXGetter(req))
    end
    return val
end

-- StatPart_Health

function StatPart_Health:new(statData, index)
    local points = SMW.show(statData, "StatDef.parts." .. index .. ".curve.points")
    if points == nil then
        return nil
    end
    setmetatable(self, StatPart_Curve)
    local part = StatPart_Curve:new(points)
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Health"
    part.index = index
    return part
end

function StatPart_Health:appliesTo(req)
    return req:hasThing() and req:get_Thing().def.useHitPoints
end

function StatPart_Health:curveXGetter(req)
    return req:get_Thing():get_HitPoints() / req:get_Thing():get_MaxHitPoints()
end

function StatPart_Health:explainEcharts()
    local StatsReport_HealthMultiplier = Keyed_zhcn.trans("StatsReport_HealthMultiplier")
    StatsReport_HealthMultiplier = string.gsub(StatsReport_HealthMultiplier, "（{0}）", "")
    local HitPointsBasic = Keyed_zhcn.trans("HitPointsBasic")
    local option = Collapse.newOption("value")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_HealthMultiplier
    option.title.subtext = HitPointsBasic .. "的曲线处理坐标点：" .. self.curve:toString()
    option.tooltip.formatter = StatsReport_HealthMultiplier .. "<br/>" .. HitPointsBasic .. "（{b}%）：× {c}%"
    option.xAxis[1].name = HitPointsBasic
    option.xAxis[1].axisLabel.formatter = "{value}%"
    option.yAxis[1].name = StatsReport_HealthMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    local curve = self.curve
    for hp = 0, 100, 1 do
        xAxis1_data[i] = tostring(hp)
        series1_data[i] = Mathf.round(curve:evaluate(hp / 100) * 100, 2)
        i = i + 1
    end
    option.xAxis[1].data = xAxis1_data
    option.series[1] = {
        name = StatsReport_HealthMultiplier,
        type = "line",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = series1_data
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_HealthMultiplier .. "（片段）",
        option = option
    })
end

-- StatPart_Mood

function StatPart_Mood:new(statData, index)
    local points = SMW.show(statData, "StatDef.parts." .. index .. ".curve.points")
    if points == nil then
        return nil
    end
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Mood"
    part.index = index
    part.curve = SimpleCurve:new(points)
    return part
end

-- function StatPart_Mood:transformValue(req, val)
--     if req:hasThing() then
--         local pawn = req:get_Thing()
--         if pawn ~= nil and pawn.needs.mood ~= nil then
--             return val * self:moodMultiplier(pawn.needs.mood:get_CurLevel())
--         end
--     end
--     return val
-- end

-- function StatPart_Mood:moodMultiplier(mood)
--     return self.curve:evaluate(mood)
-- end

function StatPart_Mood:explainEcharts()
    local StatsReport_MoodMultiplier = Keyed_zhcn.trans("StatsReport_MoodMultiplier")
    StatsReport_MoodMultiplier = string.gsub(StatsReport_MoodMultiplier, "（{0}）", "")
    local moodLevel = "心情值"
    local option = Collapse.newOption("value")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_MoodMultiplier
    option.title.subtext = moodLevel .. "的曲线处理坐标点：" .. self.curve:toString()
    option.tooltip.formatter = StatsReport_MoodMultiplier .. "<br/>" .. moodLevel .. "（{b}%）：× {c}%"
    option.xAxis[1].name = moodLevel
    option.xAxis[1].axisLabel.formatter = "{value}%"
    option.yAxis[1].name = StatsReport_MoodMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    local curve = self.curve
    for ml = 0, 100, 1 do
        xAxis1_data[i] = tostring(ml)
        series1_data[i] = Mathf.round(curve:evaluate(ml / 100) * 100, 2)
        i = i + 1
    end
    option.xAxis[1].data = xAxis1_data
    option.series[1] = {
        name = StatsReport_MoodMultiplier,
        type = "line",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = series1_data
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_MoodMultiplier .. "（片段）",
        option = option
    })
end

-- StatPart_BodySize

function StatPart_BodySize:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_BodySize"
    part.index = index
    return part
end

-- function StatPart_BodySize:transformValue(req, val)
--     local num = {}
--     if self:tryGetBodySize(req, num) then
--         return val * num.out
--     end
--     return val
-- end

-- function StatPart_BodySize:tryGetBodySize(req, bodySize)
--     return PawnOrCorpseStatUtility.tryGetPawnOrCorpseStat(
--         req,
--         function(x)
--             return x:get_BodySize()
--         end,
--         function(x)
--             return x.race.baseBodySize
--         end,
--         bodySize
--     )
-- end

function StatPart_BodySize:explainEcharts()
    local StatsReport_BodySize = Keyed_zhcn.trans("StatsReport_BodySize")
    StatsReport_BodySize = string.gsub(StatsReport_BodySize, "（{0}）", "")
    local bodySize = "体型值"
    local option = Collapse.newOption("value")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_BodySize
    option.tooltip.formatter = StatsReport_BodySize .. "<br/>" .. bodySize .. "（{b}）：× {c}%"
    option.xAxis[1].name = bodySize
    option.yAxis[1].name = StatsReport_BodySize
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    for bs = 0, 40, 1 do
        xAxis1_data[i] = string.format("%.1f", bs / 10) 
        series1_data[i] = bs * 10
        i = i + 1
    end
    option.xAxis[1].data = xAxis1_data
    option.series[1] = {
        name = StatsReport_BodySize,
        type = "line",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = series1_data
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_BodySize .. "（片段）",
        option = option
    })
end

-- StatPart_BodySize

function StatPart_NaturalNotMissingBodyPartsCoverage:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_NaturalNotMissingBodyPartsCoverage"
    part.index = index
    return part
end

function StatPart_NaturalNotMissingBodyPartsCoverage:explainEcharts()
    local StatsReport_MissingBodyParts = Keyed_zhcn.trans("StatsReport_MissingBodyParts")
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_MissingBodyParts .. "（片段）",
        headers = {{
            text = StatsReport_MissingBodyParts .. "取决于自然身体部件的缺失程度。"
        }}
    })
end

-- StatPart_Food

function StatPart_Food:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Food"
    part.index = index
    local prop = "StatDef.parts." .. index .. "."
    part.factorStarving = tonumber(SMW.show(statData, prop .. "factorStarving")) or 1
    part.factorUrgentlyHungry = tonumber(SMW.show(statData, prop .. "factorUrgentlyHungry")) or 1
    part.factorHungry = tonumber(SMW.show(statData, prop .. "factorHungry")) or 1
    part.factorFed = tonumber(SMW.show(statData, prop .. "factorFed")) or 1
    return part
end

-- function StatPart_Food:transformValue(req, val)
--     if req:hasThing() then
--         local pawn = req:get_Thing()
--         if pawn ~= nil and pawn.needs.food ~= nil then
--             return val * self:foodMultiplier(pawn.needs.food:get_CurCategory())
--         end
--     end
--     return val
-- end

-- function StatPart_Food:foodMultiplier(hunger)
--     if hunger == "Fed" then
--         return self.factorFed
--     elseif hunger == "Hungry" then
--         return self.factorHungry
--     elseif hunger == "UrgentlyHungry" then
--         return self.factorUrgentlyHungry
--     elseif hunger == "Starving" then
--         return self.factorStarving
--     else
--         return 1
--     end
-- end

function StatPart_Food:explainEcharts()
    local HungerRate = Keyed_zhcn.trans("HungerRate")
    local StatsReport_HungerRateMultiplier = HungerRate .. "乘数"
    local option = Collapse.newOption("span")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_HungerRateMultiplier
    option.tooltip.formatter = StatsReport_HungerRateMultiplier .. "<br/>" .. HungerRate .. "（{b}）：× {c}%"
    option.xAxis[1].name = HungerRate
    option.xAxis[1].data = {
        Keyed_zhcn.trans("HungerLevel_Starving"),
        Keyed_zhcn.trans("HungerLevel_UrgentlyHungry"),
        Keyed_zhcn.trans("HungerLevel_Hungry"),
        Keyed_zhcn.trans("HungerLevel_Fed")
    }
    option.yAxis[1].name = StatsReport_HungerRateMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
        step = "middle",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = {
            self.factorStarving * 100,
            self.factorUrgentlyHungry * 100,
            self.factorHungry * 100,
            self.factorFed * 100
        }
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_HungerRateMultiplier .. "（片段）",
        option = option
    })
end

-- StatPart_Rest

function StatPart_Rest:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Rest"
    part.index = index
    local prop = "StatDef.parts." .. index .. "."
    part.factorExhausted = tonumber(SMW.show(statData, prop .. "factorExhausted")) or 1
    part.factorVeryTired = tonumber(SMW.show(statData, prop .. "factorVeryTired")) or 1
    part.factorTired = tonumber(SMW.show(statData, prop .. "factorTired")) or 1
    part.factorRested = tonumber(SMW.show(statData, prop .. "factorRested")) or 1
    return part
end

-- function StatPart_Rest:transformValue(req, val)
--     if req:hasThing() then
--         local pawn = req:get_Thing()
--         if pawn ~= nil and pawn.needs.rest ~= nil then
--             return val * self:restMultiplier(pawn.needs.rest:get_CurCategory())
--         end
--     end
--     return val
-- end

-- function StatPart_Rest:restMultiplier(hunger)
--     if hunger == "Rested" then
--         return self.factorRested
--     elseif hunger == "Tired" then
--         return self.factorTired
--     elseif hunger == "VeryTired" then
--         return self.factorVeryTired
--     elseif hunger == "Exhausted" then
--         return self.factorExhausted
--     else
--         return 1
--     end
-- end

function StatPart_Rest:explainEcharts()
    local Tiredness = Keyed_zhcn.trans("Tiredness")
    local StatsReport_TirednessMultiplier = Tiredness .. "乘数"
    local option = Collapse.newOption("span")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_TirednessMultiplier
    option.tooltip.formatter = StatsReport_TirednessMultiplier .. "<br/>" .. Tiredness .. "（{b}）：× {c}%"
    option.xAxis[1].name = Tiredness
    option.xAxis[1].data = {
        Keyed_zhcn.trans("HungerLevel_Exhausted"),
        Keyed_zhcn.trans("HungerLevel_VeryTired"),
        Keyed_zhcn.trans("HungerLevel_Tired"),
        Keyed_zhcn.trans("HungerLevel_Rested")
    }
    option.yAxis[1].name = StatsReport_TirednessMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
        step = "middle",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = {
            self.factorExhausted * 100,
            self.factorVeryTired * 100,
            self.factorTired * 100,
            self.factorRested * 100
        }
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_TirednessMultiplier .. "（片段）",
        option = option
    })
end

-- StatPart_BedStat

function StatPart_BedStat:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_BedStat"
    part.index = index
    part.stat = SMW.show(statData, "StatDef.parts." .. index .. ".stat")
    return part
end

function StatPart_BedStat:explainEcharts()
    local StatsReport_BedStatMultiplier = "床铺属性乘数"
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_BedStatMultiplier .. "（片段）",
        headers = {{
            text = "床铺属性：" .. "[[Stats_" .. self.stat .. "|" .. SMW.show("Core:Defs_StatDef_" .. self.stat, "StatDef.label.zh-cn") .. "]]"
        }}
    })
end

-- StatPart_Age

function StatPart_Age:new(statData, index)
    local points = SMW.show(statData, "StatDef.parts." .. index .. ".curve.points")
    if points == nil then
        return nil
    end
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Age"
    part.index = index
    part.curve = SimpleCurve:new(points)
    return part
end

function StatPart_Age:explainEcharts()
    local StatsReport_AgeMultiplier = Keyed_zhcn.trans("StatsReport_AgeMultiplier")
    StatsReport_AgeMultiplier = string.gsub(StatsReport_AgeMultiplier, "（{0}）", "")
    local ageLifeRate = "龄寿比"
    local option = Collapse.newOption("value")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_AgeMultiplier
    option.title.subtext = ageLifeRate .. "（当前年龄/预期寿命）的曲线处理坐标点：" .. self.curve:toString()
    option.tooltip.formatter = StatsReport_AgeMultiplier .. "<br/>" .. ageLifeRate .. "（{b}%）：× {c}%"
    option.xAxis[1].name = ageLifeRate
    option.xAxis[1].axisLabel.formatter = "{value}%"
    option.yAxis[1].name = StatsReport_AgeMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    local curve = self.curve
    for alr = 0, 100, 5 do
        xAxis1_data[i] = tostring(alr)
        series1_data[i] = Mathf.round(curve:evaluate(alr / 100) * 100,2)
        i = i + 1
    end
    option.xAxis[1].data = xAxis1_data
    option.series[1] = {
        name = StatsReport_AgeMultiplier,
        type = "line",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = series1_data
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_AgeMultiplier .. "（片段）",
        option = option
    })
end

-- StatPart_ApparelStatOffset

function StatPart_ApparelStatOffset:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_ApparelStatOffset"
    part.index = index
    part.apparelStat = SMW.show(statData, "StatDef.parts." .. index .. ".apparelStat")
    return part
end

function StatPart_ApparelStatOffset:explainEcharts()
    local StatsReport_ApparelStatOffset = "衣物属性偏移量"
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_ApparelStatOffset .. "（片段）",
        headers = {{
            text = "衣物属性：" .. "[[Stats_" .. self.apparelStat .. "|" .. SMW.show("Core:Defs_StatDef_" .. self.apparelStat, "StatDef.label.zh-cn") .. "]]",
            width = "50%"
        }}
    })
end

-- StatPart_WorkTableUnpowered

function StatPart_WorkTableUnpowered:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_WorkTableUnpowered"
    part.index = index
    return part
end

function StatPart_WorkTableUnpowered:explainEcharts()
    local StatsReport_WorkTableUnpowered = Keyed_zhcn.trans("NoPower") .. "乘数"
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_WorkTableUnpowered .. "（片段）",
        headers = {{
            text = StatsReport_WorkTableUnpowered .. " = 工作台未通电工作速度系数"
        }}
    })
end

-- StatPart_WorkTableTemperature

function StatPart_WorkTableTemperature:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_WorkTableTemperature"
    part.index = index
    part.WorkRateFactor = 0.6
    part.MinTemp = 5
    part.MaxTemp = 35
    return part
end

function StatPart_WorkTableTemperature:explainEcharts()
    local StatsReport_WorkTableTemperature = Keyed_zhcn.trans("BadTemperature") .. "乘数"
    local temperature = "温度"
    local degreesCelsius = "℃"
    local option = Collapse.newOption("span")
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_WorkTableTemperature
    option.tooltip.formatter = StatsReport_WorkTableTemperature .. "<br/>" .. temperature .. "（{b}）：× {c}%"
    option.xAxis[1].name = temperature
    option.xAxis[1].data = {
        "t ＜ " .. self.MinTemp .. degreesCelsius,
        self.MinTemp .. degreesCelsius .. " ≤ t ≤ " .. self.MaxTemp .. degreesCelsius,
        self.MaxTemp .. degreesCelsius .. " ＜ t"
    }
    option.yAxis[1].name = StatsReport_WorkTableTemperature
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
        step = "middle",
        label = {
            normal = {
                show = true,
                formatter = "{c}%"
            }
        },
        data = {
            self.WorkRateFactor * 100,
            100,
            self.WorkRateFactor * 100
        }
    }
    return Collapse.echarts({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        title = StatsReport_WorkTableTemperature .. "（片段）",
        option = option
    })
end

-- StatPart_Outdoors

function StatPart_Outdoors:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Outdoors"
    part.index = index
    local prop = "StatDef.parts." .. index .. "."
    part.factorIndoors = tonumber(SMW.show(statData, prop .. "factorIndoors")) or 1
    part.factorOutdoors = tonumber(SMW.show(statData, prop .. "factorOutdoors")) or 1
    return part
end

function StatPart_Outdoors:explainEcharts()
    local Outdoors = Keyed_zhcn.trans("Outdoors")
    local Indoors = Keyed_zhcn.trans("Indoors")
    local StatsReport_Outdoors = Outdoors .. "/" .. Indoors .. "乘数"
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_Outdoors .. "（片段）",
        headers = {{
            text = Outdoors .. "：×" .. (self.factorOutdoors * 100) .. "%",
            width = "50%"
        },{
            text = Indoors .. "：×" .. (self.factorIndoors * 100) .. "%",
            width = "50%"
        }}
    })
end

-- StatPart_Outdoors

function StatPart_RoomStat:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_RoomStat"
    part.index = index
    local prop = "StatDef.parts." .. index .. "."
    part.roomStat = SMW.show(statData, prop .. "roomStat")
    part.customLabel = SMW.show(statData, prop .. "customLabel")
    part.customLabel_zhcn = SMW.show(statData, prop .. "customLabel.zh-cn")
    part.customLabel_zhtw = SMW.show(statData, prop .. "customLabel.zh-tw")
    return part
end

function StatPart_RoomStat:explainEcharts()
    local StatsReport_RoomStat = "房间属性乘数"
    if self.roomStat == "ResearchSpeedFactor" then
        local cleanliness = self.customLabel_zhcn
        local roomStatLabel = SMW.show("Core:Defs_RoomStatDef_" .. self.roomStat, "RoomStatDef.label.zh-cn")
        local option = Collapse.newOption("value")
        local curve = SimpleCurve:new('"(-5,0.75)","(-2.5,0.85)","(0,1)","(1,1.15)"')
        option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_RoomStat
        option.title.subtext = "将" .. cleanliness .. "处理为" .. roomStatLabel .. "的曲线处理坐标点：" .. curve:toString()
        option.tooltip.formatter = StatsReport_RoomStat .. "<br/>" .. cleanliness .. "（{b}）：× {c}%"
        option.xAxis[1].name = cleanliness
        option.yAxis[1].name = roomStatLabel
        option.yAxis[1].axisLabel.formatter = "{value}%"
        local xAxis1_data = {}
        local series1_data = {}
        for cl = -60, 20 do
            xAxis1_data[#xAxis1_data + 1] = tostring(cl / 10)
            series1_data[#series1_data + 1] = Mathf.round(curve:evaluate(cl / 10) * 100, 2)
        end
        option.xAxis[1].data = xAxis1_data
        option.series[1] = {
            name = roomStatLabel,
            type = "line",
            label = {
                normal = {
                    show = true,
                    formatter = "{c}%"
                }
            },
            data = series1_data
        }
        return Collapse.echarts({
            id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
            title = StatsReport_RoomStat .. "（片段）",
            above = "房间属性：[[RoomStats_" .. self.roomStat .. "|" .. SMW.show("Core:Defs_RoomStatDef_" .. self.roomStat, "RoomStatDef.label.zh-cn") .. "]]<br/>"
                .. "自定义显示名称（英文）：" .. self.customLabel .. "<br/>"
                .. "自定义显示名称（简中）：" .. self.customLabel_zhcn .. "<br/>"
                .. "自定义显示名称（繁中）：" .. self.customLabel_zhtw .. "<br/>"
                .. "（游戏中会显示为“" .. cleanliness .. "”，但实际是经过计算后得到隐藏的房间属性“" .. roomStatLabel .. "”，再将此隐藏属性作为乘数。）",
            aboveExtraCssText = "text-align:left;",
            option = option
        })
    else
        return Collapse.ctable({
            id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
            style = "max-width:809px;",
            title = StatsReport_RoomStat .. "（片段）",
            headers = {{
                text = "房间属性",
                width = "50%"
            },{
                text = "[[RoomStats_" .. self.roomStat .. "|" .. SMW.show("Core:Defs_RoomStatDef_" .. self.roomStat, "RoomStatDef.label.zh-cn") .. "]]",
                width = "50%"
            }},
            rows = {{
                cols = "自定义显示名称（英文）", self.customLabel
            },{
                cols = "自定义显示名称（简中）", self.customLabel_zhcn
            },{
                cols = "自定义显示名称（繁中）", self.customLabel_zhtw
            }}
        })
    end
end

-- StatPart_WornByCorpse

function StatPart_WornByCorpse:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Outdoors"
    part.index = index
    return part
end

function StatPart_WornByCorpse:explainEcharts()
    local StatsReport_WornByCorpse = Keyed_zhcn.trans("StatsReport_WornByCorpse")
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_WornByCorpse .. "（片段）",
        headers = {{
            text = StatsReport_WornByCorpse .. "：×" .. (0.1 * 100) .. "%"
        }}
    })
end

-- StatPart_GearAndInventoryMass

function StatPart_GearAndInventoryMass:new(statData, index)
    setmetatable(self, StatPart)
    local part = StatPart:new()
    setmetatable(part, self)
    self.__index = self
    -- fields
    part.class = "StatPart_Outdoors"
    part.index = index
    return part
end

function StatPart_GearAndInventoryMass:explainEcharts()
    local StatsReport_GearAndInventoryMass = Keyed_zhcn.trans("StatsReport_GearAndInventoryMass")
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = StatsReport_GearAndInventoryMass .. "（片段）",
        headers = {{
            text = StatsReport_GearAndInventoryMass .. " = 所有装备与货物质量的总和；此项作为加数。"
        }}
    })
end


-- Instance

function StatPart.instance(statData, index)
    local className = SMW.show(statData, "StatDef.parts." .. index .. ".Class")
    if className == nil then
        return nil
    elseif className == "StatPart_Quality" then
        return StatPart_Quality:new(statData, index)
    elseif className == "StatPart_Health" then
        return StatPart_Health:new(statData, index)
    elseif className == "StatPart_Mood" then
        return StatPart_Mood:new(statData, index)
    elseif className == "StatPart_BodySize" then
        return StatPart_BodySize:new(statData, index)
    elseif className == "StatPart_NaturalNotMissingBodyPartsCoverage" then
        return StatPart_NaturalNotMissingBodyPartsCoverage:new(statData, index)
    elseif className == "StatPart_Food" then
        return StatPart_Food:new(statData, index)
    elseif className == "StatPart_Rest" then
        return StatPart_Rest:new(statData, index)
    elseif className == "StatPart_BedStat" then
        return StatPart_BedStat:new(statData, index)
    elseif className == "StatPart_Age" then
        return StatPart_Age:new(statData, index)
    elseif className == "StatPart_ApparelStatOffset" then
        return StatPart_ApparelStatOffset:new(statData, index)
    elseif className == "StatPart_WorkTableUnpowered" then
        return StatPart_WorkTableUnpowered:new(statData, index)
    elseif className == "StatPart_WorkTableTemperature" then
        return StatPart_WorkTableTemperature:new(statData, index)
    elseif className == "StatPart_Outdoors" then
        return StatPart_Outdoors:new(statData, index)
    elseif className == "StatPart_RoomStat" then
        return StatPart_RoomStat:new(statData, index)
    elseif className == "StatPart_WornByCorpse" then
        return StatPart_WornByCorpse:new(statData, index)
    elseif className == "StatPart_GearAndInventoryMass" then
        return StatPart_GearAndInventoryMass:new(statData, index)
    end
    
end

return StatPart