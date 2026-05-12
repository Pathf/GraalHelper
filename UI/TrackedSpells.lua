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

function GraalHelper:RefreshTrackedSpellsUI()
    if not self.options or not self.options.spellsSection or not self.options.spellsSection.rows then
        return
    end

    local trackedSpells = (self.config and self.config.trackedSpells) or {}
    local content = self.options.spellsSection.content
    local totalHeight = 0

    if #trackedSpells == 0 then
        if not self.options.spellsSection.emptyText then
            self.options.spellsSection.emptyText = content:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            self.options.spellsSection.emptyText:SetPoint("TOPLEFT", 14, -10)
            self.options.spellsSection.emptyText:SetJustifyH("LEFT")
            self.options.spellsSection.emptyText:SetWidth(265)
        end
        self.options.spellsSection.emptyText:SetText(L.noSpellsTracked)
        self.options.spellsSection.emptyText:Show()
    elseif self.options.spellsSection.emptyText then
        self.options.spellsSection.emptyText:Hide()
    end

    for i, spell in ipairs(trackedSpells) do
        local row = self.options.spellsSection.rows[i]
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
            row.name:SetJustifyH("LEFT")
            row.name:SetWidth(180)

            row.category = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.category:SetPoint("TOPLEFT", row.name, "BOTTOMLEFT", 0, -2)
            row.category:SetJustifyH("LEFT")
            row.category:SetWidth(180)

            row.divider = row:CreateTexture(nil, "BACKGROUND")
            row.divider:SetPoint("BOTTOMLEFT", 0, 0)
            row.divider:SetPoint("BOTTOMRIGHT", -10, 0)
            row.divider:SetHeight(1)
            row.divider:SetTexture("Interface\\Buttons\\WHITE8x8")
            row.divider:SetVertexColor(0.20, 0.20, 0.24, 0.85)

            self.options.spellsSection.rows[i] = row
        end

        row:SetPoint("TOPLEFT", 10, -((i - 1) * 30) - 4)
        row.check:SetChecked(GraalHelper:IsSpellEnabled(spell.key))
        row.icon:SetTexture(spell.icon or "Interface\\Icons\\INV_Misc_QuestionMark")
        row.name:SetText(spell.name or spell.key)
        row.category:SetText((spell.categoryLabel or "") ..
            (spell.spellId and (" |cffa8a8a8[#" .. spell.spellId .. "]|r") or ""))
        row:Show()

        row.check:SetScript("OnClick", function(self)
            GraalHelper.config.spellFilter[spell.key] = self:GetChecked() and true or false
        end)

        local function ShowRowTooltip()
            GraalHelper:ShowTrackedSpellTooltip(row, spell)
        end

        local function HideRowTooltip()
            GameTooltip:Hide()
        end

        row:SetScript("OnEnter", ShowRowTooltip)
        row:SetScript("OnLeave", HideRowTooltip)
        row.check:SetScript("OnEnter", ShowRowTooltip)
        row.check:SetScript("OnLeave", HideRowTooltip)
        row.icon:SetScript("OnEnter", ShowRowTooltip)
        row.icon:SetScript("OnLeave", HideRowTooltip)
        row.name:SetScript("OnEnter", ShowRowTooltip)
        row.name:SetScript("OnLeave", HideRowTooltip)
        row.category:SetScript("OnEnter", ShowRowTooltip)
        row.category:SetScript("OnLeave", HideRowTooltip)

        totalHeight = i * 30
    end

    for i = #trackedSpells + 1, #self.options.spellsSection.rows do
        self.options.spellsSection.rows[i]:Hide()
    end

    content:SetHeight(math.max(1, totalHeight + 12))
end
