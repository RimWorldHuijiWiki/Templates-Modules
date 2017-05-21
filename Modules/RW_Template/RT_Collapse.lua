local Collapse = {}

collapse_ID = 1
ctable_ID = 1
navbox_ID = 1
echarts_ID = 1


-- args = {
--     id = "",
--     parent = ""
--     style = "",
--     title = "",
--     barClass = "", -- default/primary/success/info/warning/danger default: primary
--     contentShow = true/false, default: true
--     contentStyle = "",
--     content = ""
-- }
function Collapse.collapse(args)

    if args == nil or type(args) ~= "table" then
        return ""
    end

    local text = "<div class=\"panel rw-collapse\""
        .. (args.style and (" style=\"" .. args.style .. "\"") or "")
        .. ">\n<div class=\"bg-"

    local barClass = args.barClass
    if barClass == "default" then
        text = text .. "default"
    elseif barClass == "primary" then
        text = text .. "primary"
    elseif barClass == "success" then
        text = text .. "success"
    elseif barClass == "info" then
        text = text .. "info"
    elseif barClass == "warning" then
        text = text .. "warning"
    elseif barClass == "danger" then
        text = text .. "danger"
    else
        text = text .. "primary"
    end

    local parent = args.parent
    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\""
        .. (parent and (" data-parent=\"#" .. parent .. "\"") or "")
        .. " data-target=\"#rw-collapse-"
    
    local id = args.id
    if id == nil or mw.text.trim(id) == "" then
        id = "id" .. collapse_ID
        collapse_ID = collapse_ID + 1
    end
    text = text .. id

    local show = args.contentShow
    if show == nil then
        show = true
    end
    if parent then
        show = false
    end
    text = text
        .. "\">"
        .. (args.title or "&nbsp;")
        .. "</div>\n<div class=\"collapse "
        .. (show and "in" or "")
        .. "\" id=\"rw-collapse-"
        .. id
        .. "\">\n"

    text = text
        .. "<div class=\"rw-collapse-content\""
        .. (args.contentStyle and (" style=\"" .. args.contentStyle .. "\"") or "")
        .. ">"
        .. (args.content or "")
        .. "</div>\n"

    text = text .. "</div>\n</div>\n"

    return text
end


-- local args = {
--     id = "",
--     style = "",
--     title = "",
--     barClass = "", -- default/primary/success/info/warning/danger default: primary
--     headers = {{
--         text = "",
--         width = "60%"
--     },{
--         text = "",
--         width = "40%"
--     }},
--     rows = {{
--         cols = {},
--         extraCssText = "",
--         extraStyleText = "",
--     },{
--     cols = {{
--         text = "",
--         span = 1,
--         rowspan = 1
--     },{
--         text = "",
--         extraStyleText = "",
--     }}
--     }}
-- }
function Collapse.ctable(args)

    if args == nil or type(args) ~= "table" then
        return "generate ctable failure, parameter error."
    end

    local text = "<div class=\"panel rw-collapse\""
        .. (args.style and (" style=\"" .. args.style .. "\"") or "")
        .. ">\n<div class=\"bg-"

    local barClass = args.barClass
    if barClass == "default" then
        text = text .. "default"
    elseif barClass == "primary" then
        text = text .. "primary"
    elseif barClass == "success" then
        text = text .. "success"
    elseif barClass == "info" then
        text = text .. "info"
    elseif barClass == "warning" then
        text = text .. "warning"
    elseif barClass == "danger" then
        text = text .. "danger"
    else
        text = text .. "primary"
    end

    local parent = args.parent
    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\""
        .. (parent and (" data-parent=\"#" .. parent .. "\"") or "")
        .. " data-target=\"#rw-ctable-simple-"

    local id = args.id
    if id == nil or mw.text.trim(id) == "" then
        id = "id" .. ctable_ID
        ctable_ID = ctable_ID + 1
    end
    text = text .. id

    local show = args.contentShow
    if show == nil then
        show = true
    end
    if parent then
        show = false
    end
    text = text
        .. "\">"
        .. (args.title or "&nbsp;")
        .. "</div>\n<div class=\"collapse "
        .. (show and "in" or "")
        .. "\" id=\"rw-ctable-simple-"
        .. id
        .. "\">\n"
    
    text = text
        .. "<table class=\"rw-ctable-simple\">\n"

    local headers = args.headers
    if headers ~= nil and type(headers) == "table" then
        text = text .. "<tr>"
        for i, th in pairs(headers) do
            text = text
                .. "<th"
                .. (th.text and "" or " class=\"rw-ctable-empty\"")
                .. (th.width and (" style=\"width:" .. th.width .. ";\"") or "")
                .. ">"
                .. (th.text or "")
                .. "</th>"
        end
        text = text .. "</tr>\n"
    end

    local rows = args.rows
    if rows ~= nil and type(rows) == "table" then
        for i, tr in pairs(rows) do
            if tr.extraCssText then
                text = text .. "<tr class=\"" .. tr.extraCssText .. "\">"
            else
                text = text .. "<tr>"
            end
            local cols = tr.cols
            if cols ~= nil and type(cols) == "table" then
                for j, td in pairs(cols) do
                    if type(td) == "table" then
                        text = text
                            .. "<td"
                            .. (td.span and (" colspan=\"" .. td.span .. "\"") or "")
                            .. (td.rowspan and (" rowspan=\"" .. td.rowspan .. "\"") or "")
                            .. (td.extraStyleText and (" style=\"" .. td.extraStyleText .. "\"") or "")
                            .. ">"
                            .. (td.text or "")
                            .. "</td>"
                    else
                        text = text
                            .. "<td>"
                            .. tostring(td)
                            .. "</td>"
                    end
                end
            end
            text = text .. "</tr>\n"
        end
    end

    text = text .. "</table>\n</div>\n</div>\n"

    return text
end


-- local args = {
--     id = "",
--     title = "",
--     above = "",
--     rows = {{
--         label = "",
--         list = {}
--     },{
--         label = "",
--         list = {}
--     },{
--         label = "",
--         children = {{
--             label = "",
--             list = {}
--         }}
--     }},
--    footer = ""
-- }
function Collapse.navbox(args)

    if args == nil or type(args) ~= "table" then
        return "generate navbox failure, parameter error."
    end

    local text = "<div class=\"panel rw-collapse\">\n<div class=\"bg-primary rw-collapse-head rw-collapse-navbox\" type=\"button\" data-toggle=\"collapse\" data-target=\"#rw-navbox-"

    local id = args.id
    if id == nil or mw.text.trim(id) == "" then
        id = "id" .. navbox_ID
        navbox_ID = navbox_ID + 1
    end
    text = text .. id

    text = text
        .. "\">"
        .. (args.title or "&nbsp;")
        .. "</div>\n<div class=\"collapse in\" id=\"rw-navbox-"
        .. id
        .. "\">\n"
        .. (args.above and ("<div class=\"rw-collapse-above\">" .. args.above .. "</div>") or "")
        .. Collapse.navbox_table(args.rows)
        .. (args.footer and ("<div class=\"rw-collapse-above\">" .. args.footer .. "</div>") or "")
        .. "</div>\n"

    text = text .. "</div>"

    return text
end

function Collapse.navbox_table(rows, isChild)
    local text = "<table class=\"rw-navbox"
        .. (isChild and " rw-navbox-child" or "")
        .. "\">\n"

    for i, tr in pairs(rows) do
        text = text
            .. "<tr>\n"
            .. "<th scope=\"row\" class=\"rw-navbox-label\">"
            .. (tr.label or "&nbsp;")
            .. "</th>\n"

        if tr.list then
            text = text .. "<td class=\"rw-navbox-list\">"
            for i, td in pairs(tr.list) do
                text = text
                    .. "<span class=\"item\">"
                    .. (td or "&nbsp;")
                    .. "</span>"
            end
            text = text .. "</td>\n"
        elseif tr.children then
            text = text
                .. "<td class=\"rw-navbox-list children\">\n"
                .. Collapse.navbox_table(tr.children, true)
                .. "\n</td>\n"
        else
            text = text
                .. "<td class=\"rw-navbox-list\">&nbsp;</td>"
        end

        text = text
            .. "</tr>\n"
    end
        
    text = text .. "</table>\n"

    return text
end


-- args = {
--     mode = "", -- normal/debug
--     id = "",
--     parent = "",
--     style = "",
--     title = "",
--     barClass = "", -- default/primary/success/info/warning/danger default: primary
--     above = "",
--     aboveExtraCssText = ""
--     width = ""
--     height = ""
--     option = {}
-- }
function Collapse.echarts(args)

    if args == nil or type(args) ~= "table" then
        return ""
    end

    local text = "<div class=\"panel rw-collapse\""
        .. (args.width and (" style=\"width:" .. args.width .. ";\"") or " style=\"width:809px;\"")
        .. ">\n<div class=\"bg-"

    local barClass = args.barClass
    if barClass == "default" then
        text = text .. "default"
    elseif barClass == "primary" then
        text = text .. "primary"
    elseif barClass == "success" then
        text = text .. "success"
    elseif barClass == "info" then
        text = text .. "info"
    elseif barClass == "warning" then
        text = text .. "warning"
    elseif barClass == "danger" then
        text = text .. "danger"
    else
        text = text .. "primary"
    end

    local parent = args.parent
    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\""
        .. (parent and (" data-parent=\"#" .. parent .. "\"") or "")
        .. " data-target=\"#rw-collapse-echarts-"
    
    local id = args.id
    if id == nil or mw.text.trim(id) == "" then
        id = "id" .. collapse_ID
        collapse_ID = collapse_ID + 1
    end
    text = text .. id

    local show = args.contentShow
    if show == nil then
        show = true
    end
    if parent then
        show = false
    end
    text = text
        .. "\">"
        .. (args.title or "&nbsp;")
        .. "</div>\n<div class=\"collapse in\" id=\"rw-collapse-echarts-"
        .. id
        .. "\">\n"
    
    local above = args.above
    if above ~= nil and above ~= "" then
        text = text
            .. "<div class=\"rw-collapse-above\""
            .. (args.aboveExtraCssText and (" style=\"" .. args.aboveExtraCssText .. "\"") or "")
            .. ">"
            .. above
            .. "</div>\n"
    end

    text = text
        .. "<div class=\"echarts-outter\""
        .. (args.height and (" style=\"height:" .. args.height .. ";\"") or " style=\"height:500px;\"")
        .. ">\n"
        .. "<div class=\"echarts\">"
        .. (args.option and mw.text.jsonEncode(args.option) or "{}")
        .. "</div>\n"
        .. "<div class=\"echarts-loading\"><i class=\"fa fa-circle-o-notch fa-spin fa-4x fa-fw\"></i></div>"
        .. "</div>\n"

    text = text .. "</div>\n</div>\n"

    local debug = (args.mode == "debug")
    return (debug and mw.text.nowiki(text) or text)
end


-- Preset Colors

Collapse.highlighting = "#e6af2e"
Collapse.foregroundColor = "#c0c7da"
Collapse.backgroundColor = "#282f44"
Collapse.handleIcon = "path://M306.1,413c0,2.2-1.8,4-4,4h-59.8c-2.2,0-4-1.8-4-4V200.8c0-2.2,1.8-4,4-4h59.8c2.2,0,4,1.8,4,4V413z"


-- Create a new option table for echarts

function Collapse.newOptionNormal(colors)
    return {
        formatterStyle = "Normal",
        color = colors or {Collapse.highlighting},
        backgroundColor = Collapse.backgroundColor,
        title = {
            top = "4%",
            left = "center",
            text = "",
            textStyle = {
                color = Collapse.foregroundColor,
                fontWeight = "normal"
            },
            subtext = "",
            itemGap = 12
        },
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
        grid = {
            top = "20%"
        },
        xAxis = {{
            type = "category",
            axisLabel = {
                formatter = "{value}"
            },
            axisTick = {
                alignWithLabel = true
            },
            axisLine = {
                onZero = false,
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
            boundaryGap = true
        }},
        yAxis = {{
            type = "value",
            axisLabel = {
                formatter = "{value}"
            },
            axisLine = {
                onZero = false,
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
        }},
        series = {}
    }
end

-- Create a new option table for echarts
function Collapse.newOptionCurve(colors)
    return {
        formatterStyle = "Curve",
        color = colors or {Collapse.highlighting},
        backgroundColor = Collapse.backgroundColor,
        title = {
            top = "4%",
            left = "center",
            text = "",
            textStyle = {
                color = Collapse.foregroundColor,
                fontWeight = "normal"
            },
            subtext = "",
            itemGap = 12
        },
        tooltip = {
            trigger = "axis",
            formatter = "",
            backgroundColor = Collapse.backgroundColor,
            axisPointer = {
                type = "cross",
                label = {
                    formatter = "{value}",
                    shadowBlur = 0,
                    borderWidth = 1,
                    borderColor = Collapse.highlighting,
                    backgroundColor = Collapse.backgroundColor,
                    extraCssText = "border-radius: 2px;"
                }
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
        grid = {
            top = "20%",
            bottom = "16%"
        },
        xAxis = {{
            type = "value",
            name = "X",
            axisLabel = {
                formatter = "{value}"
            },
            axisLine = {
                onZero = false,
                lineStyle = {
                    color = Collapse.foregroundColor
                }
            },
            axisPointer = {
                snap = false
            },
            splitLine = {
                lineStyle = {
                    type = "dashed",
                    color = Collapse.foregroundColor,
                }
            },
        }},
        yAxis = {{
            type = "value",
            name = "Y",
            axisLabel = {
                formatter = "{value}"
            },
            axisLine = {
                onZero = false,
                lineStyle = {
                    color = Collapse.foregroundColor
                }
            },
            axisPointer = {
                snap = false
            },
            splitLine = {
                lineStyle = {
                    type = "dashed",
                    color = Collapse.foregroundColor,
                }
            },
        }},
        dataZoom = {{
            type = "slider",
            height = 12,
            bottom = 20,
            handleIcon = Collapse.handleIcon,
            handleSize = 16
        },{
            type = "inside"
        },{
            type = "slider",
            yAxisIndex = 0,
            width = 12,
            right = 22,
            handleIcon = Collapse.handleIcon,
            handleSize = 16
        }},
        series = {}
    }
end

function Collapse.newOption(style, colors)
    local option = Collapse.newOptionNormal(colors)
    if style == "normal" then
        return option
    elseif style == "point" then
        option.tooltip.axisPointer.type = "line"
        return option
    elseif style == "span" then
        option.xAxis[1].axisTick.alignWithLabel = false
        return option
    elseif style == "value" then
        option.tooltip.axisPointer.type = "line"
        option.xAxis[1].boundaryGap = false
        return option
    else
        return option
    end        
end

function Collapse.newOptionPlusminus(colors)
    return {
        formatterStyle = "Normal",
        color = colors or {Collapse.highlighting},
        backgroundColor = Collapse.backgroundColor,
        title = {
            top = "10",
            left = "center",
            text = "",
            textStyle = {
                color = Collapse.foregroundColor,
                fontWeight = "normal"
            },
            subtext = "",
            itemGap = 12
        },
        legend = {
            top = 40,
            textStyle = {
                color = Collapse.foregroundColor
            }
        },
        tooltip = {
            trigger = "axis",
            axisPointer = {
                type = "shadow"
            },
            backgroundColor = Collapse.backgroundColor,
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
            top = 40,
            right = "10%"
        },
        grid = {},
        xAxis = {},
        yAxis = {},
        series = {}
    }
end

function Collapse.newOptionPlusminusX(xAxisCount, colors)
    xAxisCount = xAxisCount or 1
    local option = Collapse.newOptionPlusminus(colors)
    option.grid.top = xAxisCount * 40 + 100
    local xAxis = option.xAxis
    for i = 1, xAxisCount do
        xAxis[i] = {
            type = "value",
            axisLabel = {
                formatter = "{value}"
            },
            axisLine = {
                lineStyle = {
                    color = (colors and colors[i] or Collapse.foregroundColor)
                }
            },
            splitLine = {
                show = false
            },
            position = "top",
            offset = 40 * i - 40
        }
    end
    option.yAxis[1] = {
        type = "category",
        axisLabel = {
            formatter = "{value}"
        },
        axisLine = {
            lineStyle = {
                color = Collapse.foregroundColor
            }
        },
        splitLine = {
            show = true,
            lineStyle = {
                color = Collapse.foregroundColor,
                type = "dashed",
                opacity = 0.8
            }
        },
        boundaryGap = true
    }
    return option    
end

function Collapse.newOptionPie(colors)
    return {
        formatterStyle = "Pie",
        color = colors or {Collapse.highlighting},
        backgroundColor = Collapse.backgroundColor,
        title = {
            top = "center",
            left = "center",
            text = "",
            textStyle = {
                color = Collapse.foregroundColor,
                fontWeight = "normal"
            },
            subtext = "",
            itemGap = 12
        },
        tooltip = {
            -- trigger = "item",
            backgroundColor = Collapse.backgroundColor,
            borderColor = Collapse.highlighting,
            borderWidth = 2,
            padding = {12, 12},
            extraCssText = "border-radius: 2px;",
            formatter = "{b}<br/>{a}：{c}（{d}%）"
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
        series = {{
            name = "权重",
            type = "pie",
            radius = {"55%", "75%"},
            label = {
                normal = {
                    formatter = "{b} {d}%",
                    textStyle = {
                        fontSize = 14
                    }
                },
                emphasis = {
                    show = true,
                    textStyle = {
                        fontSize = 14,
                        fontWeight = "bold",
                    }
                }
            }
        }}
    }
end

return Collapse