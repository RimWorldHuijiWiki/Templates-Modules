local Biomes = {}

local ColorUtility = require("Module:ColorUtility")

local Collapse = require("Module:RT_Collapse")
local Note = require("Module:RT_Note")

local BiomeDef = require("Module:RW_BiomeDef")

function Biomes.view(frame)
    local text = Note.note("rimworld", "th-large", "生态区", "英文 Biome，是 RimWorld 中的一种定义，在生成世界时，根据不同的温度和降雨量生成具备不同地表和动植物群落的区域。")
        .. "<hr/>\n"
    
    -- Arid
    local AridShrubland = BiomeDef.of("AridShrubland")
    local Desert = BiomeDef.of("Desert")
    local ExtremeDesert = BiomeDef.of("ExtremeDesert")
    -- Cold
    local BorealForest = BiomeDef.of("BorealForest")
    local Tundra = BiomeDef.of("Tundra")
    local IceSheet = BiomeDef.of("IceSheet")
    local SeaIce = BiomeDef.of("SeaIce")
    -- Moderate
    local TemperateForest = BiomeDef.of("TemperateForest")
    local TropicalRainforest = BiomeDef.of("TropicalRainforest")
    -- Unlandable
    local Ocean = BiomeDef.of("Ocean")
    local Lake = BiomeDef.of("Lake")
    
    text = text
        .. "<div class=\"rw-capture\">[[File:Captures_Biomes.png|link=]]</div>\n"
        .. Note.note("info", "lightbulb-o", "新手攻略", "热带雨林的疾病频率最高，加上热浪，并不适合新手。通常认为，温带森林的温度和疾病频率较为合适新手。但实际上，如果着陆点的冬夏温差过大，将会面临热浪和寒流的考验。而如果着陆时选择一个不那么冷的寒带森林则会更容易些，只要在入冬前储备足够的食物，并种一些棉花做几件风雪大衣，就可以很简单地度过第一年。")
        .. "<div class=\"row\">\n"
        .. "<div class=\"col-md-6\">\n"
        .. "<h2>干旱</h2>\n"
        .. AridShrubland:getButton()
        .. Desert:getButton()
        .. ExtremeDesert:getButton()
        .. "</div>\n"
        .. "<div class=\"col-md-6\">\n"
        .. "<h2>寒冷</h2>\n"
        .. BorealForest:getButton()
        .. Tundra:getButton()
        .. IceSheet:getButton()
        .. SeaIce:getButton()
        .. "</div>\n"
        .. "<div class=\"col-md-6\">\n"
        .. "<h2>中性</h2>\n"
        .. TemperateForest:getButton()
        .. TropicalRainforest:getButton()
        .. "</div>\n"
        .. "<div class=\"col-md-6\">\n"
        .. "<h2>无法着陆</h2>\n"
        .. Ocean:getButton()
        .. Lake:getButton()
        .. "</div>\n"
        .. "</div>\n"
        .. "<hr/>"
    
    local allBiomes = {AridShrubland, Desert, ExtremeDesert, BorealForest, Tundra, IceSheet, SeaIce, TemperateForest, TropicalRainforest, Ocean, Lake}
    local countBiomes = #allBiomes
    local colors = {"#896647", "#9a7a56", "#9e815f", "#64522e", "#836a59", "#a09fa0", "#939394", "#766c39", "#656633", "#3c475c", "#3c475c"}

    local rainMax, rainSpan, tempMin, tempMax, tempSpan = 4000, 40, -40, 60, 1
    
    local xAxis_data = {}
    local xAxis_data_index = 1
    for i = 0, rainMax, rainSpan do
        xAxis_data[xAxis_data_index] = i
        xAxis_data_index = xAxis_data_index + 1
    end
    local yAxis_data = {}
    local yAxis_data_index = 1
    for i = tempMin, tempMax, tempSpan do
        yAxis_data[yAxis_data_index] = i
        yAxis_data_index = yAxis_data_index + 1
    end

    local allWorkers = {}
    local allLabels = {}
    for i = 1, countBiomes do
        allWorkers[i] = allBiomes[i]:get_Worker()
        allLabels[i] = allBiomes[i].label_zhcn
    end
    local pieces = {}
    for i = 1, countBiomes do
        pieces[i] = {value = i, label = allLabels[i], color = colors[i]}
    end

    local data = {}
    local data_index = 1
    local tile = {
        temperature = 0,
        rainfall = 0
    }
    xAxis_data_index = 0
    for rainfall = 0, rainMax, rainSpan do
        yAxis_data_index = 0
        for temperature = tempMin, tempMax, tempSpan do
            tile.rainfall = rainfall
            tile.temperature = temperature

            local biomeIndex = 0
            local num = 0
            for i = 1, countBiomes do
                local score = allWorkers[i].getScore(tile)
                if (score > num or biomeIndex == 0) then
                    biomeIndex = i
                    num = score
                end
            end
            data[data_index] = {xAxis_data_index, yAxis_data_index, biomeIndex}
            data_index = data_index + 1
            
            yAxis_data_index = yAxis_data_index + 1
        end
        xAxis_data_index = xAxis_data_index + 1
    end

    text = text .. Collapse.echarts({
        id = "biomesMap",
        title = "<h2>生态区的降雨量/平均温度分布</h2>",
        width = "100%",
        option = {
            formatterStyle = "BiomeMap",
            extraOption = {
                allLabels = allLabels,
                rainMax = rainMax,
                rainSpan = rainSpan,
                tempMin = tempMin,
                tempMax = tempMax,
                tempSpan = tempSpan
            },
            color = colors,
            backgroundColor = Collapse.backgroundColor,
            tooltip = {
                position = "top",
                backgroundColor = Collapse.backgroundColor,
                borderColor = Collapse.highlighting,
                borderWidth = 2,
                padding = {12, 12},
                extraCssText = "border-radius: 2px;",
                formatter = "生态区"
            },
            visualMap = {
                type = "piecewise",
                pieces = pieces,
                textStyle = {color = Collapse.foregroundColor},
                top = "middle",
                left = "2%"
            },
            grid = {
                left = "20%"
            },
            xAxis = {{
                name = "降雨量",
                type = "category",
                axisLabel = {
                    formatter = "{value} mm"
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
                data = xAxis_data
            }},
            yAxis = {{
                name = "平均温度",
                type = "category",
                axisLabel = {
                    formatter = "{value} ℃"
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
                data = yAxis_data
            }},
            series = {{
                name = "生态区的降雨量/平均温度分布",
                type = "heatmap",
                data = data
            }}
        }
    })
    
    colors = ColorUtility.colorSet(4)
    local animalDensity_data, plantDensity_data, diseaseMtbDays_data = {}, {}, {}
    for i, biome in pairs(allBiomes) do
        animalDensity_data[i] = biome.animalDensity
        plantDensity_data[i] = biome.plantDensity
        diseaseMtbDays_data[i] = biome.diseaseMtbDays
    end

    text = text .. Collapse.echarts({
        id = "biomesComparision",
        title = "<h2>生态区的数据对比</h2>",
        width = "100%",
        option = {
            formatterStyle = "Normal",
            color = colors,
            backgroundColor = Collapse.backgroundColor,
            tooltip = {
                trigger = "axis",
                backgroundColor = Collapse.backgroundColor,
                axisPointer = {
                    type = "shadow"
                },
                borderColor = Collapse.highlighting,
                borderWidth = 2,
                padding = {12, 12},
                extraCssText = "border-radius: 2px;"
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
                data = {"动物密度", "植被密度", "疾病最大间隔时间"}
            },
            grid = {
                top = "20%",
                right = "15%",
            },
            xAxis = {{
                type = "category",
                axisLabel = {
                    interval = 0,
                    rotate = 30
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
                name = "动物密度",
                type = "value",
                axisLine = {
                    lineStyle = {
                        color = colors[1]
                    }
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                position = "right"
            },{
                name = "植被密度",
                type = "value",
                axisLine = {
                    lineStyle = {
                        color = colors[2]
                    }
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                position = "right",
                offset = 60,
            },{
                name = "疾病最大间隔时间",
                type = "value",
                axisLabel = {
                    formatter = "{value} 天"
                },
                axisLine = {
                    lineStyle = {
                        color = colors[3]
                    }
                },
                splitLine = {
                    lineStyle = {
                        type = "dashed",
                        color = Collapse.foregroundColor,
                    }
                },
                position = "left"
            }},
            series = {{
                name = "动物密度",
                type = "bar",
                barGap = "10%",
                data = animalDensity_data
            },{
                name = "植被密度",
                type = "bar",
                yAxisIndex = 1,
                data = plantDensity_data
            },{
                name = "疾病最大间隔时间",
                type = "line",
                yAxisIndex = 2,
                symbolSize = 8,
                lineStyle = {
                    width = 4,
                },
                data = diseaseMtbDays_data
            }}
        }
    })
    
    return text
end

return Biomes