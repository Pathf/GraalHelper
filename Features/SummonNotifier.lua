local _, GraalHelper = ...

function Summoning(spellIDs, spellID, message)
    if (not spellIDs[spellID]) then return end
    if IsInRaid() then
        SendChatMessage(message, "RAID")
    else
        SendChatMessage(message, "PARTY")
    end
    return true
end

function SummoningPeopleByStone(spellID)
    local target = GetUnitName("target", false)
    if target == nil then return end
    -- 23598 = summoning stone (channeled)
    local trackedSpells = { [23598] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning " .. target .. ". Please click! <-")
end

function SummoningPeopleByRitual(spellID)
    local target = GetUnitName("target", false)
    if target == nil then return end
    -- 698 = ritual of summoning (initial cast, not the channel)
    local trackedSpells = { [698] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning " .. target .. ". Please click! <-")
end

function SummoningRitualOfSouls(spellID)
    -- 29893 = ritual of souls
    local trackedSpells = { [29893] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning Candy. Please click! <-")
end

function SummoningRitualOfRefreshment(spellID)
    -- 43987 = Ritual of refreshment
    local trackedSpells = { [43987] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning Refreshment. Please click! <-")
end

function GraalHelper:SummonNotify(caster, spellID)
    local desactivate = not self.config.summonNotifier.active
    if desactivate or caster ~= "player" or IsInGroup() == false then return end
    SummoningPeopleByStone(spellID)
    SummoningPeopleByRitual(spellID)
    SummoningRitualOfSouls(spellID)
    SummoningRitualOfRefreshment(spellID)
end
