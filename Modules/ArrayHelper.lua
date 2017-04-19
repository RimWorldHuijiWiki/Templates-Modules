local p = {}

-- {{#invoke:ArrayHelper|indexs|count}}
function p.indexs( frame )
    
    if ( frame.args[1] == nil or tonumber( frame.args[1] ) <= 0  ) then
        return '0'
    end

    local result = {}

    for i = 0, tonumber( frame.args[1] ) - 1 do
        result[#result + 1] = tostring(i)
    end

    return table.concat( result, ',' )

end

return p