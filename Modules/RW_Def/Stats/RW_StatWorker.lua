local StatWorker = {}

-- base

function StatWorker:new(workerClass)
    if workerClass == "StatWorker_MarketValue" then

    else
        local worker = {}
        setmetatable(worker, self)
        self.__index = self
        return worker
    end
end

function StatWorker:InitSetStat(newStat)
    self.stat = newStat
end

return StatWorker