local PawnCapacityFactor = {}

function PawnCapacityFactor:new(capacity, weight, max)
    local factor = {}
    setmetatable(factor, self)
    self.__index = self
    -- fields
    factor.capacity = capacity
    factor.weight = weight or 1
    factor.max = max or 9999
    return factor
end

function PawnCapacityFactor:getFactor(capacityEfficiency)
    local num = capacityEfficiency
    if num > self.max then
        return self.max
    end
    return capacityEfficiency
end

return PawnCapacityFactor