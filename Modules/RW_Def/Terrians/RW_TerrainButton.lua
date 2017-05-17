local TerrainButton = {}

local SMW = require("Module:SMW")
local Color = require("Module:UE_Color")
local Textures = require("Module:Textures")

function TerrainButton.buttonX(frame)
    return TerrainButton.button(frame.args[1])
end

function TerrainButton.button(defName, texturePath, color, label)
    local data = "Core:Defs_TerrainDef_" .. defName
    local text = "<div class=\"rw-lbtn\">\n"
    if defName == "Underwall" then
        text = text .. "<div class=\"rw-lbtn-icon\" style=\"background-color: #4a4a4a;\"></div>\n"
    elseif defName == "WaterDeep"
        or defName == "WaterMovingDeep"
        or defName == "WaterOceanDeep" then
        text = text
            .. "<div class=\"rw-lbtn-icon\">\n"
            .. "<div class=\"x256-128\">[[File:Captures_Terrains_WaterDeep.gif|link=]]</div>\n"
            .. "</div>\n"
    elseif defName == "WaterShallow"
        or defName == "WaterMovingShallow"
        or defName == "WaterOceanShallow" then
        text = text
            .. "<div class=\"rw-lbtn-icon\">\n"
            .. "<div class=\"x256-128\">[[File:Captures_Terrains_WaterShallow.gif|link=]]</div>\n"
            .. "</div>\n"
    else
        text = text
            .. "<div class=\"rw-lbtn-icon\">\n"
            .. "<div class=\"rw-terrain\">[[File:" .. Textures.getFileName(texturePath or SMW.show(data, "TerrainDef.texturePath")) .. "|link=]]</div>\n"
            .. "<div class=\"rw-icon-blend\" style=\"" .. (color or Color.fromString(SMW.show(data, "TerrainDef.color"))):toBG() .. "\"></div>\n"
            .. "</div>\n"
    end
    text = text
        .. "<div class=\"rw-lbtn-label\">" .. (label or SMW.show(data, "TerrainDef.label.zh-cn")) .. "</div>\n"
        .. "<div class=\"rw-lbtn-link\">[[Terrains_" .. defName .. "|&nbsp;]]</div>\n"
        .. "</div>\n"
    return text
end

return TerrainButton