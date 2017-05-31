local SkillDef = {}
local base = require("Module:RW_Def")
setmetatable(SkillDef, base)
SkillDef.__index = SkillDef

local Collapse = base.Collapse

function SkillDef:new(data)
    local def = base.ctor("SkillDef", data, {
        texts = {
            -- "skillLabel",
            -- {"skillLabel_zhcn", "skillLabel.zh-cn"},
            -- {"skillLabel_zhtw", "skillLabel.zh-tw"},
            "disablingWorkTags"
        },
        -- booleans = {
        --     {"usuallyDefinedInBackstories", "usuallyDefinedInBackstories", true}
        -- }
    })
    setmetatable(def, self);
    def:postLoad()
    return def;
end

function SkillDef:postLoad()

    if self.disablingWorkTags then
        local disablingWorkTags = mw.text.split(string.gsub(self.disablingWorkTags, '"', ""), ",")
        self.disablingWorkTags = disablingWorkTags;
    end

end

-- functions

function SkillDef:showDetail(allTags)

    local workTags = ''
    if self.disablingWorkTags then
        for i, tag in pairs(self.disablingWorkTags) do
            workTags = workTags .. '<span class="item">' .. allTags[tag].label .. '</span>'
            allTags[tag].skills = allTags[tag].skills .. '<span class="item">' .. self.label_zhcn .. '</span>'
        end
    end

    return Collapse.ctable_simple({
        headers = {{width = Collapse.firstHeaderWidth},{}},
        rows = {
            {cols = {"defType", self.defType}},
            {cols = {"defName", self.defName}},
            {cols = {"名称（英文）", self.label}},
            {cols = {"名称（简中）", self.label_zhcn}},
            {cols = {"名稱（繁中）", self.label_zhtw}},
            {cols = {"描述（英文）", self.description}},
            {cols = {"描述（简中）", self.description_zhcn}},
            {cols = {"描述（繁中）", self.description_zhtw}},
            {cols = {"分类（标签）", workTags}},
        }
    })
end

-- of

SkillDefOf = {}
function SkillDef.of(defName)
    local def = SkillDefOf[defName]
    if def == nil then
        def = SkillDef:new("Core:Defs_SkillDef_" .. defName)
        SkillDef[defName] = def
    end
    return def
end

return SkillDef