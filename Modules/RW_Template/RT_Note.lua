local Note = {}

function Note.noteX(frame)
    local class = frame.args[1]
    local icon = frame.args[2]
    local label = frame.args[3]
    local text = frame.args[4]
    return Note.note(class, icon, label, text)
end

function Note.note(class, icon, label, text)
    local newNote = "<div class=\"rw-note"
    if class == "rimworld" then
        newNote = newNote .. " quote-primary quote-rimworld"
    elseif class ~= nil and class ~= "" then
        newNote = newNote .. " quote-" .. class
    end
    if icon ~= nil and icon ~= "" then
        newNote = newNote .. " fa-" .. icon
    end
    newNote = newNote .. "\">"
    local flagLabel = (label ~= nil and label ~= "")
    local flagText = (text ~= nil and text ~= "")
    if flagLabel then
        newNote = newNote .. "<strong>" .. label .. "</strong>"
    end
    if flagLabel and flagText then
        newNote = newNote .. "<br/>"
    end
    if flagText then
        newNote = newNote .. text
    end
    return newNote .. "</div>"
end

return Note