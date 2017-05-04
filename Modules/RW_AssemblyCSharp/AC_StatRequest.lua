local StatRequest = {}

function StatRequest:new()
    local req = {}
    setmetatable(req, self)
    self.__index = self
    return req
end

function StatRequest:get_Thing()
    return self.thingInt
end

function StatRequest:get_Def()
    return self.defInt
end

function StatRequest:get_StuffDef()
    return self.stuffDefInt
end

function StatRequest:get_QualityCategory()
    return self.qualityCategoryInt
end

function StatRequest:hasThing()
    return self.thingInt ~= nil
end

function StatRequest:empty()
    return self.defInt == nil
end

function StatRequest.forThing(thing)
    local req = StatRequest:new()
    if thing == nil then
        return req
    end
    req.thingInt = thing
    req.defInt = thing.def
    req.stuffDefInt = thing:get_Stuff()
    req.qualityCategoryInt = thing:tryGetQuality()
    return req
end

function StatRequest.forBuildableDef(def, stuffDef, quality)
    local req = StatRequest:new()
    if def == nil then
        return req
    end
    req.thingInt = nil
    req.defInt = def
    req.stuffDefInt = stuffDef
    req.qualityCategoryInt = quality or "Normal"
    return req
end

return StatRequest