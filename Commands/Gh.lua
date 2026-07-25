local _, GraalHelper = ...

local L = GraalHelper.L

local function showAllWarnings()
    GraalHelper:StartStealTestMode()
    GraalHelper:StartKickTestMode()
    GraalHelper:StartHunterPackAspectTestMode()
    GraalHelper:StartReflectTestMode()
    GraalHelper:StartSilenceTestMode()
    GraalHelper:StartStunTestMode()
    GraalHelper:StartRootTestMode()
    GraalHelper:StartDisarmTestMode()
    GraalHelper:StartFearTestMode()
end

local function lockAllWarnings()
    GraalHelper.config.steal.locked = true
    GraalHelper.config.kick.locked = true
    GraalHelper.config.hunterPackAspect.locked = true
    GraalHelper.config.reflect.locked = true
    GraalHelper.config.silence.locked = true
    GraalHelper.config.stun.locked = true
    GraalHelper.config.root.locked = true
    GraalHelper.config.disarm.locked = true
    GraalHelper.config.fear.locked = true
    GraalHelper:RefreshOptionsUI()
    GraalHelper:Print(L.bothLocked)
end

local function unlockAllWarnings()
    GraalHelper.config.steal.locked = false
    GraalHelper.config.kick.locked = false
    GraalHelper.config.hunterPackAspect.locked = false
    GraalHelper.config.reflect.locked = false
    GraalHelper.config.silence.locked = false
    GraalHelper.config.stun.locked = false
    GraalHelper.config.root.locked = false
    GraalHelper.config.disarm.locked = false
    GraalHelper.config.fear.locked = false
    GraalHelper:RefreshOptionsUI()
    GraalHelper:Print(L.bothUnlocked)
end

local function printAllCommands()
    GraalHelper:Print(L.slashMenu)
    GraalHelper:Print(L.slashTest)
    GraalHelper:Print(L.slashHide)
    GraalHelper:Print(L.slashLock)
    GraalHelper:Print(L.slashUnlock)
end

function GraalHelper:SetupSlashCommands()
    SLASH_GRAALHELPER1 = "/gh"

    SlashCmdList["GRAALHELPER"] = function(msg)
        msg = string.lower((msg or ""):gsub("^%s+", ""):gsub("%s+$", ""))

        if msg == "" then
            GraalHelper:ToggleOptions()
        elseif msg == "t" then
            showAllWarnings()
        elseif msg == "hide" then
            GraalHelper:StopAllTestsAndHide()
        elseif msg == "lock" then
            lockAllWarnings()
        elseif msg == "unlock" then
            unlockAllWarnings()
        else
            printAllCommands()
        end
    end
end
