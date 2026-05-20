local _, GraalHelper = ...

if GetLocale() ~= "frFR" then return end

GraalHelper.L = {
    addonLoaded = "Saisir /gh ouvrira le menu",
    bothLocked = "Alertes verrouillées.",
    bothUnlocked = "Alertes déverrouillées.",
    chooseSound = "Choix du son",
    displayDuration = "Durée d'affichage",
    enableSound = "Active le son",
    errors = {
        options = {
            null = "Les options ne sont pas chargées."
        },
    },
    lockWindow = "Verrouille l'alerte",
    menuTitle = "GraalHelper",
    nav = {
        danger = "Danger",
        action = "Action",
        settings = "Options"
    },
    noSpellsTracked = "Aucun sort n'a encore été suivi.",
    reflectFound = "Sort de Reflection actif",
    reflectLine = "Ne lancer pas de sort - Reflection actif !",
    reflectSection = "Sort de reflection",
    reflectTitle = "Sort de reflection !",
    scale = "Taille de l'alerte",
    showBuffNames = "Montre les noms des buffs",
    silenceFound = "Sort de Silence actif",
    silenceLine = "Impossible de lancer des sorts - Silence actif !",
    silenceSection = "Sort de silence",
    silenceTitle = "Sort de silence !",
    slashHide = "/gh hide - Cache les alertes",
    slashLock = "/gh lock - Verrouille les alertes",
    slashMenu = "/gh - Ouvre le menu",
    slashTest = "/gh test - Test spellsteal + reflection",
    slashUnlock = "/gh unlock - Déverrouille les alertes",
    spellsHint = "Seuls les sorts suivis vus par l'addon apparaissent ici.",
    spellsSection = "Sorts suivis",
    spellstealFound = "Buffs volables trouvés",
    spellstealLine = "Buffs prêt pour etre volé !",
    stealTitle = "Vol de sort",
    test = "Test",
    trackReflect = "Reflection",
    trackSteal = "Voler",

    MATCH = {
        SPELL_REFLECTION_NAMES = {
            ["Cocon de ténèbres"] = true,
            ["Renvoi de sort"] = true,
            ["Bouclier réflecteur de magie"] = true,
        },
        SPELL_SILENCE_NAMES = {
            ["Silence"] = true,
            ["Verrou magique"] = true,
            ["Torrent arcanique"] = true,
            ["Contresort - Silencieux"] = true,
            ["Coup de pied - Silencieux"] = true,
            ["Rugissement assourdissant"] = true
        },
    },
}
