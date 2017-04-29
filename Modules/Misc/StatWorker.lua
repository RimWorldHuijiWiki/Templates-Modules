local StatWorker = {}

local SMW = require("Module:SMW")

function StatWorker.getBaseValueForX(frame)
    return StatWorker.getBaseValueFor(frame.args[1], frame.args[2])
end

function StatWorker.getBaseValueFor( statDef, defData )

    local result = SMW.show("Core:Defs_StatDef_" .. statDef, "StatDef.defaultBaseValue")

    local defType = SMW.show(defData, "defType")

    local statBases = SMW.show(defData, defType .. ".statBases")

    if statBases then
        local d = mw.text.split(statBases, ";")
        for i, kvp in pairs(d) do
            local t = mw.text.split(kvp, ",")
            if t[1] == "\"" .. statDef .."\"" then
                result = string.sub(t[2], 2, -2)
                break
            end
        end
    end

    return result
end

return StatWorker