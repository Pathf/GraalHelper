local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addDisarmPanel(self)
    self.options.panels.disarm = self:CreatePanel(self.options.content)
    self.options.panels.disarm.title = self.options.panels.disarm:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.disarm.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.disarm.title:SetText(C.RED .. L.disarmSection .. C.RESET)

    self.options.disarmLockCheck = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .disarm,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.disarmLockCheck:SetPoint("TOPLEFT", 16, -62)
    self.options.disarmLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.disarm.locked = self:GetChecked() and true or false
    end)
    self.options.disarmLockCheck.label = self.options.disarmLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.disarmLockCheck.label:SetPoint("LEFT", self.options.disarmLockCheck, "RIGHT", 4, 1)
    self.options.disarmLockCheck.label:SetText(L.lockWindow)
    self.options.disarmLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.disarmNameCheck = CreateFrame("CheckButton", "GraalHelperDisarmNamesCheck",
        self.options.panels.disarm,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.disarmNameCheck:SetPoint("TOPLEFT", self.options.disarmLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.disarmNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.disarm.showBuffNames = self:GetChecked() and true or false
    end)
    self.options.disarmNameCheck.label = self.options.disarmNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.disarmNameCheck.label:SetPoint("LEFT", self.options.disarmNameCheck, "RIGHT", 4, 1)
    self.options.disarmNameCheck.label:SetText(L.showBuffNames)
    self.options.disarmNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.disarmSayCheck = CreateFrame("CheckButton", "GraalHelperDisarmSayCheck",
        self.options.panels.disarm,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.disarmSayCheck:SetPoint("TOPLEFT", self.options.disarmNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.disarmSayCheck:SetScript("OnClick", function(self)
        GraalHelper.config.disarm.say = self:GetChecked() and true or false
    end)
    self.options.disarmSayCheck.label = self.options.disarmSayCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.disarmSayCheck.label:SetPoint("LEFT", self.options.disarmSayCheck, "RIGHT", 4, 1)
    self.options.disarmSayCheck.label:SetText(L.sayCheck)
    self.options.disarmSayCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.disarmSoundCheck = CreateFrame("CheckButton", "GraalHelperDisarmSoundCheck",
        self.options.panels.disarm,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.disarmSoundCheck:SetPoint("TOPLEFT", self.options.disarmSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.disarmSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.disarm.soundEnabled = self:GetChecked() and true or false
    end)
    self.options.disarmSoundCheck.label = self.options.disarmSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.disarmSoundCheck.label:SetPoint("LEFT", self.options.disarmSoundCheck, "RIGHT", 4, 1)
    self.options.disarmSoundCheck.label:SetText(L.enableSound)
    self.options.disarmSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.disarmScaleSlider = self:CreateSlider(self.options.panels.disarm, "GraalHelperDisarmScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -210)
    self.options.disarmScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.disarm.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiDisarm, GraalHelper.config.disarm)
    end)
    self:SkinSlider(self.options.disarmScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.disarmScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.disarmDurationSlider = self:CreateSlider(self.options.panels.disarm,
        "GraalHelperDisarmDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.disarmDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.disarm.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.disarmDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.disarmDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.disarmSoundLabel = self.options.panels.disarm:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.disarmSoundLabel:SetPoint("TOPLEFT", 18, -330)
    self.options.disarmSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

    self.options.disarmSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.disarm,
        "GraalHelperDisarmSoundDropdown",
        0, -345,
        function() return GraalHelper.config.disarm.sound end,
        function(value) GraalHelper.config.disarm.sound = value end,
        function()
            if GraalHelper.config.disarm.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.disarm)
            end
        end
    )

    self.options.disarmTestButton = self:CreateMenuButton(self.options.panels.disarm, "", 150, 100, 40)
    self.options.disarmTestButton:SetScript("OnClick", function()
        GraalHelper:StartDisarmTestMode()
    end)
    self.options.disarmTestButton:SetText(L.test)
end

function GraalHelper:addDisarmNav(self)
    self.options.nav.disarmButton = self:CreateNavSubItem(self.options.nav, L.disarmSection, -55, function()
        GraalHelper:ShowOptionsPanel("disarm")
    end)
end

function GraalHelper:RefreshOptionsUIDisarm()
    self.options.disarmLockCheck:SetChecked(self.config.disarm.locked)
    self.options.disarmNameCheck:SetChecked(self.config.disarm.showBuffNames)
    self.options.disarmSayCheck:SetChecked(self.config.disarm.say)
    self.options.disarmSoundCheck:SetChecked(self.config.disarm.soundEnabled)
    self.options.disarmScaleSlider:SetValue(self.config.disarm.scale)
    self.options.disarmScaleSlider.valueText:SetText(string.format("%.2f", self.config.disarm.scale))
    self.options.disarmDurationSlider:SetValue(self.config.disarm.displayDuration)
    self.options.disarmDurationSlider.valueText:SetText(tostring(self.config.disarm.displayDuration) .. " Sec.")
    local disarmSoundEntry = self:GetSelectedSoundEntry(self.config.disarm.sound)
    UIDropDownMenu_SetSelectedValue(self.options.disarmSoundDropdown, disarmSoundEntry.value)
    UIDropDownMenu_SetText(self.options.disarmSoundDropdown, disarmSoundEntry.text)
end

local function ChatSay()
    SendChatMessage("❌ DISARM", "PARTY")
end

function GraalHelper:StartDisarmTestMode()
    R.disarmTestMode = true
    R.disarmDisplayUntil = GetTime() + (self.config.disarm.displayDuration or 4)
    R.lastDisarmAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiDisarm, ICONS.DISARM, C.RED .. L.disarmTitle .. C.RESET, L.disarmLine, "")
    self:PlayConfiguredSound(self.config.disarm)
    if self.config.disarm.say then ChatSay() end
end

function GraalHelper:HandleDisarmDisplay(scanData, guid, now)
    if R.disarmTestMode then
        if now >= R.disarmDisplayUntil then
            R.disarmTestMode = false
            self:HideDisplay(self.uiDisarm)
        end
        return
    end

    local hasDisarm = #scanData.disarmDebuffs > 0
    local alertKey = nil

    if hasDisarm then
        alertKey = guid .. "::DISARM::" .. scanData.disarmSignature
    end

    if alertKey and alertKey ~= R.lastDisarmAlertKey then
        local sub = self.config.disarm.showBuffNames
            and self:FormatBuffList(scanData.disarmDebuffs, L.disarmFound) or L.disarmFound

        self:ShowDisplay(
            self.uiDisarm,
            scanData.disarmIcon or ICONS.DISARM,
            C.RED .. L.disarmTitle .. C.RESET,
            L.disarmLine,
            sub
        )
        if self.config.disarm.say then ChatSay() end

        self:PlayConfiguredSound(self.config.disarm)
        R.disarmDisplayUntil = now + (self.config.disarm.displayDuration or 4)
        R.lastDisarmAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastDisarmAlertKey then
        if now < R.disarmDisplayUntil then
            if not self.uiDisarm:IsShown() then
                local sub = self.config.disarm.showBuffNames and
                    self:FormatBuffList(scanData.disarmDebuffs, L.disarmFound) or L.disarmFound

                self:ShowDisplay(
                    self.uiDisarm,
                    scanData.disarmIcon or ICONS.DISARM,
                    C.RED .. L.disarmTitle .. C.RESET,
                    L.disarmLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiDisarm)
        end
        return
    end

    R.lastDisarmAlertKey = nil
    if now >= R.disarmDisplayUntil then
        self:HideDisplay(self.uiDisarm)
    end
end
