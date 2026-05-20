local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
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
    self:ApplyFrameSettings(self.uiReflect, self.config.reflect)
    self:ApplyFrameSettings(self.uiSilence, self.config.silence)
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

function GraalHelper:StartStealTestMode()
    R.stealTestMode = true
    R.stealDisplayUntil = GetTime() + (self.config.steal.displayDuration or 4)
    R.lastStealAlertKey = "TESTMODE"

    self:ShowDisplay(
        self.uiSteal,
        "Interface\\Icons\\Spell_Holy_MagicalSentry",
        C.BLUE .. L.stealTitle .. C.RESET,
        L.spellstealLine,
        ""
    )

    self:PlayConfiguredSound(self.config.steal)
end

function GraalHelper:StartReflectTestMode()
    R.reflectTestMode = true
    R.reflectDisplayUntil = GetTime() + (self.config.reflect.displayDuration or 4)
    R.lastReflectAlertKey = "TESTMODE"

    self:ShowDisplay(
        self.uiReflect,
        "Interface\\Icons\\Ability_Warrior_Challange",
        C.RED .. L.reflectTitle .. C.RESET,
        L.reflectLine,
        ""
    )

    self:PlayConfiguredSound(self.config.reflect)
end

function GraalHelper:StartSilenceTestMode()
    R.silenceTestMode = true
    R.silenceDisplayUntil = GetTime() + (self.config.silence.displayDuration or 4)
    R.lastSilenceAlertKey = "TESTMODE"

    self:ShowDisplay(
        self.uiSilence,
        "Interface\\Icons\\Spell_Holy_Silence",
        C.RED .. L.silenceTitle .. C.RESET,
        L.silenceLine,
        ""
    )

    self:PlayConfiguredSound(self.config.silence)
end

function GraalHelper:HandleStealDisplay(scanData, guid, now)
    if R.stealTestMode then
        if now >= R.stealDisplayUntil then
            R.stealTestMode = false
            self:HideDisplay(self.uiSteal)
        end
        return
    end

    local hasSteal = #scanData.stealBuffs > 0
    local alertKey = nil

    if hasSteal then
        alertKey = guid .. "::STEAL::" .. scanData.stealSignature
    end

    if alertKey and alertKey ~= R.lastStealAlertKey then
        local sub = self.config.steal.showBuffNames and self:FormatBuffList(scanData.stealBuffs, L.spellstealFound) or
            L.spellstealFound

        self:ShowDisplay(
            self.uiSteal,
            scanData.stealIcon or "Interface\\Icons\\Spell_Nature_WispSplode",
            C.BLUE .. L.stealTitle .. C.RESET,
            L.spellstealLine,
            sub
        )

        self:PlayConfiguredSound(self.config.steal)
        R.stealDisplayUntil = now + (self.config.steal.displayDuration or 4)
        R.lastStealAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastStealAlertKey then
        if now < R.stealDisplayUntil then
            if not self.uiSteal:IsShown() then
                local sub = self.config.steal.showBuffNames and
                    self:FormatBuffList(scanData.stealBuffs, L.spellstealFound) or
                    L.spellstealFound

                self:ShowDisplay(
                    self.uiSteal,
                    scanData.stealIcon or "Interface\\Icons\\Spell_Nature_WispSplode",
                    C.BLUE .. L.stealTitle .. C.RESET,
                    L.spellstealLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiSteal)
        end
        return
    end

    R.lastStealAlertKey = nil
    if now >= R.stealDisplayUntil then
        self:HideDisplay(self.uiSteal)
    end
end

function GraalHelper:HandleReflectDisplay(scanData, guid, now)
    if R.reflectTestMode then
        if now >= R.reflectDisplayUntil then
            R.reflectTestMode = false
            self:HideDisplay(self.uiReflect)
        end
        return
    end

    local hasReflect = #scanData.reflectBuffs > 0
    local alertKey = nil

    if hasReflect then
        alertKey = guid .. "::REFLECT::" .. scanData.reflectSignature
    end

    if alertKey and alertKey ~= R.lastReflectAlertKey then
        local sub = self.config.reflect.showBuffNames and self:FormatBuffList(scanData.reflectBuffs, L.reflectFound) or
            L.reflectFound

        self:ShowDisplay(
            self.uiReflect,
            scanData.reflectIcon or "Interface\\Icons\\Ability_Warrior_Challange",
            C.RED .. L.reflectTitle .. C.RESET,
            L.reflectLine,
            sub
        )

        self:PlayConfiguredSound(self.config.reflect)
        R.reflectDisplayUntil = now + (self.config.reflect.displayDuration or 4)
        R.lastReflectAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastReflectAlertKey then
        if now < R.reflectDisplayUntil then
            if not self.uiReflect:IsShown() then
                local sub = self.config.reflect.showBuffNames and
                    self:FormatBuffList(scanData.reflectBuffs, L.reflectFound) or
                    L.reflectFound

                self:ShowDisplay(
                    self.uiReflect,
                    scanData.reflectIcon or "Interface\\Icons\\Ability_Warrior_Challange",
                    C.RED .. L.reflectTitle .. C.RESET,
                    L.reflectLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiReflect)
        end
        return
    end

    R.lastReflectAlertKey = nil
    if now >= R.reflectDisplayUntil then
        self:HideDisplay(self.uiReflect)
    end
end

function GraalHelper:HandleSilenceDisplay(scanData, guid, now)
    if R.silenceTestMode then
        if now >= R.silenceDisplayUntil then
            R.silenceTestMode = false
            self:HideDisplay(self.uiSilence)
        end
        return
    end

    local hasSilence = #scanData.silenceDebuffs > 0
    local alertKey = nil

    if hasSilence then
        alertKey = guid .. "::SILENCE::" .. scanData.silenceSignature
    end

    if alertKey and alertKey ~= R.lastSilenceAlertKey then
        local sub = self.config.silence.showBuffNames and self:FormatBuffList(scanData.silenceDebuffs, L.silenceFound) or
            L.silenceFound

        self:ShowDisplay(
            self.uiSilence,
            scanData.silenceIcon or "Interface\\Icons\\Spell_Holy_Silence",
            C.RED .. L.silenceTitle .. C.RESET,
            L.silenceLine,
            sub
        )

        self:PlayConfiguredSound(self.config.silence)
        R.silenceDisplayUntil = now + (self.config.silence.displayDuration or 4)
        R.lastSilenceAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastSilenceAlertKey then
        if now < R.silenceDisplayUntil then
            if not self.uiSilence:IsShown() then
                local sub = self.config.silence.showBuffNames and
                    self:FormatBuffList(scanData.silenceDebuffs, L.silenceFound) or
                    L.silenceFound

                self:ShowDisplay(
                    self.uiSilence,
                    scanData.silenceIcon or "Interface\\Icons\\Spell_Holy_Silence",
                    C.RED .. L.silenceTitle .. C.RESET,
                    L.silenceLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiSilence)
        end
        return
    end

    R.lastSilenceAlertKey = nil
    if now >= R.silenceDisplayUntil then
        self:HideDisplay(self.uiSilence)
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
            if now >= R.stealDisplayUntil then
                self:HideDisplay(self.uiSteal)
            end
        end

        if not R.reflectTestMode then
            R.lastReflectAlertKey = nil
            if now >= R.reflectDisplayUntil then
                self:HideDisplay(self.uiReflect)
            end
        end

        if not R.silenceTestMode then
            R.lastSilenceAlertKey = nil
            if now >= R.silenceDisplayUntil then
                self:HideDisplay(self.uiSilence)
            end
        end

        if R.stealTestMode and now >= R.stealDisplayUntil then
            R.stealTestMode = false
            self:HideDisplay(self.uiSteal)
        end

        if R.reflectTestMode and now >= R.reflectDisplayUntil then
            R.reflectTestMode = false
            self:HideDisplay(self.uiReflect)
        end

        if R.silenceTestMode and now >= R.silenceDisplayUntil then
            R.silenceTestMode = false
            self:HideDisplay(self.uiSilence)
        end

        return
    end

    local targetGuid = UnitGUID("target") or "noguid"
    local scanTargetBuffData = self:ScanTargetBuffs("target")
    self:HandleStealDisplay(scanTargetBuffData, targetGuid, now)
    self:HandleReflectDisplay(scanTargetBuffData, targetGuid, now)

    local playerGuid = UnitGUID("player") or "noguid"
    local scanPlayerDebuffData = self:ScanTargetDebuffs("player")
    self:HandleSilenceDisplay(scanPlayerDebuffData, playerGuid, now)
end

function GraalHelper:StopAllTestsAndHide()
    R.stealTestMode = false
    R.stealDisplayUntil = 0
    R.lastStealAlertKey = nil

    R.reflectTestMode = false
    R.reflectDisplayUntil = 0
    R.lastReflectAlertKey = nil

    R.silenceTestMode = false
    R.silenceDisplayUntil = 0
    R.lastSilenceAlertKey = nil

    self:HideDisplay(self.uiSteal)
    self:HideDisplay(self.uiReflect)
    self:HideDisplay(self.uiSilence)
end
