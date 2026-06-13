local _, GraalHelper = ...

function GraalHelper:Print(message)
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cff69ccf0GraalHelper:|r " .. tostring(message)
    )
end

function GraalHelper:PrintDebug(...)
    local args = {}

    for i = 1, select("#", ...) do
        args[i] = tostring(select(i, ...))
    end

    DEFAULT_CHAT_FRAME:AddMessage()
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cff69ccf0GraalHelper DEBUG:|r " .. table.concat(args, " ")
    )
end

function GraalHelper:PrintError(message)
    DEFAULT_CHAT_FRAME:AddMessage(
        "|cffff4040GraalHelper Error:|r " .. tostring(message)
    )
end

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
