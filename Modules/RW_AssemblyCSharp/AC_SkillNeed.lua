local SkillNeed = {}
local base = SkillNeed
local SkillNeed_BaseBonus = {}
local SkillNeed_Direct = {}

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

function SkillNeed.create_BaseBonus(skill, reportInverse, baseFactor, bonusFactor)
    return SkillNeed_BaseBonus:new(skill, reportInverse, baseFactor, bonusFactor)
end

function SkillNeed.create_Direct(skill, reportInverse, factorsPerLevel)
    return SkillNeed_Direct:new(skill, reportInverse, factorsPerLevel)
end

-- base

function SkillNeed:new(skill, reportInverse)
    local need = {}
    setmetatable(need, self)
    self.__index = self
    -- fields
    need.skill = skill
    need.reportInverse = reportInverse
    return need
end

function SkillNeed:factorFor(level)
    return 1
end

-- SkillNeed_BaseBonus

function SkillNeed_BaseBonus:new(skill, reportInverse, baseFactor, bonusFactor)
    setmetatable(self, base)
    local need = base:new(skill, reportInverse)
    setmetatable(need, self)
    self.__index = self
    -- fields
    self.class = "SkillNeed_BaseBonus"
    self.baseFactor = baseFactor or 0.5
    self.bonusFactor = bonusFactor or 0.5
    return need
end

function SkillNeed_BaseBonus:factorFor(level)
    if level == nil then return 1 end
    return self.baseFactor + self.bonusFactor * level
end

-- SkillNeed_Direct

function SkillNeed_Direct:new(skill, reportInverse, factorsPerLevel)
    setmetatable(self, base)
    local need = base:new(skill, reportInverse)
    setmetatable(need, self)
    self.__index = self
    -- fields
    self.class = "SkillNeed_Direct"
    if type(factorsPerLevel) == "string" then
        local t = mw.text.split(factorsPerLevel, ",")
        for i, v in pairs(t) do
            t[i] = tonumber(string.sub(v, 2, -2))
        end
        self.factorsPerLevel = t
    else
        self.factorsPerLevel = factorsPerLevel
    end
    return need
end

function SkillNeed_Direct:factorFor(skillLevel)
    if skillLevel == nil then return 1 end
    local lvp = skillLevel + 1
    for i, val in pairs(self.factorsPerLevel) do
        if lvp == i then
            return val
        end
    end
    local factors = self.factorsPerLevel
    if #factors > 0 then
        return factors[#factors]
    end
    return 1
end




return SkillNeed