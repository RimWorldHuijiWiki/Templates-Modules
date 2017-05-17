local TerrainDef = {}
local base = require("Module:RW_BuildableDef")

local SMW = require("Module:SMW")

local Color = require("Module:UE_Color")

function TerrainDef.init(ThingDefClass, StatDefClass, StuffCategoryDefClass, CollapseClass)
    base.init(ThingDefClass, StatDefClass, StuffCategoryDefClass, CollapseClass)
end

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

function TerrainDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    def.texturePath = SMW.show(data, "TerrainDef.texturePath")
    def.edgeType = SMW.show(data, "TerrainDef.edgeType", "Hard")
    def.waterDepthShader = SMW.show(data, "TerrainDef.waterDepthShader")
    def.renderPrecedence = SMW.show(data, "TerrainDef.renderPrecedence")
    -- list
    def.affordances = SMW.show(data, "TerrainDef.affordances")
    def.layerable = SMW.show(data, "TerrainDef.layerable")
    def.scatterType = SMW.show(data, "TerrainDef.scatterType")
    def.takeFootprints = toboolean(SMW.show(data, "TerrainDef.takeFootprints"))
    def.takeSplashes = toboolean(SMW.show(data, "TerrainDef.takeSplashes"))
    def.avoidWander = toboolean(SMW.show(data, "TerrainDef.avoidWander"))
    def.changeable = toboolean(SMW.show(data, "TerrainDef.changeable", "true"))
    def.smoothedTerrain = SMW.show(data, "TerrainDef.smoothedTerrain")
    def.holdSnow = toboolean(SMW.show(data, "TerrainDef.holdSnow", "true"))
    -- color
    def.color = SMW.show(data, "TerrainDef.color")
    def.driesTo = SMW.show(data, "TerrainDef.driesTo")
    -- list
    def.tags = SMW.show(data, "TerrainDef.tags")
    def.burnedDef = SMW.show(data, "TerrainDef.burnedDef")
    def.terrainFilthDef = SMW.show(data, "TerrainDef.terrainFilthDef")
    def.acceptTerrainSourceFilth = toboolean(SMW.show(data, "TerrainDef.acceptTerrainSourceFilth"))
    def.acceptFilth = toboolean(SMW.show(data, "TerrainDef.acceptFilth", "true"))
    def:postLoad()
    return def
end

function TerrainDef:postLoad()
    self.placingDraggableDimensions = 2

    if self.affordances ~= nil then
        local affordances = mw.text.split(self.affordances, ",")
        for i, curAffordances in pairs(affordances) do
            affordances[i] = curAffordances:sub(2, -2)
        end
        self.affordances = affordances
    end

    if self.color ~= nil then
        self.color = Color.fromString(self.color)
    else
        self.color = Color.white()
    end

    if self.tags ~= nil then
        local tags = mw.text.split(self.tags, ",")
        for i, curTag in pairs(tags) do
            tags[i] = curTag:sub(2, -2)
        end
        self.tags = tags
    end

end

-- of
TerrainDefOf = {}
function TerrainDef.of(defName)
    local def = TerrainDefOf[defName]
    if def == nil then
        def = TerrainDef:new("Core:Defs_TerrainDef_" .. defName)
        TerrainDefOf[defName] = def
    end
    return def
end



return TerrainDef