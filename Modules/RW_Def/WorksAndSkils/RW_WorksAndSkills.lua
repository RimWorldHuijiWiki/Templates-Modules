local WorksAndSkills = {}

local Keyed_zhcn = require("Module:Keyed_zhcn")

local SkillDef = require("Module:RW_SkillDef")
local WorkTypeDef = require("Module:RW_WorkTypeDef")
local WorkGiverDef = require("Module:RW_WorkGiverDef")

local ColorUtility = require("Module:ColorUtility")
local Collapse = SkillDef.Collapse
local Note = require("Module:RT_Note")

function WorksAndSkills.view(frame)
    local text = ""
    local queryResult
    local args

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
        None = {label = Keyed_zhcn.trans("WorkTagNone"), skills = "", workTypes = "", workGivers = ""},
		ManualDumb = {label = Keyed_zhcn.trans("WorkTagManualDumb"), skills = "", workTypes = "", workGivers = ""},
		ManualSkilled = {label = Keyed_zhcn.trans("WorkTagManualSkilled"), skills = "", workTypes = "", workGivers = ""},
		Violent = {label = Keyed_zhcn.trans("WorkTagViolent"), skills = "", workTypes = "", workGivers = ""},
		Caring = {label = Keyed_zhcn.trans("WorkTagCaring"), skills = "", workTypes = "", workGivers = ""},
		Social = {label = Keyed_zhcn.trans("WorkTagSocial"), skills = "", workTypes = "", workGivers = ""},
		Intellectual = {label = Keyed_zhcn.trans("WorkTagIntellectual"), skills = "", workTypes = "", workGivers = ""},
		Animals = {label = Keyed_zhcn.trans("WorkTagAnimals"), skills = "", workTypes = "", workGivers = ""},
		Artistic = {label = Keyed_zhcn.trans("WorkTagArtistic"), skills = "", workTypes = "", workGivers = ""},
		Crafting = {label = Keyed_zhcn.trans("WorkTagCrafting"), skills = "", workTypes = "", workGivers = ""},
		Cooking = {label = Keyed_zhcn.trans("WorkTagCooking"), skills = "", workTypes = "", workGivers = ""},
		Firefighting = {label = Keyed_zhcn.trans("WorkTagFirefighting"), skills = "", workTypes = "", workGivers = ""},
		Cleaning = {label = Keyed_zhcn.trans("WorkTagCleaning"), skills = "", workTypes = "", workGivers = ""},
		Hauling = {label = Keyed_zhcn.trans("WorkTagHauling"), skills = "", workTypes = "", workGivers = ""},
		PlantWork = {label = Keyed_zhcn.trans("WorkTagPlantWork"), skills = "", workTypes = "", workGivers = ""},
		Mining = {label = Keyed_zhcn.trans("WorkTagMining"), skills = "", workTypes = "", workGivers = ""},
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
    
    local allSkillLabels = {}
    text = text
        .. "<h2>技能</h2>\n"
        .. '<div class="rw-capture">[[File:Captures_Skills.png]]</div>'
    args = {}
    for i, skill in pairs(allSkills) do
        allSkillLabels[skill.defName] = skill.label_zhcn
        args[i] = {
            id = "SkillDef-" .. skill.defName,
            label = skill.label_zhcn,
            content = skill:showDetail(allTags)
        }
    end
    text = text
        .. Collapse.tab(args)
        .. "<h3>技能等级</h3>\n"
        .. "<p>不同的技能等级会影响人物的各种属性，比如各种工作的速度、成功率等。参见[[Stats|属性]]</p>\n"
        .. WorksAndSkills.showSkillLevels()
        .. "<h3>兴趣度</h3>\n"
        .. "<p>不同的兴趣度，学习速度会不同，还会影响工作时获取娱乐值的量。</p>\n"
        .. WorksAndSkills.showPassions()
        .. Note.note("primary", "lightbulb-o", nil, '每日学习上限为<span class="item">4000</span>，到达上限后，后续学习乘以<span class="item">20%</span>。')
        .. Note.note("primary", "lightbulb-o", nil, '通常年轻的角色会有更高的兴趣度，但技能等级会偏低，年老的角色则相反。')

    local allWorkTypes = {}
    queryResult = mw.smw.ask("[[defType::WorkTypeDef]]|?defName|mainlabel=-|headers=hide")
    for i, row in pairs(queryResult) do
        allWorkTypes[i] = WorkTypeDef.of(row["DefName"])
    end
    table.sort(allWorkTypes, function(a, b) return a.naturalPriority > b.naturalPriority end)

    local allWorkGivers = {}
    queryResult = mw.smw.ask("[[defType::WorkGiverDef]]|?defName|mainlabel=-|headers=hide|limit=100")
    for i, row in pairs(queryResult) do
        allWorkGivers[i] = WorkGiverDef.of(row["DefName"])
    end
    -- text = text .. "<p>WorkGivers:" .. (#allWorkGivers) .. "</p>\n"

    local special = {}
    text = text
        .. "<h2>工作类型</h2>\n"
        .. '<div class="rw-capture">[[File:Captures_WorkTypes.png]]</div>'
        .. "<p>各种工作类型，由左至右优先级为由高至低。启用「自定义优先级」后，可通过数字设置优先级，数字越小，优先级越高。当优先级数字相同时，左侧的工作优先级更高。将鼠标悬停在表格头部的工作类型上时，可以查看其下的相关工作，这些相关工作的优先级也是由高至低的。</p>"
    args = {}
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
        workType.workGivers = givers
        args[i] = {
            id = "WorkTypeDef-" .. workType.defName,
            label = workType.label_zhcn,
            content = workType:showDetail(allTags, allSkillLabels, special)
        }
    end
    text = text
        .. Collapse.tab(args)
        .. Note.note("primary", "lightbulb-o", "注意", '研究工作的优先级比较特殊，需要将之设为最高优先级，并且只有在一天当中的早晨才能开始研究工作。')        

    text = text
        .. "<h2>分类（标签）</h2>\n"
        .. '<div class="rw-capture">[[File:Captures_WorkTags.png]]</div>'
        .. "<p>技能与工作会有对应的分类标签，而人物的背景故事则会通过分类标签来设定角色无法从事的工作。</p>"
    args = {}
    for i, index in pairs(allTagsIndex) do
        local tag = allTags[index]
        args[i] = {
            id = "WorkTag-" .. index,
            label = tag.label,
            content = Collapse.ctable_simple({
                headers = {{width = Collapse.firstHeaderWidth},{}},
                rows = {
                    {cols = {"技能", tag.skills}},
                    {cols = {"工作类型", tag.workTypes}},
                    {cols = {"工作", tag.workGivers}},
                },
            })
        }
    end
    text = text .. Collapse.tab(args)

    local note = ""
    for i, sp in pairs(special) do
        note = note .. '<span class="item">' .. sp.giver .. '</span>同时属于' .. sp.tags .. '分类。<br/>'
    end
    text = text .. Note.note("primary", "lightbulb-o", "注意", note)

    return text
end

function WorksAndSkills.showSkillLevels()

    local interval = function(lv)
        if lv == 10 then return -0.1 end
        if lv == 11 then return -0.2 end
        if lv == 12 then return -0.4 end
        if lv == 13 then return -0.65 end
        if lv == 14 then return -1 end
        if lv == 15 then return -1.5 end
        if lv == 16 then return -2 end
        if lv == 17 then return -3 end
        if lv == 18 then return -4 end
        if lv == 19 then return -6 end
        if lv == 20 then return -8 end
        return 0
    end

    local colors = ColorUtility.colorSet(21)
    local rows = {}
    for i = 1, 21 do
        local lv = i - 1
        rows[i] = {
            cols = {
                {extraStyleText = "background-color: " .. colors[i] .. ";"},
                lv,
                Keyed_zhcn.trans("Skill" .. lv),
                (lv ~= 20 and (1000 + lv * 1000) or ""),
                (lv >= 10 and (interval(lv) .. " / 200 tick") or "")
            }
        }
    end

    return Collapse.ctable_simple({
        headers = {
            {width = "1px"},
            {text = "等级", width = "88px"},
            {width = "128px"},
            {text = "达到下一级所需的经验"},
            {text = "技能经验流失速度（1 秒 = 60 tick）"}
        },
        rows = rows
    })
end

function WorksAndSkills.showPassions()
    return Collapse.ctable_simple({
        headers = {{
            width = "72px"
        },{
            text = "兴趣度",
        },{
            text = "工作时每点经验获取的娱乐值"
        }},
        rows = {{
            cols = {
                "",
                Keyed_zhcn.trans("PassionNone", "33.3%%"),
                "0%",
            }
        },{
            cols = {
                "[[File:Textures_ui_icons_passionminor.png|link=]]",
                Keyed_zhcn.trans("PassionMinor", "100%%"),
                2e-5 * 100 .. "%",
            }
        },{
            cols = {
                "[[File:Textures_ui_icons_passionmajor.png|link=]]",
                Keyed_zhcn.trans("PassionMajor", "150%%"),
                4e-5 * 100 .. "%",
            }
        }}
    })
end

return WorksAndSkills