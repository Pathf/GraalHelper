local _, GraalHelper = ...

function GraalHelper:InSpellList(spellListName, spellListId, name, id)
    if (spellListId and id and spellListId[id]) or (spellListName and name and spellListName[name]) then
        return true
    end
    return false
end
