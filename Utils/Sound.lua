local _, GraalHelper = ...

local C = GraalHelper.Constants

local function GetSelectedEntry(list, value)
    for _, entry in ipairs(list) do
        if entry.value == value then return entry end
    end
    return list[1]
end

function GraalHelper:GetSelectedMinDurationEntry(minValue)
    return GetSelectedEntry(C.DURATION_OPTIONS, minValue)
end

function GraalHelper:GetSelectedSoundEntry(soundValue)
    return GetSelectedEntry(C.SOUND_OPTIONS, soundValue)
end

function GraalHelper:GetSelectedChatEntry(chatValue)
    return GetSelectedEntry(C.CHAT_OPTIONS, chatValue)
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
