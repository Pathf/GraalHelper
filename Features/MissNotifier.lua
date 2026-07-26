local _, GraalHelper = ...

function GraalHelper:MissNotify(caster, spellID)
    local desactivate = not self.config.missNotifier.active
    if desactivate then return end
    local playerGUID = UnitGUID("player")
    local _, subEvent, _, sourceGUID, sourceName, _, _, _, _, _, _, missType = CombatLogGetCurrentEventInfo()

    if sourceGUID ~= playerGUID then return end

    if subEvent == "SWING_MISSED" then
        if missType == nil then missType = '' end
        local message = "{rt7} " .. missType .. " - " .. sourceName
        self:SendChatMessage(message, self.config.missNotifier.chat)
    end
end
