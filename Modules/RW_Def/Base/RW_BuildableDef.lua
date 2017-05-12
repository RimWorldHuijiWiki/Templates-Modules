local BuildableDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

function BuildableDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    local prop = def.defType .. "."
    -- list
    def.statBases = SMW.show(data, prop .. "statBases")
    def.passability = SMW.show(data, prop .. "passability")
    def.pathCost = tonumber(SMW.show(data, prop .. "pathCost"))
    def.pathCostIgnoreRepeat = toboolean(SMW.show(data, prop .. "pathCostIgnoreRepeat", "true"))
    def.fertility = tonumber(SMW.show(data, prop .. "fertility")) or 1
    -- list
    def.costList = SMW.show(data, prop .. "costList")
    def.costStuffCount = tonumber(SMW.show(data, prop .. "costStuffCount")) or -1
    -- list
    def.stuffCategories = tonumber(SMW.show(data, prop .. "stuffCategories"))
    def.terrainAffordanceNeeded = SMW.show(data, prop .. "terrainAffordanceNeeded") or "Light"
    -- list
    def.researchPrerequisites = SMW.show(data, prop .. "researchPrerequisites")
    def.resourcesFractionWhenDeconstructed = SMW.show(data, prop .. "resourcesFractionWhenDeconstructed") or 0.75
    def.uiIconPath = SMW.show(data, prop .. "uiIconPath")
    def.altitudeLayer = SMW.show(data, prop .. "altitudeLayer") or "Item"
    def.menuHidden = toboolean(SMW.show(data, prop .. "menuHidden"))
    def.specialDisplayRadius = tonumber(SMW.show(data, prop .. "specialDisplayRadius"))
    def.designationCategory = SMW.show(data, prop .. "designationCategory")
    def.designationHotKey = SMW.show(data, prop .. "designationHotKey")
    def:postLoad()
    return def
end

function BuildableDef:postLoad()
    
    if self.statBases ~= nil then
        local statBases = {}
        local dictTemp = mw.text.split(self.statBases, ";")
        for i, kvp in pairs(dictTemp) do
            kvp = mw.text.split(kvp, ",")
            statBases[i] = {
                stat = string.sub(kvp[1], 2, -2),
                value = tonumber(string.sub(kvp[2], 2, -2))
            }
        end
        self.statBases = statBases
    end

    if self.costList ~= nil then
        local costList = {}
        local dictTemp = mw.text.split(self.costList, ";")
        for i, kvp in pairs(dictTemp) do
            kvp = mw.text.split(kvp, ",")
            costList[i] = {
                thingDef = string.sub(kvp[1], 2, -2),
                count = tonumber(string.sub(kvp[2], 2, -2))
            }
        end
        self.costList = costList
    end

    if self.stuffCategories ~= nil then
        local stuffCategories = {}
        local listTemp = mw.text.split(self.stuffCategories, ",")
        for i, item in pairs(listTemp) do
            stuffCategories[i] = string.sub(item, 2, -2)
        end
        self.stuffCategories = stuffCategories
    end

    if self.researchPrerequisites ~= nil then
        local researchPrerequisites = {}
        local listTemp = mw.text.split(self.researchPrerequisites, ",")
        for i, item in pairs(listTemp) do
            researchPrerequisites[i] = string.sub(item, 2, -2)
        end
        self.researchPrerequisites = researchPrerequisites
    end

end

function BuildableDef:madeFromStuff()
    return #(self.stuffCategories) > 0
end



return BuildableDef