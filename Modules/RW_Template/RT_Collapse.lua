local Collapse = {}

collapse_ID = 1
ctable_ID = 1
echarts_ID = 1

-- args = {
--     id = "",
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

    local text = "<div class=\"rw-collapse\""
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

    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\" data-target=\"#rw-collapse-"
    
    local id = args.id
    if id == nil or id == "" then
        id = "id" .. collapse_ID
        collapse_ID = collapse_ID + 1
    end
    text = text .. id

    local show = args.contentShow
    if show == nil then
        show = true
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

-- local cell = {
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
--         cols = {}
--     }}
-- }
function Collapse.ctable(cells)

    if cells == nil or type(cells) ~= "table" then
        return "generate ctable failure, parameter error."
    end

    local text = "<div class=\"rw-collapse\""
        .. (cells.style and (" style=\"" .. cells.style .. "\"") or "")
        .. ">\n<div class=\"bg-"

    local barClass = cells.barClass
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

    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\" data-target=\"#rw-ctable-simple-"

    local id = cells.id
    if id == nil or id == "" then
        id = "id" .. ctable_ID
        ctable_ID = ctable_ID + 1
    end
    text = text .. id

    local show = cells.contentShow
    if show == nil then
        show = true
    end
    text = text
        .. "\">"
        .. (cells.title or "&nbsp;")
        .. "</div>\n<div class=\"collapse "
        .. (show and "in" or "")
        .. "\" id=\"rw-ctable-simple-"
        .. id
        .. "\">\n"
    
    text = text
        .. "<table class=\"rw-ctable-simple\">\n"

    local headers = cells.headers
    if headers ~= nil and type(headers) == "table" then
        text = text .. "<tr>"
        for i, th in pairs(headers) do
            text = text
                .. "<th"
                .. (th.width and (" style=\"width:" .. th.width .. ";\"") or "")
                .. ">"
                .. (th.text or "")
                .. "</th>"
        end
        text = text .. "</tr>\n"
    end

    local rows = cells.rows
    if rows ~= nil and type(rows) == "table" then
        for i, tr in pairs(rows) do
            text = text .. "<tr>"
            local cols = tr.cols
            if cols ~= nil and type(cols) == "table" then
                for j, td in pairs(cols) do
                    text = text
                        .. "<td>"
                        .. td or ""
                        .. "</td>"
                end
            end
            text = text .. "</tr>\n"
        end
    end

    text = text .. "</table>\n</div>\n</div>\n"

    return text
end

-- args = {
--     id = "",
--     style = "",
--     title = "",
--     barClass = "", -- default/primary/success/info/warning/danger default: primary
--     above = "",
--     width = ""
--     height = ""
--     option = {}
-- }
function Collapse.echarts(args)

    if args == nil or type(args) ~= "table" then
        return ""
    end

    local text = "<div class=\"rw-collapse\""
        .. (args.width and (" style=\"" .. args.width .. ";\"") or " style=\"width:809px;\"")
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

    text = text .. " rw-collapse-head\" type=\"button\" data-toggle=\"collapse\" data-target=\"#rw-collapse-echarts-"
    
    local id = args.id
    if id == nil or id == "" then
        id = "id" .. collapse_ID
        collapse_ID = collapse_ID + 1
    end
    text = text .. id

    local show = args.contentShow
    if show == nil then
        show = true
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
            .. "<div class=\"echarts-above\">"
            .. above
            .. "</div>\n"
    end

    text = text
        .. "<div class=\"echarts-outter\""
        .. (args.height and (" style=\"" .. args.height .. ";\"") or " style=\"height:500px;\"")
        .. ">\n"
        .. "<div class=\"echarts\">"
        .. (args.option and mw.text.jsonEncode(args.option) or "{}")
        .. "</div>\n"
        .. "<div class=\"echarts-loading\"><i class=\"fa fa-circle-o-notch fa-spin fa-4x fa-fw\"></i></div>"
        .. "</div>\n"

    text = text .. "</div>\n</div>\n"

    return text
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
            borderWidth = 1,
            padding = {8, 10},
            extraCssText = "border-radius: 0;"
        },
        toolbox = {
            itemSize = 20,
            feature = {
                dataView = {
                    show = true,
                    readOnly = false
                },
                saveAsImage = {
                    show = true
                }
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
            }
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
            }
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
                    backgroundColor = Collapse.backgroundColor
                }
            },
            borderColor = Collapse.highlighting,
            borderWidth = 1,
            padding = {8, 10},
            extraCssText = "border-radius: 0;"
        },
        toolbox = {
            itemSize = 20,
            feature = {
                dataView = {
                    show = true,
                    readOnly = false
                },
                saveAsImage = {
                    show = true
                }
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
            }
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
            }
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

return Collapse