local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addGlobalPanel()
    self.options.panels.global = self:CreatePanelWithTitle(self.options.content, L.globalSection, C.COLORS.GOLD.C)

    self.options.cameraMaxZoomSlider = self:CreateSliderWithConfig(
        self.options.panels.global,
        "GraalHelperCameraMaxZoomSlider",
        L.globalCameraMaxZoom,
        1, 3.5, 0.1, 280, 34, -65,
        C.COLORS.GOLD,
        function(s, value)
            value = math.floor((value * 100) + 0.5) / 100
            GraalHelper.config.cameraMaxZoom = value
            s.valueText:SetText(tostring(value))
            GraalHelper:UpdateZoomOut()
        end
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
    self.options.cameraMaxZoomSlider.valueText:SetText(tostring(self.config.cameraMaxZoom) .. " Sec.")
end

function GraalHelper:OpenGlobalPanel()
    if self.options.nav.globalButton then
        self.options.nav.globalButton:Click()
    end
end
