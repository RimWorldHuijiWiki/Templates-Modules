local Color = {}
Color.__index = Color

function Color:new(r, g, b, a)
    local color = {
        r = r,
        g = g,
        b = b,
        a = a or 1
    }
    setmetatable(color, self)
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

function Color:get_SourceString()
    return self.sourceString or ""
end

function Color:toIcon()
    return "<span style=\"color: " .. self:toCSS() .. ";\"><i class=\"fa fa-file\" aria-hidden=\"true\"></i> " .. self:toCSS() .. "</span>"
end

function Color.white()
    return Color:new(255, 255, 255, 1)
end

function Color.fromString(sourceString)
    if sourceString == nil or sourceString == "" then
        return Color.white()
    end
    local arr = mw.text.split(sourceString:gsub("[RGBA\(\) ]", ""), ",")
    local r = tonumber(arr[1])
    local g = tonumber(arr[2])
    local b = tonumber(arr[3])
    local flag = (r > 1 or g > 1 or b > 1)
    local a = (flag and 255 or 1)
    if #arr == 4 then
        a = tonumber(arr[4])
    end
    local newColor
    if flag then
        newColor = Color:new(
            math.floor(r + 0.5),
            math.floor(g + 0.5),
            math.floor(b + 0.5),
            math.floor(a + 0.5) / 255
        )
    else
        newColor = Color:new(
            math.floor(r * 255 + 0.5),
            math.floor(g * 255 + 0.5),
            math.floor(b * 255 + 0.5),
            a
        )
    end
    newColor.sourceString = sourceString
    return newColor
end

return Color