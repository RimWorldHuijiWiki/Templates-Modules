local Textures = {}

local dict

function Textures.getFileX(frame)
    return Textures.getFileName(frame.args[1])
end

function Textures.getFileName(path)
    return "Textures_" .. path:lower():gsub("/", "_") .. ".png"
end

function Textures.getLink(path)
    return "[[:File:" .. Textures.getFileName(path) .. "|" .. path .. "]]"
end

function Textures.getRandom(path)
    dict = dict or mw.loadData("Module:Textures_dict")
end

return Textures