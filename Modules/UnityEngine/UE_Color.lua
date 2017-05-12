local Color = {}

local Mathf = require("Module:UE_Mathf")

function Color:new(r, g, b, a)
    local color = {
        r = r,
        g = g,
        b = b,
        a = a or 1
    }
    setmetatable(color, self)
    self.__index = self
    return color
end

function Color:toCSS()
    return "rgba("
        .. self.r .. ","
        .. self.g .. ","
        .. self.b .. ","
        .. self.a .. ")"
end

function Color:toBG()
    return "background-color:" .. self:toCSS() .. ";"
end

function Color.white()
    return Color:new(255, 255, 255, 1)
end

function Color.fromString(str)
    if str == nil or str == "" then
        Color.white()
    end
    str = str:gsub("[RGBA\(\) ]", "")
    local arr = mw.text.split(str, ",")
    local r = tonumber(arr[1])
    local g = tonumber(arr[2])
    local b = tonumber(arr[3])
    local flag = (r > 1 or g > 1 or b > 1)
    local a = (flag and 255 or 1)
    if #arr == 4 then
        a = tonumber(arr[4])
    end
    if flag then
        return Color:new(
            Mathf.roundToInt(r),
            Mathf.roundToInt(g),
            Mathf.roundToInt(b),
            Mathf.roundToInt(a) / 255
        )
    else
        return Color:new(
            Mathf.roundToInt(r * 255),
            Mathf.roundToInt(g * 255),
            Mathf.roundToInt(b * 255),
            a
        )
    end
end

return Color