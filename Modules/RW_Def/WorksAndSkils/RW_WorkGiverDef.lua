local WorkGiverDef = {}
local base = require("Module:RW_Def")
setmetatable(WorkGiverDef, base)
WorkGiverDef.__index = WorkGiverDef

function WorkGiverDef:new(data)
    local def = base.ctor("WorkGiverDef", data, {
        texts = {
            "giverClass",
            "workType",
            "workTags",
            "verb",
            {"verb_zhcn", "verb.zh-cn"},
            {"verb_zhtw", "verb.zh-tw"},
            "gerund",
            {"gerund_zhcn", "gerund.zh-cn"},
            {"gerund_zhtw", "gerund.zh-tw"},
            "requiredCapacities",
            {"tagToGive", "tagToGive", "MiscWork"},
            "fixedBillGiverDefs"
        },
        numbers = {
            "priorityInType",
        },
        booleans = {
            {"scanThings", "scanThings", true},
            "scanCells",
            "emergency",
            {"directOrderable", "directOrderable", true},
            "prioritizeSustains",
            "canBeDoneByNonColonists",
		    "billGiversAllHumanlikes",
		    "billGiversAllHumanlikesCorpses",
		    "billGiversAllMechanoids",
		    "billGiversAllMechanoidsCorpses",
		    "billGiversAllAnimals",
		    "billGiversAllAnimalsCorpses",
		    'tendToHumanlikesOnly',
		    "tendToAnimalsOnly",
		    "feedHumanlikesOnly",
		    "feedAnimalsOnly",
        }
    })
    setmetatable(def, self)
    def:postLoad()
    return def
end

function WorkGiverDef:postLoad()

    if self.workTags then
        local workTags = mw.text.split(self.workTags, ",")
        for i, tag in pairs(workTags) do
            workTags[i] = string.sub(tag, 2, -2)
        end
        self.workTags = workTags;
    end

    if self.requiredCapacities then
        local requiredCapacities = mw.text.split(self.requiredCapacities, ",")
        for i, cap in pairs(requiredCapacities) do
            requiredCapacities[i] = string.sub(cap, 2, -2)
        end
        self.requiredCapacities = requiredCapacities;
    end

    if self.fixedBillGiverDefs then
        local fixedBillGiverDefs = mw.text.split(self.fixedBillGiverDefs, ",")
        for i, giverDef in pairs(fixedBillGiverDefs) do
            fixedBillGiverDefs[i] = string.sub(giverDef, 2, -2)
        end
        self.fixedBillGiverDefs = fixedBillGiverDefs;
    end

end

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