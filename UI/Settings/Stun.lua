local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addStunPanel(self)
    self.options.panels.stun = self:CreatePanel(self.options.content)
    self.options.panels.stun.title = self.options.panels.stun:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.stun.title:SetPoint("TOPLEFT", 18, -18)

    self.options.stunLockCheck = CreateFrame("CheckButton", "GraalHelperStunLockCheck", self.options.panels
        .stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.stunLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stunLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.locked = self:GetChecked() and true or false
    end)

    self.options.stunNameCheck = CreateFrame("CheckButton", "GraalHelperStunNamesCheck",
        self.options.panels.stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunNameCheck:SetPoint("TOPLEFT", self.options.stunLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stunNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stunNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.stunSoundCheck = CreateFrame("CheckButton", "GraalHelperStunSoundCheck",
        self.options.panels.stun,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stunSoundCheck:SetPoint("TOPLEFT", self.options.stunNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stunSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stunSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.stun.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.stunScaleSlider = self:CreateSlider(self.options.panels.stun, "GraalHelperStunScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.stunScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.stun.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiStun, GraalHelper.config.stun)
    end)
    self:SkinSlider(self.options.stunScaleSlider, 1.0, 0.30, 0.20)

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

    self.options.stunSoundLabel = self.options.panels.stun:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stunSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.stunSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.stun,
        "GraalHelperStunSoundDropdown",
        0, -335,
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

    self.options.panels.stun.title:SetText(C.RED .. L.stunSection .. C.RESET)
    _G[self.options.stunLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
    _G[self.options.stunNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
    _G[self.options.stunSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)
    _G[self.options.stunScaleSlider:GetName() .. "Text"]:SetText(L.scale)
    _G[self.options.stunDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)
    self.options.stunSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
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
    self.options.stunSoundCheck:SetChecked(self.config.stun.soundEnabled)
    self.options.stunScaleSlider:SetValue(self.config.stun.scale)
    self.options.stunScaleSlider.valueText:SetText(string.format("%.2f", self.config.stun.scale))
    self.options.stunDurationSlider:SetValue(self.config.stun.displayDuration)
    self.options.stunDurationSlider.valueText:SetText(tostring(self.config.stun.displayDuration) .. " Sec.")
    local stunSoundEntry = self:GetSelectedSoundEntry(self.config.stun.sound)
    UIDropDownMenu_SetSelectedValue(self.options.stunSoundDropdown, stunSoundEntry.value)
    UIDropDownMenu_SetText(self.options.stunSoundDropdown, stunSoundEntry.text)
end
