local StatDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

local GenText = require("Module:AC_GenText")
local SkillNeed = require("Module:AC_SkillNeed")

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

function StatDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    def.category = SMW.show(data, "StatDef.category", "StatWorker")
    def.workerClass = SMW.show(data, "StatDef.workerClass")
    def.hideAtValue = SMW.show(data, "StatDef.hideAtValue")
    def.showNonAbstract = toboolean(SMW.show(data, "StatDef.showNonAbstract", "true"))
    def.showIfUndefined = toboolean(SMW.show(data, "StatDef.showIfUndefined", "true"))
    def.showOnPawns = toboolean(SMW.show(data, "StatDef.showOnPawns", "true"))
    def.showOnHumanlikes = toboolean(SMW.show(data, "StatDef.showOnHumanlikes", "true"))
    def.showOnAnimals = toboolean(SMW.show(data, "StatDef.showOnAnimals", "true"))
    def.showOnMechanoids = toboolean(SMW.show(data, "StatDef.showOnMechanoids", "true"))
    def.toStringNumberSense = SMW.show(data, "StatDef.toStringNumberSense", "Absolute")
    def.toStringStyle = SMW.show(data, "StatDef.toStringStyle")
    def.formatString = SMW.show(data, "StatDef.formatString")
    def.defaultBaseValue = tonumber(SMW.show(data, "StatDef.defaultBaseValue", "1"))
    def.minValue = tonumber(SMW.show(data, "StatDef.minValue"))
    def.maxValue = tonumber(SMW.show(data, "StatDef.maxValue", "9999999"))
    def.roundValue = toboolean(SMW.show(data, "StatDef.roundValue", "false"))
    def.roundToFiveOver = tonumber(SMW.show(data, "StatDef.roundToFiveOver", "99999999"))
    -- list
    def.statFactors = SMW.show(data, "StatDef.statFactors")
    def.applyFactorsIfNegative = toboolean(SMW.show(data, "StatDef.applyFactorsIfNegative", "true"))
    def.noSkillFactor = SMW.show(data, "StatDef.noSkillFactor", "1")
    -- tree
    def.skillNeedFactors = SMW.show(data, "StatDef.skillNeedFactors")
    -- tree
    def.capacityFactors = SMW.show(data, "StatDef.capacityFactors")
    -- tree
    def.postProcessCurve = SMW.show(data, "StatDef.postProcessCurve.points")
    -- tree
    def.parts = SMW.show(data, "StatDef.parts")
    def:Init(data)
    return def
end

function StatDef:Init(data)

    if self.statFactors ~= nil then
        local t = mw.text.split(self.statFactors, ",")
        for i, s in pairs(t) do
            t[i] = string.sub(s, 2, -2)
        end
        self.statFactors = t
    end

    if self.skillNeedFactors == "Exist" then
        local class = SMW.show(data, "StatDef.skillNeedFactors.0.Class")
        local skill = SMW.shwo(data, "StatDef.skillNeedFactors.0.skill")
        local reportInverse toboolean(SMW.show(data, "StatDef.skillNeedFactors.0.reportInverse", "false"))
        if class == "SkillNeed_BaseBonus" then
            local baseFactor = tonumber(SMW.show(data, "StatDef.skillNeedFactors.0.baseFactor"))
            local bonusFactor = tonumber(SMW.show(data, "StatDef.skillNeedFactors.0.bonusFactor"))
            self.skillNeedFactors = {SkillNeed.create_BaseBonus(skill, reportInverse, baseFactor, bonusFactor)}
        else
            local factorsPerLevel = SMW.show(data, "StatDef.skillNeedFactors.0.factorsPerLevel")
            self.skillNeedFactors = {SkillNeed.create_Direct(skill, reportInverse, factorsPerLevel)}
        end
    end



    -- if self.capacityFactors == "Exist" then
    --     local pcfs = {}
    --     local count = tonumber(SMW.show(data, "StatDef.capacityFactors.Count"))
    --     for i = 1, count do
    --         pcf = {}
    --         prop = "StatDef.capacityFactors." .. i - 1
    --         pcf.capacity = SMW.show(data, prop .. ".capacity")
    --         pcf.weight = tonumber(SMW.show(data, prop .. ".weight", "1"))
    --         pcf.max = tonumber(SMW.show(data, prop .. ".max", "9999"))
    --         pcfs[i] = pcf
    --     end
    --     self.capacityFactors = pcfs
    -- end

    -- if self.postProcessCurve == "Exist" then
    --     local points = {}
    --     local qs = SMW.show(data, "StatDef.postProcessCurve.points")
    --     local t = mw.text.split(string.sub(qs, 2, -2), "\",\"")
    --     for i, vec in pairs(t) do
    --         vec = mw.text.split(string.sub(vec, 2, -2), ",")
    --         local p = {}
    --         p.x = tonumber(vec[1])
    --         p.y = tonumber(vec[2])
    --         points[i] = p
    --     end
    --     self.postProcessCurve = {points}
    -- end

end

-- function StatDef:get_Worker()
--     if self.workerInt == nil then
--         if self.parts ~= nil then
--             for i, p in pairs(self.parts) do
--                 p.parentStat = self
--             end
--         end
--         self.workerInt = StatWorker:new(self.workerClass)
--         self.workerInt:InitSetStat(self)
--     end
--     return self.workerInt
-- end

-- function StatDef:valueToString(val, numberSense)
--     if numberSense == nil or numberSense == "" then numberSense = "Absolute" end
--     local text = GenText.ToStringByStyle(val, self.toStringStyle, numberSense)
--     if not (self.formatString == null or self.formatString == "") then
--         text = string.gsub(self.formatString, "{0}", text)
--     end
--     return text
-- end

return StatDef