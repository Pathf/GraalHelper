local _, GraalHelper = ...

GraalHelper.Runtime = {
    lastReflectAlertKey = nil,
    reflectDisplayUntil = 0,
    reflectTestMode = false,

    lastDispelAlertKey = nil,
    dispelDisplayUntil = 0,
    dispelTestMode = false,

    lastSilenceAlertKey = nil,
    silenceDisplayUntil = 0,
    silenceTestMode = false,

    lastStunAlertKey = nil,
    stunDisplayUntil = 0,
    stunTestMode = false,

    lastRootAlertKey = nil,
    rootDisplayUntil = 0,
    rootTestMode = false,

    lastDisarmAlertKey = nil,
    disarmDisplayUntil = 0,
    disarmTestMode = false,

    lastFearAlertKey = nil,
    fearDisplayUntil = 0,
    fearTestMode = false,

    lastStealAlertKey = nil,
    stealDisplayUntil = 0,
    stealTestMode = false,

    lastKickAlertKey = nil,
    kickDisplayUntil = 0,
    kickTestMode = false,

    lastHunterPackAspectAlertKey = nil,
    hunterPackAspectDisplayUntil = 0,
    hunterPackAspectTestMode = false,

    ticker = 0,
    updateInterval = 0.10,
}

GraalHelper.frame = CreateFrame("Frame", "GraalHelperFrame")

GraalHelper.frame:SetScript("OnEvent", function(_, event, ...)
    if GraalHelper[event] then
        GraalHelper[event](GraalHelper, ...)
    end
end)

GraalHelper.frame:RegisterEvent("PLAYER_LOGIN")
GraalHelper.frame:RegisterEvent("PLAYER_LOGOUT")
GraalHelper.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
GraalHelper.frame:RegisterEvent("UNIT_SPELLCAST_START")
GraalHelper.frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
GraalHelper.frame:RegisterEvent("PLAYER_REGEN_ENABLED")
GraalHelper.frame:RegisterEvent("PLAYER_REGEN_DISABLED")
GraalHelper.playerRegen = CreateFrame("Frame")
