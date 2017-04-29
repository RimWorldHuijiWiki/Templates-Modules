local StatNav = {}

local Navbox = require("Module:Navbox")

function StatNav.nav(frame)
    
    local statCats = mw.smw.ask("[[defType::StatCategoryDef]]|?StatCategoryDef.defName|?StatCategoryDef.label.zh-cn|mainlabel=-|headers=hide|link=none")
    local stats = mw.smw.ask("[[defType::StatDef]]|?StatDef.defName|?StatDef.label.zh-cn|?StatDef.category|limit=200|mainlabel=-|headers=hide|link=none")

    if type(statCats) ~= "table" and type(stats) ~= "table" then
        return "Generate Navbox Error: SMW query result is invalid."
    end

    local countStats = 0
    local countCats = 0
    local navboxArgs = {}
    navboxArgs.name = "RW_StatNav"
    navboxArgs.title = "[[Stats|RimWorld 中的属性<i class=\"fa fa-arrow-circle-right\" aria-hidden=\"true\" style=\"margin-left:10px;\"></i>]]"
    for i, row in pairs(statCats) do
        local category = row["StatCategoryDef.defName"]
        navboxArgs["group" .. i] = "[[StatCategories_" .. category .. "|" .. row["StatCategoryDef.label.zh-cn"] .. "]]"
        local list = ""
        for j, sub in pairs(stats) do
            if sub["StatDef.category"] == category then
                list = list .. "[[Stats_" .. sub["StatDef.defName"] .. "|" .. sub["StatDef.label.zh-cn"] .. "]] | "
                countStats = countStats + 1
            end
        end
        if list == "" then
            navboxArgs["list" .. i] = "&nbsp;"
        else
            navboxArgs["list" .. i] = string.sub(list, 1, -4)
        end
        countCats = countCats + 1
    end
    navboxArgs["group" .. countCats + 1] = "总计"
    navboxArgs["list" .. countCats + 1] = countCats .. " 个分类，" .. countStats .. " 个属性"

    return Navbox._navbox(navboxArgs)
end

return StatNav
