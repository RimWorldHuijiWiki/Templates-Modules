local WorkGiverDef = {}
local base = require("Module:RW_Def")
setmetatable(WorkGiverDef, base)
WorkGiverDef.__index = WorkGiverDef

function WorkGiverDef:new(data)
    local def = base.ctor("WorkGiverDef", data, {
        texts = {
            -- "giverClass",
            "workType",
            "workTags",
            -- "verb",
            -- {"verb_zhcn", "verb.zh-cn"},
            -- {"verb_zhtw", "verb.zh-tw"},
            -- "gerund",
            -- {"gerund_zhcn", "gerund.zh-cn"},
            -- {"gerund_zhtw", "gerund.zh-tw"},
            "requiredCapacities",
            -- {"tagToGive", "tagToGive", "MiscWork"},
            "fixedBillGiverDefs"
        },
        numbers = {
            "priorityInType",
        },
        -- booleans = {
        --     {"scanThings", "scanThings", true},
        --     "scanCells",
        --     "emergency",
        --     {"directOrderable", "directOrderable", true},
        --     "prioritizeSustains",
        --     "canBeDoneByNonColonists",
		--     "billGiversAllHumanlikes",
		--     "billGiversAllHumanlikesCorpses",
		--     "billGiversAllMechanoids",
		--     "billGiversAllMechanoidsCorpses",
		--     "billGiversAllAnimals",
		--     "billGiversAllAnimalsCorpses",
		--     'tendToHumanlikesOnly',
		--     "tendToAnimalsOnly",
		--     "feedHumanlikesOnly",
		--     "feedAnimalsOnly",
        -- }
    })
    setmetatable(def, self)
    def:postLoad()
    return def
end

function WorkGiverDef:postLoad()

    if self.workTags then
        self.workTags = mw.text.split(string.gsub(self.workTags, '"', ""), ",");
    end

    if self.requiredCapacities then
        self.requiredCapacities = mw.text.split(string.gsub(self.requiredCapacities, '"', ""), ",");
    end

    if self.fixedBillGiverDefs then
        self.fixedBillGiverDefs = mw.text.split(string.gsub(self.fixedBillGiverDefs, '"', ""), ",");
    end

end

-- of

WorkGiverDefOf = {}
function WorkGiverDef.of(defName)
    local def = WorkGiverDefOf[defName]
    if def == nil then
        def = WorkGiverDef:new("Core:Defs_WorkGiverDef_" .. defName)
        WorkGiverDefOf[defName] = def
    end
    return def
end

return WorkGiverDef