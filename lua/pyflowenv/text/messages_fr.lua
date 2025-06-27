-- ************************************
-- ** pyflowenv/text/messages_fr.lua **
-- ************************************

return {
  errors = {
    no_file_browser = " ❌ telescope-file-browser.nvim n'est pas chargé",
    no_project_name = "  ❌ Aucun nom de projet saisi.",
    no_telescope = " ❌ Telescope n'a pas été trouvé",
    dir_exists = "  Le répertoire existe déjà.",
    mkdir_failed = "  ❌ Erreur : impossible de créer le répertoire.",
    venv_failed = "  ❌ Erreur création environnement virtuel.",
    git_failed = "  ❌ Impossible d'initialiser Git.",
    git_commit_failed = "  ❌ Échec du commit initial. Avez-vous configuré Git ?",
    gitignore_failed = "  ❌ Erreur création du .gitignore.",
  },
  success = {
    dir_created = function(path) return "  📂 Répertoire créé : " .. path end,
    venv_created = "  ✅ Environnement virtuel créé.",
    gitignore_created = "  ✅ Fichier .gitignore créé.",
    git_initialized = "  ✅ Dépôt Git initialisé.",
    git_local = function(msg) return "  ✅ Commit réalisé : « " .. msg .. " »" end,
    project_created = function(name) return "  ✅ Projet '" .. name .. "' créé." end,
  },
  ui = {
    cancelled = "  Abandon 'Création de projet'",
    press_q = "  [q] pour quitter...",
    prompt = "  🐍 Nom du projet : ",
    rep_choice = "📁 Choisir un répertoire de destination",
    title_ui = " Création d'un projet Python ",
    waiting = "  ⏳ Veuillez patienter pendant la création du projet...",
  },
}

