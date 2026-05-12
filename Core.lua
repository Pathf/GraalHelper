local _, GraalHelper = ...

GraalHelper.Runtime = {
    lastReflectAlertKey = nil,
    lastSilenceAlertKey = nil,
    lastStealAlertKey = nil,
    reflectDisplayUntil = 0,
    reflectTestMode = false,
    silenceDisplayUntil = 0,
    silenceTestMode = false,
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
