local StatDef = {}
local base = require("Module:RW_Def")

local SMW = require("Module:SMW")

local GenText = require("Module:AC_GenText")
local SkillNeed = require("Module:AC_SkillNeed")
local PawnCapacityFactor = require("Module:AC_PawnCapacityFactor")
local SimpleCurve = require("Module:AC_SimpleCurve")
local StatPart = require("Module:AC_StatPart")

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
    def.hideAtValue = tonumber(SMW.show(data, "StatDef.hideAtValue", "-2.14748365E+09"))
    def.showNonAbstract = toboolean(SMW.show(data, "StatDef.showNonAbstract", "true"))
    def.showIfUndefined = toboolean(SMW.show(data, "StatDef.showIfUndefined", "true"))
    def.showOnPawns = toboolean(SMW.show(data, "StatDef.showOnPawns", "true"))
    def.showOnHumanlikes = toboolean(SMW.show(data, "StatDef.showOnHumanlikes", "true"))
    def.showOnAnimals = toboolean(SMW.show(data, "StatDef.showOnAnimals", "true"))
    def.showOnMechanoids = toboolean(SMW.show(data, "StatDef.showOnMechanoids", "true"))
    def.toStringNumberSense = SMW.show(data, "StatDef.toStringNumberSense", "Absolute")
    def.toStringStyle = SMW.show(data, "StatDef.toStringStyle")
    def.formatString = SMW.show(data, "StatDef.formatString")
    def.formatString_zhcn = SMW.show(data, "StatDef.formatString.zh-cn")
    def.formatString_zhtw = SMW.show(data, "StatDef.formatString.zh-tw")
    def.defaultBaseValue = tonumber(SMW.show(data, "StatDef.defaultBaseValue", "1"))
    def.minValue = tonumber(SMW.show(data, "StatDef.minValue"))
    def.maxValue = tonumber(SMW.show(data, "StatDef.maxValue", "9999999"))
    def.roundValue = toboolean(SMW.show(data, "StatDef.roundValue", "false"))
    def.roundToFiveOver = tonumber(SMW.show(data, "StatDef.roundToFiveOver", "3.40282347E+38"))
    -- list
    def.statFactors = SMW.show(data, "StatDef.statFactors")
    def.applyFactorsIfNegative = toboolean(SMW.show(data, "StatDef.applyFactorsIfNegative", "true"))
    def.noSkillFactor = SMW.show(data, "StatDef.noSkillFactor", "1")
    -- tree
    def.skillNeedFactors = SMW.show(data, "StatDef.skillNeedFactors")
    -- tree
    def.capacityFactors = SMW.show(data, "StatDef.capacityFactors")
    -- tree
    def.postProcessCurve = SMW.show(data, "StatDef.postProcessCurve")
    -- tree
    def.parts = SMW.show(data, "StatDef.parts")
    def:postLoad(data)
    return def
end

function StatDef:postLoad(data)

    if self.statFactors ~= nil then
        local t = mw.text.split(self.statFactors, ",")
        for i, s in pairs(t) do
            t[i] = string.sub(s, 2, -2)
        end
        self.statFactors = t
    end

    if self.skillNeedFactors == "Exist" then
        local class = SMW.show(data, "StatDef.skillNeedFactors.0.Class")
        local skill = SMW.show(data, "StatDef.skillNeedFactors.0.skill")
        local reportInverse toboolean(SMW.show(data, "StatDef.skillNeedFactors.0.reportInverse", "false"))
        if class == "SkillNeed_BaseBonus" then
            local baseFactor = tonumber(SMW.show(data, "StatDef.skillNeedFactors.0.baseFactor"))
            local bonusFactor = tonumber(SMW.show(data, "StatDef.skillNeedFactors.0.bonusFactor"))
            self.skillNeedFactors = {SkillNeed.create_BaseBonus(skill, reportInverse, baseFactor, bonusFactor)}
        else
            local factorsPerLevel = SMW.show(data, "StatDef.skillNeedFactors.0.factorsPerLevel")
            self.skillNeedFactors = {SkillNeed.create_Direct(skill, reportInverse, factorsPerLevel)}
        end
    else
        self.skillNeedFactors = nil
    end

    if self.capacityFactors == "Exist" then
        local pcfs = {}
        local count = tonumber(SMW.show(data, "StatDef.capacityFactors.Count"))
        for i = 1, count do
            local prop = "StatDef.capacityFactors." .. i - 1
            local capacity = SMW.show(data, prop .. ".capacity")
            local weight = tonumber(SMW.show(data, prop .. ".weight"))
            local max = tonumber(SMW.show(data, prop .. ".max"))
            pcfs[i] = PawnCapacityFactor:new(capacity, weight, max)
        end
        self.capacityFactors = pcfs
    else
        self.capacityFactors = nil
    end

    if self.postProcessCurve == "Exist" then
        self.postProcessCurve = SimpleCurve:new(SMW.show(data, "StatDef.postProcessCurve.points"))
    else
        self.postProcessCurve = nil
    end

    if self.parts == "Exist" then
        local parts = {}
        local count = tonumber(SMW.show(data, "StatDef.parts.Count"))
        for i = 0, count - 1 do
            local part = StatPart.instance(data, i)
            if part ~= nil then
                part.parentStat = self
                parts[#parts + 1] = part
            end
        end
        self.parts = parts
    else
        self.parts = nil
    end

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

function StatDef:valueToString(val, numberSense)

    if numberSense == nil or numberSense == "" then
        numberSense = "Absolute"
    end

    local text = GenText.toStringByStyle(val, self.toStringStyle, numberSense)

    if not (self.formatString == nil or self.formatString == "") then
        text = string.gsub(self.formatString, "{0}", text)
    end

    return text
end

return StatDef