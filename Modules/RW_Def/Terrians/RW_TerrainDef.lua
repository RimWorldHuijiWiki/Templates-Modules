local TerrainDef = {}
local base = require("Module:RW_BuildableDef")

local SMW = require("Module:SMW")

local Color = require("Module:UE_Color")

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
    def.edgeType = SMW.show(data, "TerrainDef.edgeType")
    def.waterDepthShader = SMW.show(data, "TerrainDef.waterDepthShader")
    def.renderPrecedence = SMW.show(data, "TerrainDef.renderPrecedence")
    -- list
    def.affordances = SMW.show(data, "TerrainDef.affordances")
    def.layerable = SMW.show(data, "TerrainDef.layerable")
    def.scatterType = SMW.show(data, "TerrainDef.scatterType")
    def.takeFootprints = toboolean(SMW.show(data, "TerrainDef.takeFootprints"))
    def.takeSplashes = toboolean(SMW.show(data, "TerrainDef.takeSplashes"))
    def.changeable = toboolean(SMW.show(data, "TerrainDef.changeable", "true"))
    def.smoothedTerrain = SMW.show(data, "TerrainDef.smoothedTerrain")
    def.holdSnow = toboolean(SMW.show(data, "TerrainDef.holdSnow", "true"))
    -- color
    def.color = SMW.show(data, "TerrainDef.color", "true")
    def.driesTo = SMW.show(data, "TerrainDef.driesTo", "true")
    -- list
    def.tags = SMW.show(data, "TerrainDef.tags", "true")
    def.burnedDef = SMW.show(data, "TerrainDef.burnedDef", "true")
    def.terrainFilthDef = SMW.show(data, "TerrainDef.terrainFilthDef", "true")
    def.acceptTerrainSourceFilth = SMW.show(data, "TerrainDef.acceptTerrainSourceFilth", "true")
    def.acceptFilth = SMW.show(data, "TerrainDef.acceptFilth", "true")
    return def
end

function TerrainDef:postLoad()
    self.placingDraggableDimensions = 2

    if self.affordances ~= nil then
        local affordances = mw.text.split(self.affordances)
        for i, curAffordances in pairs(self.affordances) do
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



return TerrainDef