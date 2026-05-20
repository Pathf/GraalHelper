local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addRootPanel(self)
    self.options.panels.root = self:CreatePanel(self.options.content)
    self.options.panels.root.title = self.options.panels.root:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.root.title:SetPoint("TOPLEFT", 18, -18)

    self.options.rootLockCheck = CreateFrame("CheckButton", "GraalHelperRootLockCheck", self.options.panels
        .root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.rootLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.rootLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.root.locked = self:GetChecked() and true or false
    end)

    self.options.rootNameCheck = CreateFrame("CheckButton", "GraalHelperRootNamesCheck",
        self.options.panels.root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootNameCheck:SetPoint("TOPLEFT", self.options.rootLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.rootNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.rootNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.root.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.rootSoundCheck = CreateFrame("CheckButton", "GraalHelperRootSoundCheck",
        self.options.panels.root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootSoundCheck:SetPoint("TOPLEFT", self.options.rootNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.rootSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.rootSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.root.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.rootScaleSlider = self:CreateSlider(self.options.panels.root, "GraalHelperRootScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.rootScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.root.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiRoot, GraalHelper.config.root)
    end)
    self:SkinSlider(self.options.rootScaleSlider, 1.0, 0.30, 0.20)

    self.options.rootDurationSlider = self:CreateSlider(self.options.panels.root,
        "GraalHelperRootDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.rootDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.root.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.rootDurationSlider, 1.0, 0.30, 0.20)

    self.options.rootSoundLabel = self.options.panels.root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.rootSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.root,
        "GraalHelperRootSoundDropdown",
        0, -335,
        function() return GraalHelper.config.root.sound end,
        function(value) GraalHelper.config.root.sound = value end,
        function()
            if GraalHelper.config.root.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.root)
            end
        end
    )

    self.options.rootTestButton = self:CreateMenuButton(self.options.panels.root, "", 150, 100, 40)
    self.options.rootTestButton:SetScript("OnClick", function()
        GraalHelper:StartRootTestMode()
    end)

    self.options.panels.root.title:SetText(C.RED .. L.rootSection .. C.RESET)
    _G[self.options.rootLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
    _G[self.options.rootNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
    _G[self.options.rootSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)
    _G[self.options.rootScaleSlider:GetName() .. "Text"]:SetText(L.scale)
    _G[self.options.rootDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)
    self.options.rootSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.rootTestButton:SetText(L.test)
end

function GraalHelper:addRootNav(self)
    self.options.nav.rootButton = self:CreateNavSubItem(self.options.nav, L.rootSection, -145, function()
        GraalHelper:ShowOptionsPanel("root")
    end)
end

function GraalHelper:RefreshOptionsUIRoot()
    self.options.rootLockCheck:SetChecked(self.config.root.locked)
    self.options.rootNameCheck:SetChecked(self.config.root.showBuffNames)
    self.options.rootSoundCheck:SetChecked(self.config.root.soundEnabled)
    self.options.rootScaleSlider:SetValue(self.config.root.scale)
    self.options.rootScaleSlider.valueText:SetText(string.format("%.2f", self.config.root.scale))
    self.options.rootDurationSlider:SetValue(self.config.root.displayDuration)
    self.options.rootDurationSlider.valueText:SetText(tostring(self.config.root.displayDuration) .. " Sec.")
    local rootSoundEntry = self:GetSelectedSoundEntry(self.config.root.sound)
    UIDropDownMenu_SetSelectedValue(self.options.rootSoundDropdown, rootSoundEntry.value)
    UIDropDownMenu_SetText(self.options.rootSoundDropdown, rootSoundEntry.text)
end
