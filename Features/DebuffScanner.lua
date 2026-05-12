local _, GraalHelper = ...

local spellSilenceNames = GraalHelper.L.MATCH.SPELL_SILENCE_NAMES

function GraalHelper:ScanTargetDebuffs(unit)
    local silenceDebuffs = {}
    local silenceIcon = nil
    local silenceSignature = {}

    for i = 1, 40 do
        local name, icon, _, _, _, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)

        if not name then
            break
        end

        -- SILENCE SPELL
        if self:InSpellList(spellSilenceNames, nil, name, spellId) then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "silence")
            if self:IsSpellEnabled(spellKey) then
                table.insert(silenceDebuffs, name)
                table.insert(silenceSignature, spellKey)
                if not silenceIcon then
                    silenceIcon = icon
                end
            end
        end
    end

    if self.options and self.options:IsShown() then
        self:RefreshTrackedSpellsUI()
    end

    return {
        silenceDebuffs = silenceDebuffs,
        silenceIcon = silenceIcon,
        silenceSignature = table.concat(silenceSignature, "|"),
    }
end
