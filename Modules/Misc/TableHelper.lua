local TableHelper = {}

local SMW = require("Module:SMW")

--{{#invoke:TableHelper|GetRows|<page>|<prop>|<propDefType>|<linkHeader>}}
function TableHelper.getRows( frame )

    if not frame.args[1] or not frame.args[2] or not frame.args[3] then
        return "<tr><td>Error</td><td>no parameter found.</td></tr>"
    end

    local page = frame.args[1]

    local defType = SMW.show(page, "defType")
    if defType == nil then
        return "<tr><td>Error</td><td>data page no found or has no 'defType' property.</td></tr>"
    end
    
    local queryResult = SMW.show(frame.args[1], frame.args[2])

    if queryResult == nil then
        return "<tr><td>（无）</td><td>（无）</td></tr>"
    end

    local result = ""

    local propDefType = frame.args[3]

    local linkHeader = frame.args[4]

    local dict = mw.text.split(queryResult, ";")

    if linkHeader then
        for i, kvp in pairs(dict) do
            kvp = mw.text.split(kvp, ",")
            def = string.sub(kvp[1], 2, -2)
            val = string.sub(kvp[2], 2, -2)
            label = SMW.show("Core:Defs_" .. propDefType .. "_" .. def, propDefType .. ".label.zh-cn", def)
            result = result .. "<tr><td>[[" .. linkHeader .. def .. "|" .. label .. "]]</td><td>" .. val .. "</td></tr>"
        end
    else
        for i, kvp in pairs(dict) do
            kvp = mw.text.split(kvp, ",")
            def = string.sub(kvp[1], 2, -2)
            val = string.sub(kvp[2], 2, -2)
            label = SMW.show("Core:Defs_" .. propDefType .. "_" .. def, propDefType .. ".label.zh-cn", def)
            result = result .. "<tr><td>" .. label .. "</td><td>" .. val .. "</td></tr>"
        end
    end

    return result
end

--{{#invoke:TableHelper|GetRows|<linkHeader>|<defType>|<keyValuePairs>}}
function TableHelper.GetRows( frame )

    if not mw.smw then
        return '<tr><td>Error</td><td>mw.smw module not found.</td><tr>'
    end

    if frame.args[1] == nil or frame.args[2] == nil or frame.args[3] == nil then
        return '<tr><td>Error</td><td>no parameter found.</td><tr>'
    end

    local linkHeader = frame.args[1]

    local defType = frame.args[2]

    local dict = mw.text.split( frame.args[3], ';' )

    local result = ''

    for n, kvp in pairs(dict) do
        local t = mw.text.split( kvp, ',' )
        local defName = string.sub( t[1], 2, -2 )
        local label = ''

        local queryResult = mw.smw.ask( '[[dataType::Def]][[defType::' .. defType .. ']][[defName::' .. defName .. ']]|?' .. defType .. '.label.zh-cn|mainlabel=-|headers=hide|link=none}}' )
        if type( queryResult ) == 'table' then
            for n, row in pairs( queryResult ) do
                for propName, propValue in pairs( row ) do
                    label = propValue
                    break
                end
            end
        end

        if label == '' then
            label = defName
        end
        
        result = result .. '<tr><td>[[' .. linkHeader .. defName .. '|' .. label .. ']]</td><td>' .. string.sub( t[2], 2, -2 ) .. '</td></tr>'
    end

    return result
end

return TableHelper