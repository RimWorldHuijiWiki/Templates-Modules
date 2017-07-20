local Weathers = {}

local ColorUtility = require("Module:ColorUtility")

local Collapse = require("Module:RT_Collapse")
local Note = require("Module:RT_Note")

local WeatherDef = require("Module:RW_WeatherDef")

function Weathers.view(frame)
    local text = Note.note("rimworld", "cloud", "天气", "英文 Weather，发生在大气层中的自然现象。")
        .. "<hr/>"
        .. Note.note("danger", "warning", nil, "坏天气不仅会让露天的物品老化变质，还会降低移动速度和射击精确度。")
        .. Note.note("danger", "bolt", nil, "电器淋雨/雪会发生短路。")
        .. Note.note("info", "fire-extinguisher", nil, "发生大面积火灾时有一定几率引发降雨。")

    local allWeathers = {
        WeatherDef.of("Clear"),
        WeatherDef.of("Fog"),
        WeatherDef.of("Rain"),
        WeatherDef.of("DryThunderstorm"),
        WeatherDef.of("RainyThunderstorm"),
        WeatherDef.of("FoggyRain"),
        WeatherDef.of("SnowHard"),
        WeatherDef.of("SnowGentle"),
    }

    text = text
        .. "<div class=\"panel-group rw-collapse-group\" id=\"weathers-group\" style=\"width: 890px;\">\n"
    for i, weather in pairs(allWeathers) do
        text = text .. Collapse.ctable({
            id = weather.defName,
            parent = "weathers-group",
            title = "<h2>" .. weather.label_zhcn .. "</h2>",
            headers = {{
                width = "144px"
            },{}},
            rows = {{
                cols = {{
                    text = "[[File:Icons_Weathers_" .. weather.defName .. ".svg|64px|link=]]",
                    span = 2
                }},
                extraCssText = "rw-ctable-thumbnail"
            },{
                cols = {"defType", "WeatherDef"}
            },{
                cols = {"defName", weather.defName}
            },{
                cols = {"名称（英文）", weather.label}
            },{
                cols = {"名称（简中）", weather.label_zhcn}
            },{
                cols = {"名稱（繁中）", weather.label_zhtw}
            },{
                cols = {"描述（英文）", weather.description}
            },{
                cols = {"描述（简中）", weather.description_zhcn}
            },{
                cols = {"描述（繁中）", weather.description_zhtw}
            }}
        })
    end
    text = text
        .. "</div>\n"
        .. "<hr/>"
    
    local colors = ColorUtility.colorSet(4)
    colors = {colors[1], colors[3]}
    local allLabels = {}
    local moveSpeedMultiplier_data, accuracyMultiplier_data = {}, {}
    for i, weather in pairs(allWeathers) do
        allLabels[i] = weather.label_zhcn
        moveSpeedMultiplier_data[i] = weather.moveSpeedMultiplier * 100
        accuracyMultiplier_data[i] = weather.accuracyMultiplier * 100
    end
    text = text .. Collapse.echarts({
        id = "weathersComparision",
        title = "<h2>各种天气的数据对比</h2>",
        width = "100%",
        option = {
            formatterStyle = "Normal",
            color = colors,
            tooltip = {
                trigger = "axis",
                backgroundColor = Collapse.backgroundColor,
                axisPointer = {
                    type = "shadow"
                },
                borderColor = Collapse.highlighting,
                borderWidth = 2,
                padding = {12, 12},
                extraCssText = "border-radius: 2px;",
                formatter = "{b}<br/>移动速度乘数：{c0}%<br/>射击精确度乘数：{c1}%"
            },
            toolbox = {
                itemSize = 20,
                feature = {
                    dataView = {
                        show = true,
                        readOnly = false
                    },
                    -- saveAsImage = {
                    --     show = true
                    -- }
                },
                iconStyle = {
                    normal = {
                        borderColor = Collapse.foregroundColor
                    },
                    emphasis = {
                        borderColor = Collapse.highlighting
                    }
                },
                top = "4%",
                right = "5%"
            },
            legend = {
                top = "4%",
                left = "center",
                textStyle = {
                    color = Collapse.foregroundColor,
                    fontSize = 14
                },
                itemGap = 12,
                data = {"移动速度乘数", "射击精确度乘数"}
            },
            grid = {
                top = "20%",
            },
            xAxis = {{
                type = "category",
                axisLabel = {
                    interval = 0,
                },
                axisLine = {
                    lineStyle = {
                        color = Collapse.foregroundColor
                    }
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                boundaryGap = true,
                data = allLabels
            }},
            yAxis = {{
                name = "移动速度乘数",
                type = "value",
                axisLabel = {
                    formatter = "{value}%"
                },
                axisLine = {
                    lineStyle = {
                        color = colors[1]
                    },
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                position = "left"
            },{
                name = "射击精确度乘数",
                type = "value",
                axisLabel = {
                    formatter = "{value}%"
                },
                axisLine = {
                    lineStyle = {
                        color = colors[2]
                    },
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                position = "right",
            }},
            series = {{
                name = "移动速度乘数",
                type = "bar",
                barGap = "10%",
                data = moveSpeedMultiplier_data
            },{
                name = "射击精确度乘数",
                type = "bar",
                yAxisIndex = 1,
                data = accuracyMultiplier_data
            }}
        }
    })
    

    return text
end

return Weathers