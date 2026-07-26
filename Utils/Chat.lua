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

function GraalHelper:SendRaidOrParty(message)
    if IsInRaid() then
        SendChatMessage(message, "RAID")
    elseif IsInGroup() then
        SendChatMessage(message, "PARTY")
    end
end

function GraalHelper:SendChatMessage(message, chatType)
    if (chatType == 'RAID' and not IsInRaid()) or (chatType == 'PARTY' and not IsInGroup()) then
        return
    elseif chatType == 'RAID_PARTY' then
        self:SendRaidOrParty(message)
    else
        SendChatMessage(message, chatType)
    end
end
