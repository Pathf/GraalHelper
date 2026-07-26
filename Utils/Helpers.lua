local _, GraalHelper = ...

function GraalHelper:RoundNumber(value)
    if not value then
        return 0
    elseif value >= 0 then
        return math.floor(value + 0.5)
    else
        return math.ceil(value - 0.5)
    end
end

function GraalHelper:CopyDefaults(source, copy)
    if type(copy) ~= "table" then
        copy = {}
    end

    for k, v in pairs(source) do
        if type(v) == "table" then
            copy[k] = self:CopyDefaults(v, copy[k])
        elseif copy[k] == nil then
            copy[k] = v
        end
    end

    return copy
end

function GraalHelper:FormatBuffList(buffs, fallbackText)
    if not buffs or #buffs == 0 then
        return fallbackText or ""
    end

    local text = table.concat(buffs, ", ")
    if string.len(text) > 95 then
        text = string.sub(text, 1, 92) .. "..."
    end
    return text
end
