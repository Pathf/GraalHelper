local _, GraalHelper = ...

local C = GraalHelper.Constants
local ritualOfRefreshmentID = C.SPELL.RITUAL_OF_REFRESHMENT.ID
local ritualOfSoulsID = C.SPELL.RITUAL_OF_SOULS.ID
local ritualOfSummoningID = C.SPELL.RITUAL_OF_SUMMONING.ID
local summoningStoneID = C.SPELL.SUMMONING_STONE.ID

function Summoning(spellIDs, spellID, message)
    if (not spellIDs[spellID]) then return end
    GraalHelper:SendRaidOrParty(message)
    return true
end

function SummoningPeopleByStone(spellID)
    local target = GetUnitName("target", false)
    if target == nil then return end
    local trackedSpells = { [summoningStoneID] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning " .. target .. ". Please click! <-")
end

function SummoningPeopleByRitual(spellID)
    local target = GetUnitName("target", false)
    if target == nil then return end
    local trackedSpells = { [ritualOfSummoningID] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning " .. target .. ". Please click! <-")
end

function SummoningRitualOfSouls(spellID)
    local trackedSpells = { [ritualOfSoulsID] = true }
    return Summoning(trackedSpells, spellID, "-> Summoning Candy. Please click! <-")
end

function SummoningRitualOfRefreshment(spellID)
    local trackedSpells = { [ritualOfRefreshmentID] = true }
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
