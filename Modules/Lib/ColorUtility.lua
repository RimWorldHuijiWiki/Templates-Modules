local ColorUtility = {}

local Color = require("Module:Color")

function ColorUtility.colorSet(count, startColor)
    startColor = startColor or "#f55f5f"
    local color = Color(startColor)
    local set = {startColor}
    local span = 360 / count
    for i = 1, count - 1 do
        set[i + 1] = color:hue_offset(span * i):tostring()
    end
    return set
end

return ColorUtility