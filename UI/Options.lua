local addonName, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:CreateOptionsWindow()
    if self.options then
        self:PrintError(L.errors.options.null)
        return
    end

    self.options = CreateFrame("Frame", "GraalHelperOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    self.options:SetSize(1120, 540)
    self.options:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    self.options:SetFrameStrata("DIALOG")
    self.options:SetMovable(true)
    self.options:EnableMouse(true)
    self.options:RegisterForDrag("LeftButton")
    self.options:SetClampedToScreen(true)
    self.options:Hide()
    self:CreateBasicBackdrop(self.options, 0.01, 0.01, 0.01, 0.88)

    self.options.bg = self.options:CreateTexture(nil, "BACKGROUND")
    self.options.bg:SetAllPoints(true)
    self.options.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    self.options.bg:SetVertexColor(0.03, 0.03, 0.04, 0.55)

    self.options.topBar = self.options:CreateTexture(nil, "ARTWORK")
    self.options.topBar:SetPoint("TOPLEFT", 14, -48)
    self.options.topBar:SetPoint("TOPRIGHT", -14, -48)
    self.options.topBar:SetHeight(1)
    self.options.topBar:SetTexture("Interface\\Buttons\\WHITE8x8")
    self.options.topBar:SetVertexColor(1, 0.84, 0.1, 0.30)

    self.options:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)

    self.options:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    self.options.title = self.options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.options.title:SetPoint("TOP", 0, -18)

    self.options.subtitle = self.options:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.options.subtitle:SetPoint("TOP", self.options.title, "BOTTOM", 0, -8)

    self.options.closeButton = CreateFrame("Button", nil, self.options, "UIPanelCloseButton")
    self.options.closeButton:SetPoint("TOPRIGHT", -5, -5)

    self.options.spellsSection = self:CreateMenuSection(
        self.options, 20, -70, 320, 440,
        { bgR = 0.48, bgG = 0.35, bgB = 0.06, lineR = 1.00, lineG = 0.80, lineB = 0.20 },
        ""
    )

    self.options.spellsSection.hint = self.options.spellsSection:CreateFontString(nil, "OVERLAY",
        "GameFontHighlightSmall")
    self.options.spellsSection.hint:SetPoint("TOPLEFT", 18, -58)
    self.options.spellsSection.hint:SetWidth(280)
    self.options.spellsSection.hint:SetJustifyH("LEFT")

    self.options.spellsSection.scrollFrame = CreateFrame("ScrollFrame", "GraalHelperTrackedSpellsScrollFrame",
        self.options.spellsSection, "UIPanelScrollFrameTemplate")
    self.options.spellsSection.scrollFrame:SetPoint("TOPLEFT", 14, -92)
    self.options.spellsSection.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 16)

    self.options.spellsSection.content = CreateFrame("Frame", nil, self.options.spellsSection.scrollFrame)
    self.options.spellsSection.content:SetSize(270, 1)
    self.options.spellsSection.scrollFrame:SetScrollChild(self.options.spellsSection.content)
    self.options.spellsSection.rows = {}

    self.options.leftSection = self:CreateMenuSection(
        self.options, 380, -70, 350, 440,
        { bgR = 0.10, bgG = 0.25, bgB = 0.55, lineR = 0.30, lineG = 0.65, lineB = 1.00 },
        ""
    )

    self.options.rightSection = self:CreateMenuSection(
        self.options, 750, -70, 350, 440,
        { bgR = 0.50, bgG = 0.10, bgB = 0.10, lineR = 1.00, lineG = 0.25, lineB = 0.25 },
        ""
    )

    self.options.stealLockCheck = CreateFrame("CheckButton", "GraalHelperStealLockCheck", self.options.leftSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.stealLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.locked = self:GetChecked() and true or false
    end)

    self.options.stealNameCheck = CreateFrame("CheckButton", "GraalHelperStealNamesCheck", self.options.leftSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealNameCheck:SetPoint("TOPLEFT", self.options.stealLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stealNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.stealSoundCheck = CreateFrame("CheckButton", "GraalHelperStealSoundCheck", self.options.leftSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealSoundCheck:SetPoint("TOPLEFT", self.options.stealNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stealSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.stealScaleSlider = self:CreateSlider(self.options.leftSection, "GraalHelperStealScaleSlider", "", 0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.stealScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.steal.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiSteal, GraalHelper.config.steal)
    end)
    self:SkinSlider(self.options.stealScaleSlider, 0.25, 0.65, 1.0)

    self.options.stealDurationSlider = self:CreateSlider(self.options.leftSection, "GraalHelperStealDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.stealDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.steal.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.stealDurationSlider, 0.25, 0.65, 1.0)

    self.options.stealSoundLabel = self.options.leftSection:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.stealSoundDropdown = self:CreateSoundDropdown(
        self.options.leftSection,
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

    self.options.stealTestButton = self:CreateMenuButton(self.options.leftSection, "", 150, 100, 16)
    self.options.stealTestButton:SetScript("OnClick", function()
        GraalHelper:StartStealTestMode()
    end)

    --- TODO Silence button
    self.options.silenceTestButton = self:CreateMenuButton(self.options.leftSection, "", 150, 100, 46)
    self.options.silenceTestButton:SetScript("OnClick", function()
        GraalHelper:StartSilenceTestMode()
    end)
    ---

    self.options.reflectLockCheck = CreateFrame("CheckButton", "GraalHelperReflectLockCheck", self.options.rightSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.reflectLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.reflectLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.reflectLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.locked = self:GetChecked() and true or false
    end)

    self.options.reflectNameCheck = CreateFrame("CheckButton", "GraalHelperReflectNamesCheck", self.options.rightSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.reflectNameCheck:SetPoint("TOPLEFT", self.options.reflectLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.reflectNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.reflectNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.reflectSoundCheck = CreateFrame("CheckButton", "GraalHelperReflectSoundCheck", self.options
        .rightSection,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.reflectSoundCheck:SetPoint("TOPLEFT", self.options.reflectNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.reflectSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.reflectSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.reflect.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.reflectScaleSlider = self:CreateSlider(self.options.rightSection, "GraalHelperReflectScaleSlider", "",
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

    self.options.reflectDurationSlider = self:CreateSlider(self.options.rightSection,
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

    self.options.reflectSoundLabel = self.options.rightSection:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.reflectSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.reflectSoundDropdown = self:CreateSoundDropdown(
        self.options.rightSection,
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

    self.options.reflectTestButton = self:CreateMenuButton(self.options.rightSection, "", 150, 100, 16)
    self.options.reflectTestButton:SetScript("OnClick", function()
        GraalHelper:StartReflectTestMode()
    end)

    self:RefreshStaticTexts()
    self:RefreshTrackedSpellsUI()
end

function GraalHelper:RefreshOptionsUI()
    if not self.options then
        GraalHelper:PrintError(L.errors.options.null)
        return
    end
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

    self:RefreshTrackedSpellsUI()
    self:RefreshStaticTexts()
end

function GraalHelper:RefreshStaticTexts()
    if self.uiSteal then
        self.uiSteal.defaultTitleText = C.BLUE .. L.spellstealTitle .. C.RESET
        self.uiSteal.defaultLineText = L.spellstealLine
        if not self.uiSteal:IsShown() then
            self.uiSteal.title:SetText(self.uiSteal.defaultTitleText)
            self.uiSteal.text:SetText(self.uiSteal.defaultLineText)
        end
    end

    if self.uiReflect then
        self.uiReflect.defaultTitleText = C.RED .. L.reflectTitle .. C.RESET
        self.uiReflect.defaultLineText = L.reflectLine
        if not self.uiReflect:IsShown() then
            self.uiReflect.title:SetText(self.uiReflect.defaultTitleText)
            self.uiReflect.text:SetText(self.uiReflect.defaultLineText)
        end
    end

    if self.options then
        self.options.title:SetText(C.GOLD .. L.menuTitle .. C.RESET)
        self.options.subtitle:SetText(C.WHITE .. L.menuSubtitle .. C.RESET)

        self.options.spellsSection.title:SetText(C.GOLD .. L.spellsSection .. C.RESET)
        self.options.spellsSection.hint:SetText(L.spellsHint)
        self.options.leftSection.title:SetText(C.BLUE .. L.stealSection .. C.RESET)
        self.options.rightSection.title:SetText(C.RED .. L.reflectSection .. C.RESET)

        _G[self.options.stealLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
        _G[self.options.stealNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
        _G[self.options.stealSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)

        _G[self.options.reflectLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
        _G[self.options.reflectNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
        _G[self.options.reflectSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)

        _G[self.options.stealScaleSlider:GetName() .. "Text"]:SetText(L.scale)
        _G[self.options.stealDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)
        _G[self.options.reflectScaleSlider:GetName() .. "Text"]:SetText(L.scale)
        _G[self.options.reflectDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

        self.options.stealSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
        self.options.reflectSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

        self.options.stealTestButton:SetText(L.testBlue)
        self.options.silenceTestButton:SetText(L.testSilence)
        self.options.reflectTestButton:SetText(L.testRed)
    end
end

function GraalHelper:ToggleOptions()
    if not self.options then
        self:PrintError(L.errors.options.null)
        return
    end

    if self.options:IsShown() then
        self.options:Hide()
    else
        self:RefreshOptionsUI()
        self.options:Show()
    end
end
