local _, GraalHelper = ...

local C = GraalHelper.Constants

function GraalHelper:CreateNavCategory(parent, text, yOffset)
    local category = CreateFrame("Frame", nil, parent)

    category:SetSize(180, 24)
    category:SetPoint("TOPLEFT", 12, yOffset)

    category.text = category:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    category.text:SetPoint("LEFT", 0, 0)
    category.text:SetText(text)
    category.text:SetTextColor(1, 0.82, 0)

    category.line = category:CreateTexture(nil, "ARTWORK")
    category.line:SetPoint("TOPLEFT", category, "BOTTOMLEFT", 0, -2)
    category.line:SetSize(160, 1)
    category.line:SetTexture("Interface\\Buttons\\WHITE8x8")
    category.line:SetVertexColor(1, 1, 1, 0.08)

    return category
end

function GraalHelper:CreateNavSubItem(parent, text, yOffset, callback)
    local item = CreateFrame("Button", nil, parent)

    item:SetSize(170, 26)
    item:SetPoint("TOPLEFT", 24, yOffset)

    item.bg = item:CreateTexture(nil, "BACKGROUND")
    item.bg:SetAllPoints(true)
    item.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    item.bg:SetVertexColor(1, 1, 1, 0)

    item.indicator = item:CreateTexture(nil, "ARTWORK")
    item.indicator:SetPoint("LEFT", 0, 0)
    item.indicator:SetSize(2, 18)
    item.indicator:SetTexture("Interface\\Buttons\\WHITE8x8")
    item.indicator:SetVertexColor(0, 0, 0, 0)

    item.text = item:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    item.text:SetPoint("LEFT", 10, 0)
    item.text:SetText(text)
    item.text:SetTextColor(0.75, 0.75, 0.75)

    item:SetScript("OnEnter", function(self)
        self.bg:SetVertexColor(1, 1, 1, 0.03)

        if not self.selected then
            self.text:SetTextColor(1, 1, 1)
        end
    end)

    item:SetScript("OnLeave", function(self)
        if not self.selected then
            self.bg:SetVertexColor(1, 1, 1, 0)
            self.text:SetTextColor(0.75, 0.75, 0.75)
        end
    end)

    item:SetScript("OnClick", function(self)
        callback()

        for _, child in ipairs({ parent:GetChildren() }) do
            if child.indicator then
                child.selected = false
                child.indicator:SetVertexColor(0, 0, 0, 0)
                child.bg:SetVertexColor(1, 1, 1, 0)
                child.text:SetTextColor(0.75, 0.75, 0.75)
            end
        end

        self.selected = true

        self.indicator:SetVertexColor(1, 0.82, 0, 1)
        self.bg:SetVertexColor(1, 1, 1, 0.05)
        self.text:SetTextColor(1, 1, 1)
    end)

    return item
end

function GraalHelper:CreateNavItem(parent, text, yOffset, callback)
    local item = CreateFrame("Button", nil, parent)

    item:SetSize(180, 32)
    item:SetPoint("TOPLEFT", 12, yOffset)

    item.bg = item:CreateTexture(nil, "BACKGROUND")
    item.bg:SetAllPoints(true)
    item.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    item.bg:SetVertexColor(1, 1, 1, 0)

    item.highlight = item:CreateTexture(nil, "ARTWORK")
    item.highlight:SetPoint("LEFT", 0, 0)
    item.highlight:SetSize(3, 24)
    item.highlight:SetTexture("Interface\\Buttons\\WHITE8x8")
    item.highlight:SetVertexColor(1, 0.82, 0, 0)

    item.text = item:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    item.text:SetPoint("LEFT", 12, 0)
    item.text:SetText(text)
    item.text:SetTextColor(0.85, 0.85, 0.85)

    item:SetScript("OnEnter", function(self)
        self.bg:SetVertexColor(1, 1, 1, 0.04)
        self.text:SetTextColor(1, 1, 1)
    end)

    item:SetScript("OnLeave", function(self)
        if not self.selected then
            self.bg:SetVertexColor(1, 1, 1, 0)
            self.text:SetTextColor(0.85, 0.85, 0.85)
        end
    end)

    item:SetScript("OnClick", function(self)
        callback()

        for _, child in ipairs({ parent:GetChildren() }) do
            if child.highlight then
                child.selected = false
                child.highlight:SetVertexColor(1, 0.82, 0, 0)
                child.bg:SetVertexColor(1, 1, 1, 0)
                child.text:SetTextColor(0.85, 0.85, 0.85)
            end
        end

        self.selected = true
        self.highlight:SetVertexColor(1, 0.82, 0, 1)
        self.bg:SetVertexColor(1, 1, 1, 0.06)
        self.text:SetTextColor(1, 1, 1)
    end)

    return item
end

function GraalHelper:CreatePanel(parent)
    local panel = CreateFrame("Frame", nil, parent)
    panel:SetAllPoints(true)

    panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    panel.title:SetPoint("TOPLEFT", 18, -18)

    panel.separator = panel:CreateTexture(nil, "ARTWORK")
    panel.separator:SetPoint("TOPLEFT", 14, -46)
    panel.separator:SetPoint("TOPRIGHT", -14, -46)
    panel.separator:SetHeight(1)
    panel.separator:SetTexture("Interface\\Buttons\\WHITE8x8")
    panel.separator:SetVertexColor(1, 0.84, 0.1, 0.18)

    return panel
end

function GraalHelper:CreateSlider(parent, name, title, minVal, maxVal, step, width, x, y)
    local slider = CreateFrame("Slider", name, parent, "OptionsSliderTemplate")
    slider:SetWidth(width or 220)
    slider:SetHeight(16)
    slider:SetPoint("TOPLEFT", x or 20, y or -20)
    slider:SetMinMaxValues(minVal, maxVal)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)
    _G[name .. "Low"]:SetText(tostring(minVal))
    _G[name .. "High"]:SetText(tostring(maxVal))
    _G[name .. "Text"]:SetText(title)
    slider.valueText = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    slider.valueText:SetPoint("TOP", slider, "BOTTOM", 0, -2)
    return slider
end

function GraalHelper:CreateMenuButton(parent, text, width, x, y)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(width, 28)
    button:SetPoint("BOTTOMLEFT", x, y)
    button:SetText(text)
    return button
end

function GraalHelper:SkinSlider(slider, r, g, b)
    if not slider then
        return
    end

    local thumb = slider:GetThumbTexture()
    if thumb then
        thumb:SetSize(18, 18)
    end

    if _G[slider:GetName() .. "Text"] then
        _G[slider:GetName() .. "Text"]:SetTextColor(1, 1, 1)
    end
    if _G[slider:GetName() .. "Low"] then
        _G[slider:GetName() .. "Low"]:SetTextColor(1, 0.95, 0.75)
    end
    if _G[slider:GetName() .. "High"] then
        _G[slider:GetName() .. "High"]:SetTextColor(1, 0.95, 0.75)
    end

    if not slider.bgLine then
        slider.bgLine = slider:CreateTexture(nil, "BACKGROUND")
        slider.bgLine:SetPoint("LEFT", slider, "LEFT", 8, 0)
        slider.bgLine:SetPoint("RIGHT", slider, "RIGHT", -8, 0)
        slider.bgLine:SetHeight(6)
        slider.bgLine:SetTexture("Interface\\Buttons\\WHITE8x8")
        slider.bgLine:SetVertexColor(0.15, 0.15, 0.15, 0.9)
    end

    if not slider.fillLine then
        slider.fillLine = slider:CreateTexture(nil, "BORDER")
        slider.fillLine:SetPoint("LEFT", slider.bgLine, "LEFT", 0, 0)
        slider.fillLine:SetHeight(4)
        slider.fillLine:SetTexture("Interface\\Buttons\\WHITE8x8")
        slider.fillLine:SetVertexColor(r, g, b, 0.8)
    end

    local function UpdateFill(self)
        local minVal, maxVal = self:GetMinMaxValues()
        local value = self:GetValue()
        local percent = 0
        if maxVal > minVal then
            percent = (value - minVal) / (maxVal - minVal)
        end
        local width = self.bgLine:GetWidth() * percent
        self.fillLine:ClearAllPoints()
        self.fillLine:SetPoint("LEFT", self.bgLine, "LEFT", 0, 0)
        self.fillLine:SetWidth(math.max(2, width))
    end

    slider:HookScript("OnValueChanged", UpdateFill)
    UpdateFill(slider)
end

function GraalHelper:CreateSoundDropdown(parent, frameName, x, y, getValueFunc, setValueFunc, previewFunc)
    local dropdown = CreateFrame("Frame", frameName, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", x, y)

    UIDropDownMenu_SetWidth(dropdown, 170)
    UIDropDownMenu_Initialize(dropdown, function(self, level)
        for _, entry in ipairs(C.SOUND_OPTIONS) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = entry.text
            info.value = entry.value
            info.func = function()
                setValueFunc(entry.value)
                UIDropDownMenu_SetSelectedValue(dropdown, entry.value)
                UIDropDownMenu_SetText(dropdown, entry.text)
                if previewFunc then
                    previewFunc()
                end
            end
            info.checked = (getValueFunc() == entry.value)
            UIDropDownMenu_AddButton(info, level)
        end
    end)

    return dropdown
end
