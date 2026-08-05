local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addTrackedPanel(self)
    self.options.panels.tracked = self:CreatePanel(self.options.content)
    self.options.panels.tracked.title = self.options.panels.tracked:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.tracked.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.tracked.title:SetText(C.GOLD .. L.spellsSection .. C.RESET)

    self.options.panels.tracked.hint = self.options.panels.tracked:CreateFontString(nil, "OVERLAY",
        "GameFontHighlightSmall")
    self.options.panels.tracked.hint:SetPoint("TOPLEFT", 18, -58)
    self.options.panels.tracked.hint:SetWidth(280)
    self.options.panels.tracked.hint:SetJustifyH("LEFT")
    self.options.panels.tracked.hint:SetText(L.spellsHint)

    self.options.panels.tracked.scrollFrame = CreateFrame("ScrollFrame", "GraalHelperTrackedSpellsScrollFrame",
        self.options.panels.tracked, "UIPanelScrollFrameTemplate")
    self.options.panels.tracked.scrollFrame:SetPoint("TOPLEFT", 18, -92)
    self.options.panels.tracked.scrollFrame:SetPoint("BOTTOMRIGHT", -30, 16)

    self.options.panels.tracked.content = CreateFrame("Frame", nil, self.options.panels.tracked.scrollFrame)
    self.options.panels.tracked.content:SetSize(270, 1)
    self.options.panels.tracked.scrollFrame:SetScrollChild(self.options.panels.tracked.content)
    self.options.panels.tracked.rows = {}
end

function GraalHelper:addTrackedNav(self)
    self.options.nav.trackedButton = self:CreateNavSubItem(self.options.nav, L.spellsSection, -455, function()
        GraalHelper:ShowOptionsPanel("tracked")
    end)
end
