local WorkTypeDef = {}
local base = require("Module:RW_Def")
setmetatable(WorkTypeDef, base)
WorkTypeDef.__index = WorkTypeDef

function WorkTypeDef:new(data)
    local def = base.ctor("WorkTypeDef", data, {
        texts = {
            "workTags",
            "labelShort",
            {"labelShort_zhcn", "labelShort.zh-cn"},
            {"labelShort_zhtw", "labelShort.zh-tw"},
            "pawnLabel",
            {"pawnLabel_zhcn", "pawnLabel.zh-cn"},
            {"pawnLabel_zhtw", "pawnLabel.zh-tw"},
            "gerundLabel",
            {"gerundLabel_zhcn", "gerundLabel.zh-cn"},
            {"gerundLabel_zhtw", "gerundLabel.zh-tw"},
            "verb",
            {"verb_zhcn", "verb.zh-cn"},
            {"verb_zhtw", "verb.zh-tw"},
            "relevantSkills"
        },
        numbers = {
            "naturalPriority",
        },
        booleans = {
            "alwaysStartActive",
            "requireCapableColonist",
        }
    })
    setmetatable(def, self);
    def:postLoad()
    return def;
end

function WorkTypeDef:postLoad()

    if self.workTags then
        local workTags = mw.text.split(self.workTags, ",")
        for i, tag in pairs(workTags) do
            workTags[i] = string.sub(tag, 2, -2)
        end
        self.workTags = workTags;
    end

    if self.relevantSkills then
        local relevantSkills = mw.text.split(self.relevantSkills, ",")
        for i, skill in pairs(relevantSkills) do
            relevantSkills[i] = string.sub(skill, 2, -2)
        end
        self.relevantSkills = relevantSkills;
    end

end

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