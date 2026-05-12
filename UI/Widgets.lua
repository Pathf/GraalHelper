local _, GraalHelper = ...

local C = GraalHelper.Constants

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

function GraalHelper:CreateMenuSection(parent, x, y, width, height, theme, titleText)
    local section = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
    section:SetSize(width, height)
    section:SetPoint("TOPLEFT", x, y)
    self:CreateBasicBackdrop(section, 0.02, 0.02, 0.03, 0.82)
    section.bg = section:CreateTexture(nil, "BACKGROUND")
    section.bg:SetAllPoints(true)
    section.bg:SetTexture("Interface\\Buttons\\WHITE8x8")
    section.bg:SetVertexColor(theme.bgR, theme.bgG, theme.bgB, 0.10)
    section.title = section:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    section.title:SetPoint("TOPLEFT", 18, -16)
    section.title:SetText(titleText)
    return section
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
