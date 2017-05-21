local RoomStatDef = {}
local base = require("Module:RW_Def")
setmetatable(RoomStatDef, base)
RoomStatDef.__index = RoomStatDef

-- require

local ColorUtility = require("Module:ColorUtility")
local SMW = base.SMW
local Collapse = base.Collapse
local Note = require("Module:RT_Note")
local SimpleCurve = require("Module:AC_SimpleCurve")
local Mathf = require("Module:UE_Mathf")

-- Worker

local RoomStatWorker = {
    RoomStatWorker_Beauty = {
        showECharts = function(defName, label)
            return ""
        end
    },
    RoomStatWorker_Cleanliness = {
        showECharts = function(defName, label)
            return ""
        end
    },
    RoomStatWorker_FoodPoisonChanceFactor = {
        showECharts = function(defName, label)
            local CleanlinessLabel = SMW.show("Core:Defs_RoomStatDef_Cleanliness", "RoomStatDef.label.zh-cn")
            local RoomStats_Cleanliness = "[[RoomStats_Cleanliness|" .. CleanlinessLabel .. "]]"

            local getScore = function(cleanlinessValue)
                local value = 1 / Mathf.unboundedValueToFactor(cleanlinessValue * 0.21)
                return Mathf.clamp(value, 0.7, 1.6)
            end
            
            local index = 1
            local xAxis1_data = {}
            local series1_data = {}
            for x = -40, 30 do
                xAxis1_data[index] = x / 10
                series1_data[index] = Mathf.round(getScore(x / 10)*100, 2)
                index = index + 1
            end

            local option = Collapse.newOption("value")
            option.grid = nil
            option.tooltip.formatter = CleanlinessLabel .. "：{b}<br/>" .. label .. "：{c}%"
            local xAxis1 = option.xAxis[1]
            xAxis1.name = CleanlinessLabel
            xAxis1.data = xAxis1_data
            local yAxis1 = option.yAxis[1]
            yAxis1.name = label
            yAxis1.axisLabel.formatter = "{value}%"
            option.series[1] = {
                name = label,
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
                id = defName .. "-formula",
                title = "房间属性 " .. label .. " 的计算公式",
                above = "根据房间属性" .. RoomStats_Cleanliness .. "计算",
                option = option
            })
        end
    },
    RoomStatWorker_GraveVisitingJoyGainFactor = {
        showECharts = function(defName, label)
            local ImpressivenessLabel = SMW.show("Core:Defs_RoomStatDef_Impressiveness", "RoomStatDef.label.zh-cn")
            local RoomStats_Impressiveness = "[[RoomStats_Impressiveness|" .. ImpressivenessLabel .. "]]"

            local getScore = function(impressivenessValue)
                return Mathf.lerp(0.8, 1.2, Mathf.inverseLerp(-150, 150, impressivenessValue))
            end
            
            local index = 1
            local xAxis1_data = {}
            local series1_data = {}
            for x = 0, 200 do
                xAxis1_data[index] = x
                series1_data[index] = Mathf.round(getScore(x)*100, 2)
                index = index + 1
            end

            local option = Collapse.newOption("value")
            option.grid = nil
            option.tooltip.formatter = ImpressivenessLabel .. "：{b}<br/>" .. label .. "：{c}%"
            local xAxis1 = option.xAxis[1]
            xAxis1.name = ImpressivenessLabel
            xAxis1.data = xAxis1_data
            local yAxis1 = option.yAxis[1]
            yAxis1.name = label
            yAxis1.axisLabel.formatter = "{value}%"
            option.series[1] = {
                name = label,
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
                id = defName .. "-formula",
                title = "房间属性 " .. label .. " 的计算公式",
                above = "根据房间属性" .. RoomStats_Impressiveness .. "计算",
                option = option
            })
        end
    },
    RoomStatWorker_Space = {
        showECharts = function(defName, label)
            return ""
        end
    },
    RoomStatWorker_SurgerySuccessChanceFactor = {
        showECharts = function(defName, label)
            local CleanlinessLabel = SMW.show("Core:Defs_RoomStatDef_Cleanliness", "RoomStatDef.label.zh-cn")
            local RoomStats_Cleanliness = "[[RoomStats_Cleanliness|" .. CleanlinessLabel .. "]]"

            local getScore = function(cleanlinessValue)
                return Mathf.clamp(Mathf.lerpDouble(-5, 5, 0.6, 1.5, cleanlinessValue), 0.6, 1.5)
            end
            
            local index = 1
            local xAxis1_data = {}
            local series1_data = {}
            for x = -60, 60 do
                xAxis1_data[index] = x / 10
                series1_data[index] = Mathf.round(getScore(x / 10)*100, 2)
                index = index + 1
            end

            local option = Collapse.newOption("value")
            option.grid = nil
            option.tooltip.formatter = CleanlinessLabel .. "：{b}<br/>" .. label .. "：{c}%"
            local xAxis1 = option.xAxis[1]
            xAxis1.name = CleanlinessLabel
            xAxis1.data = xAxis1_data
            local yAxis1 = option.yAxis[1]
            yAxis1.name = label
            yAxis1.axisLabel.formatter = "{value}%"
            option.series[1] = {
                name = label,
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
                id = defName .. "-formula",
                title = "房间属性 " .. label .. " 的计算公式",
                above = "根据房间属性" .. RoomStats_Cleanliness .. "计算",
                option = option
            })
        end
    },
    RoomStatWorker_Wealth = {
        showECharts = function(defName, label)
            return ""
        end
    },
    RoomStatWorker_ResearchSpeedFactor = {
        showECharts = function(defName, label)
            local CleanlinessLabel = SMW.show("Core:Defs_RoomStatDef_Cleanliness", "RoomStatDef.label.zh-cn")
            local RoomStats_Cleanliness = "[[RoomStats_Cleanliness|" .. CleanlinessLabel .. "]]"

            local CleanlinessFactorCurve = SimpleCurve:new({
                {-5, 0.75},
                {-2.5, 0.85},
                {0, 1},
                {1, 1.15}
            })
            local getScore = function(cleanlinessValue)
                return CleanlinessFactorCurve:evaluate(cleanlinessValue)
            end
            
            local index = 1
            local xAxis1_data = {}
            local series1_data = {}
            for x = -60, 20 do
                xAxis1_data[index] = x / 10
                series1_data[index] = Mathf.round(getScore(x / 10)*100, 2)
                index = index + 1
            end

            local option = Collapse.newOption("value")
            option.grid = nil
            option.tooltip.formatter = CleanlinessLabel .. "：{b}<br/>" .. label .. "：{c}%"
            local xAxis1 = option.xAxis[1]
            xAxis1.name = CleanlinessLabel
            xAxis1.data = xAxis1_data
            local yAxis1 = option.yAxis[1]
            yAxis1.name = label
            yAxis1.axisLabel.formatter = "{value}%"
            option.series[1] = {
                name = label,
                type = "line",
                label = {
                    normal = {
                        show = true,
                        formatter = "{c}%"
                    }
                },
                markPoint = {
                    symbolSize = 60,
                    label = {
                        normal = {
                            formatter = "{c}%"
                        }
                    },
                    data = {
                        {value = 75, xAxis = 10, yAxis = 75},
                        {value = 85, xAxis = 35, yAxis = 85},
                        {value = 100, xAxis = 60, yAxis = 100},
                        {value = 115, xAxis = 70, yAxis = 115}
                    }
                },
                data = series1_data
            }

            return Collapse.echarts({
                id = defName .. "-formula",
                title = "房间属性 " .. label .. " 的计算公式",
                above = "根据房间属性" .. RoomStats_Cleanliness .. "计算",
                option = option
            })
        end
    },
    RoomStatWorker_InfectionChanceFactor = {
        showECharts = function(defName, label)
            local CleanlinessLabel = SMW.show("Core:Defs_RoomStatDef_Cleanliness", "RoomStatDef.label.zh-cn")
            local RoomStats_Cleanliness = "[[RoomStats_Cleanliness|" .. CleanlinessLabel .. "]]"

            local getScore = function(cleanlinessValue)
                local value
                if cleanlinessValue >= 0 then
                    value = Mathf.lerpDouble(0, 1, 0.5, 0.2, cleanlinessValue)
                else
                    value = Mathf.lerpDouble(-5, 0, 1, 0.5, cleanlinessValue)
                end
                return Mathf.clamp(value, 0.2, 1)
            end
            
            local index = 1
            local xAxis1_data = {}
            local series1_data = {}
            for x = -60, 20 do
                xAxis1_data[index] = x / 10
                series1_data[index] = Mathf.round(getScore(x / 10)*100, 2)
                index = index + 1
            end

            local option = Collapse.newOption("value")
            option.grid = nil
            option.tooltip.formatter = CleanlinessLabel .. "：{b}<br/>" .. label .. "：{c}%"
            local xAxis1 = option.xAxis[1]
            xAxis1.name = CleanlinessLabel
            xAxis1.data = xAxis1_data
            local yAxis1 = option.yAxis[1]
            yAxis1.name = label
            yAxis1.axisLabel.formatter = "{value}%"
            option.series[1] = {
                name = label,
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
                id = defName .. "-formula",
                title = "房间属性 " .. label .. " 的计算公式",
                above = "根据房间属性" .. RoomStats_Cleanliness .. "计算",
                option = option
            })
        end
    },
    RoomStatWorker_Impressiveness = {
        showECharts = function(defName, label)
            return ""
        end
    }
}

-- RoomStatDef

function RoomStatDef:new(data)
    local def = base.ctor("RoomStatDef", data, {
        texts = {
            "workerClass"
        },
        numbers = {
            "updatePriority",
            "defaultScore",
            {"scoreStages", "scoreStages.Count"}
        },
        booleans = {
            "displayRounded", "isHidden"
        }
    })
    setmetatable(def, self)
    def:postLoad(data)
    return def
end

function RoomStatDef:postLoad(data)
    if self.scoreStages > 0 then
        local scoreStages = {}
        local countScoreStages = self.scoreStages
        self.scoreStages = nil
        local indexParameters = 1
        local parameters = {"[[" .. data .. "]]"}
        local minSoreDefault = tonumber("-3.40282347E+38")
        for i = 0, countScoreStages - 1 do
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. "RoomStatDef.scoreStages." .. i .. ".minScore"
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. "RoomStatDef.scoreStages." .. i .. ".label"
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. "RoomStatDef.scoreStages." .. i .. ".label.zh-cn"
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. "RoomStatDef.scoreStages." .. i .. ".label.zh-tw"
        end
        parameters.mainlabel = "-"
        parameters.headers = "hide"
        local queryResult = mw.smw.ask(parameters)
        if type(queryResult) == "table" then
            queryResult = queryResult[1]
            for i = 0, countScoreStages - 1 do
                local stage = {}
                stage.minScore = tonumber(queryResult["RoomStatDef.scoreStages." .. i .. ".minScore"]) or minSoreDefault
                stage.label = queryResult["RoomStatDef.scoreStages." .. i .. ".label"]
                stage.label_zhcn = queryResult["RoomStatDef.scoreStages." .. i .. ".label.zh-cn"]
                stage.label_zhtw = queryResult["RoomStatDef.scoreStages." .. i .. ".label.zh-tw"]
                scoreStages[i + 1] = stage
            end
        end
        self.scoreStages = scoreStages
    else
        self.scoreStages = nil
    end
end

-- show

function RoomStatDef:showIsHidden()
    if self.isHidden then
        return Note.note("rimworld", "question", nil, "这是个<strong>隐藏的</strong>房间属性。")
    end
    return ""
end

function RoomStatDef:showStages()
    if self.scoreStages == nil then
        return ""
    end

    local scoreStages = self.scoreStages
    local countScoreStages = #scoreStages
    local colors = ColorUtility.colorSet(countScoreStages)
    local rows = {}
    for i, stage in pairs(scoreStages) do
        rows[i] = {
            cols = {
                {extraStyleText = "background-color: " .. colors[i] .. ";"},
                {
                    text = (i > 1 and (stage.minScore .. " ≤") or ""),
                    extraStyleText = "text-align: right; white-space: nowrap;"
                },
                {
                    text = "评分",
                    extraStyleText = "text-align: center; white-space: nowrap;"
                },
                {
                    text = (i < countScoreStages and ("&lt; " .. scoreStages[i + 1].minScore) or ""),
                    extraStyleText = "text-align: left; white-space: nowrap;"
                },
                stage.label_zhcn
            }
        }
    end

    return Collapse.ctable({
        id = self.defName .. "-scoreStages",
        title = "各评分段印象（" .. countScoreStages .. "个阶段）",
        headers = {
            {width = "1px"},
            {},
            {},
            {},
            {width = "100%"},
        },
        rows = rows
    })
end

function RoomStatDef:showECharts()
    return RoomStatWorker[self.workerClass].showECharts(self.defName, self.label_zhcn)
end

-- of

RoomStatDefOf = {}
function RoomStatDef.of(defName)
    local def = RoomStatDefOf[defName]
    if def == nil then
        def = RoomStatDef:new("Core:Defs_RoomStatDef_" .. defName)
        RoomStatDefOf[defName] = def
    end
    return def
end


return RoomStatDef