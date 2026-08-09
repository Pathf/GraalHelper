local _, GraalHelper = ...

local L = GraalHelper.L

local function TargetHasMagicDebuff()
    local i = 1

    while true do
        local aura = C_UnitAuras.GetDebuffDataByIndex("target", i)
        if not aura then break end

        if aura.dispelName == "Magic" then
            return "Magic", aura.name, aura.spellId, aura.icon, L.dispelTypeMagic
        end

        if aura.dispelName == "Poison" then
            return "Poison", aura.name, aura.spellId, aura.icon, L.dispelTypePoison
        end

        if aura.dispelName == "Disease" then
            return "Disease", aura.name, aura.spellId, aura.icon, L.dispelTypeDisease
        end

        if aura.dispelName == "Curse" then
            return "Curse", aura.name, aura.spellId, aura.icon, L.dispelTypeCurse
        end

        -- Pour tranquilisant / appaisement
        if aura.dispelName == "Enrage" then
            return "Enrage", aura.name, aura.spellId, aura.icon, L.dispelTypeEnrage
        end

        i = i + 1
    end

    return nil
end

local function IsDispelable(dispelType)
    if not dispelType or (UnitExists("target") and not UnitIsDeadOrGhost("target") and not UnitIsFriend("player", "target")) then return false end

    local playerClass = select(2, UnitClass("player"))
    return (dispelType == 'Magic' and (playerClass == 'PRIEST' or playerClass == 'PALADIN'))
        or (dispelType == 'Poison' and (playerClass == 'SHAMAN' or playerClass == 'DRUID' or playerClass == 'PALADIN'))
        or (dispelType == 'Disease' and (playerClass == 'SHAMAN' or playerClass == 'PRIEST' or playerClass == 'PALADIN'))
        or (dispelType == 'Curse' and (playerClass == 'DRUID' or playerClass == 'MAGE'))
        or (dispelType == 'Enrage' and playerClass == 'HUNTER')
end

function GraalHelper:ScanTargetAllyDebuffs()
    local dispelDebuffs = {}
    local dispelIcon = nil
    local dispelSignature = {}

    local dispelType, spellDebuffName, spellDebuffId, spellDebuffIcon, dispelTypeTranslated = TargetHasMagicDebuff()
    if IsDispelable(dispelType) then
        local spellKey = self:RegisterTrackedSpell(spellDebuffName, spellDebuffId, spellDebuffIcon, "dispel")
        if self:IsSpellEnabled(spellKey) then
            table.insert(dispelDebuffs, spellDebuffName .. " -> " .. dispelTypeTranslated)
            table.insert(dispelSignature, spellKey)
            if not dispelIcon then dispelIcon = spellDebuffIcon end
        end
    end

    return {
        dispelDebuffs = dispelDebuffs,
        dispelIcon = dispelIcon,
        dispelSignature = table.concat(dispelSignature, "|")
    }
end

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
        local name, icon, _, _, _, _, _, _, _, spellId = UnitDebuff(unit, i)
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
