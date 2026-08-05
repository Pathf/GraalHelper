local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addGlobalPanel()
    self.options.panels.global = self:CreatePanel(self.options.content)
    self.options.panels.global.title = self.options.panels.global:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.global.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.global.title:SetText(C.RED .. L.globalSection .. C.RESET)

    self.options.cameraMaxZoomSlider = self:CreateSlider(self.options.panels.global, "GraalHelperCameraMaxZoomSlider",
        "", 1,
        3.5, 0.1, 280, 34, -65)
    self.options.cameraMaxZoomSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.cameraMaxZoom = value
        self.valueText:SetText(tostring(value) .. " Sec.")
        GraalHelper:UpdateZoomOut()
    end)
    self:SkinSlider(self.options.cameraMaxZoomSlider, 0.25, 0.65, 1.0)
    _G[self.options.cameraMaxZoomSlider:GetName() .. "Text"]:SetText(L.globalCameraMaxZoom)
end

function GraalHelper:addGlobalNav()
    self.options.nav.globalButton = self:CreateNavSubItem(self.options.nav, L.globalSection, -425,
        function()
            GraalHelper:ShowOptionsPanel("global")
        end)
end

function GraalHelper:RefreshOptionsUIGlobal()
    self.options.cameraMaxZoomSlider:SetValue(self.config.cameraMaxZoom)
    self.options.cameraMaxZoomSlider.valueText:SetText(tostring(self.config.cameraMaxZoom) .. " Sec.")
end
