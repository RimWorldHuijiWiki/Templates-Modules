local Texture2D = {}

local random
local multi

function Texture2D.file(path, )
    if random == nil then
        Texture2D.initRandom()
    end
    
end

function Texture2D.initRandom()
    random = {}

    -- 古老的路灯和水泥护栏
    random["Things/Building/Ruins/AncientConcreteBarrier"] = {
        "AncientConcreteBarrierA.png",
        "AncientConcreteBarrierB.png"
    }
    random["Things/Building/Ruins/AncientLamppost"] = {
        "AncientLamppostA.png",
        "AncientLamppostB.png",
        "AncientLamppostC.png"
    }

    -- 雕塑
    random["Things/Building/Art/SculptureSmall"] = {
        "SculptureSmallBustA.png",
        "SculptureSmallBustB.png",
        "SculptureSmallBustC.png"        
    }
    random["Things/Building/Art/SculptureLarge"] = {
        "SculptureLargeAbstractA.png",
        "SculptureLargeAbstractB.png",
        "SculptureLargeAbstractC.png"
    }
    random["Things/Building/Art/SculptureGrand"] = {
        "SculptureGrandAbstractA.png",
        "SculptureGrandAbstractB.png",
        "SculptureGrandAbstractC.png"
    }

    -- 飞船残骸
    random["Things/Building/Exotic/ShipChunk"] = {
        "ShipChunkA.png",
        "ShipChunkB.png",
        "ShipChunkC.png",
    }

    -- 钢铁
    random["Things/Item/Resource/Metal"] = {
        "MetalA.png",
        "MetalB.png",
        "MetalC.png",
    }

    -- 石块
    random["Things/Item/Chunk/ChunkStone"] = {
        "RockLowA.png",
        "RockLowB.png",
        "RockLowC.png",
    }
    random["Things/Item/Chunk/ChunkSlag"] = {
        "MetalDebrisA.png",
        "MetalDebrisB.png",
        "MetalDebrisC.png"
    }

    random["Things/Plant/Rose"] = {"RoseA.png"}
    random["Things/Plant/Daylily"] = {"Daylily.png"}

    random["Things/Plant/RicePlant"] = {"RicePlantA.png"}
    random["Things/Plant/PotatoPlant"] = {"PotatoPlant.png"}
    random["Things/Plant/CornPlant"] = 
    random["Things/Plant/CornImmature"]
    random["Things/Plant/StrawberryPlant"]
    random["Things/Plant/StrawberryImmature"]
    random["Things/Plant/Haygrass"]
    random["Things/Plant/CottonPlant"]
    random["Things/Plant/CottonImmature"]
    random["Things/Plant/Devilstrand"]
    random["Things/Plant/Healroot"]
    random["Things/Plant/HopsPlant"]
    random["Things/Plant/SmokeleafPlant"]
    random["Things/Plant/PsychoidPlant"]

    random["Things/Plant/BurnedTree"]
    random["Things/Plant/Ambrosia"] = {"Ambrosia.png"}
    random["Things/Plant/AmbrosiaImmature"] = {""}

    random["Things/Plant/Agave"]
    random["Things/Plant/SaguaroCactus"]
    random["Things/Plant/PincushionCactus"]

    random["Things/Plant/RaspberryPlant"]
    random["Things/Plant/RaspberryImmature"]
    random["Things/Plant/Bush"]
    random["Things/Plant/Healroot"]
    random["Things/Plant/Grass"]
    random["Things/Plant/Dandelion"]
    random["Things/Plant/Astragalus"]
    random["Things/Plant/Moss"]
    random["Things/Plant/TreeOak"]
    random["Things/Plant/TreePoplar"]
    random["Things/Plant/TreePine"]
    random["Things/Plant/TreeBirch"]


    random["Things/Plant/Grass"]
    random["Things/Plant/TreeTeak"]
    random["Things/Plant/TreeCecropia"]

    random[""]
    
end

return Texture2D