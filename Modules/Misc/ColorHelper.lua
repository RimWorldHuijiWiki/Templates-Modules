local ColorHelper = {}

function ColorHelper.getColor( frame )

    if frame.args[1] == nil or frame.args[1] == "" then
        return "rgb(255,255,255)"
    end

    local t = mw.text.split( string.sub( mw.text.trim( frame.args[1] ), 2, -2 ), ',' )

    if #t < 3 then
        return "paremeter error."
    end

    local flag = false

    for i=1,3 do
        t[i] = mw.text.trim( t[i] )
    end

    for i=1,3 do
        local n = tonumber( t[i] )
        if n < 1 then
            flag = true
        end
    end

    if flag then
        for i=1,3 do
            t[i] = tostring( math.ceil( 255 * tonumber( t[i] ) ) )
        end
    end

    if #t == 3 then
        return 'rgb(' .. table.concat( t, ", " ) .. ')'
    elseif #t == 4 then
        return 'rgba(' .. table.concat( t, ", " ) .. ')'
    else
        return "paremeter error."
    end

end

function ColorHelper.getBackground( frame )
    return 'background-color: ' .. ColorHelper.getColor( frame ) .. ';'
end

function ColorHelper.getIcon( frame )
    local c = ColorHelper.getColor( frame )
    return '<div style="display:inline-block;width:16px;height:16px;background-color:#fff;"><div style="width:100%;height:100%;background-color:' .. c ..'"></div></div> ' .. c
end

return ColorHelper