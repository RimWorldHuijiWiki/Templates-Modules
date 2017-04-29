local GenText = {}

-- Convert the float number to string
-- parameterstring.
-- f: float number
-- style: Integer, FloatOne, FloatTwo, PercentZero, PercentOne, PercentTwo, Temperature, TemperatureOffset, WorkAmount
-- numberSense: Undefined, Absolute, Factor, Offset
function GenText.toStringByStyle( f, style, numberSense )

    if f == nil or style == nil then
        return "GenText.toStringByStyle() error: invalid or empty parameter."
    end

    f = tonumber(f)
    if f == nil then return "GenText.toStringByStyle() error: invalid parameter 'f'." end

    if numberSense == nil then
        numberSense = "Absolute"
    end

    if style == "Temperature" and numberSense == "Offset" then
        style = "TemperatureOffset"
    end

    local text = ""

    if style == "Integer" then
        text = string.format("%.0f", f)
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
        text = GenText.toStringTemperature(f, "%.1f")
    elseif style == "WorkAmount" then
        text = GenText.toStringWorkAmount(f)
    else
        return "GenText.toStringByStyle() error: invalid parameter 'style'."
    end

    if numberSense == "Offset" then
        if f >= 0 then
            text = "+" .. text
        end
    elseif numberSense == "Factor" then
        text = "x" .. text
    end

    return text
end

function GenText.toStringDecimalIfSmall(f)

    local temp = math.abs(f)

    if temp < 1 then
        return string.format("%.2f", f)
    elseif temp < 10 then
        return string.format("%.1f", f)
    end

    return string.format("%.0f", f)
end

function GenText.toStringPercent(f, format)

    if format == nil then
        return GenText.toStringDecimalIfSmall(f * 100) .. "%"
    else
        return string.format(format, ((f + 0.00001) * 100)) .. "%"
    end

end

function GenText.toStringTemperature(celsiusTemp, format)

    if format == nil then
        format = "%.1f"
    end

    return string.format(format, celsiusTemp) .. "°C"
end

function GenText.toStringWorkAmount(workAmount)
    return tostring(math.ceil(workAmount / 60))
end

return GenText