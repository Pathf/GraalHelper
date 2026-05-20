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

function GraalHelper:SortTrackedSpells()
    if not self.config or not self.config.trackedSpells then
        return
    end

    table.sort(self.config.trackedSpells, function(a, b)
        local nameA = string.lower(a.name or "")
        local nameB = string.lower(b.name or "")

        if nameA == nameB then
            local catA = a.categoryOrder or 99
            local catB = b.categoryOrder or 99

            if catA == catB then
                return (a.spellId or 0) < (b.spellId or 0)
            end

            return catA < catB
        end

        return nameA < nameB
    end)
end

local function GetCategoryName(category)
    if category == "steal" then
        return { label = L.trackSteal, order = 1 }
    elseif category == "reflect" then
        return { label = L.trackReflect, order = 2 }
    elseif category == "silence" then
        return { label = L.trackSilence, order = 3 }
    elseif category == "stun" then
        return { label = L.trackStun, order = 4 }
    elseif category == "root" then
        return { label = L.trackRoot, order = 5 }
    elseif category == "disarm" then
        return { label = L.trackDisarm, order = 6 }
    elseif category == "fear" then
        return { label = L.trackFear, order = 7 }
    end
    return { label = L.trackUnknow, order = 99 }
end

function GraalHelper:RegisterTrackedSpell(name, spellId, icon, categoryType)
    if not self.config then
        self:PrintError(L.errors.options.null)
        return
    end

    self.config.trackedSpells = self.config.trackedSpells or {}
    self.config.spellFilter = self.config.spellFilter or {}
    local spellKey = self:MakeSpellKey(name, spellId, categoryType)

    for _, entry in ipairs(self.config.trackedSpells) do
        if entry.key == spellKey then
            if (not entry.icon or entry.icon == "") and icon then
                entry.icon = icon
            end
            if (not entry.spellId or entry.spellId == 0) and spellId then
                entry.spellId = spellId
            end
            return spellKey
        end
    end

    local category = GetCategoryName(categoryType)

    table.insert(self.config.trackedSpells, {
        key = spellKey,
        name = name or spellKey,
        spellId = spellId,
        icon = icon,
        category = categoryType,
        categoryLabel = category.label,
        categoryOrder = category.order,
    })

    if self.config.spellFilter[spellKey] == nil then
        self.config.spellFilter[spellKey] = true
    end

    self:SortTrackedSpells()

    return spellKey
end
