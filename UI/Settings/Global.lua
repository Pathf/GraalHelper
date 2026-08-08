local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:addGlobalPanel()
    self.options.panels.global = self:CreatePanel(self.options.content)
    self.options.panels.global.title = self.options.panels.global:CreateFontString(nil, "OVERLAY",
        "GameFontNormalLarge")
    self.options.panels.global.title:SetPoint("TOPLEFT", 18, -18)
    self.options.panels.global.title:SetText(C.GOLD .. L.globalSection .. C.RESET)

    self.options.cameraMaxZoomSlider = self:CreateSlider(self.options.panels.global, "GraalHelperCameraMaxZoomSlider",
        "", 1,
        3.5, 0.1, 280, 34, -65)
    self.options.cameraMaxZoomSlider:SetScript("OnValueChanged", function(s, value)
        value = math.floor((value * 100) + 0.5) / 100
        GraalHelper.config.cameraMaxZoom = value
        s.valueText:SetText(tostring(value) .. " Sec.")
        GraalHelper:UpdateZoomOut()
    end)
    self:SkinSlider(self.options.cameraMaxZoomSlider, 1.0, 0.82, 0.0)
    _G[self.options.cameraMaxZoomSlider:GetName() .. "Text"]:SetText(L.globalCameraMaxZoom)
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
