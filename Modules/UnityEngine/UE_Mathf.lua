local Mathf = {}

-- Clamps value between 0 and 1 and returns value.
function Mathf.Clamp01(value)
    if value < 0 then
        return 0
    end
    if value > 1 then
        return 1
    end
    return value
end

-- Linearly interpolates between a and b by t.
function Mathf.lerp(a, b, t)
    return a + (b - a) * Mathf.Clamp01(t)
end

return Mathf