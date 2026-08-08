local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

local function ChatSay()
    if GraalHelper.config.missNotifier.chatEnabled then
        local playerName = UnitName("player")
        GraalHelper:SendChatMessage("{rt7} MISS - " .. playerName, GraalHelper.config.missNotifier.chat)
    end
end

function GraalHelper:addMissNotifierPanel()
    self.options.panels.missNotifier = self:CreatePanel(self.options.content)
    self.options.panels.missNotifier.title = self.options.panels.missNotifier:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.missNotifier.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.missNotifier.title:SetText(C.GREEN .. L.missNotifierSection .. C.RESET)

    self.options.missNotifierActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .missNotifier,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.missNotifierActive:SetPoint("TOPLEFT", 16, -62)
    self.options.missNotifierActive:SetScript("OnClick", function(s)
        GraalHelper.config.missNotifier.active = s:GetChecked() and true or false
    end)
    self.options.missNotifierActive.label = self.options.missNotifierActive:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.missNotifierActive.label:SetPoint("LEFT", self.options.missNotifierActive, "RIGHT", 4, 1)
    self.options.missNotifierActive.label:SetText(L.activeFunctionality)
    self.options.missNotifierActive.label:SetTextColor(1, 0.90, 0.20)

    self.options.missNotifierChatLabel = self.options.panels.missNotifier:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.missNotifierChatLabel:SetPoint("TOPLEFT", 18, -92)
    self.options.missNotifierChatLabel:SetText(C.GOLD .. L.chooseChat .. C.RESET)
    self.options.missNotifierChatDropdown = self:CreateChatDropdown(
        self.options.panels.missNotifier,
        "GraalHelperDisarmSoundDropdown",
        0, -107,
        function() return GraalHelper.config.missNotifier.chat end,
        function(value) GraalHelper.config.missNotifier.chat = value end,
        function() ChatSay() end
    )
end

function GraalHelper:addMissNotifierNav(parent, category)
    self:addMissNotifierPanel()
    self.options.nav.missNotifierButton = self:CreateNavSubItem(parent, L.missNotifierSection, category, function()
        GraalHelper:ShowOptionsPanel("missNotifier")
    end)
end

function GraalHelper:RefreshOptionsUIMissNotifier()
    self.options.missNotifierActive:SetChecked(self.config.missNotifier.active)
    local missNotifierChatEntry = self:GetSelectedChatEntry(self.config.missNotifier.chat)
    UIDropDownMenu_SetSelectedValue(self.options.missNotifierChatDropdown, missNotifierChatEntry.value)
    UIDropDownMenu_SetText(self.options.missNotifierChatDropdown, missNotifierChatEntry.text)
end
