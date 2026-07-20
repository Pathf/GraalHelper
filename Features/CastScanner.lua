local _, GraalHelper = ...

function GraalHelper:ScanTargetCasts(unit)
    local kickBuffs = {}
    local kickIcon = nil
    local kickSignature = {}

    local spellName, _, icon, _, _, _, _, notKick = UnitCastingInfo("target")

    -- KICK SPELL
    if spellName and not notKick then
        local spellKey = self:RegisterTrackedSpell(spellName, nil, icon, "kick")
        if self:IsSpellEnabled(spellKey) then
            table.insert(kickBuffs, spellName)
            table.insert(kickSignature, spellKey)
            if not kickIcon then
                kickIcon = icon
            end
        end

        if self.options and self.options:IsShown() then
            self:RefreshTrackedSpellsUI()
        end
    end

    return {
        kickBuffs = kickBuffs,
        kickIcon = kickIcon,
        kickSignature = table.concat(kickSignature, "|"),
    }
end
