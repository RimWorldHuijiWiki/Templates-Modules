local StatView = {}
local StatDef = require("Module:RW_StatDef")

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")
local Keyed_zhcn = require("Module:Keyed_zhcn")

function StatView.view(frame)
    local def = StatDef:new(frame.args[1])
    local text = def:getInfoBase() .. "\n<hr/>\n"

    local StatsReport_BaseValue = Keyed_zhcn.trans("StatsReport_BaseValue")
    local StatsReport_Skills = Keyed_zhcn.trans("StatsReport_Skills")
    local StatsReport_OtherStats = Keyed_zhcn.trans("StatsReport_OtherStats")
    local StatsReport_HealthFactors = Keyed_zhcn.trans("StatsReport_HealthFactors")
    local StatsReport_PostProcessed = Keyed_zhcn.trans("StatsReport_PostProcessed")
    local StatsReport_FinalValue = Keyed_zhcn.trans("StatsReport_FinalValue")
    
    -- Base Args
    local rows = {}

    if def.category then
        rows[#rows + 1]  = {
            cols = {
                "属性分类",
                def.category,
                "[[StatCategories_" .. def.category .. "|" .. SMW.show("Core:Defs_StatCategoryDef_" .. def.category, "StatCategoryDef.label.zh-cn") .. "]]"
            }
        }
    else
        rows[#rows + 1]  = {cols = {"属性分类", "", ""}}
    end

    if def.hideAtValue then
        rows[#rows + 1]  = {
            cols = {
                "小于此值时隐藏",
                def.hideAtValue,
                ""
            }
        }
    else
        rows[#rows + 1]  = {cols = {"小于此值时隐藏", "", ""}}
    end
    
    rows[#rows + 1] = {
            cols = {"格式化显示字符串", (def.formatString or ""), (def.formatString_zhcn or "")}
    }

    if def.defaultBaseValue then
        rows[#rows + 1]  = {
            cols = {
                "默认基础值",
                def.defaultBaseValue,
                def:valueToString(def.defaultBaseValue)
            }
        }
    else
        rows[#rows + 1]  = {cols = {"默认基础值", "", ""}}
    end

    if def.minValue then
        rows[#rows + 1]  = {
            cols = {
                "最小值",
                def.minValue,
                def:valueToString(def.minValue)
            }
        }
    else
        rows[#rows + 1]  = {cols = {"最小值", "", ""}}
    end

    if def.maxValue then
        rows[#rows + 1]  = {
            cols = {
                "最大值",
                def.maxValue,
                def:valueToString(def.maxValue)
            }
        }
    else
        rows[#rows + 1]  = {cols = {"最大值", "", ""}}
    end
    
    rows[#rows + 1] = {
            cols = {"是否四舍五入成整数", tostring(def.roundValue), (def.roundValue and "是" or "否")}
    }

    if def.roundToFiveOver then
        rows[#rows + 1]  = {
            cols = {
                "大于此值时采取特殊估算",
                def.roundToFiveOver,
                ""
            }
        }
    else
        rows[#rows + 1]  = {cols = {"大于此值时采取特殊估算", "", ""}}
    end

    if def.statFactors then
        local links = ""
        for i, s in pairs(def.statFactors) do
            links = links .. "[[Stats_" .. s .. "|" .. SMW.show("Core:Defs_StatDef_" .. s, "StatDef.label.zh-cn") .. "]] "
        end
        rows[#rows + 1]  = {
            cols = {
                StatsReport_OtherStats, table.concat(def.statFactors, ", "), links
            }
        }
    else
        rows[#rows + 1]  = {cols = {StatsReport_OtherStats, "", ""}}
    end
    
    rows[#rows + 1] = {
            cols = {"负数时是否应用系数", tostring(def.applyFactorsIfNegative), (def.applyFactorsIfNegative and "是" or "否")}
    }
    rows[#rows + 1] = {
            cols = {"无技能系数", def.noSkillFactor, (def.noSkillFactor and (def.noSkillFactor * 100 .. "%") or "")}
    }

    local argBases = {
        id = "argsbases",
        style = "max-width:809px;",
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
        rows = rows
    }
    text = text .. Collapse.ctable(argBases)
    -- Base Args end 
    
    text = text .. "<hr/>\n"
    local isPercent = (def.toStringStyle == "PercentZero" or def.toStringStyle == "PercentOne" or def.toStringStyle == "PercentTwo")

    -- Skill Need Factors echarts
    if def.skillNeedFactors ~= nil then
        local option = Collapse.newOptionNormal()
        local skillNeed = def.skillNeedFactors[1]
        local skill = skillNeed.skill
        local skillLabel = SMW.show("Core:Defs_SkillDef_" .. skill, "SkillDef.label.zh-cn")
        local above
        option.title.text = "属性 " .. def.label_zhcn .. " 的" .. StatsReport_Skills .."（" .. skillLabel .. "）"
        if skillNeed.class == "SkillNeed_BaseBonus" then
            above = StatsReport_Skills
                .. "（基础加成形式）："
                .. "技能：[[Skills_" .. skill .. "|" .. skillLabel .. "]]，"
                .. "基础系数：" .. skillNeed.baseFactor * 100 .. "%，"
                .. "加成系数：" .. skillNeed.bonusFactor * 100 .. "%；"
            option.title.subtext = ""
                .. "基础系数：" .. skillNeed.baseFactor * 100 .. "%，"
                .. "加成系数：" .. skillNeed.bonusFactor * 100 .. "%；"
                .. StatsReport_Skills .. " = 基础系数 + 加成系数 × 技能等级"
        else
            above = StatsReport_Skills
                .. "（直接形式）："
                .. "技能：[[Skills_" .. skill .. "|" .. skillLabel .. "]]"
            option.title.subtext = "（直接设定每级技能的系数值）"
        end
        option.tooltip.formatter = StatsReport_Skills .. "<br/>" .. skillLabel .. "（{b}级）：× {c}%"
        option.xAxis[1].name = skillLabel
        option.xAxis[1].data = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20"}
        option.yAxis[1].name = StatsReport_Skills
        option.yAxis[1].axisLabel.formatter = "{value}%"
        local series1_data = {}
        for i = 1, 21 do
            series1_data[i] = skillNeed:factorFor(i - 1) * 100
        end
        option.series[1] = {
            name = StatsReport_Skills,
            type = "line",
            label = {
                normal = {
                    show = true,
                    formatter = "{c}%"
                }
            },
            data = series1_data
        }
        text = text .. Collapse.echarts({
            id = "StatDef-" .. def.defName .. "-skillNeedFactors",
            title = StatsReport_Skills,
            above = above,
            option = option
        })
    end
    -- Skill Need Factors end

    -- Capacity Factors
    if def.capacityFactors ~= nil then
        local healthFactors = {
            id = "StatDef-" .. def.defName .. "-capacityFactors",
            style = "max-width:809px;",
            title = StatsReport_HealthFactors,
            headers = {{
                text = "单位能力",
                width = "40%"
            },{
                text = "权重",
                width = "30%"
            },{
                text = "系数最大值",
                width = "30%"
            }}
        }
        local pcfs = def.capacityFactors
        local rows = {}
        local count = 0
        for i, factor in pairs(pcfs) do
            rows[i] = {
                cols = {
                    "[[PawnCapacities_" .. factor.capacity .. "|" .. SMW.show("Core:Defs_PawnCapacityDef_" .. factor.capacity, "PawnCapacityDef.label.zh-cn") .. "]]",
                    factor.weight * 100 .. "%",
                    (factor.max and (factor.max * 100 .. "%") or "")
                }
            }
            count = count + 1
        end
        rows[#rows + 1] = {
            cols = {{
                span = 3,
                text = StatsReport_HealthFactors .. " = 单位能力值<br/>"
                    .. StatsReport_HealthFactors .. " ≤ 系数最大值<br/>" 
                    .. "0 ≤ 权重 ≤ 1<br/>"
                    .. "处理后的属性值 = 处理前的属性值 + (处理前的属性值 × " .. StatsReport_HealthFactors .. " - 处理前的属性值) × 权重"
            }}
        }
        healthFactors.rows = rows
        text = text .. Collapse.ctable(healthFactors)
    end
    -- Capacity Factors end   

    -- Stat Parts
    if def.parts ~= nil then
        for i, part in pairs(def.parts) do
            if part ~= nil then
                text = text .. part:explainEcharts()
            end
        end
    end
    -- Stat Parts end

    -- Post Process Curve
    if def.postProcessCurve ~= nil then
        local option = Collapse.newOptionCurve()
        local postProcessCurve = def.postProcessCurve
        option.title.text = "属性 " .. def.label_zhcn .. " 的" .. StatsReport_PostProcessed
        option.tooltip.formatter = StatsReport_PostProcessed
        local points = postProcessCurve.points
        option.series[1] = {
            name = StatsReport_PostProcessed,
            type = "line",
            label = {
                normal = {
                    show = true,
                    formatter = "({c})"
                }
            }
        }
        local series1_data = {}
        if isPercent then
            for i, p in pairs(points) do
                series1_data[i] = {p.x * 100, p.y * 100}
            end
            option.formatterStyle = "CurvePercent"
            option.tooltip.axisPointer.label.formatter = "{value}%"
            option.xAxis[1].axisLabel.formatter = "{value}%"
            option.yAxis[1].axisLabel.formatter = "{value}%"
        else
            for i, p in pairs(points) do
                series1_data[i] = {p.x, p.y}
            end
        end
        option.series[1].data = series1_data
        text = text .. Collapse.echarts({
            id = "StatDef-" .. def.defName .. "-postProcessCurve",
            title = StatsReport_PostProcessed,
            above = "曲线处理坐标点：" .. postProcessCurve:toString(),
            option = option
        })
    end
    -- Post Process Curve end

    text = text .. "\n"
    -- Section 2 end


    return text
end

return StatView