local ThingDef = {}
local base = require("Module:RW_BuildableDef")

local SMW = require("Module:SMW")

local StatExtension = require("Module:AC_StatExtension")

local StatDef = require("Module:RW_StatDef")

local Color = require("Module:UE_Color")
local Mathf = require("Module:UE_Mathf")

function toboolean(s)
    if s ~= nil and string.lower(s) == "true" then
        return true
    else
        return false
    end
end

ThingDef.SmallUnitPerVolume = 10
ThingDef.SmallVolumePerUnit = 0.1

function ThingDef:new(data)
    setmetatable(self, base)
    def = base:new(data)
    setmetatable(def, self)
    self.__index = self
    -- fields
    def.thingClass = SMW.show(data, "ThingDef.thingClass")
    def.category = SMW.show(data, "ThingDef.category")
    def.tickerType = SMW.show(data, "ThingDef.tickerType")
    def.stackLimit = tonumber(SMW.show(data, "ThingDef.stackLimit")) or 1
    def.size = SMW.show(data, "ThingDef.size", "(1, 1)")
    def.destroyable = toboolean(SMW.show(data, "ThingDef.destroyable", "true"))
    def.rotatable = toboolean(SMW.show(data, "ThingDef.rotatable", "true"))
    def.smallVolume = toboolean(SMW.show(data, "ThingDef.smallVolume"))
    def.useHitPoints = toboolean(SMW.show(data, "ThingDef.useHitPoints", "true"))
    -- list
    def.comps = SMW.show(data, "ThingDef.comps")
    -- list
    def.killedLeavings = SMW.show(data, "ThingDef.killedLeavings")
    -- list
    def.butcherProducts = SMW.show(data, "ThingDef.butcherProducts")
    -- list
    def.smeltProducts = SMW.show(data, "ThingDef.smeltProducts")
    def.smeltable = toboolean(SMW.show(data, "ThingDef.smeltable"))
    def.randomizeRotationOnSpawn = toboolean(SMW.show(data, "ThingDef.randomizeRotationOnSpawn"))
    -- list
    def.damageMultipliers = SMW.show(data, "ThingDef.damageMultipliers")
    def.isBodyPartOrImplant = toboolean(SMW.show(data, "ThingDef.isBodyPartOrImplant"))
    -- list
    def.recipeMaker = SMW.show(data, "ThingDef.recipeMaker")
    def.minifiedDef = SMW.show(data, "ThingDef.minifiedDef")
    def.isUnfinishedThing = toboolean(SMW.show(data, "ThingDef.isUnfinishedThing"))
    def.leaveResourcesWhenKilled = toboolean(SMW.show(data, "ThingDef.leaveResourcesWhenKilled"))
    def.slagDef = SMW.show(data, "ThingDef.slagDef")
    def.isFrame = toboolean(SMW.show(data, "ThingDef.isFrame"))
    def.interactionCellOffset = SMW.show(data, "ThingDef.interactionCellOffset", "(0, 0, 0)")
    def.hasInteractionCell = toboolean(SMW.show(data, "ThingDef.hasInteractionCell"))
    def.filthLeaving = SMW.show(data, "ThingDef.filthLeaving")
    def.intricate = toboolean(SMW.show(data, "ThingDef.intricate"))
    def.scatterableOnMapGen = toboolean(SMW.show(data, "ThingDef.scatterableOnMapGen", "true"))
    def.deepCommonality = tonumber(SMW.show(data, "ThingDef.deepCommonality")) or 0
    def.deepCountPerCell = tonumber(SMW.show(data, "ThingDef.deepCountPerCell")) or 150
    def.generateCommonality = tonumber(SMW.show(data, "ThingDef.deepCountPerCell")) or 1
    def.generateAllowChance = tonumber(SMW.show(data, "ThingDef.generateAllowChance")) or 1
    def.canOverlapZones = toboolean(SMW.show(data, "ThingDef.canOverlapZones", "true"))
    -- postLoad
    def.startingHpRange = SMW.show(data, "ThingDef.startingHpRange", "1 ~ 1")
    -- postLoad
    def.graphicData = SMW.show(data, "ThingDef.graphicData")
    def.drawerType = SMW.show(data, "ThingDef.drawerType", "RealtimeOnly")
    def.drawOffscreen = toboolean(SMW.show(data, "ThingDef.drawOffscreen"))
    -- postLoad
    def.colorGenerator = SMW.show(data, "ThingDef.colorGenerator")
    def.hideAtSnowDepth = tonumber(SMW.show(data, "ThingDef.generateAllowChance")) or 99999
    def.drawDamagedOverlay = toboolean(SMW.show(data, "ThingDef.drawDamagedOverlay", "true"))
    def.castEdgeShadows = toboolean(SMW.show(data, "ThingDef.castEdgeShadows"))
    def.staticSunShadowHeight = tonumber(SMW.show(data, "ThingDef.staticSunShadowHeight")) or 0
    def.selectable = toboolean(SMW.show(data, "ThingDef.selectable"))
    def.neverMultiSelect = toboolean(SMW.show(data, "ThingDef.neverMultiSelect"))
    def.isAutoAttackableMapObject = toboolean(SMW.show(data, "ThingDef.isAutoAttackableMapObject"))
    def.hasTooltip = toboolean(SMW.show(data, "ThingDef.hasTooltip"))
    -- list
    def.inspectorTabs = SMW.show(data, "ThingDef.inspectorTabs")
    def.seeThroughFog = toboolean(SMW.show(data, "ThingDef.seeThroughFog"))
    def.drawGUIOverlay = toboolean(SMW.show(data, "ThingDef.drawGUIOverlay"))
    def.ResourceCountPriority = SMW.show(data, "ThingDef.ResourceCountPriority")
    def.resourceReadoutAlwaysShow = toboolean(SMW.show(data, "ThingDef.resourceReadoutAlwaysShow"))
    def.drawPlaceWorkersWhileSelected = toboolean(SMW.show(data, "ThingDef.drawPlaceWorkersWhileSelected"))
    def.storedConceptLearnOpportunity = SMW.show(data, "ThingDef.storedConceptLearnOpportunity")
    def.iconDrawScale = tonumber(SMW.show(data, "ThingDef.iconDrawScale")) or -1
    def.alwaysHaulable = toboolean(SMW.show(data, "ThingDef.alwaysHaulable"))
    def.designateHaulable = toboolean(SMW.show(data, "ThingDef.designateHaulable"))
    -- list
    def.thingCategories = SMW.show(data, "ThingDef.thingCategories")
    def.mineable = toboolean(SMW.show(data, "ThingDef.mineable"))
    def.socialPropernessMatters = toboolean(SMW.show(data, "ThingDef.socialPropernessMatters"))
    def.stealable = toboolean(SMW.show(data, "ThingDef.stealable", "true"))
    def.soundDrop = SMW.show(data, "ThingDef.soundDrop")
    def.soundPickup = SMW.show(data, "ThingDef.soundPickup")
    def.soundInteract = SMW.show(data, "ThingDef.soundInteract")
    def.soundImpactDefault = SMW.show(data, "ThingDef.soundImpactDefault")
    def.saveCompressible = toboolean(SMW.show(data, "ThingDef.saveCompressible"))
    def.isSaveable = toboolean(SMW.show(data, "ThingDef.stealable", "true"))
    def.holdsRoof = toboolean(SMW.show(data, "ThingDef.holdsRoof"))
    def.fillPercent = tonumber(SMW.show(data, "ThingDef.iconDrawScale")) or 0
    def.coversFloor = toboolean(SMW.show(data, "ThingDef.coversFloor"))
    def.neverOverlapFloors = toboolean(SMW.show(data, "ThingDef.neverOverlapFloors"))
    def.surfaceType = SMW.show(data, "ThingDef.surfaceType")
    def.blockPlants = toboolean(SMW.show(data, "ThingDef.blockPlants"))
    def.blockLight = toboolean(SMW.show(data, "ThingDef.blockLight"))
    def.blockWind = toboolean(SMW.show(data, "ThingDef.blockWind"))
    def.tradeability = SMW.show(data, "ThingDef.tradeability", "Stockable")
    -- list
    def.tradeTags = SMW.show(data, "ThingDef.tradeTags")
    def.tradeNeverStack = toboolean(SMW.show(data, "ThingDef.tradeNeverStack"))
    -- list
    def.colorGeneratorInTraderStock = SMW.show(data, "ThingDef.colorGeneratorInTraderStock")
    def.blueprintClass = SMW.show(data, "ThingDef.blueprintClass", "Blueprint_Build")
    -- list
    def.recipes = SMW.show(data, "ThingDef.recipes")
    -- list
    def.verbs = SMW.show(data, "ThingDef.verbs")
    def.equippedAngleOffset = tonumber(SMW.show(data, "ThingDef.equippedAngleOffset")) or 0
    def.equipmentType = SMW.show(data, "ThingDef.equipmentType")
    def.techLevel = SMW.show(data, "ThingDef.techLevel")
    -- list
    def.weaponTags = SMW.show(data, "ThingDef.weaponTags")
    -- list
    def.techHediffsTags = SMW.show(data, "ThingDef.techHediffsTags")
    def.canBeSpawningInventory = toboolean(SMW.show(data, "ThingDef.canBeSpawningInventory", "true"))
    def.destroyOnDrop = toboolean(SMW.show(data, "ThingDef.destroyOnDrop"))
    -- list
    def.equippedStatOffsets = SMW.show(data, "ThingDef.equippedStatOffsets")
    -- postLoad
    def.ingestible = SMW.show(data, "ThingDef.ingestible")
    -- postLoad
    def.filth = SMW.show(data, "ThingDef.filth")
    -- postLoad
    def.gas = SMW.show(data, "ThingDef.gas")
    -- postLoad
    def.building = SMW.show(data, "ThingDef.building")
    -- postLoad
    def.race = SMW.show(data, "ThingDef.race")
    -- postLoad
    def.apparel = SMW.show(data, "ThingDef.apparel")
    -- postLoad
    def.mote = SMW.show(data, "ThingDef.mote")
    -- postLoad
    def.plant = SMW.show(data, "ThingDef.plant")
    -- postLoad
    def.projectile = SMW.show(data, "ThingDef.projectile")
    -- postLoad
    def.stuffProps = SMW.show(data, "ThingDef.stuffProps")
    def:postLoad()
    return def
end

function ThingDef:postLoad()


end

-- Properties

function ThingDef:everHaulable()
    return self.alwaysHaulable or self.designateHaulable
end

function ThingDef:everStoreable()
    return self.thingCategories ~= nil and #(self.thingCategories) > 0
end

function ThingDef:get_VolumePerUnit()
    return (self.smallVolume and ThingDef.SmallVolumePerUnit or ThingDef.SmallUnitPerVolume)
end

function ThingDef:get_BaseMaxHitPoints()
    return Mathf.roundToInt(StatExtension.getStatValueAbstract(self, StatDef.of("MaxHitPoints")))
end

function ThingDef:get_BaseFlammability()
    return StatExtension.getStatValueAbstract(self, StatDef.of("Flammability"))
end

function ThingDef:get_BaseMarketValue()
    return StatExtension.getStatValueAbstract(self, StatDef.of("MarketValue"))
end

function ThingDef:get_BaseMass()
    return StatExtension.getStatValueAbstract(self, StatDef.of("Mass"))    
end

function ThingDef:playerAcquirable()
    return not self.destroyOnDrop
end

-- TODO: EverTransmitsPower




-- of
ThingDefOf = {}
function ThingDef.of(defName)
    local def = ThingDefOf[defName]
    if def == nil then
        def = ThingDef:new("Core:Defs_ThingDef_" .. defName)
        ThingDefOf[defName] = def
    end
    return def
end

return ThingDef