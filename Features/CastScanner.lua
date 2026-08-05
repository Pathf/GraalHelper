local _, GraalHelper = ...

function GraalHelper:ScanTargetCasts(unit)
    local kickBuffs = {}
    local kickIcon = nil
    local kickSignature = {}

    local spellName, _, icon, startTimeMs, endTimeMs, _, _, notKick, spellId = UnitCastingInfo("target")

    -- KICK SPELL
    if not notKick and endTimeMs and startTimeMs then
        local duration = (endTimeMs - startTimeMs) / 1000
        if duration > GraalHelper.config.kick.minDuration then
            local spellKey = self:RegisterTrackedSpell(spellName, spellId, icon, "kick")
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
    end

    return {
        kickBuffs = kickBuffs,
        kickIcon = kickIcon,
        kickSignature = table.concat(kickSignature, "|"),
    }
end
