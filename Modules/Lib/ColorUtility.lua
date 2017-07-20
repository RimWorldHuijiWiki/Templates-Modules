local ColorUtility = {}

local Color = require("Module:Color")

function ColorUtility.colorSet(count, startColor)
    count = count or 7
    startColor = startColor or "#ff6666"
    local color = Color(startColor)
    local set = {startColor}
    local span = 360 / count
    for i = 1, count - 1 do
        set[i + 1] = color:hue_offset(span * i):tostring()
    end
    return set
end

function ColorUtility.demo(frame)
    local set = ColorUtility.colorSet(360, frame.args[1])
    local text = '<table style="width:100%;">\n'
    for i = 1, 360, 10 do
        text = text .. '<tr>'
        for j = i, i + 9 do
            text = text .. '<td style="color:' .. set[j] .. ';">' .. set[j] .. '</td>'
        end
        text = text .. '</tr>\n'
    end
    text = text .. '</table>'
    return text
end

return ColorUtility