local BiomeNav = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")

function BiomeNav.nav(frame)
    return Collapse.navbox({
        id = "BiomeNav",
        title = "RimWorld 中的生态区",
        above = "[[Biomes|查看生态区专题<i class=\"fa fa-arrow-right rw-btn-icon-right\" aria-hidden=\"true\"></i>]]",
        rows = {{
            label = "干旱",
            list = {
                "[[Biomes_AridShrubland|" .. SMW.show("Core:Defs_BiomeDef_AridShrubland", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_Desert|" .. SMW.show("Core:Defs_BiomeDef_Desert", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_ExtremeDesert|" .. SMW.show("Core:Defs_BiomeDef_ExtremeDesert", "BiomeDef.label.zh-cn") .. "]]",
            }
        },{
            label = "寒冷",
            list = {
                "[[Biomes_BorealForest|" .. SMW.show("Core:Defs_BiomeDef_BorealForest", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_Tundra|" .. SMW.show("Core:Defs_BiomeDef_Tundra", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_IceSheet|" .. SMW.show("Core:Defs_BiomeDef_IceSheet", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_SeaIce|" .. SMW.show("Core:Defs_BiomeDef_SeaIce", "BiomeDef.label.zh-cn") .. "]]",                
            }
        },{
            label = "中性",
            list = {
                "[[Biomes_TemperateForest|" .. SMW.show("Core:Defs_BiomeDef_TemperateForest", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_TropicalRainforest|" .. SMW.show("Core:Defs_BiomeDef_TropicalRainforest", "BiomeDef.label.zh-cn") .. "]]",                
            }
        },{
            label = "无法着陆",
            list = {
                "[[Biomes_Ocean|" .. SMW.show("Core:Defs_BiomeDef_Ocean", "BiomeDef.label.zh-cn") .. "]]",
                "[[Biomes_Lake|" .. SMW.show("Core:Defs_BiomeDef_Lake", "BiomeDef.label.zh-cn") .. "]]",                
            }
        }}
    })
end

return BiomeNav