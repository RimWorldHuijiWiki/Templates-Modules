local Keyed = {}

local SMW = require("Module:SMW")

function Keyed.enX(frame)
    return Keyed.en(frame.args[1], frame.args[2])
end

function Keyed.en(key, args)

    if key == nil then
        return key
    end

    local content = mw.title.new("Keyed:English_json"):getContent()
    
    local data = mw.text.jsonDecode(content)

    local text = data[key]

    if text ~= nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

function Keyed.zhcnX(frame)
    return Keyed.zhcn(frame.args[1], frame.args[2])
end

function Keyed.zhcn(key, args)

    if key == nil then
        return key
    end

    local content = mw.title.new("Keyed:ChineseSimplified_json"):getContent()
    
    local data = mw.text.jsonDecode(content)

    local text = data[key]

    if text ~= nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

function Keyed.zhtwX(frame)
    return Keyed.zhtw(frame.args[1], frame.args[2])
end

function Keyed.zhtw(key, args)

    if key == nil then
        return key
    end

    local content = mw.title.new("Keyed:ChineseTraditional_json"):getContent()
    
    local data = mw.text.jsonDecode(content)

    local text = data[key]

    if text ~= nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

function Keyed.enSX(frame)
    return Keyed.enS(frame.args[1], frame.args[2])
end

function Keyed.enS(key, args)

    if key == nil then
        return key
    end

    local text = SMW.show("Keyed:English_smw", "Keyed." .. key)

    if text ~=nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

function Keyed.zhcnSX(frame)
    return Keyed.zhcnS(frame.args[1], frame.args[2])
end

function Keyed.zhcnS(key, args)

    if key == nil then
        return key
    end

    local text = SMW.show("Keyed:ChineseSimplified_smw", "Keyed." .. key)

    if text ~=nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

function Keyed.zhtwSX(frame)
    return Keyed.zhtwS(frame.args[1], frame.args[2])
end

function Keyed.zhtwS(key, args)

    if key == nil then
        return key
    end

    local text = SMW.show("Keyed:ChineseTraditional_smw", "Keyed." .. key)

    if text ~=nil then
        if args ~= nil then
            local t = mw.text.split(args, ",")
            for i, a in pairs(t) do
                text = string.gsub( text, "{" .. tostring(i - 1) .. "}", a)
            end
            return text
        else
            return text
        end
    else
        return key
    end

end

return Keyed