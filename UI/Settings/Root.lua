local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

local function ChatSay()
    if GraalHelper.config.root.chatEnabled then
        local playerName = UnitName("player")
        GraalHelper:SendChatMessage("{rt7} ROOT - " .. playerName, GraalHelper.config.root.chat)
    end
end

function GraalHelper:addRootPanel()
    self.options.panels.root = self:CreatePanelWithTitle(self.options.content, L.rootSection, C.COLORS.RED.C)

    self.options.rootActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootActive:SetPoint("TOPLEFT", 16, -62)
    self.options.rootActive:SetScript("OnClick", function(s)
        GraalHelper.config.root.active = s:GetChecked() and true or false
    end)
    self.options.rootActive.label = self.options.rootActive:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootActive.label:SetPoint("LEFT", self.options.rootActive, "RIGHT", 4, 1)
    self.options.rootActive.label:SetText(L.activeFunctionality)
    self.options.rootActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.rootLockCheck = CreateFrame("CheckButton", "GraalHelperRootLockCheck", self.options.panels
        .root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootLockCheck:SetPoint("TOPLEFT", self.options.rootActive, "BOTTOMLEFT", 0, -8)
    self.options.rootLockCheck:SetScript("OnClick", function(s)
        GraalHelper.config.root.locked = s:GetChecked() and true or false
    end)
    self.options.rootLockCheck.label = self.options.rootLockCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootLockCheck.label:SetPoint("LEFT", self.options.rootLockCheck, "RIGHT", 4, 1)
    self.options.rootLockCheck.label:SetText(L.lockWindow)
    self.options.rootLockCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.rootNameCheck = CreateFrame("CheckButton", "GraalHelperRootNamesCheck",
        self.options.panels.root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootNameCheck:SetPoint("TOPLEFT", self.options.rootLockCheck, "BOTTOMLEFT", 0, -8)
    self.options.rootNameCheck:SetScript("OnClick", function(s)
        GraalHelper.config.root.showBuffNames = s:GetChecked() and true or false
    end)
    self.options.rootNameCheck.label = self.options.rootNameCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootNameCheck.label:SetPoint("LEFT", self.options.rootNameCheck, "RIGHT", 4, 1)
    self.options.rootNameCheck.label:SetText(L.showBuffNames)
    self.options.rootNameCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.rootSayCheck = CreateFrame("CheckButton", "GraalHelperDisarmSayCheck",
        self.options.panels.root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootSayCheck:SetPoint("TOPLEFT", self.options.rootNameCheck, "BOTTOMLEFT", 0, -8)
    self.options.rootSayCheck:SetScript("OnClick", function(s)
        GraalHelper.config.root.say = s:GetChecked() and true or false
    end)
    self.options.rootSayCheck.label = self.options.rootSayCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootSayCheck.label:SetPoint("LEFT", self.options.rootSayCheck, "RIGHT", 4, 1)
    self.options.rootSayCheck.label:SetText(L.sayCheck)
    self.options.rootSayCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.rootSoundCheck = CreateFrame("CheckButton", "GraalHelperRootSoundCheck",
        self.options.panels.root,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.rootSoundCheck:SetPoint("TOPLEFT", self.options.rootSayCheck, "BOTTOMLEFT", 0, -8)
    self.options.rootSoundCheck:SetScript("OnClick", function(s)
        GraalHelper.config.root.soundEnabled = s:GetChecked() and true or false
    end)
    self.options.rootSoundCheck.label = self.options.rootSoundCheck:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootSoundCheck.label:SetPoint("LEFT", self.options.rootSoundCheck, "RIGHT", 4, 1)
    self.options.rootSoundCheck.label:SetText(L.enableSound)
    self.options.rootSoundCheck.label:SetTextColor(1, 0.90, 0.20)

    self.options.rootScaleSlider = self:CreateSlider(self.options.panels.root, "GraalHelperRootScaleSlider", "",
        0.5,
        2.0,
        0.05, 280, 34,
        -240)
    self.options.rootScaleSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.root.scale = value
        s.valueText:SetText(string.format("%.2f", value))
        GraalHelper:ApplyFrameSettings(GraalHelper.uiRoot, GraalHelper.config.root)
    end)
    self:SkinSlider(self.options.rootScaleSlider, 1.0, 0.30, 0.20)
    _G[self.options.rootScaleSlider:GetName() .. "Text"]:SetText(L.scale)

    self.options.rootDurationSlider = self:CreateSlider(self.options.panels.root,
        "GraalHelperRootDurationSlider",
        "", 1, 20,
        1, 280, 34,
        -310)
    self.options.rootDurationSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor(value + 0.5)
        GraalHelper.config.root.displayDuration = value
        s.valueText:SetText(tostring(value) .. " Sec.")
    end)
    self:SkinSlider(self.options.rootDurationSlider, 1.0, 0.30, 0.20)
    _G[self.options.rootDurationSlider:GetName() .. "Text"]:SetText(L.displayDuration)

    self.options.rootSoundLabel = self.options.panels.root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootSoundLabel:SetPoint("TOPLEFT", 18, -360)
    self.options.rootSoundLabel:SetText(C.COLORS.GOLD.C .. L.chooseSound .. C.RESET)
    self.options.rootSoundDropdown = self:CreateSoundDropdown(
        self.options.panels.root,
        "GraalHelperRootSoundDropdown",
        0, -375,
        function() return GraalHelper.config.root.sound end,
        function(value) GraalHelper.config.root.sound = value end,
        function() GraalHelper:PlayConfiguredSound(GraalHelper.config.root) end
    )

    self.options.rootChatLabel = self.options.panels.root:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    self.options.rootChatLabel:SetPoint("TOPLEFT", 18, -410)
    self.options.rootChatLabel:SetText(C.COLORS.GOLD.C .. L.chooseChat .. C.RESET)
    self.options.rootChatDropdown = self:CreateChatDropdown(
        self.options.panels.root,
        "GraalHelperDisarmSoundDropdown",
        0, -425,
        function() return GraalHelper.config.root.chat end,
        function(value) GraalHelper.config.root.chat = value end,
        function() ChatSay() end
    )

    self.options.rootTestButton = self:CreateMenuButton(self.options.panels.root, "", 150, 100, 40)
    self.options.rootTestButton:SetScript("OnClick", function()
        GraalHelper:StartRootTestMode()
    end)
    self.options.rootTestButton:SetText(L.test)
end

function GraalHelper:addRootNav(parent, category)
    self:addRootPanel()
    self.options.nav.rootButton = self:CreateNavSubItem(parent, L.rootSection, category, function()
        GraalHelper:ShowOptionsPanel("root")
    end)
end

function GraalHelper:RefreshOptionsUIRoot()
    self.options.rootActive:SetChecked(self.config.root.active)
    self.options.rootLockCheck:SetChecked(self.config.root.locked)
    self.options.rootNameCheck:SetChecked(self.config.root.showBuffNames)
    self.options.rootSayCheck:SetChecked(self.config.root.say)
    self.options.rootSoundCheck:SetChecked(self.config.root.soundEnabled)
    self.options.rootScaleSlider:SetValue(self.config.root.scale)
    self.options.rootScaleSlider.valueText:SetText(string.format("%.2f", self.config.root.scale))
    self.options.rootDurationSlider:SetValue(self.config.root.displayDuration)
    self.options.rootDurationSlider.valueText:SetText(tostring(self.config.root.displayDuration) .. " Sec.")
    local rootSoundEntry = self:GetSelectedSoundEntry(self.config.root.sound)
    UIDropDownMenu_SetSelectedValue(self.options.rootSoundDropdown, rootSoundEntry.value)
    UIDropDownMenu_SetText(self.options.rootSoundDropdown, rootSoundEntry.text)
    local rootChatEntry = self:GetSelectedChatEntry(self.config.root.chat)
    UIDropDownMenu_SetSelectedValue(self.options.rootChatDropdown, rootChatEntry.value)
    UIDropDownMenu_SetText(self.options.rootChatDropdown, rootChatEntry.text)
end

function GraalHelper:StartRootTestMode()
    if not self.config.root.active then return end
    R.rootTestMode = true
    R.rootDisplayUntil = GetTime() + (self.config.root.displayDuration or 4)
    R.lastRootAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiRoot, ICONS.ROOT, C.COLORS.RED.C .. L.rootTitle .. C.RESET, L.rootLine, "")
    self:PlayConfiguredSound(self.config.root)
    if self.config.root.say then ChatSay() end
end

function GraalHelper:HandleRootDisplay(scanData, guid, now)
    if R.rootTestMode then
        if now >= R.rootDisplayUntil then
            R.rootTestMode = false
            self:HideDisplay(self.uiRoot)
        end
        return
    end

    if not self.config.root.active then return end

    local hasRoot = #scanData.rootDebuffs > 0
    local alertKey = nil

    if hasRoot then
        alertKey = guid .. "::ROOT::" .. scanData.rootSignature
    end

    if alertKey and alertKey ~= R.lastRootAlertKey then
        local sub = self.config.root.showBuffNames
            and self:FormatBuffList(scanData.rootDebuffs, L.rootFound) or L.rootFound

        self:ShowDisplay(
            self.uiRoot,
            scanData.rootIcon or ICONS.ROOT,
            C.COLORS.RED.C .. L.rootTitle .. C.RESET,
            L.rootLine,
            sub
        )
        if self.config.root.say then ChatSay() end

        self:PlayConfiguredSound(self.config.root)
        R.rootDisplayUntil = now + (self.config.root.displayDuration or 4)
        R.lastRootAlertKey = alertKey
        return
    end

    if alertKey and alertKey == R.lastRootAlertKey then
        if now < R.rootDisplayUntil then
            if not self.uiRoot:IsShown() then
                local sub = self.config.root.showBuffNames and
                    self:FormatBuffList(scanData.rootDebuffs, L.rootFound) or L.rootFound

                self:ShowDisplay(
                    self.uiRoot,
                    scanData.rootIcon or ICONS.ROOT,
                    C.COLORS.RED.C .. L.rootTitle .. C.RESET,
                    L.rootLine,
                    sub
                )
            end
        else
            self:HideDisplay(self.uiRoot)
        end
        return
    end

    R.lastRootAlertKey = nil
    if now >= R.rootDisplayUntil then self:HideDisplay(self.uiRoot) end
end
