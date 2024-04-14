------------------
-- Instructions --
------------------

-- This is a Lua file containing the parts of the credits relative to the translation (and any other things done by the team).
-- Modify the strings to change how the credits will be displayed. Make sure to also change the ones for the English version!
--
-- If you need more than one section of credits you can comment out the t[2] table by removing the -- at the beginning of each
-- line. You can also add t[3] and so on if needed using the same format.
--
-- To make it easier to test the credits without having to play through the whole game I added a hidden way to access them by
-- pressing "C" while you are in the initial game menu (the one with the "Start game" button).
--
---------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

local t = {}

t[1] = {
    title_english = "Translation team leader",
    title_translated = "Руководитель группы по переводу",
    names_english = "Aleksandr \"Crystalwarrior\" Varnavskii",
    names_translated = "Александр \"Crystalwarrior\" Варнавский",
}

t[2] = {
    title_english = "Translation by",
    title_translated = "Перевод осуществлён",
    names_english = "Elizaveta Pobedinskaya\nAlina Khusainova\nSophia Shishatskaya\nLika",
    names_translated = "Елизавета Побединская\nАлина Хусаинова\nСофия Шишацкая\nЛика",
}

t[3] = {
    title_english = "Translation by",
    title_translated = "Перевод осуществлён",
    names_english = "Aleksandr \"Crystalwarrior\" Varnavskii\nGigalomaniac\nSvetlana Volkova\nValeria Tsyganova",
    names_translated = "Александр \"Crystalwarrior\" Варнавский\nGigalomaniac\nСветлана Волкова\nВалерия Цыганова",
}

t[4] = {
    title_english = "Graphics Localization",
    title_translated = "Локализация Графики",
    names_english = "Aleksandr \"Crystalwarrior\" Varnavskii",
    names_translated = "Александр \"Crystalwarrior\" Варнавский",
}

t[5] = {
    title_english = "Extra programming",
    title_translated = "Дополнительное программирование",
    names_english = "Aleksandr \"Crystalwarrior\" Varnavskii",
    names_translated = "Александр \"Crystalwarrior\" Варнавский",
}

return t
