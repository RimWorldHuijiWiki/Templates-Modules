local Def = {}

local SMW = require("Module:SMW")
local Navbox = require("Module:Navbox")

local GenText = require("Module:AC_GenText")

function Def:new( data )
    def = {}
    setmetatable(def, self)
    self.__index = self
    -- fields
    def.defType = SMW.show(data, "defType")
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
    
    local text = "<strong>"
        .. self:get_LabelCap()
        .. "（" .. self.label_zhcn .. " " .. self.label_zhtw .. "）"
        .. "</strong>"

    if self.description then
        text = text .. "：" .. self.description_zhcn
    elseif defaultDesc then
        text = text .. "：" .. defaultDesc
    end

    return text
end

function Def:getInfoBase()

    local navboxArgs = {}

    navboxArgs.name = "Infobase"
    navboxArgs.title = "基本信息"
    navboxArgs.group1 = "defType"
    navboxArgs.list1 = self.defType
    navboxArgs.group2 = "defName"
    navboxArgs.list2 = self.defName
    navboxArgs.group3 = "名称（英文）"
    navboxArgs.list3 = self.label
    navboxArgs.group4 = "名称（简中）"
    navboxArgs.list4 = self.label_zhcn
    navboxArgs.group5 = "名称（繁中）"
    navboxArgs.list5 = self.label_zhtw
    if self.description then
        navboxArgs.group6 = "描述（英文）"
        navboxArgs.list6 = self.description
        navboxArgs.group7 = "描述（简中）"
        navboxArgs.list7 = self.description_zhcn
        navboxArgs.group8 = "描述（繁中）"
        navboxArgs.list8 = self.description_zhtw
    end

    return Navbox._navbox(navboxArgs)
end

return Def