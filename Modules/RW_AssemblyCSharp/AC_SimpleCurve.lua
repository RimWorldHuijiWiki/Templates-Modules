local SimpleCurve = {}
SimpleCurve.__index = SimpleCurve

local Mathf = require("Module:UE_Mathf")

function SimpleCurve:new(points)

    if type(points) == "table" then
        for i, p in pairs(points) do
            points[i] = {
                x = p[1],
                y = p[2]
            }
        end
        table.sort(points, function(a, b) return a.x < b.x end)
        local curve = {points = points}
        setmetatable(curve, self)
        return curve
    end

    if type(points) == "string" then
        local curve = {}
        setmetatable(curve, self)
        -- fields
        points = string.sub(points, 2, -2)
        points = mw.text.split(points, "\",\"")
        for i, p in pairs(points) do
            p = mw.text.split(string.sub(p, 2, -2), ",")
            points[i] = {
                x = tonumber(p[1]),
                y = tonumber(p[2])
            }
        end
        table.sort(points, function(a, b) return a.x < b.x end)
        curve.points = points
        return curve
    end

end

function SimpleCurve:pointsCount()
    local points = self.points
    return #points
end

function SimpleCurve:evaluate(x)
    local points = self.points
    local count = #points
    if count == 0 then
        return 0
    end
    if x <= points[1].x then
        return points[1].y
    end
    if x >= points[count].x then
        return points[count].y
    end
    local curvePoint1 = points[1]
    local curvePoint2 = points[count]
    for i = 1, count do
        if x <= points[i].x then
            if i > 1 then
                curvePoint1 = points[i - 1]
            end
            curvePoint2 = points[i]
            break
        end
    end
    local t = (x - curvePoint1.x) / (curvePoint2.x - curvePoint1.x)
    return Mathf.lerp(curvePoint1.y, curvePoint2.y, t)
end

function SimpleCurve:toString()
    local text = ""
    for i, p in pairs(self.points) do
        text = text .. "(" .. p.x .. ", " .. p.y .. "), "
    end
    return string.sub(text, 1, -3)
end

return SimpleCurve