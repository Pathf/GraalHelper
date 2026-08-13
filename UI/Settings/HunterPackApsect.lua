local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addHunterPackAspectPanel()
    self.options.panels.hunterPackAspect = self:CreatePanelWithTitle(self.options.content, L.hunterPackAspectSection,
        C.COLORS.BLUE.C)

    self.options.hunterPackAspectActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .hunterPackAspect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.hunterPackAspectActive:SetPoint("TOPLEFT", 16, -62)
    self.options.hunterPackAspectActive:SetScript("OnClick", function(s)
        GraalHelper.config.hunterPackAspect.active = s:GetChecked() and true or false
    end)
    self.options.hunterPackAspectActive.label = self.options.hunterPackAspectActive:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.hunterPackAspectActive.label:SetPoint("LEFT", self.options.hunterPackAspectActive, "RIGHT", 4, 1)
    self.options.hunterPackAspectActive.label:SetText(L.activeFunctionality)
    self.options.hunterPackAspectActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.hunterPackAspectLockCheck = CreateFrame("CheckButton", "GraalHelperHunterPackAspectLockCheck",
        self.options.panels
        .hunterPackAspect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.hunterPackAspectLockCheck:SetPoint("TOPLEFT", self.options.hunterPackAspectActive, "BOTTOMLEFT", 0, -8)
    self.options.hunterPackAspectLockCheck:SetScript("OnClick", function(s)
        GraalHelper.config.hunterPackAspect.locked = s:GetChecked() and true or false
    end)
    self.options.hunterPackAspectLockCheck.label = self.options.hunterPackAspectLockCheck:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.hunterPackAspectLockCheck.label:SetPoint("LEFT", self.options.hunterPackAspectLockCheck, "RIGHT", 4, 1)
    self.options.hunterPackAspectLockCheck.label:SetText(L.lockWindow)
    self.options.hunterPackAspectLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.hunterPackAspectNameCheck = CreateFrame("CheckButton", "GraalHelperHunterPackAspectNamesCheck",
        self.options.panels.hunterPackAspect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.hunterPackAspectNameCheck:SetPoint("TOPLEFT", self.options.hunterPackAspectLockCheck, "BOTTOMLEFT", 0,
        -8)
    self.options.hunterPackAspectNameCheck:SetScript("OnClick", function(s)
        GraalHelper.config.hunterPackAspect.showBuffNames = s:GetChecked() and true or false
    end)
    self.options.hunterPackAspectNameCheck.label = self.options.hunterPackAspectNameCheck:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.hunterPackAspectNameCheck.label:SetPoint("LEFT", self.options.hunterPackAspectNameCheck, "RIGHT", 4, 1)
    self.options.hunterPackAspectNameCheck.label:SetText(L.showBuffNames)
    self.options.hunterPackAspectNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.hunterPackAspectSoundCheck = CreateFrame("CheckButton", "GraalHelperHunterPackAspectSoundCheck",
        self.options.panels.hunterPackAspect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.hunterPackAspectSoundCheck:SetPoint("TOPLEFT", self.options.hunterPackAspectNameCheck, "BOTTOMLEFT", 0,
        -8)
    self.options.hunterPackAspectSoundCheck:SetScript("OnClick", function(s)
        GraalHelper.config.hunterPackAspect.soundEnabled = s:GetChecked() and true or false
    end)
    self.options.hunterPackAspectSoundCheck.label =
        self.options.hunterPackAspectSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.hunterPackAspectSoundCheck.label:SetPoint("LEFT", self.options.hunterPackAspectSoundCheck, "RIGHT", 4, 1)
    self.options.hunterPackAspectSoundCheck.label:SetText(L.enableSound)
    self.options.hunterPackAspectSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.hunterPackAspectScaleSlider = self:CreateSlider(self.options.panels.hunterPackAspect,
        "GraalHelperHunterPackAspectScaleSlider", "", 0.5, 2.0, 0.05, 280, 34, -210)
    self.options.hunterPackAspectScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.hunterPackAspect.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiHunterPackAspect, GraalHelper.config.hunterPackAspect)
    end)
    self:SkinSlider(self.options.hunterPackAspectScaleSlider, 0.25, 0.65, 1.0)
    _G[self.options.hunterPackAspectScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.hunterPackAspectDurationSlider = self:CreateSlider(self.options.panels.hunterPackAspect,
        "GraalHelperHunterPackAspectDurationSlider", "", 1, 20, 1, 280, 34, -280)
    self.options.hunterPackAspectDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.hunterPackAspect.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.hunterPackAspectDurationSlider, 0.25, 0.65, 1.0)
    _G[self.options.hunterPackAspectDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.hunterPackAspectSoundLabel = self.options.panels.hunterPackAspect:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.hunterPackAspectSoundLabel:SetPoint("TOPLEFT", 18, -320)
    self.options.hunterPackAspectSoundLabel:SetText(C.COLORS.GOLD.C .. L.chooseSound .. C.RESET)

    self.options.hunterPackAspectSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.hunterPackAspect,
        "GraalHelperHunterPackAspectSoundDropdown",
        0, -335,
        function() return GraalHelper.config.hunterPackAspect.sound end,
        function(value) GraalHelper.config.hunterPackAspect.sound = value end,
        function() GraalHelper:PlayConfiguredSound(GraalHelper.config.hunterPackAspect) end
    )

    self.options.hunterPackAspectTestButton = self:CreateMenuButton(self.options.panels.hunterPackAspect, "", 150, 100,
        40)
    self.options.hunterPackAspectTestButton:SetScript("OnClick", function()
        GraalHelper:StartHunterPackAspectTestMode()
    end)
    self.options.hunterPackAspectTestButton:SetText(L.test)
end

function GraalHelper:addHunterPackAspectNav(parent, category)
    self:addHunterPackAspectPanel()
    self.options.nav.hunterPackAspectButton = self:CreateNavSubItem(parent, L.hunterPackAspectSection, category,
        function()
            GraalHelper:ShowOptionsPanel("hunterPackAspect")
        end)
end

function GraalHelper:RefreshOptionsUIHunterPackAspect()
    self.options.hunterPackAspectActive:SetChecked(self.config.hunterPackAspect.active)
    self.options.hunterPackAspectLockCheck:SetChecked(self.config.hunterPackAspect.locked)
    self.options.hunterPackAspectNameCheck:SetChecked(self.config.hunterPackAspect.showBuffNames)
    self.options.hunterPackAspectSoundCheck:SetChecked(self.config.hunterPackAspect.soundEnabled)
    self.options.hunterPackAspectScaleSlider:SetValue(self.config.hunterPackAspect.scale)
    self.options.hunterPackAspectScaleSlider.valueText:SetText(string.format("%.2f", self.config.hunterPackAspect.scale))
    self.options.hunterPackAspectDurationSlider:SetValue(self.config.hunterPackAspect.displayDuration)
    self.options.hunterPackAspectDurationSlider.valueText:SetText(tostring(self.config.hunterPackAspect.displayDuration) ..
        " Sec.")
    local hunterPackAspectSoundEntry = self:GetSelectedSoundEntry(self.config.hunterPackAspect.sound)
    UIDropDownMenu_SetSelectedValue(self.options.hunterPackAspectSoundDropdown, hunterPackAspectSoundEntry.value)
    UIDropDownMenu_SetText(self.options.hunterPackAspectSoundDropdown, hunterPackAspectSoundEntry.text)
end

function GraalHelper:StartHunterPackAspectTestMode()
    if not self.config.hunterPackAspect.active then return end
    R.hunterPackAspectTestMode = true
    R.hunterPackAspectDisplayUntil = GetTime() + (self.config.hunterPackAspect.displayDuration or 4)
    R.lastHunterPackAspectAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiHunterPackAspect, ICONS.HUNTER_PACK_ASPECT,
        C.COLORS.BLUE.C .. L.hunterPackAspectTitle .. C.RESET,
        L.hunterPackAspectLine, "")
    self:PlayConfiguredSound(self.config.hunterPackAspect)
end

function GraalHelper:HandleHunterPackAspectDisplay(scanData, guid, now)
    if R.hunterPackAspectTestMode then
        if now >= R.hunterPackAspectDisplayUntil then
            R.hunterPackAspectTestMode = false
            self:HideDisplay(self.uiHunterPackAspect)
        end
        return
    end

    if not self.config.hunterPackAspect.active then return end

    local hasHunterPackAspect = #scanData.hunterPackAspectBuffs > 0
    local alertKey = nil

    if hasHunterPackAspect then
        alertKey = guid .. "::HUNTER_PACK_ASPECT::" .. scanData.hunterPackAspectSignature
    end

    if alertKey and alertKey ~= R.lastHunterPackAspectAlertKey then
        local sub = self.config.hunterPackAspect.showBuffNames and
            self:FormatBuffList(scanData.hunterPackAspectBuffs, L.hunterPackAspectFound) or
            L.hunterPackAspectFound

        self:ShowDisplay(
            self.uiHunterPackAspect,
            scanData.hunterPackAspectIcon or ICONS.HUNTER_PACK_ASPECT,
            C.COLORS.BLUE.C .. L.hunterPackAspectTitle .. C.RESET,
            L.hunterPackAspectLine,
            sub
        )

        self:PlayConfiguredSound(self.config.hunterPackAspect)
        R.hunterPackAspectDisplayUntil = now + (self.config.hunterPackAspect.displayDuration or 4)
        R.lastHunterPackAspectAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastHunterPackAspectAlertKey then
        if now < R.hunterPackAspectDisplayUntil then
            if not self.uiHunterPackAspect:IsShown() then
                local sub = self.config.hunterPackAspect.showBuffNames and
                    self:FormatBuffList(scanData.hunterPackAspectBuffs, L.hunterPackAspectFound) or
                    L.hunterPackAspectFound

                self:ShowDisplay(
                    self.uiHunterPackAspect,
                    scanData.hunterPackAspectIcon or ICONS.HUNTER_PACK_ASPECT,
                    C.COLORS.BLUE.C .. L.hunterPackAspectTitle .. C.RESET,
                    L.hunterPackAspectLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiHunterPackAspect)
        end
        return
    end

    R.lastHunterPackAspectAlertKey = nil
    if now >= R.hunterPackAspectDisplayUntil then
        self:HideDisplay(self.uiHunterPackAspect)
    end
end
