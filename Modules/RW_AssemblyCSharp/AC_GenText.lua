local GenText = {}

local Mathf = require("Module:UE_Mathf")

-- 首字母大写
function GenText.capitalizeFirst(str)
    if str == nil or str == "" then
        return str
    end
    local first = string.sub(str, 1, 1)
    str = string.upper(first) .. string.sub(str, 2, -1)
    return str
end

-- 将值转换成指定形式的字符串
function GenText.toStringByStyle(f, style, numberSense)

    if f == nil then
        return "N/A"
    end

    if numberSense == nil or numberSense == "" then
        numberSense = "Absolute"
    end

    if style == "Temperature" and numberSense == "Offset" then
        style = "TemperatureOffset"
    end

    local text

    if style == "Integer" then
        text = Mathf.roundToInt(f)
    elseif style == "FloatOne" then
        text = string.format("%.1f", f)
    elseif style == "FloatTwo" then
        text = string.format("%.2f", f)
    elseif style == "PercentZero" then
        text = GenText.toStringPercent(f)
    elseif style == "PercentOne" then
        text = GenText.toStringPercent(f, "%.1f")
    elseif style == "PercentTwo" then
        text = GenText.toStringPercent(f, "%.2f")
    elseif style == "Temperature" then
        text = GenText.toStringTemperature(f, "%.1f")
    elseif style == "TemperatureOffset" then
        text = GenText.toStringTemperatureOffset(f, "%.1f")
    elseif style == "WorkAmount" then
        text = GenText.toStringWorkAmount(f)
    else
        text = tostring(f)
    end

    if numberSense == "Offset" then
        if f > 0 then
            text = "+" .. text
        end
    elseif numberSense == "Factor" then
        text = "x" .. text
    end

    return text
end

function GenText.toStringDecimalIfSmall(f)
    local a = math.abs(f)
    if a < 1 then
        return string.format("%.2f", (Mathf.round(f, 2)))
    end
    if a > 10 then
        return string.format("%.1f", (Mathf.round(f, 1)))
    end
    return tostring(Mathf.roundToInt(f))
end

function GenText.toStringPercent(f, format)
    if format == nil then
        return GenText.toStringDecimalIfSmall(f * 100) .. "%"
    end
    return string.format(format, (f + 0.00001) * 100) .. "%"
end

function GenText.toStringTemperature(celsiusTemp, format)
    if format == nil then
        format = "%.1f"
    end
    return string.format(format, celsiusTemp) .. "℃"
end

function GenText.toStringTemperatureOffset(celsiusTemp, format)
    if format == nil then
        format = "%.1f"
    end
    return string.format(format, celsiusTemp) .. "℃"
end

function GenText.toStringWorkAmount(workAmount)
    return tostring(math.ceil(workAmount / 60)) .. " 秒"
end

-- boolean to icon

function GenText.booleanToIcon(value)
    return (value and "<i class=\"fa fa-check\" aria-hidden=\"true\"></i>" or "<i class=\"fa fa-times\" aria-hidden=\"true\"></i>")
end

-- enum to string

function GenText.enumTraversabilityToString(passability)
    if passability == "Standable" then
        return "可站立"
    elseif passability == "PassThroughOnly" then
        return "仅可通行"
    elseif passability == "Impassable" then
        return "不可通行"
    else
        return ""
    end
end

function GenText.enumTerrainEdgeTypeToString(edgeType)
    if edgeType == "Hard" then
        return "锐利"
    elseif edgeType == "Fade" then
        return "淡出"
    elseif edgeType == "FadeRough" then
        return "粗糙淡出"
    elseif edgeType == "FadeRough" then
        return "水面"
    else
        return ""
    end
end

return GenText