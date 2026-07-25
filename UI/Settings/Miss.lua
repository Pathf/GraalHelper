local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addMissNotifierPanel()
    self.options.panels.missNotifier = self:CreatePanel(self.options.content)
    self.options.panels.missNotifier.title = self.options.panels.missNotifier:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.missNotifier.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.missNotifier.title:SetText(C.RED .. L.missNotifierSection .. C.RESET)

    self.options.missNotifierActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .missNotifier,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.missNotifierActive:SetPoint("TOPLEFT", 16, -62)
    self.options.missNotifierActive:SetScript("OnClick", function(self)
        GraalHelper.config.missNotifier.active = self:GetChecked() and true or false
    end)
    self.options.missNotifierActive.label = self.options.missNotifierActive:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.missNotifierActive.label:SetPoint("LEFT", self.options.missNotifierActive, "RIGHT", 4, 1)
    self.options.missNotifierActive.label:SetText(L.activeFunctionality)
    self.options.missNotifierActive.label:SetTextColor(1, 0.90, 0.20)
end

function GraalHelper:addMissNotifierNav()
    self.options.nav.missNotifierButton = self:CreateNavSubItem(self.options.nav, L.missNotifierSection, -455,
        function()
            GraalHelper:ShowOptionsPanel("missNotifier")
        end)
end

function GraalHelper:RefreshOptionsUIMissNotifier()
    self.options.missNotifierActive:SetChecked(self.config.missNotifier.active)
end
