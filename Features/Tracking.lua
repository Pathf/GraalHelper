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

function GraalHelper:RegisterTrackedSpell(name, spellId, icon, category)
    if not self.config then
        self:PrintError(L.errors.options.null)
        return
    end

    self.config.trackedSpells = self.config.trackedSpells or {}
    self.config.spellFilter = self.config.spellFilter or {}
    local spellKey = self:MakeSpellKey(name, spellId, category)

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

    table.insert(self.config.trackedSpells, {
        key = spellKey,
        name = name or spellKey,
        spellId = spellId,
        icon = icon,
        category = category,
        categoryLabel = category == "reflect" and L.trackReflect or L.trackSteal,
        categoryOrder = category == "reflect" and 2 or 1,
    })

    if self.config.spellFilter[spellKey] == nil then
        self.config.spellFilter[spellKey] = true
    end

    self:SortTrackedSpells()

    return spellKey
end
