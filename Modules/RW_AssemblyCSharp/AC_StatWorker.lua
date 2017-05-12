local StatWorker = {}
local base = StatWorker

local StatRequest = require("Module:AC_StatRequest")
local StatUtility = require("Module:AC_StatUtility")
local Mathf = require("Module:UE_Mathf")

-- StatWorker (base)

function StatWorker:new()
    local worker = {}
    setmetatable(worker, self)
    self.__index = self
    return worker
end

function StatWorker:InitSetStat(newStat)
    self.stat = newStat
end

function StatWorker:getValueAbstract(def, stuffDef)
    return self:getValue(StatRequest.forBuildableDef(def, stuffDef, "Normal"), true)
end

function StatWorker:getValue(req, applyPostProcess)
    if applyPostProcess == nil then
        applyPostProcess = true
    end
    local valueUnfinalized = self:getValueUnfinalized(req, applyPostProcess)
    local valueFinalized = self:getValueFinalized(req, valueUnfinalized, applyPostProcess)
    return valueFinalized
end

function StatWorker:getValueUnfinalized(req, applyPostProcess)
    if applyPostProcess == nil then
        applyPostProcess = true
    end
    local stat = self.stat
    local statDefName = self.stat.defName
    local num = self:getBaseValueFor(req:get_Def())
    local thing = req:get_Thing()
    local pawn
    if thing.class == "Pawn" then
        pawn = thing
    end
    if pawn ~= nil then
        -- TODO pawn's traits, hediffs, apparels, equipments
        num = num * StatUtility.getStatFactorFromList(pawn.ageTracker:get_CurLifeStage().statFactors, statDefName)
    end
    local stuffDef = req:get_StuffDef()
    if stuffDef ~= nil then
        num = num + StatUtility.getStatOffsetFromList(stuffDef.stuffProps.statOffsets, statDefName)
        num = num * StatUtility.getStatFactorFromList(stuffDef.stuffProps.statOffsets, statDefName)
    end
    return num
end

function StatWorker:getValueFinalized(req, val, applyPostProcess)
    local stat = self.stat
    if stat.parts ~= nil then
        for i, part in pairs(stat.parts) do
            val = part:transformValue(req, val)
        end
    end
    if applyPostProcess and stat.postProcessCurve ~= nil then
        val = stat.postProcessCurve:evaluate(val)
    end
    if math.abs(val) > stat.roundToFiveOver then
        val = Mathf.round(val / 5) * 5
    end
    val = Mathf.clamp(val, stat.minValue, stat.maxValue)
    if stat.roundValue then
        val = Mathf.roundToInt(val)
    end
    return val
end

function StatWorker:getBaseValueFor(def)
    local result = self.stat.defaultBaseValue
    if def.statBases ~= nil then
        local statDefName = self.stat.defName
        for i, statModifier in pairs(def.statBases) do
            if statModifier.stat == statDefName then
                result = statModifier.value
                break
            end
        end
    end
    return result
end

-- StatWorker_MarketValue

function StatWorker_MarketValue:new()
    setmetatable(self, base)
    local worker = base:new()
    setmetatable(worker, self)
    self.__index = self
    return worker
end

function StatWorker_MarketValue:getValueUnfinalized(req, applyPostProcess)
    if applyPostProcess == nil then
        applyPostProcess = true
    end
    local thing = req:get_Thing()
    if thing ~= nil and thing.class == "Pawn" then
        return base.getValueUnfinalized(self, StatRequest.F)
    end
    local def = req:get_Def()
    if def.costList ~= nil then
        for i, thingCountClass in pairs(def.costList) do
            local thingDef
        end
    end
end


return StatWorker