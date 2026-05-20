local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addSilencePanel(self)
    self.options.panels.silence = self:CreatePanel(self.options.content)
    self.options.panels.silence.title = self.options.panels.silence:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.silence.title:SetPoint("TOPLEFT", 18, -18)

    self.options.silenceLockCheck = CreateFrame("CheckButton", "GraalHelperSilenceLockCheck", self.options.panels
        .silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.silenceLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.locked = self:GetChecked() and true or false
    end)

    self.options.silenceNameCheck = CreateFrame("CheckButton", "GraalHelperSilenceNamesCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceNameCheck:SetPoint("TOPLEFT", self.options.silenceLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.silenceNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.silenceSoundCheck = CreateFrame("CheckButton", "GraalHelperSilenceSoundCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceSoundCheck:SetPoint("TOPLEFT", self.options.silenceNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.silenceSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.silenceScaleSlider = self:CreateSlider(self.options.panels.silence, "GraalHelperSilenceScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.silenceScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.silence.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiSilence, GraalHelper.config.silence)
    end)
    self:SkinSlider(self.options.silenceScaleSlider, 1.0, 0.30, 0.20)

    self.options.silenceDurationSlider = self:CreateSlider(self.options.panels.silence,
        "GraalHelperSilenceDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.silenceDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.silence.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.silenceDurationSlider, 1.0, 0.30, 0.20)

    self.options.silenceSoundLabel = self.options.panels.silence:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.silenceSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.silence,
        "GraalHelperSilenceSoundDropdown",
        0, -335,
        function() return GraalHelper.config.silence.sound end,
        function(value) GraalHelper.config.silence.sound = value end,
        function()
            if GraalHelper.config.silence.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.silence)
            end
        end
    )

    self.options.silenceTestButton = self:CreateMenuButton(self.options.panels.silence, "", 150, 100, 40)
    self.options.silenceTestButton:SetScript("OnClick", function()
        GraalHelper:StartSilenceTestMode()
    end)

    self.options.panels.silence.title:SetText(C.RED .. L.silenceSection .. C.RESET)
    _G[self.options.silenceLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
    _G[self.options.silenceNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
    _G[self.options.silenceSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)
    _G[self.options.silenceScaleSlider:GetName() .. "Text"]:SetText(L.scale)
    _G[self.options.silenceDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)
    self.options.silenceSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.silenceTestButton:SetText(L.test)
end

function GraalHelper:addSilenceNav(self)
    self.options.nav.silenceButton = self:CreateNavSubItem(self.options.nav, L.silenceSection, -175, function()
        GraalHelper:ShowOptionsPanel("silence")
    end)
end

function GraalHelper:RefreshOptionsUISilence()
    self.options.silenceLockCheck:SetChecked(self.config.silence.locked)
    self.options.silenceNameCheck:SetChecked(self.config.silence.showBuffNames)
    self.options.silenceSoundCheck:SetChecked(self.config.silence.soundEnabled)
    self.options.silenceScaleSlider:SetValue(self.config.silence.scale)
    self.options.silenceScaleSlider.valueText:SetText(string.format("%.2f", self.config.silence.scale))
    self.options.silenceDurationSlider:SetValue(self.config.silence.displayDuration)
    self.options.silenceDurationSlider.valueText:SetText(tostring(self.config.silence.displayDuration) .. " Sec.")
    local silenceSoundEntry = self:GetSelectedSoundEntry(self.config.silence.sound)
    UIDropDownMenu_SetSelectedValue(self.options.silenceSoundDropdown, silenceSoundEntry.value)
    UIDropDownMenu_SetText(self.options.silenceSoundDropdown, silenceSoundEntry.text)
end

function GraalHelper:StartSilenceTestMode()
    R.silenceTestMode = true
    R.silenceDisplayUntil = GetTime() + (self.config.silence.displayDuration or 4)
    R.lastSilenceAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiSilence, ICONS.SILENCE, C.RED .. L.silenceTitle .. C.RESET, L.silenceLine, "")
    self:PlayConfiguredSound(self.config.silence)
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
            scanData.silenceIcon or ICONS.SILENCE,
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
                    scanData.silenceIcon or ICONS.SILENCE,
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
