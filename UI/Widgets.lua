local _, GraalHelper = ...

local C = GraalHelper.Constants
local L = GraalHelper.L

function GraalHelper:CreateNavCategory(parent, key, text)
    local width = 174

    local category = CreateFrame("Button", nil, parent)
    category:SetSize(width, 24)

    category.text = category:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    category.text:SetPoint("LEFT", 0, 0)
    category.text:SetText(text)
    category.text:SetTextColor(1, 0.82, 0)

    category.arrow = category:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    category.arrow:SetPoint("RIGHT", category, "RIGHT", 0, 0)

    category.line = category:CreateTexture(nil, "ARTWORK")
    category.line:SetPoint("TOPLEFT", category, "BOTTOMLEFT", 0, -2)
    category.line:SetSize(width, 1)
    category.line:SetTexture("Interface\\Buttons\\WHITE8x8")
    category.line:SetVertexColor(1, 1, 1, 0.08)

    category.key = key
    category.items = {}

    category:SetScript("OnClick", function()
        self.collapsedNavCategories = self.collapsedNavCategories or {}
        self.collapsedNavCategories[key] = not self.collapsedNavCategories[key]
        self:RefreshNav()
    end)

    return category
end

function GraalHelper:CreateNavSubItem(parent, text, category, callback)
    local item = CreateFrame("Button", nil, parent)

    item:SetSize(170, 26)

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

    item:SetScript("OnEnter", function(s)
        s.bg:SetVertexColor(1, 1, 1, 0.03)
        if not s.selected then s.text:SetTextColor(1, 1, 1) end
    end)

    item:SetScript("OnLeave", function(s)
        if not s.selected then
            s.bg:SetVertexColor(1, 1, 1, 0)
            s.text:SetTextColor(0.75, 0.75, 0.75)
        end
    end)

    item:SetScript("OnClick", function(s)
        if callback then callback(s) end

        local content = s:GetParent()
        for _, child in ipairs({ content:GetChildren() }) do
            if child.indicator then
                child.selected = false
                child.indicator:SetVertexColor(0, 0, 0, 0)
                child.bg:SetVertexColor(1, 1, 1, 0)
                child.text:SetTextColor(0.75, 0.75, 0.75)
            end
        end

        s.selected = true
        s.indicator:SetVertexColor(1, 0.82, 0, 1)
        s.bg:SetVertexColor(1, 1, 1, 0.05)
        s.text:SetTextColor(1, 1, 1)
    end)

    if category and category.items then
        table.insert(category.items, item)
    end

    return item
end

function GraalHelper:RefreshNav()
    if not self.options or not self.options.navCategories then return end

    self.collapsedNavCategories = self.collapsedNavCategories or {}
    local y = 10

    for _, category in ipairs(self.options.navCategories) do
        local isCollapsed = self.collapsedNavCategories[category.key]
        category:ClearAllPoints()
        category:SetPoint("TOPLEFT", 10, -y)
        category.arrow:SetText(isCollapsed and C.COLORS.GOLD.C .. "[+]" .. C.RESET or C.COLORS.GOLD.C .. "[-]" .. C
            .RESET)
        category:Show()
        y = y + 28

        if not isCollapsed then
            for _, item in ipairs(category.items) do
                item:ClearAllPoints()
                item:SetPoint("TOPLEFT", 10, -y)
                item:Show()
                y = y + 28
            end
            category.line:Show()
        else
            for _, item in ipairs(category.items) do
                item:Hide()
            end
            category.line:Hide()
        end

        y = y + 10
    end

    if self.options.navContent then
        self.options.navContent:SetHeight(math.abs(y) + 20)
    end
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

    item:SetScript("OnEnter", function(s)
        s.bg:SetVertexColor(1, 1, 1, 0.04)
        s.text:SetTextColor(1, 1, 1)
    end)

    item:SetScript("OnLeave", function(s)
        if not s.selected then
            s.bg:SetVertexColor(1, 1, 1, 0)
            s.text:SetTextColor(0.85, 0.85, 0.85)
        end
    end)

    item:SetScript("OnClick", function(s)
        callback()

        for _, child in ipairs({ parent:GetChildren() }) do
            if child.highlight then
                child.selected = false
                child.highlight:SetVertexColor(1, 0.82, 0, 0)
                child.bg:SetVertexColor(1, 1, 1, 0)
                child.text:SetTextColor(0.85, 0.85, 0.85)
            end
        end

        s.selected = true
        s.highlight:SetVertexColor(1, 0.82, 0, 1)
        s.bg:SetVertexColor(1, 1, 1, 0.06)
        s.text:SetTextColor(1, 1, 1)
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

local function CreateDropdown(parent, frameName, options, isTranslate, x, y, getValueFunc, setValueFunc, previewFunc)
    local dropdown = CreateFrame("Frame", frameName, parent, "UIDropDownMenuTemplate")
    dropdown:SetPoint("TOPLEFT", x, y)

    UIDropDownMenu_SetWidth(dropdown, 170)
    UIDropDownMenu_Initialize(dropdown, function(_, level)
        for _, entry in ipairs(options) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = entry.text
            if isTranslate then info.text = L[entry.text] end
            info.value = entry.value
            info.func = function()
                setValueFunc(entry.value)
                UIDropDownMenu_SetSelectedValue(dropdown, entry.value)
                local entryText = entry.text
                if isTranslate then entryText = L[entry.text] end
                UIDropDownMenu_SetText(dropdown, entryText)
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

function GraalHelper:CreateSoundDropdown(parent, frameName, x, y, getValueFunc, setValueFunc, previewFunc)
    return CreateDropdown(parent, frameName, C.SOUND_OPTIONS, false, x, y, getValueFunc, setValueFunc, previewFunc)
end

function GraalHelper:CreateChatDropdown(parent, frameName, x, y, getValueFunc, setValueFunc, previewFunc)
    return CreateDropdown(parent, frameName, C.CHAT_OPTIONS, true, x, y, getValueFunc, setValueFunc, previewFunc)
end

function GraalHelper:CreateDropdownWithConfig(options, isTranslate, parent, frameName, text, y, color, getValueFunc,
                                              setValueFunc, previewFunc)
    local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    label:SetPoint("TOPLEFT", 18, y)
    label:SetText(color.C .. text .. C.RESET)
    local dropdown = CreateDropdown(parent, frameName, options, isTranslate, 0, y - 15, getValueFunc, setValueFunc,
        previewFunc)
    return label, dropdown
end

function GraalHelper:CreatePanelWithTitle(parent, titleText, colorCode)
    local panel = self:CreatePanel(parent)

    panel.title = panel:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    panel.title:SetPoint("TOPLEFT", 18, -18)

    local color = colorCode or C.COLORS.GOLD.C
    panel.title:SetText(color .. titleText .. C.RESET)

    return panel
end

function GraalHelper:CreateCheckButton(parent, frameName, labelText, x, y, getValueFunc, setValueFunc, relativeTo)
    local check = CreateFrame("CheckButton", frameName, parent, "InterfaceOptionsCheckButtonTemplate")

    if relativeTo then
        check:SetPoint("TOPLEFT", relativeTo, "BOTTOMLEFT", x or 0, y or -8)
    else
        check:SetPoint("TOPLEFT", x or 16, y or -62)
    end

    check.label = check:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    check.label:SetPoint("LEFT", check, "RIGHT", 4, 1)
    check.label:SetText(labelText)
    check.label:SetTextColor(1, 0.90, 0.20)

    if getValueFunc then
        check:SetChecked(getValueFunc())
    end

    check:SetScript("OnClick", function(s)
        local isChecked = s:GetChecked() and true or false
        if setValueFunc then
            setValueFunc(isChecked)
        end
    end)

    return check
end

function GraalHelper:CreateSliderWithConfig(parent, name, title, minVal, maxVal, step, width, x, y, rgb, onValueChanged)
    local slider = self:CreateSlider(parent, name, title, minVal, maxVal, step, width, x, y)
    slider:SetScript("OnValueChanged", onValueChanged)
    self:SkinSlider(slider, rgb.R, rgb.G, rgb.B)
    return slider
end

function GraalHelper:CreateTestButton(parent, text, testFunction, width, x, y)
    width = width or 150
    x = x or 100
    y = y or 40
    local testButton = self:CreateMenuButton(parent, text, width, x, y)
    testButton:SetScript("OnClick", testFunction)
    return testButton
end
