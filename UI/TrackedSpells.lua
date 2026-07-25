local _, GraalHelper = ...

local L = GraalHelper.L

function GraalHelper:ShowTrackedSpellTooltip(owner, spell)
    if not owner or not spell then
        return
    end

    GameTooltip:SetOwner(owner, "ANCHOR_RIGHT")

    local shown = false
    if spell.spellId and spell.spellId > 0 then
        if GameTooltip.SetSpellByID then
            local ok = pcall(GameTooltip.SetSpellByID, GameTooltip, spell.spellId)
            shown = ok and true or false
        end

        if not shown and GameTooltip.SetHyperlink then
            local ok = pcall(GameTooltip.SetHyperlink, GameTooltip, "spell:" .. spell.spellId)
            shown = ok and true or false
        end
    end

    if not shown then
        GameTooltip:ClearLines()
        GameTooltip:SetText(spell.name or "Unknown Spell", 1, 0.82, 0)
        if spell.categoryLabel and spell.categoryLabel ~= "" then
            GameTooltip:AddLine(spell.categoryLabel, 0.7, 0.7, 0.7)
        end
        if spell.spellId and spell.spellId > 0 then
            GameTooltip:AddLine("Spell ID: " .. spell.spellId, 0.7, 0.7, 0.7)
        end
    end

    GameTooltip:Show()
end

local function isRowsExist(self)
    return not self.options
        or not self.options.panels
        or not self.options.panels.tracked
        or not self.options.panels.tracked.rows
end

function GraalHelper:RefreshTrackedSpellsUI()
    if isRowsExist(self) then return end

    self:SortTrackedSpells()

    local trackedSpells = (self.config and self.config.trackedSpells) or {}
    local content = self.options.panels.tracked.content

    self.options.panels.tracked.rows = self.options.panels.tracked.rows or {}
    self.options.panels.tracked.headers = self.options.panels.tracked.headers or {}

    -- Cache tous les éléments existants
    for _, row in ipairs(self.options.panels.tracked.rows) do
        row:Hide()
    end

    for _, header in pairs(self.options.panels.tracked.headers) do
        header:Hide()
    end

    ----------------------------------------------------------------------
    -- Aucun sort
    ----------------------------------------------------------------------
    if #trackedSpells == 0 then
        if not self.options.panels.tracked.emptyText then
            self.options.panels.tracked.emptyText =
                content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            self.options.panels.tracked.emptyText:SetPoint("TOPLEFT", 450, -10)
            self.options.panels.tracked.emptyText:SetWidth(265)
            self.options.panels.tracked.emptyText:SetJustifyH("LEFT")
        end

        self.options.panels.tracked.emptyText:SetText(L.noSpellsTracked)
        self.options.panels.tracked.emptyText:Show()

        content:SetHeight(1)
        return
    elseif self.options.panels.tracked.emptyText then
        self.options.panels.tracked.emptyText:Hide()
    end

    ----------------------------------------------------------------------
    -- Construction des groupes
    ----------------------------------------------------------------------
    local groups = {}
    local order = {}

    for _, spell in ipairs(trackedSpells) do
        local category = spell.categoryLabel or L.other or "Autres"

        if not groups[category] then
            groups[category] = {}
            table.insert(order, category)
        end

        table.insert(groups[category], spell)
    end

    ----------------------------------------------------------------------
    -- Affichage
    ----------------------------------------------------------------------
    local y = 4
    local rowIndex = 1

    for _, category in ipairs(order) do
        ------------------------------------------------------------------
        -- Header
        ------------------------------------------------------------------
        local header = self.options.panels.tracked.headers[category]

        if not header then
            header = content:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            header:SetTextColor(1, 0.82, 0)
            self.options.panels.tracked.headers[category] = header
        end

        header:ClearAllPoints()
        header:SetPoint("TOPLEFT", 10, -y)
        header:SetText(category)
        header:Show()

        y = y + 22

        ------------------------------------------------------------------
        -- Sorts
        ------------------------------------------------------------------
        for _, spell in ipairs(groups[category]) do
            local row = self.options.panels.tracked.rows[rowIndex]

            if not row then
                row = CreateFrame("Frame", nil, content)
                row:SetSize(270, 28)
                row:EnableMouse(true)

                row.check = CreateFrame("CheckButton", nil, row, "UICheckButtonTemplate")
                row.check:SetPoint("TOPLEFT", 0, 2)

                row.icon = row:CreateTexture(nil, "ARTWORK")
                row.icon:SetSize(18, 18)
                row.icon:SetPoint("LEFT", row.check, "RIGHT", 2, 0)

                row.name = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                row.name:SetPoint("TOPLEFT", row.icon, "TOPRIGHT", 6, 0)
                row.name:SetWidth(180)
                row.name:SetJustifyH("LEFT")

                row.category = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
                row.category:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -2)
                row.category:SetWidth(180)
                row.category:SetJustifyH("LEFT")

                row.divider = row:CreateTexture(nil, "BACKGROUND")
                row.divider:SetPoint("BOTTOMLEFT", 0, 0)
                row.divider:SetPoint("BOTTOMRIGHT", -10, 0)
                row.divider:SetHeight(1)
                row.divider:SetTexture("Interface\\Buttons\\WHITE8x8")
                row.divider:SetVertexColor(0.20, 0.20, 0.24, 0.85)

                self.options.panels.tracked.rows[rowIndex] = row
            end

            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", 10, -y)

            row.check:SetChecked(self:IsSpellEnabled(spell.key))
            row.icon:SetTexture(spell.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
            row.name:SetText(spell.name or spell.key)

            row.category:SetText(
                spell.spellId and ("|cffa8a8a8[#" .. spell.spellId .. "]|r") or ""
            )

            row.check:SetScript("OnClick", function(btn)
                self.config.spellFilter[spell.key] = btn:GetChecked() or false
            end)

            local function ShowTooltip()
                self:ShowTrackedSpellTooltip(row, spell)
            end

            local function HideTooltip()
                GameTooltip:Hide()
            end

            row:SetScript("OnEnter", ShowTooltip)
            row:SetScript("OnLeave", HideTooltip)

            row.check:SetScript("OnEnter", ShowTooltip)
            row.check:SetScript("OnLeave", HideTooltip)

            row.icon:SetScript("OnEnter", ShowTooltip)
            row.icon:SetScript("OnLeave", HideTooltip)

            row.name:SetScript("OnEnter", ShowTooltip)
            row.name:SetScript("OnLeave", HideTooltip)

            row.category:SetScript("OnEnter", ShowTooltip)
            row.category:SetScript("OnLeave", HideTooltip)

            row:Show()

            rowIndex = rowIndex + 1
            y = y + 30
        end

        y = y + 6
    end

    content:SetHeight(y)

    -- Cache les anciennes rows inutilisées
    for i = rowIndex, #self.options.panels.tracked.rows do
        self.options.panels.tracked.rows[i]:Hide()
    end
end
