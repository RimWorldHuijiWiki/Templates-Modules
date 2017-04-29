local GenText = {}

function GenText.capitalizeFirst(str)
    if str == nil or str == "" then
        return str
    end
    local first = string.sub(str, 1, 1)
    str = string.upper(first) .. string.sub(str, 2, -1)
    return str
end

return GenText