local StatUtility = {}

function StatUtility.getStatFactorFromList(modList, stat)
    return StatUtility.getStatValueFromList(modList, stat, 1)
end

function StatUtility.getStatOffsetFromList(modList, stat)
    return StatUtility.getStatValueFromList(modList, stat, 0)
end

function StatUtility.getStatValueFromList(modList, stat, defaultValue)
    if modList ~= nil then
        for i, statModifier in pairs(modList) do
            if statModifier.stat == stat then
                return statModifier.value
            end
        end
    end
    return defaultValue
end

function StatUtility.statListContains(modList, stat)
    if modList ~= nil then
        for i, statModifier in pairs(modList) do
            if statModifier.stat == stat then
                return true
            end
        end
    end
    return false
end

return StatUtility