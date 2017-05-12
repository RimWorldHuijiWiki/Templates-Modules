local Test = {}

function Test.test(frame)
    local str = "RGBA(2, 3, 5, 6)"
    local temp = str:gsub("[RGBA\(\) ]", "")
    -- local temp = mw.text.trim(str, "[RGBA\(\)]")
    return temp
end

return Test