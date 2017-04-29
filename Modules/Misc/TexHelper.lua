local p = {}

function p.GetIcon( frame )
    
    if frame.args[1] == nil then
        return "no parameter found."
    end

    local t = mw.text.split( frame.args[1], '/' )

    local result = '[[File:' .. t[#t] .. '.png|64px|link=]]'

    return result
end

function p.GetFile( frame )

    if frame.args[1] == nil then
        return "no parameter found."
    end

    local t = mw.text.split( frame.args[1], '/' )

    local result = t[#t] .. '.png'

    return result
end

return p