local _, GraalHelper = ...

if GetLocale() ~= "deDE" then return end

GraalHelper.L = {
    addonLoaded = "Wenn Sie /gh eingeben, wird das Menü geöffnet.",
    bothLocked = "Warnungen gesperrt.",
    bothUnlocked = "Warnungen entsperrt.",
    chooseSound = "Klangwahl",
    displayDuration = "Anzeigebehdauer",
    enableSound = "Aktiviert den Ton",
    errors = {
        options = {
            null = "Die Optionen sind nicht geladen."
        },
    },
    lockWindow = "Warnung gesperrt",
    menuTitle = "GraalHelper",
    nav = {
        danger = "Gefahr",
        action = "Aktionen",
        settings = "Einstellungen"
    },
    noSpellsTracked = "Bisher wurde noch kein Zauber verfolgt.",
    reflectFound = "Aktiver Reflexionszauber",
    reflectLine = "Wirke keine Zauber - Reflexion aktiv!",
    reflectSection = "Warnung : Reflexionszauber",
    reflectTitle = "Reflexionszauber!",
    scale = "Warnungsgröße",
    showBuffNames = "Zeigt die Namen der Buffs",
    silenceFound = "Stilleffekt aktiv",
    silenceLine = "Zauber können nicht gewirkt werden - Stille aktiv!",
    silenceSection = "Warnung: Stilleffekt",
    silenceTitle = "Stilleffekt!",
    slashHide = "/gh hide - Blendet Warnungen aus",
    slashLock = "/gh lock - Gesperrte Warnungen",
    slashMenu = "/gh - Öffnet das Menü",
    slashTest = "/gh test - Test: Zauberdiebstahl + Reflexion",
    slashUnlock = "/gh unlock - Warnungen entsperrt",
    spellsHint = "Hier erscheinen nur verfolgte Zauber, die das Add-on sieht.",
    spellsSection = "Zauber verfolgt",
    spellstealFound = "Stiehlbare Buffs gefunden",
    spellstealLine = "Buffs sind bereit, gestohlen zu werden!",
    stealTitle = "Zauberdiebstahl",
    test = "Test",
    trackReflect = "Reflexion",
    trackSteal = "Stehlen",

    MATCH = {
        SPELL_REFLECTION_NAMES = {
            ["Dunkle Hülle"] = true,
            ["Zauberreflexion"] = true,
            ["Reflektierender Magieschild"] = true,
        },
        SPELL_SILENCE_NAMES = {
            ["Stille"] = true,
            ["Zaubersperre"] = true,
            ["Arkaner Strom"] = true,
            ["Gegenzauber - zum Schweigen gebracht"] = true,
            ["Tritt - zum Schweigen gebracht"] = true,
            ["Ohrenbetäubendes Gebrüll"] = true
        },
    },
}
