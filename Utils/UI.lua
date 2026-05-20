local _, GraalHelper = ...

function GraalHelper:CreateBasicBackdrop(frame, bgR, bgG, bgB, bgA)
    if not frame.SetBackdrop then
        return
    end

    frame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = {
            left = 4,
            right = 4,
            top = 4,
            bottom = 4
        }
    })
    frame:SetBackdropColor(bgR or 0.02, bgG or 0.02, bgB or 0.02, bgA or 0.9)
end

function GraalHelper:SaveFramePosition(frame, sectionConfig)
    if not frame or not sectionConfig then
        return
    end

    local point, _, relativePoint, xOfs, yOfs = frame:GetPoint(1)

    if not point then
        return
    end

    sectionConfig.point = point or "CENTER"
    sectionConfig.relativePoint = relativePoint or "CENTER"
    sectionConfig.x = self:RoundNumber(xOfs or 0)
    sectionConfig.y = self:RoundNumber(yOfs or 0)
end

function GraalHelper:RestoreFramePosition(frame, sectionConfig)
    if not frame or not sectionConfig then
        return
    end

    frame:ClearAllPoints()
    frame:SetPoint(
        sectionConfig.point or "CENTER",
        UIParent,
        sectionConfig.relativePoint or "CENTER",
        sectionConfig.x or 0,
        sectionConfig.y or 0
    )
end
