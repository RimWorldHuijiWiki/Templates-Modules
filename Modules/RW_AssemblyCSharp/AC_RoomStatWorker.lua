local RoomStatWorker = {}
local RoomStatWorker_Beauty = {}
local RoomStatWorker_Cleanliness = {}
local RoomStatWorker_FoodPoisonChanceFactor = {}
local RoomStatWorker_GraveVisitingJoyGainFactor = {}
local RoomStatWorker_Impressiveness = {}
local RoomStatWorker_InfectionChanceFactor = {}
local RoomStatWorker_ResearchSpeedFactor = {}
local RoomStatWorker_Space = {}
local RoomStatWorker_SurgerySuccessChanceFactor = {}
local RoomStatWorker_Wealth = {}

local SMW = require("Module:SMW")
local Collapse = require("Module:RT_Collapse")
local Keyed_zhcn = require("Module:Keyed_zhcn")

local SimpleCurve = require("Module:AC_SimpleCurve")

-- Base

function RoomStatWorker:new()
    local part = {
        parentStat = nil
    }
    setmetatable(part, self)
    self.__index = self
    return part
end

function RoomStatWorker:explainEcharts()
    return ""
end

return RoomStatWorker