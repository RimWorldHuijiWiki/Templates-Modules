local WorkTypeDef = {}
local base = require("Module:RW_Def")
setmetatable(WorkTypeDef, base)
WorkTypeDef.__index = WorkTypeDef

local Collapse = base.Collapse

function WorkTypeDef:new(data)
    local def = base.ctor("WorkTypeDef", data, {
        texts = {
            "workTags",
            -- "labelShort",
            -- {"labelShort_zhcn", "labelShort.zh-cn"},
            -- {"labelShort_zhtw", "labelShort.zh-tw"},
            -- "pawnLabel",
            -- {"pawnLabel_zhcn", "pawnLabel.zh-cn"},
            -- {"pawnLabel_zhtw", "pawnLabel.zh-tw"},
            -- "gerundLabel",
            -- {"gerundLabel_zhcn", "gerundLabel.zh-cn"},
            -- {"gerundLabel_zhtw", "gerundLabel.zh-tw"},
            -- "verb",
            -- {"verb_zhcn", "verb.zh-cn"},
            -- {"verb_zhtw", "verb.zh-tw"},
            "relevantSkills"
        },
        numbers = {
            "naturalPriority",
        },
        -- booleans = {
        --     "alwaysStartActive",
        --     "requireCapableColonist",
        -- }
    })
    setmetatable(def, self);
    def:postLoad()
    return def;
end

function WorkTypeDef:postLoad()

    if self.workTags then
        local workTags = mw.text.split(string.gsub(self.workTags, '"', ""), ",")
        self.workTags = workTags;
    end

    if self.relevantSkills then
        local relevantSkills = mw.text.split(string.gsub(self.relevantSkills, "\"", ""), ",")
        self.relevantSkills = relevantSkills;
    end

end

-- functions

function WorkTypeDef:showDetail(allTags, allSkillLabels, special)

    local relevantSkills = ''
    if self.relevantSkills then
        for i, skill in pairs(self.relevantSkills) do
            relevantSkills = relevantSkills .. '<span class="item">' .. allSkillLabels[skill] .. '</span>'
        end
    end

    local workTags = ''
    if self.workTags then
        for i, tag in pairs(self.workTags) do
            workTags = workTags .. '<span class="item">' .. allTags[tag].label .. '</span>'
            allTags[tag].workTypes = allTags[tag].workTypes .. '<span class="item">' .. self.label_zhcn .. '</span>'
        end
    end

    local workGivers = ''
    if self.workGivers then
        for i, giver in pairs(self.workGivers) do
            workGivers = workGivers .. '<span class="item">' .. giver.label_zhcn .. '</span>'
            if self.workTags then
                for j, tag in pairs(self.workTags) do
                    allTags[tag].workGivers = allTags[tag].workGivers .. '<span class="item">' .. giver.label_zhcn .. '</span>'
                end
            end
            if giver.workTags then
                local workTags = {}
                for j, tagSP in pairs(giver.workTags) do
                    allTags[tagSP].workGivers = allTags[tagSP].workGivers .. '<span class="item">' .. giver.label_zhcn .. '</span>'
                    table.insert(workTags, '<span class="item">' .. allTags[tagSP].label .. '</span>')
                end
                if self.workTags then
                    for k, tag in pairs(self.workTags) do
                        table.insert(workTags, '<span class="item">' .. allTags[tag].label .. '</span>')
                    end
                end
                table.insert(special, {giver = giver.label_zhcn, tags = table.concat(workTags, "、")})
            end
        end
    end
    workGivers = workGivers .. '<span class="item">（优先级由高至低）</span>'

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
            {cols = {"相关技能", relevantSkills}},
            {cols = {"相关工作", workGivers}},
        }
    })
end

-- of

WorkTypeDefOf = {}
function WorkTypeDef.of(defName)
    local def = WorkTypeDefOf[defName]
    if def == nil then
        def = WorkTypeDef:new("Core:Defs_WorkTypeDef_" .. defName)
        WorkTypeDefOf[defName] = def
    end
    return def
end

return WorkTypeDef