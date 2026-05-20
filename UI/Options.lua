local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

local function buildBackground(self)
    self:CreateBasicBackdrop(self.options, 0.01, 0.01, 0.01, 0.88)
    self.options.bg = self.options:CreateTexture(nil, "BACKGROUND")
    self.options.bg:SetAllPoints(true)
    self.options.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    self.options.bg:SetVertexColor(0.03, 0.03, 0.04, 0.55)
end

local function buildTopBar(self)
    self.options.topBar = self.options:CreateTexture(nil, "ARTWORK")
    self.options.topBar:SetPoint("TOPLEFT", 14, -48)
    self.options.topBar:SetPoint("TOPRIGHT", -14, -48)
    self.options.topBar:SetHeight(1)
    self.options.topBar:SetTexture("Interface\\Buttons\\WHITE8x8")
    self.options.topBar:SetVertexColor(1, 0.84, 0.1, 0.30)

    self.options.title = self.options:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.options.title:SetPoint("TOP", 0, -18)
    self.options.title:SetText(C.GOLD .. L.menuTitle .. C.RESET)

    self.options.subtitle = self.options:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.options.subtitle:SetPoint("TOP", self.options.title, "BOTTOM", 0, -8)
    self.options.subtitle:SetText(C.WHITE .. "v" .. C_AddOns.GetAddOnMetadata('GraalHelper', 'version') .. C.RESET)

    self.options.closeButton = CreateFrame("Button", nil, self.options, "UIPanelCloseButton")
    self.options.closeButton:SetPoint("TOPRIGHT", -5, -5)
end

local function buildNav(self)
    self.options.nav = CreateFrame("Frame", nil, self.options, BackdropTemplateMixin and "BackdropTemplate")
    self.options.nav:SetPoint("TOPLEFT", 14, -62)
    self.options.nav:SetSize(220, 460)
    self:CreateBasicBackdrop(self.options.nav, 0.02, 0.02, 0.02, 0.75)

    -- TODO I18n
    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, "Alerts", -20)
    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, "Actions", -120)
    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, "Settings", -190)
end

local function buildContent(self)
    self.options.content = CreateFrame("Frame", nil, self.options, BackdropTemplateMixin and "BackdropTemplate")
    self.options.content:SetPoint("TOPLEFT", self.options.nav, "TOPRIGHT", 14, 0)
    self.options.content:SetPoint("BOTTOMRIGHT", -14, 14)
    self:CreateBasicBackdrop(self.options.content, 0.01, 0.01, 0.01, 0.88)
    self.options.panels = {}
end

local function addReflectPanel(self)
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

local function addReflectNav(self)
    self.options.nav.reflectButton = self:CreateNavSubItem(self.options.nav, L.reflectSection, -55, function()
        GraalHelper:ShowOptionsPanel("reflect")
    end)
end

local function addSilencePanel(self)
    self.options.panels.silence = self:CreatePanel(self.options.content)
    self.options.panels.silence.title = self.options.panels.silence:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.silence.title:SetPoint("TOPLEFT", 18, -18)

    self.options.silenceLockCheck = CreateFrame("CheckButton", "GraalHelperSilenceLockCheck", self.options.panels
        .silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.silenceLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.locked = self:GetChecked() and true or false
    end)

    self.options.silenceNameCheck = CreateFrame("CheckButton", "GraalHelperSilenceNamesCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceNameCheck:SetPoint("TOPLEFT", self.options.silenceLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.silenceNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.showBuffNames = self:GetChecked() and true or false
    end)

    self.options.silenceSoundCheck = CreateFrame("CheckButton", "GraalHelperSilenceSoundCheck",
        self.options.panels.silence,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.silenceSoundCheck:SetPoint("TOPLEFT", self.options.silenceNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.silenceSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.silenceSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.silence.soundEnabled = self:GetChecked() and true or false
    end)

    self.options.silenceScaleSlider = self:CreateSlider(self.options.panels.silence, "GraalHelperSilenceScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -180)
    self.options.silenceScaleSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.silence.scale = value
        self.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiSilence, GraalHelper.config.silence)
    end)
    self:SkinSlider(self.options.silenceScaleSlider, 1.0, 0.30, 0.20)

    self.options.silenceDurationSlider = self:CreateSlider(self.options.panels.silence,
        "GraalHelperSilenceDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.silenceDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.silence.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.silenceDurationSlider, 1.0, 0.30, 0.20)

    self.options.silenceSoundLabel = self.options.panels.silence:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.silenceSoundLabel:SetPoint("TOPLEFT", 18, -320)

    self.options.silenceSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.silence,
        "GraalHelperSilenceSoundDropdown",
        0, -335,
        function() return GraalHelper.config.silence.sound end,
        function(value) GraalHelper.config.silence.sound = value end,
        function()
            if GraalHelper.config.silence.soundEnabled then
                GraalHelper:PlayConfiguredSound(GraalHelper.config.silence)
            end
        end
    )

    self.options.silenceTestButton = self:CreateMenuButton(self.options.panels.silence, "", 150, 100, 40)
    self.options.silenceTestButton:SetScript("OnClick", function()
        GraalHelper:StartSilenceTestMode()
    end)

    self.options.panels.silence.title:SetText(C.RED .. L.silenceSection .. C.RESET)
    _G[self.options.silenceLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)
    _G[self.options.silenceNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)
    _G[self.options.silenceSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)
    _G[self.options.silenceScaleSlider:GetName() .. "Text"]:SetText(L.scale)
    _G[self.options.silenceDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)
    self.options.silenceSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)
    self.options.silenceTestButton:SetText(L.test)
end

local function addSilenceNav(self)
    self.options.nav.silenceButton = self:CreateNavSubItem(self.options.nav, L.silenceSection, -85, function()
        GraalHelper:ShowOptionsPanel("silence")
    end)
end

local function addStealPanel(self)
    self.options.panels.steal = CreateFrame("Frame", nil, self.options.content)
    self.options.panels.steal:SetAllPoints(true)

    self.options.panels.steal.r = self:CreatePanel(self.options.panels.steal)
    self.options.panels.steal.r.title = self.options.panels.steal.r:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.steal.r.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.steal.r.title:SetText(C.BLUE .. L.stealTitle .. C.RESET)

    self.options.stealLockCheck = CreateFrame("CheckButton", "GraalHelperStealLockCheck", self.options.panels.steal.r,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealLockCheck:SetPoint("TOPLEFT", 16, -62)
    _G[self.options.stealLockCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealLockCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.locked = self:GetChecked() and true or false
    end)
    _G[self.options.stealLockCheck:GetName() .. "Text"]:SetText(L.lockWindow)

    self.options.stealNameCheck = CreateFrame("CheckButton", "GraalHelperStealNamesCheck", self.options.panels.steal.r,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealNameCheck:SetPoint("TOPLEFT", self.options.stealLockCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stealNameCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealNameCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.showBuffNames = self:GetChecked() and true or false
    end)
    _G[self.options.stealNameCheck:GetName() .. "Text"]:SetText(L.showBuffNames)

    self.options.stealSoundCheck = CreateFrame("CheckButton", "GraalHelperStealSoundCheck", self.options.panels.steal.r,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.stealSoundCheck:SetPoint("TOPLEFT", self.options.stealNameCheck, "BOTTOMLEFT", 0, -8)
    _G[self.options.stealSoundCheck:GetName() .. "Text"]:SetTextColor(1, 0.90, 0.20)
    self.options.stealSoundCheck:SetScript("OnClick", function(self)
        GraalHelper.config.steal.soundEnabled = self:GetChecked() and true or false
    end)
    _G[self.options.stealSoundCheck:GetName() .. "Text"]:SetText(L.enableSound)

    self.options.stealScaleSlider = self:CreateSlider(self.options.panels.steal.r, "GraalHelperStealScaleSlider", "", 0.5,
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
    _G[self.options.stealScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.stealDurationSlider = self:CreateSlider(self.options.panels.steal.r, "GraalHelperStealDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -280)
    self.options.stealDurationSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.steal.displayDuration = value
        self.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.stealDurationSlider, 0.25, 0.65, 1.0)
    _G[self.options.stealDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.stealSoundLabel = self.options.panels.steal:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.stealSoundLabel:SetPoint("TOPLEFT", 18, -320)
    self.options.stealSoundLabel:SetText(C.GOLD .. L.chooseSound .. C.RESET)

    self.options.stealSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.steal.r,
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

    self.options.stealTestButton = self:CreateMenuButton(self.options.panels.steal.r, "", 150, 100, 40)
    self.options.stealTestButton:SetScript("OnClick", function()
        GraalHelper:StartStealTestMode()
    end)
    self.options.stealTestButton:SetText(L.test)


    -- SPELLS
    self.options.panels.steal.l = self:CreatePanel(self.options.panels.steal)
    self.options.panels.steal.l.title = self.options.panels.steal.l:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.steal.l.title:SetPoint("TOPLEFT", 450, -18)
    self.options.panels.steal.l.title:SetText(C.GOLD .. L.spellsSection .. C.RESET)

    self.options.panels.steal.l.hint = self.options.panels.steal.l:CreateFontString(nil, "OVERLAY",
        "GameFontHighlightSmall")
    self.options.panels.steal.l.hint:SetPoint("TOPLEFT", 450, -58)
    self.options.panels.steal.l.hint:SetWidth(280)
    self.options.panels.steal.l.hint:SetJustifyH("LEFT")
    self.options.panels.steal.l.hint:SetText(L.spellsHint)

    self.options.panels.steal.l.scrollFrame = CreateFrame("ScrollFrame", "GraalHelperTrackedSpellsScrollFrame",
        self.options.panels.steal.l, "UIPanelScrollFrameTemplate")
    self.options.panels.steal.l.scrollFrame:SetPoint("TOPLEFT", 450, -92)
    self.options.panels.steal.l.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 16)

    self.options.panels.steal.l.content = CreateFrame("Frame", nil, self.options.panels.steal.l.scrollFrame)
    self.options.panels.steal.l.content:SetSize(270, 1)
    self.options.panels.steal.l.scrollFrame:SetScrollChild(self.options.panels.steal.l.content)
    self.options.panels.steal.l.rows = {}
end

local function addStealNav(self)
    self.options.nav.stealButton = self:CreateNavSubItem(self.options.nav, L.stealTitle, -155, function()
        GraalHelper:ShowOptionsPanel("steal")
    end)
end



function GraalHelper:CreateOptionsWindow()
    if self.options then return end

    self.options = CreateFrame("Frame", "GraalHelperOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    self.options:SetSize(1120, 540)
    self.options:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    self.options:SetFrameStrata("DIALOG")
    self.options:SetMovable(true)
    self.options:EnableMouse(true)
    self.options:RegisterForDrag("LeftButton")
    self.options:SetClampedToScreen(true)
    self.options:Hide()
    self.options:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    self.options:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)

    buildBackground(self)
    buildTopBar(self)
    buildNav(self)
    buildContent(self)

    addReflectPanel(self)
    addReflectNav(self)

    addStealPanel(self)
    addStealNav(self)

    addSilencePanel(self)
    addSilenceNav(self)

    self:RefreshTrackedSpellsUI()
    self:ShowOptionsPanel("steal")
end

function GraalHelper:ShowOptionsPanel(panelName)
    for _, panel in pairs(self.options.panels) do
        panel:Hide()
    end

    if self.options.panels[panelName] then
        self.options.panels[panelName]:Show()
    end
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

    self.options.silenceLockCheck:SetChecked(self.config.silence.locked)
    self.options.silenceNameCheck:SetChecked(self.config.silence.showBuffNames)
    self.options.silenceSoundCheck:SetChecked(self.config.silence.soundEnabled)
    self.options.silenceScaleSlider:SetValue(self.config.silence.scale)
    self.options.silenceScaleSlider.valueText:SetText(string.format("%.2f", self.config.silence.scale))
    self.options.silenceDurationSlider:SetValue(self.config.silence.displayDuration)
    self.options.silenceDurationSlider.valueText:SetText(tostring(self.config.silence.displayDuration) .. " Sec.")
    local reflectSoundEntry = self:GetSelectedSoundEntry(self.config.silence.sound)
    UIDropDownMenu_SetSelectedValue(self.options.silenceSoundDropdown, reflectSoundEntry.value)
    UIDropDownMenu_SetText(self.options.silenceSoundDropdown, reflectSoundEntry.text)

    self:RefreshTrackedSpellsUI()
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
