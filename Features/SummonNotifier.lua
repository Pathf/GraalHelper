local _, GraalHelper = ...

function Summoning(spellIDs, spellID, message)
    if (not spellIDs[spellID]) then return false end
    if IsInRaid() then
        SendChatMessage(message, "RAID")
    else
        SendChatMessage(message, "PARTY")
    end
    return true
end

function SummoningPeople(spellID)
    local target = GetUnitName("target", false)
    if target == nil then return end
    local trackedSpells = {
        [23598] = true, -- 23598 = summoning stone (channeled)
        [698] = true,   -- 698 = ritual of summoning (initial cast, not the channel)
    }
    return Summoning(trackedSpells, spellID, "-> Summoning " .. target .. ". Please click! <-")
end

function SummoningRitualOfSouls(spellID)
    local trackedSpells = {
        [29893] = true, -- 29893 = ritual of souls
    }
    return Summoning(trackedSpells, spellID, "-> Summoning Candy. Please click! <-")
end

function SummoningRitualOfRefreshment(spellID)
    local trackedSpells = {
        [43987] = true, -- 43987 = Ritual of refreshment
    }
    return Summoning(trackedSpells, spellID, "-> Summoning Refreshment. Please click! <-")
end

function GraalHelper:SummonNotify(caster, spellID)
    local desactivate = not self.config.summonNotifier.active
    if desactivate or caster ~= "player" or IsInGroup() == false then return end
    if SummoningPeople(spellID) then return end
    if SummoningRitualOfSouls(spellID) then return end
    if SummoningRitualOfRefreshment() then return end
end
