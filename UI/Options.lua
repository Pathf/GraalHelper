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
    local navFrame = CreateFrame("Frame", nil, self.options, BackdropTemplateMixin and "BackdropTemplate")
    navFrame:SetPoint("TOPLEFT", 14, -62)
    navFrame:SetSize(220, 544)
    self:CreateBasicBackdrop(navFrame, 0.02, 0.02, 0.02, 0.75)

    local scrollFrame = CreateFrame("ScrollFrame", "GraalHelperNavScrollFrame", navFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 4, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", -26, 6)

    local navContent = CreateFrame("Frame", nil, scrollFrame)
    navContent:SetSize(180, 1)
    scrollFrame:SetScrollChild(navContent)

    self.options.nav = navFrame
    self.options.navScrollFrame = scrollFrame
    self.options.navContent = navContent

    self.options.navCategories = {
        self:CreateNavCategory(navContent, "settings", L.settings),
        self:CreateNavCategory(navContent, "alerts", L.alerts),
        self:CreateNavCategory(navContent, "actions", L.actions),
        self:CreateNavCategory(navContent, "notifiers", L.notifiers),
    }

    self.options.nav.settingsCategory = self.options.navCategories[1]
    self.options.nav.alertsCategory = self.options.navCategories[2]
    self.options.nav.actionsCategory = self.options.navCategories[3]
    self.options.nav.notifiersCategory = self.options.navCategories[4]
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
    self.options:SetScript("OnDragStart", function(s) s:StartMoving() end)
    self.options:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)

    buildBackground(self)
    buildTopBar(self)
    buildNav(self)
    buildContent(self)

    local parent = self.options.navContent

    local settings = self.options.nav.settingsCategory
    GraalHelper:addGlobalNav(parent, settings)
    GraalHelper:addTrackedNav(parent, settings)

    local alerts = self.options.nav.alertsCategory
    GraalHelper:addDisarmNav(parent, alerts)
    GraalHelper:addStunNav(parent, alerts)
    GraalHelper:addRootNav(parent, alerts)
    GraalHelper:addFearNav(parent, alerts)
    GraalHelper:addSilenceNav(parent, alerts)
    GraalHelper:addReflectNav(parent, alerts)

    local actions = self.options.nav.actionsCategory
    GraalHelper:addKickNav(parent, actions)
    GraalHelper:addHunterPackAspectNav(parent, actions)
    GraalHelper:addDispelNav(parent, actions)
    GraalHelper:addStealNav(parent, actions)

    local notifiers = self.options.nav.notifiersCategory
    GraalHelper:addSummonNotifierNav(parent, notifiers)
    GraalHelper:addMissNotifierNav(parent, notifiers)

    self:RefreshNav()
    self:RefreshTrackedSpellsUI()
    self:OpenGlobalPanel()
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
    self:RefreshOptionsUIHunterPackAspect()
    self:RefreshOptionsUIReflect()
    self:RefreshOptionsUISilence()
    self:RefreshOptionsUIStun()
    self:RefreshOptionsUIRoot()
    self:RefreshOptionsUIDisarm()
    self:RefreshOptionsUIFear()
    self:RefreshTrackedSpellsUI()
    self:RefreshOptionsUISummonNotifier()
    self:RefreshOptionsUIMissNotifier()
    self:RefreshOptionsUIDispel()
    self:RefreshOptionsUIGlobal()
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
