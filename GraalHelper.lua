local _, GraalHelper = ...
local L = GraalHelper.L
local C = GraalHelper.Constants
local R = GraalHelper.Runtime
local ICONS = C.ICONS.SPELLS

function GraalHelper:PLAYER_LOGIN()
    GraalHelperDB = self:CopyDefaults(self.defaults, GraalHelperDB or {})
    self.config = GraalHelperDB
    self.config.trackedSpells = self.config.trackedSpells or {}
    self.config.spellFilter = self.config.spellFilter or {}
    self:SortTrackedSpells()

    self.uiSteal = self:CreateDisplayFrame(
        "GraalHelperMainFrame",
        self.config.steal,
        {
            titleText = C.BLUE .. L.stealTitle .. C.RESET,
            lineText = L.spellstealLine,
            defaultIcon = ICONS.STEAL,
            glowR = 0.20,
            glowG = 0.55,
            glowB = 1.00,
            barR = 0.25,
            barG = 0.65,
            barB = 1.00,
        }
    )

    self.uiReflect = self:CreateDisplayFrame(
        "GraalHelperReflectFrame",
        self.config.reflect,
        {
            titleText = C.RED .. L.reflectTitle .. C.RESET,
            lineText = L.reflectLine,
            defaultIcon = ICONS.REFLECT,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self.uiSilence = self:CreateDisplayFrame(
        "GraalHelperSilenceFrame",
        self.config.silence,
        {
            titleText = C.RED .. L.silenceTitle .. C.RESET,
            lineText = L.silenceLine,
            defaultIcon = ICONS.SILENCE,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self.uiStun = self:CreateDisplayFrame(
        "GraalHelperStunFrame",
        self.config.stun,
        {
            titleText = C.RED .. L.stunTitle .. C.RESET,
            lineText = L.stunLine,
            defaultIcon = ICONS.STUN,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self.uiRoot = self:CreateDisplayFrame(
        "GraalHelperRootFrame",
        self.config.root,
        {
            titleText = C.RED .. L.rootTitle .. C.RESET,
            lineText = L.rootLine,
            defaultIcon = ICONS.ROOT,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self.uiDisarm = self:CreateDisplayFrame(
        "GraalHelperDisarmFrame",
        self.config.disarm,
        {
            titleText = C.RED .. L.disarmTitle .. C.RESET,
            lineText = L.disarmLine,
            defaultIcon = ICONS.DISARM,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self.uiFear = self:CreateDisplayFrame(
        "GraalHelperFearFrame",
        self.config.fear,
        {
            titleText = C.RED .. L.fearTitle .. C.RESET,
            lineText = L.fearLine,
            defaultIcon = ICONS.FEAR,
            glowR = 1.00,
            glowG = 0.18,
            glowB = 0.18,
            barR = 1.00,
            barG = 0.22,
            barB = 0.22,
        }
    )

    self:ApplyAllDisplaySettings()
    self:CreateOptionsWindow()
    self:RefreshOptionsUI()
    self:SetupSlashCommands()
    self:CreateMinimapButton()

    self.frame:SetScript("OnUpdate", function(_, elapsed)
        R.ticker = R.ticker + elapsed
        if R.ticker >= R.updateInterval then
            R.ticker = 0
            GraalHelper:UpdateDisplays()
        end
    end)

    self:Print(L.addonLoaded)
end

function GraalHelper:PLAYER_LOGOUT()
    if self.config then
        self:SaveFramePosition(self.uiSteal, self.config.steal)
        self:SaveFramePosition(self.uiReflect, self.config.reflect)
        self:SaveFramePosition(self.uiSilence, self.config.silence)
        self:SaveFramePosition(self.uiStun, self.config.stun)
        self:SaveFramePosition(self.uiRoot, self.config.root)
        self:SaveFramePosition(self.uiDisarm, self.config.disarm)
        self:SaveFramePosition(self.uiFear, self.config.fear)
    end
end
