local StatExtension = {}

function StatExtension.getStatValue(thing, stat, applyPostProcess)
    if applyPostProcess == nil then
        applyPostProcess = true
    end
    return stat:get_Worker():getValue(thing, applyPostProcess)
end

function StatExtension.getStatValueAbstract(def, stat, stuff)
    return stat:get_Worker():getValueAbstract(def, stuff)
end

return StatExtension