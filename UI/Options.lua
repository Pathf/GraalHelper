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
    self.options.nav:SetSize(220, 544)
    self:CreateBasicBackdrop(self.options.nav, 0.02, 0.02, 0.02, 0.75)

    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, L.alerts, -20)
    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, L.actions, -240)
    self.options.nav.alertsCategory = self:CreateNavCategory(self.options.nav, L.settings, -335)
end

local function buildContent(self)
    self.options.content = CreateFrame("Frame", nil, self.options, BackdropTemplateMixin and "BackdropTemplate")
    self.options.content:SetPoint("TOPLEFT", self.options.nav, "TOPRIGHT", 14, 0)
    self.options.content:SetPoint("BOTTOMRIGHT", -14, 14)
    self:CreateBasicBackdrop(self.options.content, 0.01, 0.01, 0.01, 0.88)
    self.options.panels = {}
end

function GraalHelper:CreateOptionsWindow()
    if self.options then return end

    self.options = CreateFrame("Frame", "GraalHelperOptionsFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
    self.options:SetSize(620, 620)
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

    GraalHelper:addReflectPanel(self)
    GraalHelper:addReflectNav(self)

    GraalHelper:addStealPanel(self)
    GraalHelper:addStealNav(self)

    GraalHelper:addKickPanel(self)
    GraalHelper:addKickNav(self)

    GraalHelper:addSilencePanel(self)
    GraalHelper:addSilenceNav(self)

    GraalHelper:addStunPanel(self)
    GraalHelper:addStunNav(self)

    GraalHelper:addRootPanel(self)
    GraalHelper:addRootNav(self)

    GraalHelper:addDisarmPanel(self)
    GraalHelper:addDisarmNav(self)

    GraalHelper:addFearPanel(self)
    GraalHelper:addFearNav(self)

    GraalHelper:addTrackedPanel(self)
    GraalHelper:addTrackedNav(self)

    GraalHelper:addSummonNotifierPanel(self)
    GraalHelper:addSummonNotifierNav(self)

    self:RefreshTrackedSpellsUI()
    self.options.nav.trackedButton:Click()
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

    self:RefreshOptionsUISteal()
    self:RefreshOptionsUIKick()
    self:RefreshOptionsUIReflect()
    self:RefreshOptionsUISilence()
    self:RefreshOptionsUIStun()
    self:RefreshOptionsUIRoot()
    self:RefreshOptionsUIDisarm()
    self:RefreshOptionsUIFear()
    self:RefreshTrackedSpellsUI()
    self:RefreshOptionsUISummonNotifier()
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
