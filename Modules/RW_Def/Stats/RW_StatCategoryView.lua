local StatCategoryView = {}
local StatCategoryDef = require("Module:RW_StatCategoryDef")

-- local SMW = require("Module:SMW")

function StatCategoryView.view(frame)
    local def = StatCategoryDef:new(frame.args[1])
    local text = ""
        .. def:getSummary(def.label_zhcn .. "属性的分类。")
        .. "\n"
        .. def:getInfoBase()
        .. "\n<hr/>\n"
    local stats = mw.smw.ask("[[defType::StatDef]]|?StatDef.defName|?StatDef.category|?StatDef.label.zh-cn|limit=200|mainlabel=-|headers=hide|link=none")
    if type(stats) == "table" then
        local statsTable = "<div class=\"row\">\n<div class=\"col-md-4\">\n<table class=\"wikitable rw-infobase\">\n<tr><th>属于此分类下的属性</th></tr>\n"
        for i, row in pairs(stats) do
            if row["StatDef.category"] == def.defName then
                statsTable = statsTable .. "<tr><td>[[Stats_" .. row["StatDef.defName"] .. "|" .. row["StatDef.label.zh-cn"] .. "]]</td></tr>\n"
            end
        end
        statsTable = statsTable .. "</table>\n</div>\n</div>\n"
        text = text .. statsTable
    end
    return text
end

return StatCategoryView