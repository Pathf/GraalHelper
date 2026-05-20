local _, GraalHelper = ...

function GraalHelper:ScanTargetDebuffs(unit)
    local silenceDebuffs = {}
    local silenceIcon = nil
    local silenceSignature = {}

    local stunDebuffs = {}
    local stunIcon = nil
    local stunSignature = {}

    local rootDebuffs = {}
    local rootIcon = nil
    local rootSignature = {}

    local disarmDebuffs = {}
    local disarmIcon = nil
    local disarmSignature = {}

    local fearDebuffs = {}
    local fearIcon = nil
    local fearSignature = {}

    for i = 1, 40 do
        local name, icon, _, _, _, expirationTime, _, _, _, spellId = UnitDebuff(unit, i)
        local locData = C_LossOfControl.GetActiveLossOfControlDataByUnit(unit, i)

        if not name or not locData or not locData.locType then
            break
        end

        if locData.locType == "SILENCE" or locData.locType == "SCHOOL_INTERRUPT" then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "silence")
            if self:IsSpellEnabled(spellKey) then
                table.insert(silenceDebuffs, name)
                table.insert(silenceSignature, spellKey)
                if not silenceIcon then silenceIcon = icon end
            end
        end

        if locData.locType == "STUN" or locData.locType == "STUN_MECHANIC" then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "stun")
            if self:IsSpellEnabled(spellKey) then
                table.insert(stunDebuffs, name)
                table.insert(stunSignature, spellKey)
                if not stunIcon then stunIcon = icon end
            end
        end

        if locData.locType == "ROOT" then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "root")
            if self:IsSpellEnabled(spellKey) then
                table.insert(rootDebuffs, name)
                table.insert(rootSignature, spellKey)
                if not rootIcon then rootIcon = icon end
            end
        end

        if locData.locType == "DISARM" then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "disarm")
            if self:IsSpellEnabled(spellKey) then
                table.insert(disarmDebuffs, name)
                table.insert(disarmSignature, spellKey)
                if not disarmIcon then disarmIcon = icon end
            end
        end

        if locData.locType == "FEAR_MECHANIC" or locData.locType == "CONFUSE" then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "fear")
            if self:IsSpellEnabled(spellKey) then
                table.insert(fearDebuffs, name)
                table.insert(fearSignature, spellKey)
                if not fearIcon then fearIcon = icon end
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

        stunDebuffs = stunDebuffs,
        stunIcon = stunIcon,
        stunSignature = table.concat(stunSignature, "|"),

        rootDebuffs = rootDebuffs,
        rootIcon = rootIcon,
        rootSignature = table.concat(rootSignature, "|"),

        disarmDebuffs = disarmDebuffs,
        disarmIcon = disarmIcon,
        disarmSignature = table.concat(disarmSignature, "|"),

        fearDebuffs = fearDebuffs,
        fearIcon = fearIcon,
        fearSignature = table.concat(fearSignature, "|"),
    }
end
