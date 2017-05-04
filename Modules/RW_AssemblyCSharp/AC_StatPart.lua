local StatPart = {}
local StatPart_Quality = {}
local StatPart_Curve = {}
local StatPart_Health = {}
local StatPart_Mood = {}
local StatPart_BodySize = {}
local StatPart_Food = {}
local StatPart_Rest = {}
local StatPart_BedStat = {}
local StatPart_Age = {}
local StatPart_ApparelStatOffset = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")
local Keyed = require("Module:Keyed")

local SimpleCurve = require("Module:AC_SimpleCurve")
local PawnOrCorpseStatUtility  = require("Module:AC_PawnOrCorpseStatUtility")

-- local StatRequest = require("Module:AC_StatRequest")

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

-- Base

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
    local StatsReport_QualityMultiplier = Keyed.zhcnS("StatsReport_QualityMultiplier")
    local Quality = Keyed.zhcnS("Quality")
    local option = Collapse.newOptionNormal()
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_QualityMultiplier
    option.tooltip.formatter = StatsReport_QualityMultiplier .. "<br/>" .. Quality .. "（{b}）：× {c}%"
    option.xAxis[1].name = Quality
    option.xAxis[1].data = {
        Keyed.zhcnS("QualityCategoryShort_Awful"),
        Keyed.zhcnS("QualityCategoryShort_Shoddy"),
        Keyed.zhcnS("QualityCategoryShort_Poor"),
        Keyed.zhcnS("QualityCategoryShort_Normal"),
        Keyed.zhcnS("QualityCategoryShort_Good"),
        Keyed.zhcnS("QualityCategoryShort_Superior"),
        Keyed.zhcnS("QualityCategoryShort_Excellent"),
        Keyed.zhcnS("QualityCategoryShort_Masterwork"),
        Keyed.zhcnS("QualityCategoryShort_Legendary")
    }
    option.yAxis[1].name = StatsReport_QualityMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
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
        title = StatsReport_QualityMultiplier,
        above = "是否应用于负数：" .. (self.alsoAppliesToNegativeValues and "是；" or "否；")
            .. "计算公式：[[Formulas_Stat#StatsReport_QualityMultiplier|" .. StatsReport_QualityMultiplier .. "]]",
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
        return  
    end
    return val * self.curve:evaluate(self:curveXGetter(req))
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
    local StatsReport_HealthMultiplier = Keyed.zhcnS("StatsReport_HealthMultiplier")
    StatsReport_HealthMultiplier = string.gsub(StatsReport_HealthMultiplier, "（{0}）", "")
    local HitPointsBasic = Keyed.zhcnS("HitPointsBasic")
    local option = Collapse.newOptionNormal()
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
    for hp = 0, 100, 5 do
        xAxis1_data[i] = hp
        series1_data[i] = curve:evaluate(hp / 100) * 100
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
        title = StatsReport_HealthMultiplier,
        above = "计算公式：[[Formulas_Stat#StatsReport_HealthMultiplier|" .. StatsReport_HealthMultiplier .. "]]",
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

function StatPart_Mood:transformValue(req, val)
    if req:hasThing() then
        local pawn = req:get_Thing()
        if pawn ~= nil and pawn.needs.mood ~= nil then
            return val * self:moodMultiplier(pawn.needs.mood:get_CurLevel())
        end
    end
    return val
end

function StatPart_Mood:moodMultiplier(mood)
    return self.curve:evaluate(mood)
end

function StatPart_Mood:explainEcharts()
    local StatsReport_MoodMultiplier = Keyed.zhcnS("StatsReport_MoodMultiplier")
    StatsReport_MoodMultiplier = string.gsub(StatsReport_MoodMultiplier, "（{0}）", "")
    local moodLevel = "心情值"
    local option = Collapse.newOptionNormal()
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
    for ml = 0, 100, 5 do
        xAxis1_data[i] = ml
        series1_data[i] = curve:evaluate(ml / 100) * 100
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
        title = StatsReport_MoodMultiplier,
        above = "计算公式：[[Formulas_Stat#StatsReport_MoodMultiplier|" .. StatsReport_MoodMultiplier .. "]]",
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

function StatPart_BodySize:transformValue(req, val)
    local num = {}
    if self:tryGetBodySize(req, num) then
        return val * num.out
    end
    return val
end

function StatPart_BodySize:tryGetBodySize(req, bodySize)
    return PawnOrCorpseStatUtility.tryGetPawnOrCorpseStat(
        req,
        function(x)
            return x:get_BodySize()
        end,
        function(x)
            return x.race.baseBodySize
        end,
        bodySize
    )
end

function StatPart_BodySize:explainEcharts()
    local StatsReport_BodySize = Keyed.zhcnS("StatsReport_BodySize")
    StatsReport_BodySize = string.gsub(StatsReport_BodySize, "（{0}）", "")
    local bodySize = "体型值"
    local option = Collapse.newOptionNormal()
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_BodySize
    option.tooltip.formatter = StatsReport_BodySize .. "<br/>" .. bodySize .. "（{b}）：× {c}%"
    option.xAxis[1].name = bodySize
    option.yAxis[1].name = StatsReport_BodySize
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    for bs = 0, 400, 10 do
        xAxis1_data[i] = string.format("%.2f", bs / 100) 
        series1_data[i] = bs
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
        title = StatsReport_BodySize,
        above = "计算公式：[[Formulas_Stat#StatsReport_BodySize|" .. StatsReport_BodySize .. "]]",
        option = option
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

function StatPart_Food:transformValue(req, val)
    if req:hasThing() then
        local pawn = req:get_Thing()
        if pawn ~= nil and pawn.needs.food ~= nil then
            return val * self:foodMultiplier(pawn.needs.food:get_CurCategory())
        end
    end
    return val
end

function StatPart_Food:foodMultiplier(hunger)
    if hunger == "Fed" then
        return self.factorFed
    elseif hunger == "Hungry" then
        return self.factorHungry
    elseif hunger == "UrgentlyHungry" then
        return self.factorUrgentlyHungry
    elseif hunger == "Starving" then
        return self.factorStarving
    else
        return 1
    end
end

function StatPart_Food:explainEcharts()
    local HungerRate = Keyed.zhcnS("HungerRate")
    local StatsReport_HungerRateMultiplier = HungerRate .. "乘数"
    local option = Collapse.newOptionNormal()
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_HungerRateMultiplier
    option.tooltip.formatter = StatsReport_HungerRateMultiplier .. "<br/>" .. HungerRate .. "（{b}）：× {c}%"
    option.xAxis[1].name = HungerRate
    option.xAxis[1].data = {
        Keyed.zhcnS("HungerLevel_Starving"),
        Keyed.zhcnS("HungerLevel_UrgentlyHungry"),
        Keyed.zhcnS("HungerLevel_Hungry"),
        Keyed.zhcnS("HungerLevel_Fed")
    }
    option.yAxis[1].name = StatsReport_HungerRateMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
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
        title = StatsReport_HungerRateMultiplier,
        above = "计算公式：[[Formulas_Stat#StatsReport_HungerRateMultiplier|" .. StatsReport_HungerRateMultiplier .. "]]",
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

function StatPart_Rest:transformValue(req, val)
    if req:hasThing() then
        local pawn = req:get_Thing()
        if pawn ~= nil and pawn.needs.rest ~= nil then
            return val * self:restMultiplier(pawn.needs.rest:get_CurCategory())
        end
    end
    return val
end

function StatPart_Rest:restMultiplier(hunger)
    if hunger == "Rested" then
        return self.factorRested
    elseif hunger == "Tired" then
        return self.factorTired
    elseif hunger == "VeryTired" then
        return self.factorVeryTired
    elseif hunger == "Exhausted" then
        return self.factorExhausted
    else
        return 1
    end
end

function StatPart_Rest:explainEcharts()
    local Tiredness = Keyed.zhcnS("Tiredness")
    local StatsReport_TirednessMultiplier = Tiredness .. "乘数"
    local option = Collapse.newOptionNormal()
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_TirednessMultiplier
    option.tooltip.formatter = StatsReport_TirednessMultiplier .. "<br/>" .. Tiredness .. "（{b}）：× {c}%"
    option.xAxis[1].name = Tiredness
    option.xAxis[1].data = {
        Keyed.zhcnS("HungerLevel_Exhausted"),
        Keyed.zhcnS("HungerLevel_VeryTired"),
        Keyed.zhcnS("HungerLevel_Tired"),
        Keyed.zhcnS("HungerLevel_Rested")
    }
    option.yAxis[1].name = StatsReport_TirednessMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    option.series[1] = {
        name = StatsReport_Skills,
        type = "line",
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
        title = StatsReport_TirednessMultiplier,
        above = "计算公式：[[Formulas_Stat#StatsReport_TirednessMultiplier|" .. StatsReport_TirednessMultiplier .. "]]",
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
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = "床铺属性乘数",
        headers = {{
            text = "床铺属性：" .. "[[Stats_" .. self.stat .. "|" .. SMW.show("Core:Defs_StatDef_" .. self.stat, "StatDef.label.zh-cn") .. "]]",
            width = "50%"
        },{
            text = "计算公式：[[Formulas_Stat#StatsReport_BedStatMultiplier|床铺属性乘数]]",
            width = "50%"
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
    local StatsReport_AgeMultiplier = Keyed.zhcnS("StatsReport_AgeMultiplier")
    StatsReport_AgeMultiplier = string.gsub(StatsReport_AgeMultiplier, "（{0}）", "")
    local ageLifeRate = "龄寿比"
    local option = Collapse.newOptionNormal()
    option.title.text = "属性 " .. self.parentStat.label_zhcn .. " 的" .. StatsReport_AgeMultiplier
    option.title.subtext = ageLifeRate .. "的曲线处理坐标点：" .. self.curve:toString()
    option.tooltip.formatter = StatsReport_AgeMultiplier .. "<br/>" .. ageLifeRate .. "（{b}%）：× {c}%"
    option.xAxis[1].name = ageLifeRate
    option.xAxis[1].axisLabel.formatter = "{value}%"
    option.yAxis[1].name = StatsReport_AgeMultiplier
    option.yAxis[1].axisLabel.formatter = "{value}%"
    local xAxis1_data = {}
    local series1_data = {}
    local i = 1
    local curve = self.curve
    for ml = 0, 100, 5 do
        xAxis1_data[i] = ml
        series1_data[i] = curve:evaluate(ml / 100) * 100
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
        title = StatsReport_AgeMultiplier,
        above = ageLifeRate .. " = 当前年龄 / 预期寿命；计算公式：[[Formulas_Stat#StatsReport_AgeMultiplier|" .. StatsReport_AgeMultiplier .. "]]",
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
    return Collapse.ctable({
        id = self.parentStat.defName .. "-parts-" .. self.index .. "-" .. self.class,
        style = "max-width:809px;",
        title = "衣物属性偏移量",
        headers = {{
            text = "衣物属性：" .. "[[Stats_" .. self.apparelStat .. "|" .. SMW.show("Core:Defs_StatDef_" .. self.apparelStat, "StatDef.label.zh-cn") .. "]]",
            width = "50%"
        },{
            text = "计算公式：[[Formulas_Stat#StatsReport_ApparelStatOffset|衣物属性偏移量]]",
            width = "50%"
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
    end
end

return StatPart