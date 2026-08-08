local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

local function ChatSay()
    if GraalHelper.config.silence.chatEnabled then
        local playerName = UnitName("player")
        GraalHelper:SendChatMessage("{rt7} SILENCE - " .. playerName, GraalHelper.config.silence.chat)
    end
end

function GraalHelper:addSilencePanel()
    self.options.panels.silence = self:CreatePanel(self.options.content)
    self.options.panels.silence.title = self.options.panels.silence:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.silence.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.silence.title:SetText(C.RED .. L.silenceSection .. C.RESET)

    self.options.silenceActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceActive:SetPoint("TOPLEFT", 16, -62)
    self.options.silenceActive:SetScript("OnClick", function(s)
        GraalHelper.config.silence.active = s:GetChecked() and true or false
    end)
    self.options.silenceActive.label = self.options.silenceActive:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceActive.label:SetPoint("LEFT", self.options.silenceActive, "RIGHT", 4, 1)
    self.options.silenceActive.label:SetText(L.activeFunctionality)
    self.options.silenceActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.silenceLockCheck = CreateFrame("CheckButton", "GraalHelperSilenceLockCheck", self.options.panels
        .silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceLockCheck:SetPoint("TOPLEFT", self.options.silenceActive, "BOTTOMLEFT", 0, -8)
    self.options.silenceLockCheck:SetScript("OnClick", function(s)
        GraalHelper.config.silence.locked = s:GetChecked() and true or false
    end)
    self.options.silenceLockCheck.label = self.options.silenceLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceLockCheck.label:SetPoint("LEFT", self.options.silenceLockCheck, "RIGHT", 4, 1)
    self.options.silenceLockCheck.label:SetText(L.lockWindow)
    self.options.silenceLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.silenceNameCheck = CreateFrame("CheckButton", "GraalHelperSilenceNamesCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceNameCheck:SetPoint("TOPLEFT", self.options.silenceLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.silenceNameCheck:SetScript("OnClick", function(s)
        GraalHelper.config.silence.showBuffNames = s:GetChecked() and true or false
    end)
    self.options.silenceNameCheck.label = self.options.silenceNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceNameCheck.label:SetPoint("LEFT", self.options.silenceNameCheck, "RIGHT", 4, 1)
    self.options.silenceNameCheck.label:SetText(L.showBuffNames)
    self.options.silenceNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.silenceSayCheck = CreateFrame("CheckButton", "GraalHelperDisarmSayCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceSayCheck:SetPoint("TOPLEFT", self.options.silenceNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.silenceSayCheck:SetScript("OnClick", function(s)
        GraalHelper.config.silence.say = s:GetChecked() and true or false
    end)
    self.options.silenceSayCheck.label = self.options.silenceSayCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceSayCheck.label:SetPoint("LEFT", self.options.silenceSayCheck, "RIGHT", 4, 1)
    self.options.silenceSayCheck.label:SetText(L.sayCheck)
    self.options.silenceSayCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.silenceSoundCheck = CreateFrame("CheckButton", "GraalHelperSilenceSoundCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceSoundCheck:SetPoint("TOPLEFT", self.options.silenceSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.silenceSoundCheck:SetScript("OnClick", function(s)
        GraalHelper.config.silence.soundEnabled = s:GetChecked() and true or false
    end)
    self.options.silenceSoundCheck.label =
        self.options.silenceSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceSoundCheck.label:SetPoint("LEFT", self.options.silenceSoundCheck, "RIGHT", 4, 1)
    self.options.silenceSoundCheck.label:SetText(L.enableSound)
    self.options.silenceSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.silenceScaleSlider = self:CreateSlider(self.options.panels.silence, "GraalHelperSilenceScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -240)
    self.options.silenceScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.silence.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiSilence, GraalHelper.config.silence)
    end)
    self:SkinSlider(self.options.silenceScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.silenceScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.silenceDurationSlider = self:CreateSlider(self.options.panels.silence,
        "GraalHelperSilenceDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -310)
    self.options.silenceDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.silence.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.silenceDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.silenceDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.silenceSoundLabel = self.options.panels.silence:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceSoundLabel:SetPoint("TOPLEFT", 18, -360)
    self.options.silenceSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.silenceSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.silence,
        "GraalHelperSilenceSoundDropdown",
        0, -375,
        function() return GraalHelper.config.silence.sound end,
        function(value) GraalHelper.config.silence.sound = value end,
        function() GraalHelper:PlayConfiguredSound(GraalHelper.config.silence) end
    )

    self.options.silenceChatLabel = self.options.panels.silence:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceChatLabel:SetPoint("TOPLEFT", 18, -410)
    self.options.silenceChatLabel:SetText(C.GOLD .. L.chooseChat .. C.RESET)
    self.options.silenceChatDropdown = self:CreateChatDropdown(
        self.options.panels.silence,
        "GraalHelperDisarmSoundDropdown",
        0, -425,
        function() return GraalHelper.config.silence.chat end,
        function(value) GraalHelper.config.silence.chat = value end,
        function() ChatSay() end
    )

    self.options.silenceTestButton = self:CreateMenuButton(self.options.panels.silence, "", 150, 100, 40)
    self.options.silenceTestButton:SetScript("OnClick", function()
        GraalHelper:StartSilenceTestMode()
    end)
    self.options.silenceTestButton:SetText(L.test)
end

function GraalHelper:addSilenceNav(parent, category)
    self:addSilencePanel()
    self.options.nav.silenceButton = self:CreateNavSubItem(parent, L.silenceSection, category, function()
        GraalHelper:ShowOptionsPanel("silence")
    end)
end

function GraalHelper:RefreshOptionsUISilence()
    self.options.silenceActive:SetChecked(self.config.silence.active)
    self.options.silenceLockCheck:SetChecked(self.config.silence.locked)
    self.options.silenceNameCheck:SetChecked(self.config.silence.showBuffNames)
    self.options.silenceSayCheck:SetChecked(self.config.silence.say)
    self.options.silenceSoundCheck:SetChecked(self.config.silence.soundEnabled)
    self.options.silenceScaleSlider:SetValue(self.config.silence.scale)
    self.options.silenceScaleSlider.valueText:SetText(string.format("%.2f", self.config.silence.scale))
    self.options.silenceDurationSlider:SetValue(self.config.silence.displayDuration)
    self.options.silenceDurationSlider.valueText:SetText(tostring(self.config.silence.displayDuration) .. " Sec.")
    local silenceSoundEntry = self:GetSelectedSoundEntry(self.config.silence.sound)
    UIDropDownMenu_SetSelectedValue(self.options.silenceSoundDropdown, silenceSoundEntry.value)
    UIDropDownMenu_SetText(self.options.silenceSoundDropdown, silenceSoundEntry.text)
    local silenceChatEntry = self:GetSelectedChatEntry(self.config.silence.chat)
    UIDropDownMenu_SetSelectedValue(self.options.silenceChatDropdown, silenceChatEntry.value)
    UIDropDownMenu_SetText(self.options.silenceChatDropdown, silenceChatEntry.text)
end

function GraalHelper:StartSilenceTestMode()
    if not self.config.silence.active then return end
    R.silenceTestMode = true
    R.silenceDisplayUntil = GetTime() + (self.config.silence.displayDuration or 4)
    R.lastSilenceAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiSilence, ICONS.SILENCE, C.RED .. L.silenceTitle .. C.RESET, L.silenceLine, "")
    self:PlayConfiguredSound(self.config.silence)
    if self.config.silence.say then ChatSay() end
end

function GraalHelper:HandleSilenceDisplay(scanData, guid, now)
    if R.silenceTestMode then
        if now >= R.silenceDisplayUntil then
            R.silenceTestMode = false
            self:HideDisplay(self.uiSilence)
        end
        return
    end

    if not self.config.silence.active then return end

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
        if self.config.silence.say then ChatSay() end

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
