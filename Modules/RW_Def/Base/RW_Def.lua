local Def = {}
Def.__index = Def

-- toboolean

function toboolean(s)
    return (s ~= nil and string.lower(s) == "true")
end

-- require

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")

local GenText = require("Module:AC_GenText")

Def.SMW = SMW
Def.Collapse = Collapse
Def.GenText = GenText

function Def:new(data)
    def = {}
    setmetatable(def, self)
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

-- fields = {
--     texts = {
--         {"defName", "defName", "UnnamedDef"},
--         {"label", "label"},
--         {"label_zhcn", "label.zh-cn"},
--         {"label_zhtw", "label.zh-tw"},
--         {"description", "description"},
--         {"description_zhcn", "description.zh-cn"},
--         {"description_zhtw", "description.zh-tw"},
--     },
--     numbers = {
--         {"filedName", "propName", defaultValue}
--     },
--     booleans = {
--         {"filedName", "propName", defaultValue}
--     }
-- }
function Def.ctor(defType, data, args)
    args = args or {texts = {}}
    local propHead = defType .. "."
    local indexParameters = 3
    local para
    local parameters = {"[[" .. data .. "]]", "?defType", "?defName"}
    local texts = args.texts
    texts[#texts + 1] = {"label", "label"}
    texts[#texts + 1] = {"label_zhcn", "label.zh-cn"}
    texts[#texts + 1] = {"label_zhtw", "label.zh-tw"}
    texts[#texts + 1] = {"description", "description"}
    texts[#texts + 1] = {"description_zhcn", "description.zh-cn"}
    texts[#texts + 1] = {"description_zhtw", "description.zh-tw"}
    for i, section in pairs(texts) do
        if type(section) == "string" then
            section = {section}
            texts[i] = section
        end
        para = section[2] and (propHead .. section[2]) or (propHead .. section[1])
        section[2] = para
        indexParameters = indexParameters + 1
        parameters[indexParameters] = "?" .. para
    end
    if args.numbers then
        local numbers = args.numbers
        for i, section in pairs(numbers) do
            if type(section) == "string" then
                section = {section}
                numbers[i] = section
            end
            para = section[2] and (propHead .. section[2]) or (propHead .. section[1])
            section[2] = para
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. para
            section[3] = section[3] or 0
        end
    end
    if args.booleans then
        local booleans = args.booleans
        for i, section in pairs(booleans) do
            if type(section) == "string" then
                section = {section}
                booleans[i] = section
            end
            para = section[2] and (propHead .. section[2]) or (propHead .. section[1])
            section[2] = para
            indexParameters = indexParameters + 1
            parameters[indexParameters] = "?" .. para
            if section[3] == nil then
                section[3] = false
            end
        end
    end
    parameters.mainlabel = "-"
    parameters.headers = "hide"

    local queryResult = mw.smw.ask(parameters)
    local def = {}
    
    if type(queryResult) == "table" then
        local queryResult = queryResult[1]
        def.countFields = countFields
        def.defType = queryResult["DefType"]
        def.defName = queryResult["DefName"]
        def.label = queryResult[propHead .. "label"]
        for i, section in pairs(args.texts) do
            def[section[1]] = queryResult[section[2]] or section[3]
        end
        if args.numbers then
            for i, section in pairs(args.numbers) do
                def[section[1]] = tonumber(queryResult[section[2]]) or section[3]
            end
        end
        if args.booleans then
            local text
            for i, section in pairs(args.booleans) do
                text = queryResult[section[2]]
                if text then
                    def[section[1]] = toboolean(text)
                else
                    def[section[1]] = section[3]
                end
            end
        end
    end

    if def.defName == nil then
        return nil
    end

    -- setmetatable(def, self)
    return def
end

-- properties

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

-- Custom

function Def:setLabel(newLabel)
    self.label_zhcn = newLabel
    return self;
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

function Def:getInfoBase(thumbnail)
    local rows = {}
    if thumbnail then
        rows[#rows + 1] = {
            cols = {{
                text = thumbnail,
                span = 2
            }},
            extraCssText = "rw-ctable-thumbnail"
        }
    end
    rows[#rows + 1] = {cols = {"defType", self.defType}}
    rows[#rows + 1] = {cols = {"defName", self.defName}}
    if self.label ~= nil then
        rows[#rows + 1] = {cols = {"名称（英文）", self.label}}
        rows[#rows + 1] = {cols = {"名称（简中）", self.label_zhcn}}
        rows[#rows + 1] = {cols = {"名稱（繁中）", self.label_zhtw}}
    end
    if self.description ~= nil then
        rows[#rows + 1] = {cols = {"描述（英文）", self.description}}
        rows[#rows + 1] = {cols = {"描述（简中）", self.description_zhcn}}
        rows[#rows + 1] = {cols = {"描述（繁中）", self.description_zhtw}}
    end
    return Collapse.ctable({
        id = self.defName .. "infoBase",
        title = "基本信息",
        headers = {{
            width = "144px"
        },{}},
        rows = rows
    })
end

return Def