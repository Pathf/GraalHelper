local _, GraalHelper = ...

local spellReflectionIds = GraalHelper.Constants.SPELL_REFLECTION_SPELL_IDS
local spellReflectionNames = GraalHelper.L.MATCH.SPELL_REFLECTION_NAMES
local spellHunterPackAspectId = GraalHelper.Constants.HUNTER_PACK_ASPECT_ID

function GraalHelper:ScanTargetBuffs(unit)
    local stealBuffs = {}
    local stealIcon = nil
    local stealSignature = {}

    local reflectBuffs = {}
    local reflectIcon = nil
    local reflectSignature = {}

    for i = 1, 40 do
        local name, icon, _, _, _, _, _, isStealable, _, spellId = UnitBuff(unit, i)

        if not name then
            break
        end

        -- STEALABLE SPELL
        if isStealable then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "steal")
            if self:IsSpellEnabled(spellKey) then
                table.insert(stealBuffs, name)
                table.insert(stealSignature, spellKey)
                if not stealIcon then
                    stealIcon = icon
                end
            end
        end

        -- REFLECTION SPELL
        if self:InSpellList(spellReflectionNames, spellReflectionIds, name, spellId) then
            local spellKey = self:RegisterTrackedSpell(name, spellId, icon, "reflect")
            if self:IsSpellEnabled(spellKey) then
                table.insert(reflectBuffs, name)
                table.insert(reflectSignature, spellKey)
                if not reflectIcon then
                    reflectIcon = icon
                end
            end
        end
    end

    if self.options and self.options:IsShown() then
        self:RefreshTrackedSpellsUI()
    end

    return {
        stealBuffs = stealBuffs,
        stealIcon = stealIcon,
        stealSignature = table.concat(stealSignature, "|"),

        reflectBuffs = reflectBuffs,
        reflectIcon = reflectIcon,
        reflectSignature = table.concat(reflectSignature, "|"),
    }
end

function GraalHelper:ScanPlayerBuffs(unit)
    local hunterPackAspectBuffs = {}
    local hunterPackAspectIcon = nil
    local hunterPackAspectSignature = {}


    local playerClass = select(2, UnitClass("player"))

    for i = 1, 40 do
        local name, icon, _, _, _, _, _, _, _, spellId = UnitBuff(unit, i)

        if not name then
            break
        end

        -- HUNTER PACK ASPECT
        if playerClass == "HUNTER" and spellId == spellHunterPackAspectId then
            table.insert(hunterPackAspectBuffs, name)
            if not hunterPackAspectIcon then
                hunterPackAspectIcon = icon
            end
        end
    end

    if self.options and self.options:IsShown() then
        self:RefreshTrackedSpellsUI()
    end

    return {
        hunterPackAspectBuffs = hunterPackAspectBuffs,
        hunterPackAspectIcon = hunterPackAspectIcon,
        hunterPackAspectSignature = table.concat(hunterPackAspectSignature, "|"),
    }
end
