local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addKickPanel(self)
    self.options.panels.kick = self:CreatePanel(self.options.content)
    self.options.panels.kick.title = self.options.panels.kick:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.kick.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.kick.title:SetText(C.BLUE .. L.kickTitle .. C.RESET)

    self.options.kickActive = CreateFrame(
        "CheckButton",
        "GraalHelperDisarmLockCheck",
        self.options.panels.kick,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.kickActive:SetPoint("TOPLEFT", 16, -62)
    self.options.kickActive:SetScript("OnClick", function(self)
        GraalHelper.config.kick.active = self:GetChecked() and true or false
    end)
    self.options.kickActive.label = self.options.kickActive:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.kickActive.label:SetPoint("LEFT", self.options.kickActive, "RIGHT", 4, 1)
    self.options.kickActive.label:SetText(L.activeFunctionality)
    self.options.kickActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.kickLockCheck = CreateFrame(
        "CheckButton",
        "GraalHelperKickLockCheck",
        self.options.panels.kick,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.kickLockCheck:SetPoint("TOPLEFT", self.options.kickActive, "BOTTOMLEFT", 0, -8)
    self.options.kickLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.kick.locked = self:GetChecked() and true or false
    end)
    self.options.kickLockCheck.label = self.options.kickLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.kickLockCheck.label:SetPoint("LEFT", self.options.kickLockCheck, "RIGHT", 4, 1)
    self.options.kickLockCheck.label:SetText(L.lockWindow)
    self.options.kickLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.kickNameCheck = CreateFrame(
        "CheckButton",
        "GraalHelperKickNamesCheck",
        self.options.panels.kick,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.kickNameCheck:SetPoint("TOPLEFT", self.options.kickLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.kickNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.kick.showBuffNames = self:GetChecked() and true or false
    end)
    self.options.kickNameCheck.label = self.options.kickNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.kickNameCheck.label:SetPoint("LEFT", self.options.kickNameCheck, "RIGHT", 4, 1)
    self.options.kickNameCheck.label:SetText(L.showBuffNames)
    self.options.kickNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.kickSoundCheck = CreateFrame(
        "CheckButton",
        "GraalHelperKickSoundCheck",
        self.options.panels.kick,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.kickSoundCheck:SetPoint("TOPLEFT", self.options.kickNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.kickSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.kick.soundEnabled = self:GetChecked() and true or false
    end)
    self.options.kickSoundCheck.label = self.options.kickSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.kickSoundCheck.label:SetPoint("LEFT", self.options.kickSoundCheck, "RIGHT", 4, 1)
    self.options.kickSoundCheck.label:SetText(L.enableSound)
    self.options.kickSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.kickScaleSlider = self:CreateSlider(self.options.panels.kick, "GraalHelperKickScaleSlider", "", 0.5,
        2.0, 0.05, 280, 34, -210
    )
    self.options.kickScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.kick.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiKick, GraalHelper.config.kick)
    end)
    self:SkinSlider(self.options.kickScaleSlider, 0.25, 0.65, 1.0)
    _G[self.options.kickScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.kickDurationSlider = self:CreateSlider(self.options.panels.kick, "GraalHelperKickDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.kickDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.kick.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.kickDurationSlider, 0.25, 0.65, 1.0)
    _G[self.options.kickDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.kickSoundLabel = self.options.panels.kick:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.kickSoundLabel:SetPoint("TOPLEFT", 18, -320)
    self.options.kickSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.kickSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.kick,
        "GraalHelperKickSoundDropdown",
        0, -335,
        function() return GraalHelper.config.kick.sound end,
        function(value) GraalHelper.config.kick.sound = value end,
        function()
            if GraalHelper.config.kick.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.kick)
            end
        end
    )

    self.options.kickTestButton = self:CreateMenuButton(self.options.panels.kick, "", 150, 100, 40)
    self.options.kickTestButton:SetScript("OnClick", function()
        GraalHelper:StartKickTestMode()
    end)
    self.options.kickTestButton:SetText(L.test)
end

function GraalHelper:addKickNav(self)
    self.options.nav.kickButton = self:CreateNavSubItem(self.options.nav, L.kickSection, -300, function()
        GraalHelper:ShowOptionsPanel("kick")
    end)
end

function GraalHelper:RefreshOptionsUIKick()
    self.options.kickActive:SetChecked(self.config.kick.active)
    self.options.kickLockCheck:SetChecked(self.config.kick.locked)
    self.options.kickNameCheck:SetChecked(self.config.kick.showBuffNames)
    self.options.kickSoundCheck:SetChecked(self.config.kick.soundEnabled)
    self.options.kickScaleSlider:SetValue(self.config.kick.scale)
    self.options.kickScaleSlider.valueText:SetText(string.format("%.2f", self.config.kick.scale))
    self.options.kickDurationSlider:SetValue(self.config.kick.displayDuration)
    self.options.kickDurationSlider.valueText:SetText(tostring(self.config.kick.displayDuration) .. " Sec.")
    local kickSoundEntry = self:GetSelectedSoundEntry(self.config.kick.sound)
    UIDropDownMenu_SetSelectedValue(self.options.kickSoundDropdown, kickSoundEntry.value)
    UIDropDownMenu_SetText(self.options.kickSoundDropdown, kickSoundEntry.text)
end

function GraalHelper:StartKickTestMode()
    if not self.config.kick.active then return end
    R.kickTestMode = true
    R.kickDisplayUntil = GetTime() + (self.config.kick.displayDuration or 4)
    R.lastKickAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiKick, ICONS.KICK, C.BLUE .. L.kickTitle .. C.RESET, L.spellkickLine, "")
    self:PlayConfiguredSound(self.config.kick)
end

function GraalHelper:HandleKickDisplay(scanData, guid, now)
    if R.kickTestMode then
        if now >= R.kickDisplayUntil then
            R.kickTestMode = false
            self:HideDisplay(self.uiKick)
        end
        return
    end

    if not self.config.kick.active then return end

    local hasKick = #scanData.kickBuffs > 0
    local alertKey = nil

    if hasKick then
        alertKey = guid .. "::KICK::" .. scanData.kickSignature
    end

    if alertKey and alertKey ~= R.lastKickAlertKey then
        local sub = self.config.kick.showBuffNames and self:FormatBuffList(scanData.kickBuffs, L.spellkickFound) or
            L.spellkickFound

        self:ShowDisplay(
            self.uiKick,
            scanData.kickIcon or ICONS.KICK,
            C.BLUE .. L.kickTitle .. C.RESET,
            L.spellkickLine,
            sub
        )

        self:PlayConfiguredSound(self.config.kick)
        R.kickDisplayUntil = now + (self.config.kick.displayDuration or 4)
        R.lastKickAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastKickAlertKey then
        if now < R.kickDisplayUntil then
            if not self.uiKick:IsShown() then
                local sub = self.config.kick.showBuffNames and
                    self:FormatBuffList(scanData.kickBuffs, L.spellkickFound) or
                    L.spellkickFound

                self:ShowDisplay(
                    self.uiKick,
                    scanData.kickIcon or ICONS.KICK,
                    C.BLUE .. L.kickTitle .. C.RESET,
                    L.spellkickLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiKick)
        end
        return
    end

    R.lastKickAlertKey = nil
    if now >= R.kickDisplayUntil then
        self:HideDisplay(self.uiKick)
    end
end
