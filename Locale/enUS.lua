local _, GraalHelper = ...

GraalHelper.L = {
    addonLoaded = "loaded. \"/gh\" opens the menu",
    bothLocked = "Both windows locked.",
    bothUnlocked = "Both windows unlocked.",
    chooseSound = "Choose sound",
    displayDuration = "Display duration",
    enableSound = "Enable sound",
    errors = {
        options = {
            null = "The options are not loaded."
        },
    },
    lockWindow = "Lock window",
    menuSubtitle = "Spellsteal + Spell Reflection warnings",
    menuTitle = "GraalHelper",
    noSpellsTracked = "No spells tracked yet.",
    reflectFound = "Spell Reflection active",
    reflectLine = "Do not cast - Reflect active!",
    reflectSection = "Reflect Window",
    reflectTitle = "REFLECT!",
    scale = "Scale",
    showBuffNames = "Show buff names",
    silenceFound = "Silence effect active",
    silenceLine = "Unable to cast spells - Silence active!",
    silenceSection = "Alert: Silence effect",
    silenceTitle = "Silence effect!",
    slashHide = "/gh hide - Hide alerts",
    slashLock = "/gh lock - Lock both",
    slashMenu = "/gh - Open menu",
    slashTest = "/gh test - Test both",
    slashUnlock = "/gh unlock - Unlock both",
    spellsHint = "Only tracked spells seen by the addon appear here.",
    spellsSection = "Tracked Spells",
    spellstealFound = "Stealable buffs found",
    spellstealLine = "Buffs ready to steal!",
    spellstealTitle = "SPELLSTEAL!",
    stealSection = "Spellsteal Window",
    testBlue = "Test Blue",
    testRed = "Test Red",
    testSilence = "Test Silence",
    trackReflect = "Reflect",
    trackSteal = "Steal",

    MATCH = {
        SPELL_REFLECTION_NAMES = {
            ["Dark Shell"] = true,
            ["Spell Reflection"] = true,
            ["Reflective Magic Shield"] = true,
        },
        SPELL_SILENCE_NAMES = {
            ["Silence"] = true,
        },
    },
}
