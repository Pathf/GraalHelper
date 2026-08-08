local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addDispelPanel()
    self.options.panels.dispel = self:CreatePanel(self.options.content)
    self.options.panels.dispel.title = self.options.panels.dispel:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.dispel.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.dispel.title:SetText(C.BLUE .. L.dispelSection .. C.RESET)

    self.options.dispelActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .dispel,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.dispelActive:SetPoint("TOPLEFT", 16, -62)
    self.options.dispelActive:SetScript("OnClick", function(s)
        GraalHelper.config.dispel.active = s:GetChecked() and true or false
    end)
    self.options.dispelActive.label = self.options.dispelActive:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelActive.label:SetPoint("LEFT", self.options.dispelActive, "RIGHT", 4, 1)
    self.options.dispelActive.label:SetText(L.activeFunctionality)
    self.options.dispelActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.dispelLockCheck = CreateFrame("CheckButton", "GraalHelperDispelLockCheck", self.options.panels
        .dispel,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.dispelLockCheck:SetPoint("TOPLEFT", self.options.dispelActive, "BOTTOMLEFT", 0, -8)
    self.options.dispelLockCheck:SetScript("OnClick", function(s)
        GraalHelper.config.dispel.locked = s:GetChecked() and true or false
    end)
    self.options.dispelLockCheck.label = self.options.dispelLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelLockCheck.label:SetPoint("LEFT", self.options.dispelLockCheck, "RIGHT", 4, 1)
    self.options.dispelLockCheck.label:SetText(L.lockWindow)
    self.options.dispelLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.dispelNameCheck = CreateFrame("CheckButton", "GraalHelperDispelNamesCheck",
        self.options.panels.dispel,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.dispelNameCheck:SetPoint("TOPLEFT", self.options.dispelLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.dispelNameCheck:SetScript("OnClick", function(s)
        GraalHelper.config.dispel.showBuffNames = s:GetChecked() and true or false
    end)
    self.options.dispelNameCheck.label = self.options.dispelNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelNameCheck.label:SetPoint("LEFT", self.options.dispelNameCheck, "RIGHT", 4, 1)
    self.options.dispelNameCheck.label:SetText(L.showBuffNames)
    self.options.dispelNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.dispelSoundCheck = CreateFrame("CheckButton", "GraalHelperDispelSoundCheck",
        self.options.panels.dispel,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.dispelSoundCheck:SetPoint("TOPLEFT", self.options.dispelSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.dispelSoundCheck:SetScript("OnClick", function(s)
        GraalHelper.config.dispel.soundEnabled = s:GetChecked() and true or false
    end)
    self.options.dispelSoundCheck.label =
        self.options.dispelSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelSoundCheck.label:SetPoint("LEFT", self.options.dispelSoundCheck, "RIGHT", 4, 1)
    self.options.dispelSoundCheck.label:SetText(L.enableSound)
    self.options.dispelSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.dispelScaleSlider = self:CreateSlider(self.options.panels.dispel, "GraalHelperDispelScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -240)
    self.options.dispelScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.dispel.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiDispel, GraalHelper.config.dispel)
    end)
    self:SkinSlider(self.options.dispelScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.dispelScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.dispelDurationSlider = self:CreateSlider(self.options.panels.dispel,
        "GraalHelperDispelDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -310)
    self.options.dispelDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.dispel.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.dispelDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.dispelDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.dispelSoundLabel = self.options.panels.dispel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelSoundLabel:SetPoint("TOPLEFT", 18, -360)
    self.options.dispelSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.dispelSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.dispel,
        "GraalHelperDispelSoundDropdown",
        0, -375,
        function() return GraalHelper.config.dispel.sound end,
        function(value) GraalHelper.config.dispel.sound = value end,
        function() GraalHelper:PlayConfiguredSound(GraalHelper.config.dispel) end
    )

    self.options.dispelTestButton = self:CreateMenuButton(self.options.panels.dispel, "", 150, 100, 40)
    self.options.dispelTestButton:SetScript("OnClick", function()
        GraalHelper:StartDispelTestMode()
    end)
    self.options.dispelTestButton:SetText(L.test)
end

function GraalHelper:addDispelNav(parent, category)
    self:addDispelPanel()
    self.options.nav.dispelButton = self:CreateNavSubItem(parent, L.dispelSection, category, function()
        GraalHelper:ShowOptionsPanel("dispel")
    end)
end

function GraalHelper:RefreshOptionsUIDispel()
    self.options.dispelActive:SetChecked(self.config.dispel.active)
    self.options.dispelLockCheck:SetChecked(self.config.dispel.locked)
    self.options.dispelNameCheck:SetChecked(self.config.dispel.showBuffNames)
    self.options.dispelSoundCheck:SetChecked(self.config.dispel.soundEnabled)
    self.options.dispelScaleSlider:SetValue(self.config.dispel.scale)
    self.options.dispelScaleSlider.valueText:SetText(string.format("%.2f", self.config.dispel.scale))
    self.options.dispelDurationSlider:SetValue(self.config.dispel.displayDuration)
    self.options.dispelDurationSlider.valueText:SetText(tostring(self.config.dispel.displayDuration) .. " Sec.")
    local dispelSoundEntry = self:GetSelectedSoundEntry(self.config.dispel.sound)
    UIDropDownMenu_SetSelectedValue(self.options.dispelSoundDropdown, dispelSoundEntry.value)
    UIDropDownMenu_SetText(self.options.dispelSoundDropdown, dispelSoundEntry.text)
end

function GraalHelper:StartDispelTestMode()
    if not self.config.dispel.active then return end
    R.dispelTestMode = true
    R.dispelDisplayUntil = GetTime() + (self.config.dispel.displayDuration or 4)
    R.lastDispelAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiDispel, ICONS.DISPEL, C.BLUE .. L.dispelTitle .. C.RESET, L.dispelLine, "")
    self:PlayConfiguredSound(self.config.dispel)
end

function GraalHelper:HandleDispelDisplay(scanData, guid, now)
    if R.dispelTestMode then
        if now >= R.dispelDisplayUntil then
            R.dispelTestMode = false
            self:HideDisplay(self.uiDispel)
        end
        return
    end

    if not self.config.dispel.active then return end

    local hasDispel = #scanData.dispelDebuffs > 0
    local alertKey = nil

    if hasDispel then
        alertKey = guid .. "::DISPEL::" .. scanData.dispelSignature
    end

    if alertKey and alertKey ~= R.lastDispelAlertKey then
        local sub = self.config.dispel.showBuffNames and self:FormatBuffList(scanData.dispelDebuffs, L.dispelFound) or
            L.dispelFound

        self:ShowDisplay(
            self.uiDispel,
            scanData.dispelIcon or ICONS.DISPEL,
            C.BLUE .. L.dispelTitle .. C.RESET,
            L.dispelLine,
            sub
        )

        self:PlayConfiguredSound(self.config.dispel)
        R.dispelDisplayUntil = now + (self.config.dispel.displayDuration or 4)
        R.lastDispelAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastDispelAlertKey then
        if now < R.dispelDisplayUntil then
            if not self.uiDispel:IsShown() then
                local sub = self.config.dispel.showBuffNames and
                    self:FormatBuffList(scanData.dispelDebuffs, L.dispelFound) or
                    L.dispelFound

                self:ShowDisplay(
                    self.uiDispel,
                    scanData.dispelIcon or ICONS.DISPEL,
                    C.BLUE .. L.dispelTitle .. C.RESET,
                    L.dispelLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiDispel)
        end
        return
    end

    R.lastDispelAlertKey = nil
    if now >= R.dispelDisplayUntil then
        self:HideDisplay(self.uiDispel)
    end
end
