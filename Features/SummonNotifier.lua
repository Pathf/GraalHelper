local _, GraalHelper = ...

function GraalHelper:SummonNotify(caster, spellID)
    local desactivate = not self.config.summonNotifier.active
    if desactivate or caster ~= "player" or IsInGroup() == false then return end

    local target = GetUnitName("target", false)
    if target == nil then return end

    -- 698 = ritual of summoning (initial cast, not the channel)
    -- 23598 = summoning stone (channeled)
    if (spellID ~= 698 and spellID ~= 23598) then return end

    local message = "-> Summoning " .. target .. ". Please click! <-"
    if IsInRaid() then
        SendChatMessage(message, "RAID")
    else
        SendChatMessage(message, "PARTY")
    end
end
