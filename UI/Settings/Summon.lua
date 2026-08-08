local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addSummonNotifierPanel()
    self.options.panels.summonNotifier = self:CreatePanel(self.options.content)
    self.options.panels.summonNotifier.title = self.options.panels.summonNotifier:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.summonNotifier.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.summonNotifier.title:SetText(C.RED .. L.summonNotifierSection .. C.RESET)

    self.options.summonNotifierActive = CreateFrame("CheckButton", "GraalHelperDisarmLockCheck", self.options.panels
        .summonNotifier,
        "InterfaceOptionsCheckButtonTemplate")
    self.options.summonNotifierActive:SetPoint("TOPLEFT", 16, -62)
    self.options.summonNotifierActive:SetScript("OnClick", function(s)
        GraalHelper.config.summonNotifier.active = s:GetChecked() and true or false
    end)
    self.options.summonNotifierActive.label = self.options.summonNotifierActive:CreateFontString(nil, "OVERLAY",
        "GameFontNormal")
    self.options.summonNotifierActive.label:SetPoint("LEFT", self.options.summonNotifierActive, "RIGHT", 4, 1)
    self.options.summonNotifierActive.label:SetText(L.activeFunctionality)
    self.options.summonNotifierActive.label:SetTextColor(1, 0.90, 0.20)
end

function GraalHelper:addSummonNotifierNav(parent, category)
    self:addSummonNotifierPanel()
    self.options.nav.summonNotifierButton = self:CreateNavSubItem(parent, L.summonNotifierSection, category, function()
        GraalHelper:ShowOptionsPanel("summonNotifier")
    end)
end

function GraalHelper:RefreshOptionsUISummonNotifier()
    self.options.summonNotifierActive:SetChecked(self.config.summonNotifier.active)
end
