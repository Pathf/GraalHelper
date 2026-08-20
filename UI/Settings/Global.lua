local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addGlobalPanel()
    self.options.panels.global = self:CreatePanelWithTitle(self.options.content, L.globalSection, C.COLORS.GOLD.C)

    self.options.cameraMaxZoomSlider = self:CreateSliderWithConfig(
        self.options.panels.global,
        "GraalHelperCameraMaxZoomSlider",
        L.globalCameraMaxZoom,
        1, 3.5, 0.1, 280, 34, -70,
        C.COLORS.GOLD,
        function(s, value)
            value = math.floor((value * 100) + 0.5) / 100
            GraalHelper.config.cameraMaxZoom = value
            s.valueText:SetText(tostring(value))
            GraalHelper:UpdateZoomOut()
        end
    )

    self.options.welcomeFrameActiveCheck = self:CreateCheckButton(
        self.options.panels.global,
        "GraalHelperWelcomeFrameActiveCheck",
        L.welcomeActive,
        0, -16,
        function() return GraalHelper.config.welcomeFrame.active end,
        function(val) GraalHelper.config.welcomeFrame.active = val end,
        self.options.cameraMaxZoomSlider
    )

    self.options.welcomeFrameLockCheck = self:CreateCheckButton(
        self.options.panels.global,
        "GraalHelperWelcomeFrameLockCheck",
        L.welcomeLock,
        0, -8,
        function() return GraalHelper.config.welcomeFrame.locked end,
        function(val) GraalHelper.config.welcomeFrame.locked = val end,
        self.options.welcomeFrameActiveCheck
    )

    self.options.welcomeFrameDisplayButton = self:CreateTestButton(self.options.panels.global, L.welcomeTestButton,
        function()
            GraalHelper:ShowDisplay(self.uiWelcomeFrame)
            self.uiWelcomeFrame.text:SetText(GraalHelper:RandomSentence())
        end,
        150, 35, 345
    )
end

function GraalHelper:addGlobalNav(parent, category)
    self:addGlobalPanel()
    self.options.nav.globalButton = self:CreateNavSubItem(parent, L.globalSection, category, function()
        GraalHelper:ShowOptionsPanel("global")
    end)
end

function GraalHelper:RefreshOptionsUIGlobal()
    self.options.cameraMaxZoomSlider:SetValue(self.config.cameraMaxZoom)
    self.options.cameraMaxZoomSlider.valueText:SetText(tostring(self.config.cameraMaxZoom))
end

function GraalHelper:OpenGlobalPanel()
    if self.options.nav.globalButton then
        self.options.nav.globalButton:Click()
    end
end
