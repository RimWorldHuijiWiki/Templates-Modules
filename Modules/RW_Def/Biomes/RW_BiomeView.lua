local BiomeView = {}

local BiomeDef = require("Module:RW_BiomeDef")
local Textures = require("Module:Textures")

function BiomeView.view(frame)
    local def = BiomeDef:new(frame.args[1])

    local thumbnail = "<div class=\"rw-texture x128 rw-hexagon-x128\"><div class=\"rw-biome\">[[File:" .. Textures.getFileName(def.texture) .. "|link=]]</div></div>\n"

    text = def:getInfoBase(thumbnail) .. "\n<hr/>\n"
    
    text = text .. "<div class=\"row\">"
    
    text = text .. "<div class=\"col-md-6\">"
        .. def:showBasicArgs()
        .. "</div>"
    
    text = text .. "</div>"

    text = text .. def:showECharts()
    
    return text
end

return BiomeView