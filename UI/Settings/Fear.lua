local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addFearPanel(self)
    self.options.panels.fear = self:CreatePanel(self.options.content)
    self.options.panels.fear.title = self.options.panels.fear:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.fear.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.fear.title:SetText(C.RED .. L.fearSection .. C.RESET)

    self.options.fearLockCheck = CreateFrame("CheckButton", "GraalHelperFearLockCheck", self.options.panels
        .fear,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.fearLockCheck:SetPoint("TOPLEFT", 16, -62)
    self.options.fearLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.fear.locked = self:GetChecked() and true or false
    end)
    self.options.fearLockCheck.label = self.options.fearLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.fearLockCheck.label:SetPoint("LEFT", self.options.fearLockCheck, "RIGHT", 4, 1)
    self.options.fearLockCheck.label:SetText(L.lockWindow)
    self.options.fearLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.fearNameCheck = CreateFrame("CheckButton", "GraalHelperFearNamesCheck",
        self.options.panels.fear,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.fearNameCheck:SetPoint("TOPLEFT", self.options.fearLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.fearNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.fear.showBuffNames = self:GetChecked() and true or false
    end)
    self.options.fearNameCheck.label = self.options.fearNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.fearNameCheck.label:SetPoint("LEFT", self.options.fearNameCheck, "RIGHT", 4, 1)
    self.options.fearNameCheck.label:SetText(L.showBuffNames)
    self.options.fearNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.fearSayCheck = CreateFrame("CheckButton", "GraalHelperDisarmSayCheck",
        self.options.panels.fear,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.fearSayCheck:SetPoint("TOPLEFT", self.options.fearNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.fearSayCheck:SetScript("OnClick", function(self)
        GraalHelper.config.fear.say = self:GetChecked() and true or false
    end)
    self.options.fearSayCheck.label = self.options.fearSayCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.fearSayCheck.label:SetPoint("LEFT", self.options.fearSayCheck, "RIGHT", 4, 1)
    self.options.fearSayCheck.label:SetText(L.sayCheck)
    self.options.fearSayCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.fearSoundCheck = CreateFrame("CheckButton", "GraalHelperFearSoundCheck",
        self.options.panels.fear,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.fearSoundCheck:SetPoint("TOPLEFT", self.options.fearSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.fearSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.fear.soundEnabled = self:GetChecked() and true or false
    end)
    self.options.fearSoundCheck.label = self.options.fearSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.fearSoundCheck.label:SetPoint("LEFT", self.options.fearSoundCheck, "RIGHT", 4, 1)
    self.options.fearSoundCheck.label:SetText(L.enableSound)
    self.options.fearSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.fearScaleSlider = self:CreateSlider(self.options.panels.fear, "GraalHelperFearScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -210)
    self.options.fearScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.fear.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiFear, GraalHelper.config.fear)
    end)
    self:SkinSlider(self.options.fearScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.fearScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.fearDurationSlider = self:CreateSlider(self.options.panels.fear,
        "GraalHelperFearDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.fearDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.fear.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.fearDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.fearDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.fearSoundLabel = self.options.panels.fear:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.fearSoundLabel:SetPoint("TOPLEFT", 18, -330)
    self.options.fearSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

    self.options.fearSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.fear,
        "GraalHelperFearSoundDropdown",
        0, -345,
        function() return GraalHelper.config.fear.sound end,
        function(value) GraalHelper.config.fear.sound = value end,
        function()
            if GraalHelper.config.fear.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.fear)
            end
        end
    )

    self.options.fearTestButton = self:CreateMenuButton(self.options.panels.fear, "", 150, 100, 40)
    self.options.fearTestButton:SetScript("OnClick", function()
        GraalHelper:StartFearTestMode()
    end)
    self.options.fearTestButton:SetText(L.test)
end

function GraalHelper:addFearNav(self)
    self.options.nav.fearButton = self:CreateNavSubItem(self.options.nav, L.fearSection, -85, function()
        GraalHelper:ShowOptionsPanel("fear")
    end)
end

function GraalHelper:RefreshOptionsUIFear()
    self.options.fearLockCheck:SetChecked(self.config.fear.locked)
    self.options.fearNameCheck:SetChecked(self.config.fear.showBuffNames)
    self.options.fearSayCheck:SetChecked(self.config.fear.say)
    self.options.fearSoundCheck:SetChecked(self.config.fear.soundEnabled)
    self.options.fearScaleSlider:SetValue(self.config.fear.scale)
    self.options.fearScaleSlider.valueText:SetText(string.format("%.2f", self.config.fear.scale))
    self.options.fearDurationSlider:SetValue(self.config.fear.displayDuration)
    self.options.fearDurationSlider.valueText:SetText(tostring(self.config.fear.displayDuration) .. " Sec.")
    local fearSoundEntry = self:GetSelectedSoundEntry(self.config.fear.sound)
    UIDropDownMenu_SetSelectedValue(self.options.fearSoundDropdown, fearSoundEntry.value)
    UIDropDownMenu_SetText(self.options.fearSoundDropdown, fearSoundEntry.text)
end

local function ChatSay()
    SendChatMessage("❌ FEAR", "PARTY")
end

function GraalHelper:StartFearTestMode()
    R.fearTestMode = true
    R.fearDisplayUntil = GetTime() + (self.config.fear.displayDuration or 4)
    R.lastFearAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiFear, ICONS.FEAR, C.RED .. L.fearTitle .. C.RESET, L.fearLine, "")
    self:PlayConfiguredSound(self.config.fear)
    if self.config.fear.say then ChatSay() end
end

function GraalHelper:HandleFearDisplay(scanData, guid, now)
    if R.fearTestMode then
        if now >= R.fearDisplayUntil then
            R.fearTestMode = false
            self:HideDisplay(self.uiFear)
        end
        return
    end

    local hasFear = #scanData.fearDebuffs > 0
    local alertKey = nil

    if hasFear then
        alertKey = guid .. "::FEAR::" .. scanData.fearSignature
    end

    if alertKey and alertKey ~= R.lastFearAlertKey then
        local sub = self.config.fear.showBuffNames
            and self:FormatBuffList(scanData.fearDebuffs, L.fearFound) or L.fearFound

        self:ShowDisplay(
            self.uiFear,
            scanData.fearIcon or ICONS.FEAR,
            C.RED .. L.fearTitle .. C.RESET,
            L.fearLine,
            sub
        )
        if self.config.fear.say then ChatSay() end

        self:PlayConfiguredSound(self.config.fear)
        R.fearDisplayUntil = now + (self.config.fear.displayDuration or 4)
        R.lastFearAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastFearAlertKey then
        if now < R.fearDisplayUntil then
            if not self.uiFear:IsShown() then
                local sub = self.config.fear.showBuffNames and
                    self:FormatBuffList(scanData.fearDebuffs, L.fearFound) or
                    L.fearFound

                self:ShowDisplay(
                    self.uiFear,
                    scanData.fearIcon or ICONS.FEAR,
                    C.RED .. L.fearTitle .. C.RESET,
                    L.fearLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiFear)
        end
        return
    end

    R.lastFearAlertKey = nil
    if now >= R.fearDisplayUntil then
        self:HideDisplay(self.uiFear)
    end
end
