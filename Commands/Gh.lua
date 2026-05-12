local _, GraalHelper = ...

local L = GraalHelper.L

local function showAllWarnings()
    GraalHelper:StartStealTestMode()
    GraalHelper:StartReflectTestMode()
    GraalHelper:StartSilenceTestMode()
end

local function lockAllWarnings()
    GraalHelper.config.steal.locked = true
    GraalHelper.config.reflect.locked = true
    GraalHelper:RefreshOptionsUI()
    GraalHelper:Print(L.bothLocked)
end

local function unlockAllWarnings()
    GraalHelper.config.steal.locked = false
    GraalHelper.config.reflect.locked = false
    GraalHelper:RefreshOptionsUI()
    GraalHelper:Print(L.bothUnlocked)
end

local function printAllCommands()
    GraalHelper:Print(L.slashMenu)
    GraalHelper:Print(L.slashTest)
    GraalHelper:Print(L.slashTestBlue)
    GraalHelper:Print(L.slashTestRed)
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
