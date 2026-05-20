local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addStunPanel(self)
    self.options.panels.stun = self:CreatePanel(self.options.content)
    self.options.panels.stun.title = self.options.panels.stun:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.stun.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.stun.title:SetText(C.RED .. L.stunSection .. C.RESET)

    self.options.stunLockCheck = CreateFrame("CheckButton", "GraalHelperStunLockCheck", self.options.panels
        .stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunLockCheck:SetPoint("TOPLEFT", 16, -62)
    self.options.stunLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.locked = self:GetChecked() and true or false
    end)
    self.options.stunLockCheck.label = self.options.stunLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunLockCheck.label:SetPoint("LEFT", self.options.stunLockCheck, "RIGHT", 4, 1)
    self.options.stunLockCheck.label:SetText(L.lockWindow)
    self.options.stunLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stunNameCheck = CreateFrame("CheckButton", "GraalHelperStunNamesCheck",
        self.options.panels.stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunNameCheck:SetPoint("TOPLEFT", self.options.stunLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.stunNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.showBuffNames = self:GetChecked() and true or false
    end)
    self.options.stunNameCheck.label = self.options.stunNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunNameCheck.label:SetPoint("LEFT", self.options.stunNameCheck, "RIGHT", 4, 1)
    self.options.stunNameCheck.label:SetText(L.showBuffNames)
    self.options.stunNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stunSayCheck = CreateFrame("CheckButton", "GraalHelperDisarmSayCheck",
        self.options.panels.stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunSayCheck:SetPoint("TOPLEFT", self.options.stunNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.stunSayCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.say = self:GetChecked() and true or false
    end)
    _G[self.options.stunSayCheck:GetName() .. "Text"]:SetText(L.sayCheck)
    self.options.stunSayCheck.label = self.options.stunSayCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunSayCheck.label:SetPoint("LEFT", self.options.stunSayCheck, "RIGHT", 4, 1)
    self.options.stunSayCheck.label:SetText(L.sayCheck)
    self.options.stunSayCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stunSoundCheck = CreateFrame("CheckButton", "GraalHelperStunSoundCheck",
        self.options.panels.stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunSoundCheck:SetPoint("TOPLEFT", self.options.stunSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.stunSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.soundEnabled = self:GetChecked() and true or false
    end)
    self.options.stunSoundCheck.label = self.options.stunSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunSoundCheck.label:SetPoint("LEFT", self.options.stunSoundCheck, "RIGHT", 4, 1)
    self.options.stunSoundCheck.label:SetText(L.enableSound)
    self.options.stunSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.stunScaleSlider = self:CreateSlider(self.options.panels.stun, "GraalHelperStunScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -210)
    self.options.stunScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.stun.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiStun, GraalHelper.config.stun)
    end)
    self:SkinSlider(self.options.stunScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.stunScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.stunDurationSlider = self:CreateSlider(self.options.panels.stun,
        "GraalHelperStunDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.stunDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.stun.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.stunDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.stunDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.stunSoundLabel = self.options.panels.stun:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunSoundLabel:SetPoint("TOPLEFT", 18, -330)
    self.options.stunSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

    self.options.stunSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.stun,
        "GraalHelperStunSoundDropdown",
        0, -345,
        function() return GraalHelper.config.stun.sound end,
        function(value) GraalHelper.config.stun.sound = value end,
        function()
            if GraalHelper.config.stun.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.stun)
            end
        end
    )

    self.options.stunTestButton = self:CreateMenuButton(self.options.panels.stun, "", 150, 100, 40)
    self.options.stunTestButton:SetScript("OnClick", function()
        GraalHelper:StartStunTestMode()
    end)
    self.options.stunTestButton:SetText(L.test)
end

function GraalHelper:addStunNav(self)
    self.options.nav.stunButton = self:CreateNavSubItem(self.options.nav, L.stunSection, -205, function()
        GraalHelper:ShowOptionsPanel("stun")
    end)
end

function GraalHelper:RefreshOptionsUIStun()
    self.options.stunLockCheck:SetChecked(self.config.stun.locked)
    self.options.stunNameCheck:SetChecked(self.config.stun.showBuffNames)
    self.options.stunSayCheck:SetChecked(self.config.stun.say)
    self.options.stunSoundCheck:SetChecked(self.config.stun.soundEnabled)
    self.options.stunScaleSlider:SetValue(self.config.stun.scale)
    self.options.stunScaleSlider.valueText:SetText(string.format("%.2f", self.config.stun.scale))
    self.options.stunDurationSlider:SetValue(self.config.stun.displayDuration)
    self.options.stunDurationSlider.valueText:SetText(tostring(self.config.stun.displayDuration) .. " Sec.")
    local stunSoundEntry = self:GetSelectedSoundEntry(self.config.stun.sound)
    UIDropDownMenu_SetSelectedValue(self.options.stunSoundDropdown, stunSoundEntry.value)
    UIDropDownMenu_SetText(self.options.stunSoundDropdown, stunSoundEntry.text)
end

local function ChatSay()
    SendChatMessage("STUN", "PARTY")
end

function GraalHelper:StartStunTestMode()
    R.stunTestMode = true
    R.stunDisplayUntil = GetTime() + (self.config.stun.displayDuration or 4)
    R.lastStunAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiStun, ICONS.STUN, C.RED .. L.stunTitle .. C.RESET, L.stunLine, "")
    self:PlayConfiguredSound(self.config.stun)
    if self.config.stun.say then ChatSay() end
end

function GraalHelper:HandleStunDisplay(scanData, guid, now)
    if R.stunTestMode then
        if now >= R.stunDisplayUntil then
            R.stunTestMode = false
            self:HideDisplay(self.uiStun)
        end
        return
    end

    local hasStun = #scanData.stunDebuffs > 0
    local alertKey = nil

    if hasStun then
        alertKey = guid .. "::STUN::" .. scanData.stunSignature
    end

    if alertKey and alertKey ~= R.lastStunAlertKey then
        local sub = self.config.stun.showBuffNames and self:FormatBuffList(scanData.stunDebuffs, L.stunFound) or
            L.stunFound

        self:ShowDisplay(
            self.uiStun,
            scanData.stunIcon or ICONS.STUN,
            C.RED .. L.stunTitle .. C.RESET,
            L.stunLine,
            sub
        )
        if self.config.stun.say then ChatSay() end

        self:PlayConfiguredSound(self.config.stun)
        R.stunDisplayUntil = now + (self.config.stun.displayDuration or 4)
        R.lastStunAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastStunAlertKey then
        if now < R.stunDisplayUntil then
            if not self.uiStun:IsShown() then
                local sub = self.config.stun.showBuffNames
                    and self:FormatBuffList(scanData.stunDebuffs, L.stunFound) or L.stunFound

                self:ShowDisplay(
                    self.uiStun,
                    scanData.stunIcon or ICONS.STUN,
                    C.RED .. L.stunTitle .. C.RESET,
                    L.stunLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiStun)
        end
        return
    end

    R.lastStunAlertKey = nil
    if now >= R.stunDisplayUntil then
        self:HideDisplay(self.uiStun)
    end
end
