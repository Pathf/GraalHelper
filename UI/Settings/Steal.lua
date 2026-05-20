local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addStealPanel(self)
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

function GraalHelper:addStealNav(self)
    self.options.nav.stealButton = self:CreateNavSubItem(self.options.nav, L.stealTitle, -270, function()
        GraalHelper:ShowOptionsPanel("steal")
    end)
end

function GraalHelper:RefreshOptionsUISteal()
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
end
