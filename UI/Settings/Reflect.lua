local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

function GraalHelper:addReflectPanel(self)
    self.options.panels.reflect = self:CreatePanel(self.options.content)
    self.options.panels.reflect.title = self.options.panels.reflect:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.reflect.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.reflect.title:SetText(C.RED .. L.reflectSection .. C.RESET)

    self.options.reflectLockCheck = CreateFrame(
        "CheckButton",
        "GraalHelperReflectLockCheck",
        self.options.panels.reflect,
        "InterfaceOptionsCheckButtonTemplate"
    )
    self.options.reflectLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.reflectLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    _G[self.options.reflectLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
    self.options.reflectLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.locked = self:GetChecked() and true or false
    end)


    self.options.reflectNameCheck = CreateFrame("CheckButton", "GraalHelperReflectNamesCheck",
        self.options.panels.reflect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.reflectNameCheck:SetPoint("TOPLEFT", self.options.reflectLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.reflectNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    _G[self.options.reflectNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
    self.options.reflectNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.reflectSoundCheck = CreateFrame("CheckButton", "GraalHelperReflectSoundCheck",
        self.options.panels.reflect,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.reflectSoundCheck:SetPoint("TOPLEFT", self.options.reflectNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.reflectSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    _G[self.options.reflectSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)
    self.options.reflectSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.reflectScaleSlider = self:CreateSlider(self.options.panels.reflect, "GraalHelperReflectScaleSlider", "",
        0.5, 2.0,
        0.05,
        280,
        34, -180)
    self.options.reflectScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.reflect.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiReflect, GraalHelper.config.reflect)
    end)
    self:SkinSlider(self.options.reflectScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.reflectScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.reflectDurationSlider = self:CreateSlider(self.options.panels.reflect,
        "GraalHelperReflectDurationSlider", "", 1,
        20, 1,
        280,
        34, -280)
    self.options.reflectDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.reflect.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.reflectDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.reflectDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.reflectSoundLabel = self.options.panels.reflect:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.reflectSoundLabel:SetPoint("TOPLEFT", 18, -320)
    self.options.reflectSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

    self.options.reflectSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.reflect,
        "GraalHelperReflectSoundDropdown",
        0, -335,
        function() return GraalHelper.config.reflect.sound end,
        function(value) GraalHelper.config.reflect.sound = value end,
        function()
            if GraalHelper.config.reflect.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.reflect)
            end
        end
    )

    self.options.reflectTestButton = self:CreateMenuButton(self.options.panels.reflect, L.test, 150, 100, 40)
    self.options.reflectTestButton:SetScript("OnClick", function() GraalHelper:StartReflectTestMode() end)
end

function GraalHelper:addReflectNav(self)
    self.options.nav.reflectButton = self:CreateNavSubItem(self.options.nav, L.reflectSection, -115, function()
        GraalHelper:ShowOptionsPanel("reflect")
    end)
end

function GraalHelper:RefreshOptionsUIReflect()
    self.options.reflectLockCheck:SetChecked(self.config.reflect.locked)
    self.options.reflectNameCheck:SetChecked(self.config.reflect.showBuffNames)
    self.options.reflectSoundCheck:SetChecked(self.config.reflect.soundEnabled)
    self.options.reflectScaleSlider:SetValue(self.config.reflect.scale)
    self.options.reflectScaleSlider.valueText:SetText(string.format("%.2f", self.config.reflect.scale))
    self.options.reflectDurationSlider:SetValue(self.config.reflect.displayDuration)
    self.options.reflectDurationSlider.valueText:SetText(tostring(self.config.reflect.displayDuration) .. " Sec.")
    local reflectSoundEntry = self:GetSelectedSoundEntry(self.config.reflect.sound)
    UIDropDownMenu_SetSelectedValue(self.options.reflectSoundDropdown, reflectSoundEntry.value)
    UIDropDownMenu_SetText(self.options.reflectSoundDropdown, reflectSoundEntry.text)
end

function GraalHelper:StartReflectTestMode()
    R.reflectTestMode = true
    R.reflectDisplayUntil = GetTime() + (self.config.reflect.displayDuration or 4)
    R.lastReflectAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiReflect, ICONS.REFLECT, C.RED .. L.reflectTitle .. C.RESET, L.reflectLine, "")
    self:PlayConfiguredSound(self.config.reflect)
end

function GraalHelper:HandleReflectDisplay(scanData, guid, now)
    if R.reflectTestMode then
        if now >= R.reflectDisplayUntil then
            R.reflectTestMode = false
            self:HideDisplay(self.uiReflect)
        end
        return
    end

    local hasReflect = #scanData.reflectBuffs > 0
    local alertKey = nil

    if hasReflect then
        alertKey = guid .. "::REFLECT::" .. scanData.reflectSignature
    end

    if alertKey and alertKey ~= R.lastReflectAlertKey then
        local sub = self.config.reflect.showBuffNames and self:FormatBuffList(scanData.reflectBuffs, L.reflectFound) or
            L.reflectFound

        self:ShowDisplay(
            self.uiReflect,
            scanData.reflectIcon or ICONS.REFLECT,
            C.RED .. L.reflectTitle .. C.RESET,
            L.reflectLine,
            sub
        )

        self:PlayConfiguredSound(self.config.reflect)
        R.reflectDisplayUntil = now + (self.config.reflect.displayDuration or 4)
        R.lastReflectAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastReflectAlertKey then
        if now < R.reflectDisplayUntil then
            if not self.uiReflect:IsShown() then
                local sub = self.config.reflect.showBuffNames and
                    self:FormatBuffList(scanData.reflectBuffs, L.reflectFound) or
                    L.reflectFound

                self:ShowDisplay(
                    self.uiReflect,
                    scanData.reflectIcon or ICONS.REFLECT,
                    C.RED .. L.reflectTitle .. C.RESET,
                    L.reflectLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiReflect)
        end
        return
    end

    R.lastReflectAlertKey = nil
    if now >= R.reflectDisplayUntil then
        self:HideDisplay(self.uiReflect)
    end
end
