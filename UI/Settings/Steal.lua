local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addStealPanel()
    self.options.panels.steal = self:CreatePanel(self.options.content)
    self.options.panels.steal.title = self.options.panels.steal:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.steal.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.steal.title:SetText(C.COLORS.BLUE.C .. L.stealSection .. C.RESET)

    self.options.stealActive = CreateFrame(
        "CheckButton",
        "GraalHelperDisarmLockCheck",
        self.options.panels.steal,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.stealActive:SetPoint("TOPLEFT", 16, -62)
    self.options.stealActive:SetScript("OnClick", function(s)
        GraalHelper.config.steal.active = s:GetChecked() and true or false
    end)
    self.options.stealActive.label = self.options.stealActive:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealActive.label:SetPoint("LEFT", self.options.stealActive, "RIGHT", 4, 1)
    self.options.stealActive.label:SetText(L.activeFunctionality)
    self.options.stealActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.stealLockCheck = CreateFrame(
        "CheckButton",
        "GraalHelperStealLockCheck",
        self.options.panels.steal,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.stealLockCheck:SetPoint("TOPLEFT", self.options.stealActive, "BOTTOMLEFT", 0, -8)
    self.options.stealLockCheck:SetScript("OnClick", function(s)
        GraalHelper.config.steal.locked = s:GetChecked() and true or false
    end)
    self.options.stealLockCheck.label = self.options.stealLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealLockCheck.label:SetPoint("LEFT", self.options.stealLockCheck, "RIGHT", 4, 1)
    self.options.stealLockCheck.label:SetText(L.lockWindow)
    self.options.stealLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stealNameCheck = CreateFrame(
        "CheckButton",
        "GraalHelperStealNamesCheck",
        self.options.panels.steal,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.stealNameCheck:SetPoint("TOPLEFT", self.options.stealLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.stealNameCheck:SetScript("OnClick", function(s)
        GraalHelper.config.steal.showBuffNames = s:GetChecked() and true or false
    end)
    self.options.stealNameCheck.label = self.options.stealNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealNameCheck.label:SetPoint("LEFT", self.options.stealNameCheck, "RIGHT", 4, 1)
    self.options.stealNameCheck.label:SetText(L.showBuffNames)
    self.options.stealNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stealSoundCheck = CreateFrame(
        "CheckButton",
        "GraalHelperStealSoundCheck",
        self.options.panels.steal,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.stealSoundCheck:SetPoint("TOPLEFT", self.options.stealNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.stealSoundCheck:SetScript("OnClick", function(s)
        GraalHelper.config.steal.soundEnabled = s:GetChecked() and true or false
    end)
    self.options.stealSoundCheck.label = self.options.stealSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealSoundCheck.label:SetPoint("LEFT", self.options.stealSoundCheck, "RIGHT", 4, 1)
    self.options.stealSoundCheck.label:SetText(L.enableSound)
    self.options.stealSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stealScaleSlider = self:CreateSlider(self.options.panels.steal, "GraalHelperStealScaleSlider", "", 0.5,
        2.0, 0.05, 280, 34, -210
    )
    self.options.stealScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.steal.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiSteal, GraalHelper.config.steal)
    end)
    self:SkinSlider(self.options.stealScaleSlider, 0.25, 0.65, 1.0)
    _G[self.options.stealScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.stealDurationSlider = self:CreateSlider(self.options.panels.steal, "GraalHelperStealDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.stealDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.steal.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.stealDurationSlider, 0.25, 0.65, 1.0)
    _G[self.options.stealDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.stealSoundLabel = self.options.panels.steal:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealSoundLabel:SetPoint("TOPLEFT", 18, -320)
    self.options.stealSoundLabel:SetText(C.COLORS.GOLD.C .. L.chooseSound .. C.RESET)
    self.options.stealSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.steal,
        "GraalHelperStealSoundDropdown",
        0, -335,
        function() return GraalHelper.config.steal.sound end,
        function(value) GraalHelper.config.steal.sound = value end,
        function()
            if GraalHelper.config.steal.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.steal)
            end
        end
    )

    self.options.stealTestButton = self:CreateMenuButton(self.options.panels.steal, "", 150, 100, 40)
    self.options.stealTestButton:SetScript("OnClick", function()
        GraalHelper:StartStealTestMode()
    end)
    self.options.stealTestButton:SetText(L.test)
end

function GraalHelper:addStealNav(parent, category)
    self:addStealPanel()
    self.options.nav.stealButton = self:CreateNavSubItem(parent, L.stealSection, category, function()
        GraalHelper:ShowOptionsPanel("steal")
    end)
end

function GraalHelper:RefreshOptionsUISteal()
    self.options.stealActive:SetChecked(self.config.steal.active)
    self.options.stealLockCheck:SetChecked(self.config.steal.locked)
    self.options.stealNameCheck:SetChecked(self.config.steal.showBuffNames)
    self.options.stealSoundCheck:SetChecked(self.config.steal.soundEnabled)
    self.options.stealScaleSlider:SetValue(self.config.steal.scale)
    self.options.stealScaleSlider.valueText:SetText(string.format("%.2f", self.config.steal.scale))
    self.options.stealDurationSlider:SetValue(self.config.steal.displayDuration)
    self.options.stealDurationSlider.valueText:SetText(tostring(self.config.steal.displayDuration) .. " Sec.")
    local stealSoundEntry = self:GetSelectedSoundEntry(self.config.steal.sound)
    UIDropDownMenu_SetSelectedValue(self.options.stealSoundDropdown, stealSoundEntry.value)
    UIDropDownMenu_SetText(self.options.stealSoundDropdown, stealSoundEntry.text)
end

function GraalHelper:StartStealTestMode()
    if not self.config.steal.active then return end
    R.stealTestMode = true
    R.stealDisplayUntil = GetTime() + (self.config.steal.displayDuration or 4)
    R.lastStealAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiSteal, ICONS.STEAL, C.COLORS.BLUE.C .. L.stealTitle .. C.RESET, L.spellstealLine, "")
    self:PlayConfiguredSound(self.config.steal)
end

function GraalHelper:HandleStealDisplay(scanData, guid, now)
    if R.stealTestMode then
        if now >= R.stealDisplayUntil then
            R.stealTestMode = false
            self:HideDisplay(self.uiSteal)
        end
        return
    end

    if not self.config.steal.active then return end

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
            scanData.stealIcon or ICONS.STEAL,
            C.COLORS.BLUE.C .. L.stealTitle .. C.RESET,
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
                    scanData.stealIcon or ICONS.STEAL,
                    C.COLORS.BLUE.C .. L.stealTitle .. C.RESET,
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
