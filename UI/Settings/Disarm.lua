local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L
local R = GraalHelper.Runtime
local ICONS = GraalHelper.Constants.ICONS.SPELLS

local function ChatSay()
    if GraalHelper.config.disarm.chatEnabled then
        local playerName = UnitName("player")
        GraalHelper:SendChatMessage("{rt7} DISARM - " .. playerName, GraalHelper.config.disarm.chat)
    end
end

function GraalHelper:addDisarmPanel()
    self.options.panels.disarm = self:CreatePanelWithTitle(self.options.content, L.disarmSection, C.COLORS.RED.C)

    self.options.disarmActive = self:CreateCheckButton(
        self.options.panels.disarm,
        "GraalHelperDisarmActiveCheck",
        L.activeFunctionality,
        16, -62,
        function() return GraalHelper.config.disarm.active end,
        function(val) GraalHelper.config.disarm.active = val end
    )

    self.options.disarmLockCheck = self:CreateCheckButton(
        self.options.panels.disarm,
        "GraalHelperDisarmLockCheck",
        L.lockWindow,
        0, -8,
        function() return GraalHelper.config.disarm.locked end,
        function(val) GraalHelper.config.disarm.locked = val end,
        self.options.disarmActive
    )

    self.options.disarmNameCheck = self:CreateCheckButton(
        self.options.panels.disarm,
        "GraalHelperDisarmNamesCheck",
        L.showBuffNames,
        0, -8,
        function() return GraalHelper.config.disarm.showBuffNames end,
        function(val) GraalHelper.config.disarm.showBuffNames = val end,
        self.options.disarmLockCheck
    )

    self.options.disarmSayCheck = self:CreateCheckButton(
        self.options.panels.disarm,
        "GraalHelperDisarmSayCheck",
        L.sayCheck,
        0, -8,
        function() return GraalHelper.config.disarm.chatEnabled end,
        function(val) GraalHelper.config.disarm.chatEnabled = val end,
        self.options.disarmNameCheck
    )

    self.options.disarmSoundCheck = self:CreateCheckButton(
        self.options.panels.disarm,
        "GraalHelperDisarmSoundCheck",
        L.enableSound,
        0, -8,
        function() return GraalHelper.config.disarm.soundEnabled end,
        function(val) GraalHelper.config.disarm.soundEnabled = val end,
        self.options.disarmSayCheck
    )

    self.options.disarmScaleSlider = self:CreateSliderWithConfig(
        self.options.panels.disarm,
        "GraalHelperDisarmScaleSlider",
        L.scale,
        0.5, 2.0, 0.05,
        280,
        34, -240,
        C.COLORS.RED,
        function(s, value)
            value = math.floor((value * 100) + 0.5) / 100
            GraalHelper.config.disarm.scale = value
            s.valueText:SetText(string.format("%.2f", value))
            GraalHelper:ApplyFrameSettings(GraalHelper.uiDisarm, GraalHelper.config.disarm)
        end
    )

    self.options.disarmDurationSlider = self:CreateSliderWithConfig(
        self.options.panels.disarm,
        "GraalHelperDisarmDurationSlider",
        L.displayDuration,
        1, 20, 1,
        280,
        34, -310,
        C.COLORS.RED,
        function(s, value)
            value = math.floor(value + 0.5)
            GraalHelper.config.disarm.displayDuration = value
            s.valueText:SetText(tostring(value) .. " Sec.")
        end
    )

    self.options.disarmSoundLabel, self.options.disarmSoundDropdown = self:CreateDropdownWithConfig(
        C.SOUND_OPTIONS, false,
        self.options.panels.disarm,
        "GraalHelperDisarmSoundDropdown",
        L.chooseSound, -360, C.COLORS.GOLD,
        function() return GraalHelper.config.disarm.sound end,
        function(value) GraalHelper.config.disarm.sound = value end,
        function() GraalHelper:PlayConfiguredSound(GraalHelper.config.disarm) end
    )

    self.options.disarmChatLabel, self.options.disarmChatDropdown = self:CreateDropdownWithConfig(
        C.CHAT_OPTIONS, true,
        self.options.panels.disarm,
        "GraalHelperDisarmChatDropdown",
        L.chooseChat, -410, C.COLORS.GOLD,
        function() return GraalHelper.config.disarm.chat end,
        function(value) GraalHelper.config.disarm.chat = value end,
        function() ChatSay() end
    )

    self.options.disarmTestButton = self:CreateTestButton(self.options.panels.disarm, L.test, function()
        GraalHelper:StartDisarmTestMode()
    end)
end

function GraalHelper:addDisarmNav(parent, category)
    self:addDisarmPanel()
    self.options.nav.disarmButton = self:CreateNavSubItem(parent, L.disarmSection, category, function()
        GraalHelper:ShowOptionsPanel("disarm")
    end)
end

function GraalHelper:RefreshOptionsUIDisarm()
    self.options.disarmActive:SetChecked(self.config.disarm.active)
    self.options.disarmLockCheck:SetChecked(self.config.disarm.locked)
    self.options.disarmNameCheck:SetChecked(self.config.disarm.showBuffNames)
    self.options.disarmSayCheck:SetChecked(self.config.disarm.chatEnabled)
    self.options.disarmSoundCheck:SetChecked(self.config.disarm.soundEnabled)
    self.options.disarmScaleSlider:SetValue(self.config.disarm.scale)
    self.options.disarmScaleSlider.valueText:SetText(string.format("%.2f", self.config.disarm.scale))
    self.options.disarmDurationSlider:SetValue(self.config.disarm.displayDuration)
    self.options.disarmDurationSlider.valueText:SetText(tostring(self.config.disarm.displayDuration) .. " Sec.")
    local disarmSoundEntry = self:GetSelectedSoundEntry(self.config.disarm.sound)
    UIDropDownMenu_SetSelectedValue(self.options.disarmSoundDropdown, disarmSoundEntry.value)
    UIDropDownMenu_SetText(self.options.disarmSoundDropdown, disarmSoundEntry.text)
    local disarmChatEntry = self:GetSelectedChatEntry(self.config.disarm.chat)
    UIDropDownMenu_SetSelectedValue(self.options.disarmChatDropdown, disarmChatEntry.value)
    UIDropDownMenu_SetText(self.options.disarmChatDropdown, disarmChatEntry.text)
end

function GraalHelper:StartDisarmTestMode()
    if not self.config.disarm.active then return end
    R.disarmTestMode = true
    R.disarmDisplayUntil = GetTime() + (self.config.disarm.displayDuration or 4)
    R.lastDisarmAlertKey = "TESTMODE"
    self:ShowDisplay(self.uiDisarm, ICONS.DISARM, C.COLORS.RED.C .. L.disarmTitle .. C.RESET, L.disarmLine, "")
    self:PlayConfiguredSound(self.config.disarm)
    if self.config.disarm.chatEnabled then ChatSay() end
end

function GraalHelper:HandleDisarmDisplay(scanData, guid, now)
    if R.disarmTestMode then
        if now >= R.disarmDisplayUntil then
            R.disarmTestMode = false
            self:HideDisplay(self.uiDisarm)
        end
        return
    end

    if not self.config.disarm.active then return end

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
            C.COLORS.RED.C .. L.disarmTitle .. C.RESET,
            L.disarmLine,
            sub
        )
        if self.config.disarm.chatEnabled then ChatSay() end

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
                    C.COLORS.RED.C .. L.disarmTitle .. C.RESET,
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
