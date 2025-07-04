-- ************************************
-- ** pyflowenv/text/messages_fr.lua **
-- ************************************

return {

  errors = {
    failed_record_changes = " ❌ Impossible d’enregistrer les modifications",
    no_encode_json = " ❌ Échec de l'encodage JSON",
    no_path = "❌ Chemin invalide ou introuvable",
    no_project_saved = "📭 Aucun projet enregistré",
    no_repertory = " ❌ Aucun dossier sélectionné.",
    no_save_file = " ❌ Impossible de créer list_projects.json",
    no_file_browser = " ❌ telescope-file-browser.nvim n'est pas chargé",
    no_project_name = "  ❌ Aucun nom de projet saisi.",
    no_telescope = " ❌ Telescope n'a pas été trouvé",
    no_write_in_json = " ❌ Erreur d'écriture dans 'list_projects.json'",
    not_main = "  ❌ Impossible de créer main.py",
    dir_exists = "  Le répertoire existe déjà.",
    mkdir_failed = "  ❌ Erreur : impossible de créer le répertoire.",
    venv_failed = "  ❌ Erreur création environnement virtuel.",
    git_failed = "  ❌ Impossible d'initialiser Git.",
    git_commit_failed = "  ❌ Échec du commit initial. Avez-vous configuré Git ?",
    gitignore_failed = "  ❌ Erreur création du .gitignore.",
  },

  success = {
    dir_created = function(path) return string.format("  📂 Répertoire créé : %s", path) end,
    main_created = "  ✅ main.py créé.",
    readme_created = "  ✅ README.md créé.",
    venv_created = "  ✅ Environnement virtuel créé.",
    gitignore_created = "  ✅ Fichier .gitignore créé.",
    git_initialized = "  ✅ Dépôt Git initialisé.",
    git_local = function(msg) return string.format("  ✅ Commit réalisé : « %s »", msg) end,
    project_added = function(name) return string.format("  ✅ Projet « %s » ajouté à la liste.", name) end,
    project_created = function(name) return string.format("  ✅ Projet « %s » créé.", name) end,
  },

  ui = {
    cancelled = "  Abandon 'Création de projet'",
    delete_project = "❗ Supprimer le projet '",
    press_q = "  [q] pour quitter...",
    prompt = "  🐍 Nom du projet : ",
    rep_choice = "📁 Choisir un répertoire de destination",
    select_existing_folder = " Sélectionner un projet existaht ",
    title_projects_list = " Projets enregistrés ",
    title_ui = " Création d'un projet Python ",
    ui_menu = " [q] quitter, [o] ouvrir, [d] supprimer, [a] ajouter projet existant",
    waiting = "  ⏳ Veuillez patienter pendant la création du projet...",
    yes_no = "&Oui\n&Non",
  },

  time = {
    now = "à l'instant",
    minutes = "il y a %d minutes",
    hours = "il y a %d heures",
    days = "il y a %d jours",
    months = "il y a %d mois",
    years = "il y a %d ans",
  },

}

