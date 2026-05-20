local _, GraalHelper = ...

GraalHelper.Runtime = {
    lastReflectAlertKey = nil,
    lastSilenceAlertKey = nil,
    lastStunAlertKey = nil,
    lastRootAlertKey = nil,
    lastDisarmAlertKey = nil,
    lastFearAlertKey = nil,
    lastStealAlertKey = nil,
    reflectDisplayUntil = 0,
    reflectTestMode = false,
    silenceDisplayUntil = 0,
    silenceTestMode = false,
    stunDisplayUntil = 0,
    stunTestMode = false,
    rootDisplayUntil = 0,
    rootTestMode = false,
    disarmDisplayUntil = 0,
    disarmTestMode = false,
    fearDisplayUntil = 0,
    fearTestMode = false,
    stealDisplayUntil = 0,
    stealTestMode = false,

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
