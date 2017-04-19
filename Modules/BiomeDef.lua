local p = {}

-- {{#invoke:BiomeDef|getTable_terrainsByFertility|<defName>}}
function p.getTable_terrainsByFertility( frame )
    
    if not mw.smw then
        return "mw.smw module not found"
    end

    if frame.args[1] == nil then
        return "no parameter found"
    end

    local exit = mw.smw.getQueryResult( '[[dataType::Def]][[defType::BiomeDef]][[defName::' ..  frame.args[1] .. ']]|?BiomeDef.terrainsByFertility|mainlabel=-|headers=hide|link=none' );

    if type( exit ) == 'table' then
        for num, row in pairs( exit ) do
            if row == 'Exist' then
                return '<tr><td>Exist</td></tr>'
            end
            for prop, values in pairs( row ) do
                if values == 'Exist' then
                    return '<tr><td>Exist</td></tr>'
                end
            end
        end
    end

end