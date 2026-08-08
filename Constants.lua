local addonName, GraalHelper = ...

GraalHelper.Constants = {}

local C = GraalHelper.Constants

C.COLORS = {
    BLACK = {
        R = 1.0,
        G = 1.0,
        B = 1.0,
        C = "|cff000000",
    },
    BLUE = {
        R = 0.25,
        G = 0.65,
        B = 1.0,
        C = "|cff66ccff",
    },
    GOLD = {
        R = 1.0,
        G = 0.82,
        B = 0.0,
        C = "|cffffd100",
    },
    GREEN = {
        R = 0.20,
        G = 1.0,
        B = 0.20,
        C = "|cff33ff33",
    },
    RED = {
        R = 1.0,
        G = 0.30,
        B = 0.20,
        C = "|cffff4444",
    },
    WHITE = {
        R = 0.0,
        G = 0.0,
        B = 0.0,
        C = "|cffffffff",
    },
}

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

C.SPELL_REFLECTION_SPELL_IDS = {
    [23920] = true
}

C.SPELL = {
    HUNTER_PACK_ASPECT = {
        ID = 13159
    },
    RITUAL_OF_REFRESHMENT = {
        ID = 43987
    },
    RITUAL_OF_SOULS = {
        ID = 29893
    },
    RITUAL_OF_SUMMONING = {
        ID = 698
    },
    SUMMONING_STONE = {
        ID = 23598
    },
}
