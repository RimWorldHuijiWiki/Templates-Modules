local p = {}

-- {{#invoke:StatHelper|Getter|<defType>|<defName>|<statDef>}}
function p.Getter(frame)

    if not mw.smw then
        return "mw.smw module not found"
    end
    
    if frame.args[1] == nil or frame.args[2] == nil or frame.args[3] == nil then
        return "no parameter found."
    end

    --{{#ask:[[dataType::Def]][[defType::TerrainDef]][[defName::SilverTile]]|?TerrainDef.statBases|mainlabel=-|headers=hide|link=none}}
    local queryResult = mw.smw.ask('[[dataType::Def]][[defType::' .. frame.args[1] .. ']][[defName::' .. frame.args[2] .. ']]|?' .. frame.args[1] .. '.statBases|mainlabel=-|headers=hide|link=none}}')

    if type(queryResult) == 'table' then
        for n, row in pairs(queryResult) do
            for propName, propValue in pairs(row) do
                local dict = mw.text.split(propValue, ';')
                for m, kvp in pairs(dict) do
                    local t = mw.text.split(kvp, ',')
                    if string.sub(t[1], 2, -2) == frame.args[3] then
                        return string.sub(t[2], 2, -2)
                    end
                end
            end
        end
    end

    return '0'
end

-- {{#invoke:StatHelper|GetValue|<statDef>|<data>|<stuffDef>|<quality>}}
function p.getValue(frame)

    if not mw.smw then
        return "mw.smw module not found"
    end

    if frame.args[1] == nil or frame.args[2] == nil then
        return 'invalid parameters.'
    end

    local stat = frame.args[1]

    if not mw.smw.ask('[[' .. stat .. ']]|?defType|mainlabel=-|headers=hide') then
        return 'invalid stat def.'
    end

    local data = frame.args[2]

    local defType = mw.smw.ask('[[' .. data .. ']]|?defType|mainlabel=-|headers=hide')

    if defType ~= 'ThingDef' and defType ~= 'TerrainDef' then
        return 'invalid data page.'
    end

    local stuff = frame.args[3]

    if stuff == nil or stuff == 'null' then
        stuff = nil
    else
        stuff = 'Core:Defs_ThingDef_' .. stuff
        if not mw.smw.ask('[[' .. stuff .. ']]|?defType|mainlabel=-|headers=hide') then
            return 'invalid stuff def.'
        end
    end

    local quality = frame.args[4]

    if quality == nil then
        quality = 'Normal'
    elseif not p.isValidQuality(quality) then 
        return 'invalid quality category.'
    end

    

    return ''
end

function p.isValidQuality(quality)
    if quality == 'Awful' then return true end
    if quality == 'Shoddy' then return true end
    if quality == 'Poor' then return true end
    if quality == 'Normal' then return true end
    if quality == 'Good' then return true end
    if quality == 'Superior' then return true end
    if quality == 'Excellent' then return true end
    if quality == 'Masterwork' then return true end
    if quality == 'Legendary' then return true end
end

return p