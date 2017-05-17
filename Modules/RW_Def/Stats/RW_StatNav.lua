local StatNav = {}

local Collapse = require("Module:RT_Collapse")

function StatNav.nav(frame)
    
    local statCates = mw.smw.ask("[[defType::StatCategoryDef]]|?StatCategoryDef.defName|?StatCategoryDef.label.zh-cn|mainlabel=-|headers=hide|link=none")
    local allStats = mw.smw.ask("[[defType::StatDef]]|?StatDef.defName|?StatDef.label.zh-cn|?StatDef.category|limit=200|mainlabel=-|headers=hide|link=none")

    local countStats = 0
    local countCates = 0
    local rows = {}
    for i, cate in pairs(statCates) do
        local cateDefName = cate["StatCategoryDef.defName"]
        local list = {}
        for i, stat in pairs(allStats) do
            if stat["StatDef.category"] == cateDefName then
                list[#list + 1] = "[[Stats_" .. stat["StatDef.defName"] .. "|" .. stat["StatDef.label.zh-cn"] .. "]]"
                countStats = countStats + 1 
            end
        end
        rows[#rows + 1] = {
            label = "[[StatCategories_" .. cateDefName .. "|" .. cate["StatCategoryDef.label.zh-cn"] .. "]]",
            list = list
        }
        countCates = countCates + 1
    end

    rows[#rows + 1] = {
        label = "总计",
        list = {
            countCates .. "个分类",
            countStats .. "个属性"
        }
    }

    return Collapse.navbox({
        id = "StatNav",
        title = "RimWorld 中的属性",
        above = "[[Stats|查看属性专题<i class=\"fa fa-arrow-right rw-btn-icon-right\" aria-hidden=\"true\"></i>]]",
        rows = rows
    })
end

return StatNav
