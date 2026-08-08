local _, GraalHelper = ...
local L = GraalHelper.L
local C = GraalHelper.Constants
local R = GraalHelper.Runtime
local ICONS = C.ICONS.SPELLS

function GraalHelper:InitializeDB()
    GraalHelperCharDB = GraalHelperCharDB or {}
    if not GraalHelperCharDB.migrated then
        if GraalHelperDB then GraalHelperCharDB = CopyTable(GraalHelperDB) end
        GraalHelperCharDB.migrated = true
    end
end

function GraalHelper:PLAYER_LOGIN()
    GraalHelper:Print("Elle est ou la poulette ?")
    GraalHelper:InitializeDB()
    GraalHelperCharDB = self:CopyDefaults(self.defaults, GraalHelperCharDB or {})
    self.config = GraalHelperCharDB
    self.config.trackedSpells = self.config.trackedSpells or {}
    self.config.spellFilter = self.config.spellFilter or {}
    self:SortTrackedSpells()

    self.uiSteal = self:CreateDisplayFrame(
        "GraalHelperStealFrame",
        self.config.steal,
        {
            titleText = C.COLORS.BLUE.C .. L.stealTitle .. C.RESET,
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

    self.uiKick = self:CreateDisplayFrame(
        "GraalHelperKickFrame",
        self.config.kick,
        {
            titleText = C.COLORS.BLUE.C .. L.kickTitle .. C.RESET,
            lineText = L.kickLine,
            defaultIcon = ICONS.KICK,
            glowR = 0.20,
            glowG = 0.55,
            glowB = 1.00,
            barR = 0.25,
            barG = 0.65,
            barB = 1.00,
        }
    )

    self.uiHunterPackAspect = self:CreateDisplayFrame(
        "GraalHelperHunterPackAspectFrame",
        self.config.hunterPackAspect,
        {
            titleText = C.COLORS.BLUE.C .. L.hunterPackAspectTitle .. C.RESET,
            lineText = L.hunterPackAspectLine,
            defaultIcon = ICONS.HUNTER_PACK_ASPECT,
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
            titleText = C.COLORS.RED.C .. L.reflectTitle .. C.RESET,
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
            titleText = C.COLORS.RED.C .. L.silenceTitle .. C.RESET,
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
            titleText = C.COLORS.RED.C .. L.stunTitle .. C.RESET,
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
            titleText = C.COLORS.RED.C .. L.rootTitle .. C.RESET,
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
            titleText = C.COLORS.RED.C .. L.disarmTitle .. C.RESET,
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
            titleText = C.COLORS.RED.C .. L.fearTitle .. C.RESET,
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

    self.uiDispel = self:CreateDisplayFrame(
        "GraalHelperDispelFrame",
        self.config.dispel,
        {
            titleText = C.COLORS.BLUE.C .. L.dispelTitle .. C.RESET,
            lineText = L.dispelLine,
            defaultIcon = ICONS.DISPEL,
            glowR = 0.20,
            glowG = 0.55,
            glowB = 1.00,
            barR = 0.25,
            barG = 0.65,
            barB = 1.00,
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
        self:SaveFramePosition(self.uiKick, self.config.kick)
        self:SaveFramePosition(self.uiHunterPackAspect, self.config.hunterPackAspect)
        self:SaveFramePosition(self.uiReflect, self.config.reflect)
        self:SaveFramePosition(self.uiSilence, self.config.silence)
        self:SaveFramePosition(self.uiStun, self.config.stun)
        self:SaveFramePosition(self.uiRoot, self.config.root)
        self:SaveFramePosition(self.uiDisarm, self.config.disarm)
        self:SaveFramePosition(self.uiFear, self.config.fear)
        self:SaveFramePosition(self.uiDispel, self.config.dispel)
    end
end

function GraalHelper:UNIT_SPELLCAST_CHANNEL_START(caster, _, spellID)
    self:SummonNotify(caster, spellID)
end

function GraalHelper:UNIT_SPELLCAST_START(caster, _, spellID)
    self:SummonNotify(caster, spellID)
end

function GraalHelper:COMBAT_LOG_EVENT_UNFILTERED()
    self:MissNotify()
end

function GraalHelper:PLAYER_REGEN_DISABLED()
    local timer = 0
    local checkInterval = 0.2
    GraalHelper.playerRegen:SetScript("OnUpdate", function(_, elapsed)
        timer = timer + elapsed
        if timer >= checkInterval then
            timer = 0

            local now = GetTime()
            local targetExists = UnitExists("target")

            if not targetExists then
                if R.dispelTestMode and now >= R.dispelDisplayUntil then
                    R.dispelTestMode = false
                    GraalHelper:HideDisplay(GraalHelper.uiDispel)
                end
                return
            end

            local playerGuid = UnitGUID("player") or "noguid"
            local scanPlayerDebuffData = GraalHelper:ScanTargetAllyDebuffs()
            GraalHelper:HandleDispelDisplay(scanPlayerDebuffData, playerGuid, now)
        end
    end)
end

function GraalHelper:PLAYER_REGEN_ENABLED()
    GraalHelper.playerRegen:SetScript("OnUpdate", nil)
end
