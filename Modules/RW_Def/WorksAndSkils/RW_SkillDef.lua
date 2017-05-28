local SkillDef = {}
local base = require("Module:RW_Def")
setmetatable(SkillDef, base)
SkillDef.__index = SkillDef

function SkillDef:new(data)
    local def = base.ctor("SkillDef", data, {
        texts = {
            "skillLabel",
            {"skillLabel_zhcn", "skillLabel.zh-cn"},
            {"skillLabel_zhtw", "skillLabel.zh-tw"},
            "disablingWorkTags"
        },
        booleans = {
            {"usuallyDefinedInBackstories", "usuallyDefinedInBackstories", true}
        }
    })
    setmetatable(def, self);
    def:postLoad()
    return def;
end

function SkillDef:postLoad()

    if self.workTags then
        local workTags = mw.text.split(self.workTags, ",")
        for i, tag in pairs(workTags) do
            workTags[i] = string.sub(tag, 2, -2)
        end
        self.workTags = workTags;
    end

end

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