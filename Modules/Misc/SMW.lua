local SMW = {}

function SMW.showX(frame)
    return SMW.show(frame.args[1], frame.args[2], frame.args[3])
end

function SMW.show(page, prop, default)

    local queryResult = mw.smw.ask("[[" .. page .. "]]|?" .. prop .. "|mainlabel=-|headers=hide")

    if type(queryResult) == "table" then
        for i, row in pairs(queryResult) do
            for name, val in pairs(row) do
                return val
            end
        end
    end

    return default
end

return SMW