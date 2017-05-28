local WorksAndSkills = {}

local Keyed = require("Module:Keyed_zhcn")

local SkillDef = require("Module:RW_SkillDef")
local WorkTypeDef = require("Module:RW_WorkTypeDef")
local WorkGiverDef = require("Module:RW_WorkGiverDef")

function WorksAndSkills.view(frame)
    local text = ""
    local queryResult

    local allTagsIndex = {
		"ManualDumb",
		"ManualSkilled",
		"Violent",
		"Caring",
		"Social",
		"Intellectual",
		"Animals",
		"Artistic",
		"Crafting",
		"Cooking",
		"Firefighting",
		"Cleaning",
		"Hauling",
		"PlantWork",
		"Mining"
    }

    local allTags = {
        None = Keyed.trans("WorkTagNone"),
		ManualDumb = Keyed.trans("WorkTagManualDumb"),
		ManualSkilled = Keyed.trans("WorkTagManualSkilled"),
		Violent = Keyed.trans("WorkTagViolent"),
		Caring = Keyed.trans("WorkTagCaring"),
		Social = Keyed.trans("WorkTagSocial"),
		Intellectual = Keyed.trans("WorkTagIntellectual"),
		Animals = Keyed.trans("WorkTagAnimals"),
		Artistic = Keyed.trans("WorkTagArtistic"),
		Crafting = Keyed.trans("WorkTagCrafting"),
		Cooking = Keyed.trans("WorkTagCooking"),
		Firefighting = Keyed.trans("WorkTagFirefighting"),
		Cleaning = Keyed.trans("WorkTagCleaning"),
		Hauling = Keyed.trans("WorkTagHauling"),
		PlantWork = Keyed.trans("WorkTagPlantWork"),
		Mining = Keyed.trans("WorkTagMining")
    }

    local allSkills = {
        SkillDef.of("Shooting"),
        SkillDef.of("Melee"),
        SkillDef.of("Social"),
        SkillDef.of("Animals"),
        SkillDef.of("Medicine"),
        SkillDef.of("Cooking"),
        SkillDef.of("Construction"),
        SkillDef.of("Growing"),
        SkillDef.of("Mining"),
        SkillDef.of("Artistic"),
        SkillDef.of("Crafting"),
        SkillDef.of("Intellectual"),
    }

    local allWorkTypes = {}
    queryResult = mw.smw.ask("[[defType::WorkTypeDef]]|?defName|mainlabel=-|headers=hide")
    for i, row in pairs(queryResult) do
        allWorkTypes[i] = WorkTypeDef.of(row["DefName"])
    end
    table.sort(allWorkTypes, function(a, b) return a.naturalPriority > b.naturalPriority end)

    local allWorkGivers = {}
    queryResult = mw.smw.ask("[[defType::WorkGiverDef]]|?defName|mainlabel=-|headers=hide|limit=300")
    for i, row in pairs(queryResult) do
        allWorkGivers[i] = WorkGiverDef.of(row["DefName"])
    end

    for i, workType in pairs(allWorkTypes) do
        local curWorkTypeDefName = workType.defName
        local givers = {}
        local index = 1
        for j, workGiver in pairs(allWorkGivers) do
            if workGiver.workType == curWorkTypeDefName then
                givers[index] = workGiver
                index = index + 1
            end
        end
        table.sort(givers, function(a, b) return a.priorityInType > b.priorityInType end)
        workType.givers = givers
        text = text .. "<h3>" .. workType.label_zhcn .. "</h3>\n"
        for j, workGiver in pairs(givers) do
            text = text .. workGiver.label_zhcn .. ", "
        end
        text = text .. "\n"
    end

    return text
end

return WorksAndSkills