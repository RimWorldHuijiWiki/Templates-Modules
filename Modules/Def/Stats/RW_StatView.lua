local StatView = {}
local StatDef = require("Module:RW_StatDef")

function StatView.view(frame)
    local def = StatDef:new(frame.args[1])
    local text = ""
        .. def:getSummary()
        .. "\n"
        .. def:getInfoBase()
        .. "\n<hr/>\n"
    
    -- Section 1
    text = text .. "<div class=\"row\">\n"
    
    -- Base Args
    local argBases = "<div class=\"col-md-4\">\n<h3>基本参数</h3>\n<table class=\"wikitable rw-infobase\">\n<tr><th style=\"width:60%\">参数</th><th style=\"width:40%\">值</th></tr>\n"
    argBases = argBases .. "<tr><td>是否显示在单位上</td><td>" .. (def.showOnPawns and "是" or "否") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>是否显示在人类上</td><td>" .. (def.showOnHumanlikes and "是" or "否") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>是否显示在动物上</td><td>" .. (def.showOnAnimals and "是" or "否") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>是否显示在机械体上</td><td>" .. (def.showOnMechanoids and "是" or "否") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>格式化显示字符串</td><td>" .. (def.formatString or "") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>默认基础值</td><td>" .. (def.defaultBaseValue or "") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>最小值</td><td>" .. (def.minValue or "") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>最大值</td><td>" .. (def.maxValue or "") .. "</td></tr>\n"
    argBases = argBases .. "<tr><td>系数属性</td><td>" .. (def.maxValue or "") .. "</td></tr>\n"
    argBases = argBases .. "</table></div>"
    text = text .. argBases
    -- Base Args end

    text = text .. "</div>"
    -- Section 1 end

    return text
end

return StatView