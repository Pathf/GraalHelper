local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addDispelPanel()
    self.options.panels.dispel = self:CreatePanelWithTitle(self.options.content, L.dispelSection, C.COLORS.BLUE.C)

    self.options.dispelActive = self:CreateCheckButton(
        self.options.panels.dispel,
        "GraalHelperDispelActiveCheck",
        L.activeFunctionality,
        16, -62,
        function() return GraalHelper.config.dispel.active end,
        function(val) GraalHelper.config.dispel.active = val end
    )

    self.options.dispelLockCheck = self:CreateCheckButton(
        self.options.panels.dispel,
        "GraalHelperDispelLockCheck",
        L.lockWindow,
        0, -8,
        function() return GraalHelper.config.dispel.locked end,
        function(val) GraalHelper.config.dispel.locked = val end,
        self.options.dispelActive
    )

    self.options.dispelNameCheck = self:CreateCheckButton(
        self.options.panels.dispel,
        "GraalHelperDispelNamesCheck",
        L.showBuffNames,
        0, -8,
        function() return GraalHelper.config.dispel.showBuffNames end,
        function(val) GraalHelper.config.dispel.showBuffNames = val end,
        self.options.dispelLockCheck
    )

    self.options.dispelSoundCheck = self:CreateCheckButton(
        self.options.panels.dispel,
        "GraalHelperDispelSoundCheck",
        L.enableSound,
        0, -8,
        function() return GraalHelper.config.dispel.soundEnabled end,
        function(val) GraalHelper.config.dispel.soundEnabled = val end,
        self.options.dispelNameCheck
    )

    self.options.dispelScaleSlider = self:CreateSlider(self.options.panels.dispel, "GraalHelperDispelScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.dispelScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.dispel.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiDispel, GraalHelper.config.dispel)
    end)
    self:SkinSlider(self.options.dispelScaleSlider, 0.25, 0.65, 1.0)
    _G[self.options.dispelScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.dispelDurationSlider = self:CreateSlider(self.options.panels.dispel,
        "GraalHelperDispelDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -250)
    self.options.dispelDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.dispel.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.dispelDurationSlider, 0.25, 0.65, 1.0)
    _G[self.options.dispelDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.dispelSoundLabel = self.options.panels.dispel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.dispelSoundLabel:SetPoint("TOPLEFT", 18, -300)
    self.options.dispelSoundLabel:SetText(C.COLORS.GOLD.C .. L.chooseSound .. C.RESET)
    self.options.dispelSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.dispel,
        "GraalHelperDispelSoundDropdown",
        0, -315,
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
    self:ShowDisplay(self.uiDispel, ICONS.DISPEL, C.COLORS.BLUE.C .. L.dispelTitle .. C.RESET, L.dispelLine, "")
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
            C.COLORS.BLUE.C .. L.dispelTitle .. C.RESET,
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
                    C.COLORS.BLUE.C .. L.dispelTitle .. C.RESET,
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
