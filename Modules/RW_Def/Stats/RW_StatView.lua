local StatView = {}
local StatDef = require("Module:RW_StatDef")

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")
local Keyed = require("Module:Keyed")

function StatView.view(frame)
    local def = StatDef:new(frame.args[1])
    local text = ""
        .. def:getSummary()
        .. "\n"
        .. def:getInfoBase()
        .. "\n<hr/>\n"

    local StatsReport_BaseValue = Keyed.zhcnS("StatsReport_BaseValue")
    local StatsReport_Material = Keyed.zhcnS("StatsReport_Material")
    local StatsReport_Skills = Keyed.zhcnS("StatsReport_Skills")
    local StatsReport_OtherStats = Keyed.zhcnS("StatsReport_OtherStats")
    local StatsReport_HealthFactors = Keyed.zhcnS("StatsReport_HealthFactors")
    local StatsReport_PostProcessed = Keyed.zhcnS("StatsReport_PostProcessed")
    local StatsReport_FinalValue = Keyed.zhcnS("StatsReport_FinalValue")
    
    -- Base Args
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
        rows = {{
            cols = {"属性分类", (def.category and ("[[StatCategories_" .. def.category .. "|" .. SMW.show("Core:Defs_StatCategoryDef_" .. def.category, "StatCategoryDef.label.zh-cn") .. "]]") or ""), ""}
        },{
            cols = {"格式化显示字符串", (def.formatString_zhcn or ""), ""}
        },{
            cols = {"默认基础值", (def.defaultBaseValue or ""), ""}
        },{
            cols = {"最小值", (def.minValue or ""), ""}
        },{
            cols = {"最大值", (def.maxValue or ""), ""}
        },{
            cols = {"其他属性系数", (def.statFactors and (
                function()
                    local sfs = ""
                    for i, s in pairs(def.statFactors) do
                        sfs = sfs .. "[[Stats_" .. s .. "|" .. SMW.show("Core:Defs_StatDef_" .. s, "StatDef.label.zh-cn") .. "]] "
                    end
                    return sfs
                end
            ) or ""), ""}
        },{
            cols = {"负数时是否应用系数", (def.applyFactorsIfNegative and "是" or "否"), ""}
        },{
            cols = {"无技能系数", def.noSkillFactor, ""}
        }}
    }
    text = text .. Collapse.ctable(argBases)
    -- Base Args end 

    -- Section 2
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
                .. "计算公式：[[Formulas_Stat#skillNeedFactors|" .. StatsReport_Skills .. "]]"
            option.title.subtext = ""
                .. "基础系数：" .. skillNeed.baseFactor * 100 .. "%，"
                .. "加成系数：" .. skillNeed.bonusFactor * 100 .. "%；"
                .. StatsReport_Skills .. " = 基础系数 + 加成系数 × 技能等级；"
        else
            above = StatsReport_Skills
                .. "（直接形式）："
                .. "技能：[[Skills_" .. skill .. "|" .. skillLabel .. "]]；"
                .. "计算公式：[[Formulas_Stat#StatsReport_Skills|" .. StatsReport_Skills .. "]]"
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
                text = "最大值",
                width = "30%"
            }}
        }
        local pcfs = def.capacityFactors
        local rows = {}
        local count = 0
        for i, factor in pairs(pcfs) do
            rows[1] = {
                cols = {
                    "[[PawnCapacities_" .. factor.capacity .. "|" .. SMW.show("Core:Defs_PawnCapacityDef_" .. factor.capacity, "PawnCapacityDef.label.zh-cn") .. "]]",
                    factor.weight * 100 .. "%",
                    (factor.max and (factor.max * 100 .. "%") or "")
                }
            }
            count = count + 1
        end
        rows[count + 1] = {
            cols = {"计算公式：[[Formulas_Stat#StatsReport_HealthFactors|" .. StatsReport_HealthFactors .. "]]", "", ""}
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
        option.title.subtext = "曲线处理坐标点：" .. postProcessCurve:toString()
        option.tooltip.formatter = StatsReport_PostProcessed
        local points = postProcessCurve.points
        option.series[1] = {
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
            above = "计算公式：[[Formulas_Stat#StatsReport_PostProcessed|" .. StatsReport_PostProcessed .. "]]",
            option = option
        })
    end
    -- Post Process Curve end

    text = text .. "\n"
    -- Section 2 end


    return text
end

return StatView