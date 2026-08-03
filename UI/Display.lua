local _, GraalHelper = ...

local C = GraalHelper.Constants
local R = GraalHelper.Runtime

function GraalHelper:CreateDisplayFrame(frameName, sectionConfig, theme)
    local frame = CreateFrame("Frame", frameName, UIParent, BackdropTemplateMixin and "BackdropTemplate")
    frame:SetFrameStrata("HIGH")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetClampedToScreen(true)

    self:CreateBasicBackdrop(frame, 0.02, 0.02, 0.02, 0.88)

    frame.bg = frame:CreateTexture(nil, "BACKGROUND")
    frame.bg:SetAllPoints(true)
    frame.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame.bg:SetVertexColor(0.06, 0.06, 0.08, 0.25)

    frame.innerGlow = frame:CreateTexture(nil, "BORDER")
    frame.innerGlow:SetPoint("TOPLEFT", 7, -7)
    frame.innerGlow:SetPoint("BOTTOMRIGHT", -7, 7)
    frame.innerGlow:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame.innerGlow:SetVertexColor(theme.glowR, theme.glowG, theme.glowB, 0.07)

    frame.leftAccent = frame:CreateTexture(nil, "ARTWORK")
    frame.leftAccent:SetPoint("TOPLEFT", 9, -10)
    frame.leftAccent:SetPoint("BOTTOMLEFT", 9, 10)
    frame.leftAccent:SetWidth(4)
    frame.leftAccent:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame.leftAccent:SetVertexColor(theme.barR, theme.barG, theme.barB, 0.95)

    frame.iconHolder = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
    frame.iconHolder:SetSize(74, 74)
    self:CreateBasicBackdrop(frame.iconHolder, 0.01, 0.01, 0.01, 0.95)

    frame.iconGlow = frame.iconHolder:CreateTexture(nil, "BACKGROUND")
    frame.iconGlow:SetAllPoints(true)
    frame.iconGlow:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame.iconGlow:SetVertexColor(theme.glowR, theme.glowG, theme.glowB, 0.12)

    frame.icon = frame.iconHolder:CreateTexture(nil, "ARTWORK")
    frame.icon:SetPoint("TOPLEFT", 6, -6)
    frame.icon:SetPoint("BOTTOMRIGHT", -6, 6)
    frame.icon:SetTexture(theme.defaultIcon)

    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    frame.title:SetJustifyH("LEFT")
    frame.title:SetText(theme.titleText)

    frame.divider = frame:CreateTexture(nil, "ARTWORK")
    frame.divider:SetHeight(1)
    frame.divider:SetTexture("Interface\\Buttons\\WHITE8x8")
    frame.divider:SetVertexColor(theme.barR, theme.barG, theme.barB, 0.32)

    frame.text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    frame.text:SetJustifyH("LEFT")
    frame.text:SetText(theme.lineText)

    frame.subtext = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    frame.subtext:SetJustifyH("LEFT")
    frame.subtext:SetText("")

    frame.defaultTitleText = theme.titleText
    frame.defaultLineText = theme.lineText
    frame.defaultIcon = theme.defaultIcon

    frame:SetScript("OnDragStart", function(self)
        if not sectionConfig.locked then
            self:StartMoving()
        end
    end)

    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        GraalHelper:SaveFramePosition(self, sectionConfig)
    end)

    frame.anim = frame:CreateAnimationGroup()

    frame.fadeOut = frame.anim:CreateAnimation("Alpha")
    frame.fadeOut:SetFromAlpha(1.0)
    frame.fadeOut:SetToAlpha(0.82)
    frame.fadeOut:SetDuration(0.45)
    frame.fadeOut:SetOrder(1)

    frame.fadeIn = frame.anim:CreateAnimation("Alpha")
    frame.fadeIn:SetFromAlpha(0.82)
    frame.fadeIn:SetToAlpha(1.0)
    frame.fadeIn:SetDuration(0.45)
    frame.fadeIn:SetOrder(2)

    frame.anim:SetLooping("REPEAT")
    frame.anim:Play()

    frame:Hide()
    return frame
end

function GraalHelper:ApplyFrameSettings(frame, sectionConfig)
    if not frame then
        return
    end

    local width = math.floor(C.BASE_FRAME_WIDTH * sectionConfig.scale + 0.5)
    local height = math.floor(C.BASE_FRAME_HEIGHT * sectionConfig.scale + 0.5)

    frame:SetScale(1.0)
    frame:SetSize(width, height)

    local contentLeft = math.floor(104 * sectionConfig.scale + 0.5)
    local contentRight = math.floor(14 * sectionConfig.scale + 0.5)
    local contentWidth = math.max(150, width - contentLeft - contentRight)

    frame.title:ClearAllPoints()
    frame.title:SetPoint("TOPLEFT", frame, "TOPLEFT", contentLeft, math.floor(-14 * sectionConfig.scale + 0.5))
    frame.title:SetWidth(contentWidth)

    frame.divider:ClearAllPoints()
    frame.divider:SetPoint("TOPLEFT", frame.title, "BOTTOMLEFT", 0, math.floor(-6 * sectionConfig.scale + 0.5))
    frame.divider:SetPoint("TOPRIGHT", frame, "TOPRIGHT", math.floor(-14 * sectionConfig.scale + 0.5),
        math.floor(-40 * sectionConfig.scale + 0.5))

    frame.text:ClearAllPoints()
    frame.text:SetPoint("TOPLEFT", frame.divider, "BOTTOMLEFT", 0, math.floor(-8 * sectionConfig.scale + 0.5))
    frame.text:SetWidth(contentWidth)

    frame.subtext:ClearAllPoints()
    frame.subtext:SetPoint("TOPLEFT", frame.text, "BOTTOMLEFT", 0, math.floor(-10 * sectionConfig.scale + 0.5))
    frame.subtext:SetWidth(contentWidth)

    local iconSize = math.floor(74 * sectionConfig.scale + 0.5)
    if iconSize < 50 then
        iconSize = 50
    end

    frame.iconHolder:SetSize(iconSize, iconSize)
    frame.iconHolder:ClearAllPoints()
    frame.iconHolder:SetPoint("LEFT", frame, "LEFT", math.floor(18 * sectionConfig.scale + 0.5), 0)

    self:RestoreFramePosition(frame, sectionConfig)
end

function GraalHelper:ApplyAllDisplaySettings()
    self:ApplyFrameSettings(self.uiSteal, self.config.steal)
    self:ApplyFrameSettings(self.uiKick, self.config.kick)
    self:ApplyFrameSettings(self.uiHunterPackAspect, self.config.hunterPackAspect)
    self:ApplyFrameSettings(self.uiReflect, self.config.reflect)
    self:ApplyFrameSettings(self.uiSilence, self.config.silence)
    self:ApplyFrameSettings(self.uiStun, self.config.stun)
    self:ApplyFrameSettings(self.uiRoot, self.config.root)
    self:ApplyFrameSettings(self.uiDisarm, self.config.disarm)
    self:ApplyFrameSettings(self.uiFear, self.config.fear)
    self:ApplyFrameSettings(self.uiDispel, self.config.dispel)
end

function GraalHelper:ShowDisplay(frame, icon, titleText, lineText, subText)
    if not frame then
        return
    end

    frame.icon:SetTexture(icon or frame.defaultIcon)
    frame.title:SetText(titleText or frame.defaultTitleText)
    frame.text:SetText(lineText or frame.defaultLineText)
    frame.subtext:SetText(subText or "")
    frame:Show()
end

function GraalHelper:HideDisplay(frame)
    if frame then
        frame:Hide()
    end
end

function GraalHelper:UpdateDisplays()
    local now = GetTime()

    local targetExists = UnitExists("target")
    local targetEnemy = targetExists and not UnitIsFriend("player", "target")
    local targetAlive = targetExists and not UnitIsDead("target")

    if not targetExists or not targetEnemy or not targetAlive then
        if not R.stealTestMode then
            R.lastStealAlertKey = nil
            if now >= R.stealDisplayUntil then self:HideDisplay(self.uiSteal) end
        end

        if not R.kickTestMode then
            R.lastKickAlertKey = nil
            if now >= R.kickDisplayUntil then self:HideDisplay(self.uiKick) end
        end

        if not R.hunterPackAspectTestMode then
            R.lastHunterPackAspectAlertKey = nil
            if now >= R.hunterPackAspectDisplayUntil then self:HideDisplay(self.uiHunterPackAspect) end
        end

        if not R.reflectTestMode then
            R.lastReflectAlertKey = nil
            if now >= R.reflectDisplayUntil then self:HideDisplay(self.uiReflect) end
        end

        if not R.silenceTestMode then
            R.lastSilenceAlertKey = nil
            if now >= R.silenceDisplayUntil then self:HideDisplay(self.uiSilence) end
        end

        if not R.stunTestMode then
            R.lastStunAlertKey = nil
            if now >= R.stunDisplayUntil then self:HideDisplay(self.uiStun) end
        end

        if not R.rootTestMode then
            R.lastRootAlertKey = nil
            if now >= R.rootDisplayUntil then self:HideDisplay(self.uiRoot) end
        end

        if not R.disarmTestMode then
            R.lastDisarmAlertKey = nil
            if now >= R.disarmDisplayUntil then self:HideDisplay(self.uiDisarm) end
        end

        if not R.fearTestMode then
            R.lastFearAlertKey = nil
            if now >= R.fearDisplayUntil then self:HideDisplay(self.uiFear) end
        end

        if R.stealTestMode and now >= R.stealDisplayUntil then
            R.stealTestMode = false
            self:HideDisplay(self.uiSteal)
        end

        if R.kickTestMode and now >= R.kickDisplayUntil then
            R.kickTestMode = false
            self:HideDisplay(self.uiKick)
        end

        if R.hunterPackAspectTestMode and now >= R.hunterPackAspectDisplayUntil then
            R.hunterPackAspectTestMode = false
            self:HideDisplay(self.uiHunterPackAspect)
        end

        if R.reflectTestMode and now >= R.reflectDisplayUntil then
            R.reflectTestMode = false
            self:HideDisplay(self.uiReflect)
        end

        if R.silenceTestMode and now >= R.silenceDisplayUntil then
            R.silenceTestMode = false
            self:HideDisplay(self.uiSilence)
        end

        if R.stunTestMode and now >= R.stunDisplayUntil then
            R.stunTestMode = false
            self:HideDisplay(self.uiStun)
        end

        if R.rootTestMode and now >= R.rootDisplayUntil then
            R.rootTestMode = false
            self:HideDisplay(self.uiRoot)
        end

        if R.disarmTestMode and now >= R.disarmDisplayUntil then
            R.disarmTestMode = false
            self:HideDisplay(self.uiDisarm)
        end

        if R.fearTestMode and now >= R.fearDisplayUntil then
            R.fearTestMode = false
            self:HideDisplay(self.uiFear)
        end
        return
    end

    local targetGuid = UnitGUID("target") or "noguid"
    local scanTargetBuffData = self:ScanTargetBuffs("target")
    self:HandleStealDisplay(scanTargetBuffData, targetGuid, now)
    self:HandleReflectDisplay(scanTargetBuffData, targetGuid, now)

    local scanTargetCastData = self:ScanTargetCasts("target")
    self:HandleKickDisplay(scanTargetCastData, targetGuid, now)

    local playerGuid = UnitGUID("player") or "noguid"
    local scanPlayerDebuffData = self:ScanTargetDebuffs("player")
    self:HandleSilenceDisplay(scanPlayerDebuffData, playerGuid, now)
    self:HandleStunDisplay(scanPlayerDebuffData, playerGuid, now)
    self:HandleRootDisplay(scanPlayerDebuffData, playerGuid, now)
    self:HandleDisarmDisplay(scanPlayerDebuffData, playerGuid, now)
    self:HandleFearDisplay(scanPlayerDebuffData, playerGuid, now)

    local scanPlayerBuffData = self:ScanPlayerBuffs("player")
    self:HandleHunterPackAspectDisplay(scanPlayerBuffData, playerGuid, now)
end

function GraalHelper:StopAllTestsAndHide()
    R.stealTestMode = false
    R.stealDisplayUntil = 0
    R.lastStealAlertKey = nil

    R.kickTestMode = false
    R.kickDisplayUntil = 0
    R.lastKickAlertKey = nil

    R.hunterPackAspectTestMode = false
    R.hunterPackAspectDisplayUntil = 0
    R.lastHunterPackAspectAlertKey = nil

    R.reflectTestMode = false
    R.reflectDisplayUntil = 0
    R.lastReflectAlertKey = nil

    R.silenceTestMode = false
    R.silenceDisplayUntil = 0
    R.lastSilenceAlertKey = nil

    R.stunTestMode = false
    R.stunDisplayUntil = 0
    R.lastStunAlertKey = nil

    R.rootTestMode = false
    R.rootDisplayUntil = 0
    R.lastRootAlertKey = nil

    R.disarmTestMode = false
    R.disarmDisplayUntil = 0
    R.lastDisarmAlertKey = nil

    R.fearTestMode = false
    R.fearDisplayUntil = 0
    R.lastFearAlertKey = nil

    R.dispelTestMode = false
    R.dispelDisplayUntil = 0
    R.lastDispelAlertKey = nil

    self:HideDisplay(self.uiSteal)
    self:HideDisplay(self.uiKick)
    self:HideDisplay(self.uiHunterPackAspect)
    self:HideDisplay(self.uiReflect)
    self:HideDisplay(self.uiSilence)
    self:HideDisplay(self.uiStun)
    self:HideDisplay(self.uiRoot)
    self:HideDisplay(self.uiDisarm)
    self:HideDisplay(self.uiFear)
    self:HideDisplay(self.uiDispel)
end
