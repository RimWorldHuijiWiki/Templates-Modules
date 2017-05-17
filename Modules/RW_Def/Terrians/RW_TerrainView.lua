local TerrainView = {}

local TerrainDef = require("Module:RW_TerrainDef")

local SMW = require("Module:SMW")
local Keyed_zhcn = require("Module:Keyed_zhcn")
local Textures = require("Module:Textures")
local Collapse = require("Module:RT_Collapse")

local GenText = require("Module:AC_GenText")

function TerrainView.getLink(terrainDefName)
    if terrainDefName == nil or terrainDefName == "" then
        return ""
    end
    return "[[Terrains_" .. terrainDefName .. "|" .. SMW.show("Core:Defs_TerrainDef_" .. terrainDefName, "TerrainDef.label.zh-cn") .. "]]"
end

function TerrainView.view(frame)

    local def = TerrainDef:new(frame.args[1])

    local text = ""

    local defName = def.defName
    local thumbnail
    if defName == "Underwall" then
        thumbnail = "<div class=\"rw-texture x256-128\" style=\"background-color: #4a4a4a;\"></div>\n"
    elseif defName == "WaterDeep"
        or defName == "WaterMovingDeep"
        or defName == "WaterOceanDeep" then
        thumbnail = "[[File:Captures_Terrains_WaterDeep.gif|link=]]"
    elseif defName == "WaterShallow"
        or defName == "WaterMovingShallow"
        or defName == "WaterOceanShallow" then
        thumbnail = "[[File:Captures_Terrains_WaterShallow.gif|link=]]"
    else
        thumbnail = "<div class=\"rw-texture x256-128\">\n"
            .. "<div class=\"rw-terrain\">[[File:" .. Textures.getFileName(def.texturePath) .. "|link=]]</div>\n"
            .. "<div class=\"rw-icon-blend\" style=\"" .. def.color:toBG() .. "\"></div>\n"
            .. "</div>\n"
    end

    text = text .. def:getInfoBase(thumbnail)
    text = text .. "<hr/>\n"
    text = text .. "<div class=\"row\">\n"

    text = text .. "<div class=\"col-md-6\">\n"
    text = text .. Collapse.ctable({
        id = def.defName .. "-basicArgs",
        title = "基础参数",
        headers = {{
            text = "参数",
            width = "40%"
        },{
            text = "值",
            width = "30%"
        },{
            text = "显示",
            width = "30%"
        }},
        rows = {{
            cols = {
                "可通行性",
                (def.passability or ""),
                GenText.enumTraversabilityToString(def.passability)
            }
        },{
            cols = {
                "途经消耗 / " .. Keyed_zhcn.trans("WalkSpeed", ""),
                (def.pathCost or ""),
                (def.pathCost and GenText.toStringPercent(13 / (def.pathCost + 13)) or "100%")
            }
        },{
            cols = {
                Keyed_zhcn.trans("FertShort"),
                def.fertility,
                GenText.toStringPercent(def.fertility)
            }
        },{
            cols = {
                "贴图",
                {
                    text = Textures.getLink(def.texturePath),
                    span = 2
                }
            }
        },{
            cols ={
                "颜色（正片叠底）",
                def.color:get_SourceString(),
                def.color:toIcon()
            }
        },{
            cols = {
                "边缘类型",
                (def.edgeType or ""),
                GenText.enumTerrainEdgeTypeToString(def.edgeType)
            }
        },{
            cols = {
                "脚印",
                def.takeFootprints,
                GenText.booleanToIcon(def.takeFootprints)
            }
        },{
            cols = {
                "水花",
                def.takeSplashes,
                GenText.booleanToIcon(def.takeSplashes)
            }
        },{
            cols = {
                "阻止闲逛",
                def.avoidWander,
                GenText.booleanToIcon(def.avoidWander)
            }
        },{
            cols = {
                "积雪",
                def.holdSnow,
                GenText.booleanToIcon(def.holdSnow)
            }
        },{
            cols = {
                "产生污物",
                (def.terrainFilthDef or ""),
                (def.terrainFilthDef and ("[[Filth_" .. def.terrainFilthDef .. "|" .. SMW.show("Core:Defs_ThingDef_" .. def.terrainFilthDef, "ThingDef.label.zh-cn") .. "]]") or "")
            }
        },{
            cols = {
                "接受污物（地面源）",
                def.acceptTerrainSourceFilth,
                GenText.booleanToIcon(def.acceptTerrainSourceFilth)
            }
        },{
            cols = {
                "接受污物",
                def.acceptFilth,
                GenText.booleanToIcon(def.acceptFilth)
            }
        },{
            cols = {
                "可否移除",
                def.layerable,
                GenText.booleanToIcon(def.layerable)
            }
        },{
            cols = {
                "可否改变",
                def.changeable,
                GenText.booleanToIcon(def.changeable)
            }
        },{
            cols = {
                "打磨后",
                (def.smoothedTerrain or ""),
                TerrainView.getLink(def.smoothedTerrain)
            }
        },{
            cols = {
                "排水后",
                (def.driesTo or ""),
                TerrainView.getLink(def.driesTo)
            }
        },{
            cols = {
                "燃烧后",
                (def.burnedDef or ""),
                TerrainView.getLink(def.burnedDef)
            }
        },{
            cols = {
                "提供的地面用途预设",
                {
                    text = (def.affordances and table.concat(def.affordances, ", ") or ""),
                    span = 2
                }
            }
        }}
    })
    text = text .. "</div>\n"

    TerrainDef.init(require("Module:RW_ThingDef"), require("Module:RW_StatDef"), require("Module:RW_StuffCategoryDef"), Collapse)
    def:prepareCost()

    text = text .. "<div class=\"col-md-6\">\n"
    text = text .. def:showStats(true)
    text = text .. "</div>\n"

    text = text .. "<div class=\"col-md-6\">\n"
    text = text .. def:showCost()
    text = text .. "</div>\n"

    text = text .. "</div>\n"

    return text
end

return TerrainView