local _, GraalHelper = ...

local L = GraalHelper.L

function GraalHelper:MakeSpellKey(name, id, category)
    if id and id > 0 then
        return string.format("%s:%d", category or "spell", id)
    end
    return string.format("%s:%s", category or "spell", tostring(name or "unknown"))
end

function GraalHelper:IsSpellEnabled(spellKey)
    if not self.config or not self.config.spellFilter then
        return true
    end
    return self.config.spellFilter[spellKey] ~= false
end

local function GetCategoryName(category)
    if category == "disarm" then
        return { label = L.trackDisarm, order = 1 }
    elseif category == "fear" then
        return { label = L.trackFear, order = 2 }
    elseif category == "reflect" then
        return { label = L.trackReflect, order = 3 }
    elseif category == "root" then
        return { label = L.trackRoot, order = 4 }
    elseif category == "silence" then
        return { label = L.trackSilence, order = 5 }
    elseif category == "stun" then
        return { label = L.trackStun, order = 6 }
    elseif category == "steal" then
        return { label = L.trackSteal, order = 7 }
    elseif category == "kick" then
        return { label = L.trackKick, order = 8 }
    end
    return { label = L.trackUnknow, order = 99 }
end

local function UpdateOldOrder(spell)
    local tmp = GetCategoryName(spell.category)
    spell.categoryLabel = tmp.label
    spell.categoryOrder = tmp.order
    spell.updateVersion = 1
end

function GraalHelper:SortTrackedSpells()
    if not self.config or not self.config.trackedSpells then
        return
    end

    table.sort(self.config.trackedSpells, function(a, b)
        if a.updateVersion == nil then UpdateOldOrder(a) end
        if b.updateVersion == nil then UpdateOldOrder(b) end
        local catA = a.categoryOrder or 99
        local catB = b.categoryOrder or 99
        if catA == catB then
            local nameA = string.lower(a.name or "")
            local nameB = string.lower(b.name or "")
            if nameA == nameB then
                return (a.spellId or 0) < (b.spellId or 0)
            end
            return nameA < nameB
        end
        return catA < catB
    end)
end

function GraalHelper:RegisterTrackedSpell(name, spellId, icon, categoryType)
    if not self.config then
        self:PrintError(L.errors.options.null)
        return
    end

    self.config.trackedSpells = self.config.trackedSpells or {}
    self.config.spellFilter = self.config.spellFilter or {}
    local spellKey = self:MakeSpellKey(name, spellId, categoryType)
    local spellKeyWithoutId = self:MakeSpellKey(name, nil, categoryType) -- Update old keys
    local category = GetCategoryName(categoryType)                       -- Update old categories

    for _, entry in ipairs(self.config.trackedSpells) do
        if entry.key == spellKeyWithoutId then entry.key = spellKey end -- Update old keys
        if entry.key == spellKey then
            entry.name = name or spellKey
            entry.spellId = spellId
            entry.icon = icon
            entry.category = categoryType
            entry.categoryLabel = category.label
            entry.categoryOrder = category.order
            return spellKey
        end
    end

    table.insert(self.config.trackedSpells, {
        key = spellKey,
        name = name or spellKey,
        spellId = spellId,
        icon = icon,
        category = categoryType,
        categoryLabel = category.label,
        categoryOrder = category.order,
        updateVersion = 1
    })

    if self.config.spellFilter[spellKey] == nil then
        self.config.spellFilter[spellKey] = true
    end

    self:SortTrackedSpells()

    return spellKey
end
