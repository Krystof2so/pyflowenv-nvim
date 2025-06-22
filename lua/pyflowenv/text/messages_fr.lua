-- ************************************
-- ** pyflowenv/text/messages_fr.lua **
-- ************************************

return {
  errors = {
    no_project_name = "  ❌ Aucun nom de projet saisi.",
    dir_exists = "  Le répertoire existe déjà.",
    mkdir_failed = "  ❌ Erreur : impossible de créer le répertoire.",
    venv_failed = "  ❌ Erreur création environnement virtuel.",
    gitignore_failed = "  ❌ Erreur création du .gitignore.",
  },
  success = {
    dir_created = function(path) return "  📂 Répertoire créé : " .. path end,
    venv_created = "  ✅ Environnement virtuel créé.",
    gitignore_created = "  ✅ Fichier .gitignore créé.",
    project_created = function(name) return "  ✅ Projet '" .. name .. "' créé." end,
  },
  ui = {
    cancelled = "  Abandon 'Création de projet'",
    press_q = "  [q] pour quitter...",
    prompt = "  🐍 Nom du projet : ",
    title_ui = " Création d'un projet Python ",
    waiting = "  ⏳ Veuillez patienter pendant la création du projet...",
  },
}

