local Def = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")

local GenText = require("Module:AC_GenText")

function Def:new(data)
    def = {}
    setmetatable(def, self)
    self.__index = self
    -- fields
    def.defType = SMW.show(data, "defType")
    if def.defType == nil then
        return nil
    end
    def.defName = SMW.show(data, "defName")
    def.label = SMW.show(data, def.defType .. ".label")
    def.label_zhcn = SMW.show(data, def.defType .. ".label.zh-cn")
    def.label_zhtw = SMW.show(data, def.defType .. ".label.zh-tw")
    def.description = SMW.show(data, def.defType .. ".description")
    def.description_zhcn = SMW.show(data, def.defType .. ".description.zh-cn")
    def.description_zhtw = SMW.show(data, def.defType .. ".description.zh-tw")
    return def
end

function Def:get_LabelCap()
    if self.label == nil or self.label == "" then
        return nil
    end
    if self.cachedLabelCap == nil or self.cachedLabelCap == "" then
        self.cachedLabelCap = GenText.capitalizeFirst(self.label)
    end
    return self.cachedLabelCap
end

function Def:toString()
    return self.defName
end

function Def:getSummary(defaultDesc)
    
    local text = "<p><strong>"
        .. self:get_LabelCap()
        .. "（" .. self.label_zhcn .. "，" .. self.label_zhtw .. "）"
        .. "</strong>"

    if self.description then
        text = text .. "：" .. self.description_zhcn
    elseif defaultDesc then
        text = text .. "：" .. defaultDesc
    end

    text = text .. "</p>"

    return text
end

function Def:getInfoBase()

    local args = {
        id = "infobase",
        title = "基本信息",
        headers = {{
            width = "128px"
        },{}},
        rows ={{
            cols = {"defType", self.defType}
        },{
            cols = {"defName", self.defName}
        }}
    }
    if self.label ~= nil then
        args.rows[3] = {cols = {"名称（英文）", self.label}}
        args.rows[4] = {cols = {"名称（简中）", self.label_zhcn}}
        args.rows[5] = {cols = {"名称（繁中）", self.label_zhtw}}
    end
    if self.description ~= nil then
        args.rows[6] = {cols = {"描述（英文）", self.description}}
        args.rows[7] = {cols = {"描述（简中）", self.description_zhcn}}
        args.rows[8] = {cols = {"描述（繁中）", self.description_zhtw}}
    end

    return Collapse.ctable(args)
end

return Def