-- ************************************
-- ** pyflowenv/text/messages_en.lua **
-- ************************************

return {

  errors = {
    failed_record_changes = " ❌ Unable to save changes",
    no_encode_json = " ❌ JSON encoding failure",
    no_path = "❌ Path invalid or not found",
    no_project_saved = "📭 No project recorded",
    no_repertory = " ❌ No folder selected.",
    no_save_file = " ❌ Unable to create list_projects.json",
    no_file_browser = " ❌ telescope-file-browser.nvim not loaded",
    no_project_name = "  ❌ No project name provided.",
    no_telescope = "  ❌ Telescope not found",
    no_write_in_json = " ❌ Write error in 'list_projects.json'",
    not_main = "  ❌ Unable to create main.py",
    dir_exists = "  The directory already exists.",
    mkdir_failed = "  ❌ Error: failed to create the directory.",
    venv_failed = "  ❌ Error creating virtual environment.",
    git_failed = "  ❌ Failed to initialize Git.",
    git_commit_failed = "  ❌ Initial commit failed. Have you configured Git?",
    gitignore_failed = "  ❌ Error while creating .gitignore.",
  },

  success = {
    dir_created = function(path) return "  📂 Directory created: " .. path end,
    venv_created = "  ✅ Virtual environment created.",
    gitignore_created = "  ✅ .gitignore file created.",
    git_initialized = "  ✅ Git repository initialized.",
    git_local = function(msg) return "  ✅ Commit created: \"" .. msg .. "\"" end,
    main_created = "  ✅ main.py created.",
    readme_created = "  ✅ README.md created.",
    project_added = "Project '%s' added to the list",
    project_created = function(name) return "  ✅ Project '" .. name .. "' created." end,
  },

  ui = {
    cancelled = "  Project creation cancelled.",
    delete_project = "❗ Delete project '",
    press_q = "  [q] to quit...",
    prompt = "  🐍 Project name: ",
    rep_choice = "📁 Select a destination directory",
    select_existing_folder = "Select an existing folder",
    title_projects_list = " projects registered ",
    title_ui = " Python Project Creation ",
    ui_menu = " [q] quit, [o] open, [d] delete, [a] add existing project",
    waiting = "  ⏳ Please wait while the project is being created...",
    yes_no = "&Yes\n&No",
  },

  time = {
    now     = "just now",
    minutes = "%d minutes ago",
    hours   = "%d hours ago",
    days    = "%d days ago",
    months  = "%d months ago",
    years   = "%d years ago",
  },

}

