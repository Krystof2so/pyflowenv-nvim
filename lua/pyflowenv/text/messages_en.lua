-- ************************************
-- ** pyflowenv/text/messages_en.lua **
-- ************************************

return {
  errors = {
    not_fd = "❌ 'fd' is required to list directories",
    no_project_name = "  ❌ No project name provided.",
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
    project_created = function(name) return "  ✅ Project '" .. name .. "' created." end,
  },
  ui = {
    cancelled = "  Project creation cancelled.",
    press_q = "  [q] to quit...",
    prompt = "  🐍 Project name: ",
    rep_choice = "📁 Select a destination directory",
    title_ui = " Python Project Creation ",
    waiting = "  ⏳ Please wait while the project is being created...",
  },
}

