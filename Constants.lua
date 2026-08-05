local addonName, GraalHelper = ...

GraalHelper.Constants = {}

local C = GraalHelper.Constants

C.GOLD = "|cffffd100"
C.WHITE = "|cffffffff"
C.BLUE = "|cff66ccff"
C.RED = "|cffff4444"
C.RESET = "|r"

C.BASE_FRAME_WIDTH = 420
C.BASE_FRAME_HEIGHT = 96

C.ICONS = {
    SPELLS = {
        DISARM = "Interface\\Icons\\Ability_Warrior_Disarm",
        DISPEL = "Interface\\Icons\\spell_holy_dispelmagic",
        FEAR = "Interface\\Icons\\Spell_Shadow_Possession",
        HUNTER_PACK_ASPECT = "Interface\\Icons\\Ability_mount_whitetiger",
        KICK = "Interface\\Icons\\Ability_Kick",
        REFLECT = "Interface\\Icons\\Ability_Warrior_Challange",
        ROOT = "Interface\\Icons\\Spell_Nature_StrangleVines",
        SILENCE = "Interface\\Icons\\Spell_Holy_Silence",
        STEAL = "Interface\\Icons\\Spell_Nature_WispSplode",
        STUN = "Interface\\Icons\\Spell_Frost_Stun",
    }
}

C.CHAT_OPTIONS = {
    {
        text = "say",
        value = "SAY"
    },
    {
        text = "yell",
        value = "YELL"
    },
    {
        text = "party",
        value = "PARTY"
    },
    {
        text = "raid",
        value = "RAID"
    },
    {
        text = "guild",
        value = "GUILD"
    },
    {
        text = "raidOrPartyOrNothing",
        value = "RAID_PARTY"
    },
}

C.SOUND_OPTIONS = {
    {
        text = "Raid Warning",
        value = "RaidWarning",
        kit = SOUNDKIT and SOUNDKIT.RAID_WARNING or 8959,
        file = "Sound\\Interface\\RaidWarning.ogg"
    },
    {
        text = "Warning",
        value = "Warning",
        kit = SOUNDKIT and SOUNDKIT.ALARM_CLOCK_WARNING_3 or 12889,
        file = "Sound\\Interface\\Warning.ogg"
    },
    {
        text = "Map Ping",
        value = "MapPing",
        kit = SOUNDKIT and SOUNDKIT.IG_MAP_PING or 3175,
        file = "Sound\\Interface\\MapPing.ogg"
    },
    {
        text = "Ready Check",
        value = "ReadyCheck",
        kit = SOUNDKIT and SOUNDKIT.READY_CHECK or 8960,
        file = "Sound\\Interface\\ReadyCheck.ogg"
    },
    {
        text = "Tell Message",
        value = "TellMessage",
        kit = SOUNDKIT and SOUNDKIT.TELL_MESSAGE or 3081,
        file = "Sound\\Interface\\TellMessage.ogg"
    },
    {
        text = "Auction Open",
        value = "AuctionOpen",
        kit = SOUNDKIT and SOUNDKIT.IG_MAINMENU_OPEN or 850,
        file = "Sound\\Interface\\AuctionWindowOpen.ogg"
    },
}

C.DURATION_OPTIONS = {
    { text = "0s",   value = 0 },
    { text = "0.5s", value = 0.5 },
    { text = "1s",   value = 1 },
    { text = "1.5s", value = 1.5 },
    { text = "2s",   value = 2 },
    { text = "2.5s", value = 2.5 },
    { text = "3s",   value = 3 },
    { text = "3.5s", value = 3.5 },
    { text = "4s",   value = 4 },
}

C.SPELL_REFLECTION_SPELL_IDS = {
    [23920] = true
}

C.HUNTER_PACK_ASPECT_ID = 13159
