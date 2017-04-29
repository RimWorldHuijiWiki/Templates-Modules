local StatDef = {}

local GenText = require("Module:GenText")

function StatDef.valueToString( statDef, val, numberSense )

    local toStringStyle = mw.swm.ask("[[Core:Defs_StatDef_" .. statDef .. "]]|?StatDef.toStringStyle|mainlabel=-|headers=hide")

    local formatString = mw.swm.ask("[[Core:Defs_StatDef_" .. statDef .. "]]|?StatDef.formatString.zh-cn|mainlabel=-|headers=hide")

    local text = GenText.ToStringByStyle(val, toStringStyle, numberSense)

    if formatString then
        text = string.gsub(formatString, "{0}", text)
    end

    return text
end

return StatDef