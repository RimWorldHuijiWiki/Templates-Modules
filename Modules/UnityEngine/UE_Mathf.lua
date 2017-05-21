local Mathf = {}

function Mathf.clamp(value, min, max)
    if value < min then
        value = min
    elseif value > max then
        value = max
    end
    return value
end

-- Clamps value between 0 and 1 and returns value.
function Mathf.clamp01(value)
    if value < 0 then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end

-- Calculates the linear parameter t that produces the interpolant value within the range [a, b].
function Mathf.inverseLerp(a, b, value)
    if a ~= b then
        return Mathf.clamp01((value - a) / (b - a))
    end
    return 0
end

-- Linearly interpolates between a and b by t.
function Mathf.lerp(a, b, t)
    return a + (b - a) * Mathf.clamp01(t)
end

function Mathf.round(f, digits)

    if digits == nil then
        return math.floor(f + 0.5)    
    end
    
    if digits < 0 or digits > 15 then
        return f
    else
        local power = math.pow(10, math.floor(digits))
        return math.floor(f * power + 0.5) / power
    end
end

-- Returns f rounded to the nearest integer.
function Mathf.roundToInt(f)
    return math.floor(f + 0.5)
end

-- GenMath

function Mathf.lerpDouble(inFrom, inTo, outFrom, outTo, x)
    return outFrom + (outTo - outFrom) * ((x - inFrom) / (inTo - inFrom))
end

function Mathf.unboundedValueToFactor(val)
    if val > 0 then
        return 1 + val
    end
    return 1 / (1 - val)
end

return Mathf