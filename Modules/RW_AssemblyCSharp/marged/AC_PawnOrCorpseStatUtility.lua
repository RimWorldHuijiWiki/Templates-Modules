local PawnOrCorpseStatUtility = {}

function PawnOrCorpseStatUtility.tryGetPawnOrCorpseStat(req, pawnStatGetter, pawnDefStatGetter, stat)
    if req:hasThing() then
        local pawn = req:get_Thing()
        if pawn ~= nil then
            stat.out = pawnStatGetter(pawn)
            return true
        end
        -- TODO: corpse
    else
        local thingDef = req.get_Def()
        if thingDef ~= nil then
            if thingDef.category == "Pawn" then
                stat.out = pawnDefStatGetter(thingDef)
                return true
            end
            -- TODO: corpse
        end
    end
    stat.out = 0
    return false
end

return PawnOrCorpseStatUtility