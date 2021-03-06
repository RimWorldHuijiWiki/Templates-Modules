local Keyed_zhcn = {}

local dict = mw.loadData("Module:Keyed_zhcn_dict")

-- for lua
function Keyed_zhcn.trans(...)

    local args = {...}

    local key = args[1]

    if key == nil or key == "" then
        return ""
    end

    local text = dict[key]

    if text ~= nil then
        if args[2] ~= nil then
            for i = 2, #args do
                text = string.gsub(text, "{" .. (i - 2) .. "}", args[i] )
            end
        end
        return text
    end

    return key
end

-- for mw invoke
function Keyed_zhcn.transX(frame)

    local args = frame.args

    local key = args[1]

    if key == nil or key == "" then
        return ""
    end

    local text = dict[key]

    if text ~= nil then
        if args[2] ~= nil then
            for i, val in pairs(args) do
                if i > 1 then
                    text = string.gsub(text, "{" .. (i - 2) .. "}", val )
                end
            end
        end
        return text
    end

    return key
end

return Keyed_zhcn