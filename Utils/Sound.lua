local _, GraalHelper = ...

local C = GraalHelper.Constants

function GraalHelper:GetSelectedSoundEntry(soundValue)
    for _, entry in ipairs(C.SOUND_OPTIONS) do
        if entry.value == soundValue then
            return entry
        end
    end

    return C.SOUND_OPTIONS[1]
end

function GraalHelper:PlayConfiguredSound(sectionConfig)
    if not sectionConfig.soundEnabled then
        return
    end

    local entry = self:GetSelectedSoundEntry(sectionConfig.sound)
    if not entry then
        return
    end

    if entry.kit then
        local ok = pcall(PlaySound, entry.kit, "Master")

        if ok then
            return
        end
    end

    if entry.file then
        pcall(PlaySoundFile, entry.file, "Master")
    end
end
