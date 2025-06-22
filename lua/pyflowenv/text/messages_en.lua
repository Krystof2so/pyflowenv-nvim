-- ************************************
-- ** pyflowenv/text/messages_en.lua **
-- ************************************

return {
  errors = {
    no_project_name = "  ❌ No project name provided.",
    dir_exists = "  The directory already exists.",
    mkdir_failed = "  ❌ Error: failed to create the directory.",
    venv_failed = "  ❌ Error creating virtual environment.",
    gitignore_failed = "  ❌ Error creating .gitignore file.",
  },
  success = {
    dir_created = function(path) return "  📂 Directory created: " .. path end,
    venv_created = "  ✅ Virtual environment created.",
    gitignore_created = "  ✅ .gitignore file created.",
    project_created = function(name) return "  ✅ Project '" .. name .. "' created." end,
  },
  ui = {
    cancelled = "  Project creation cancelled.",
    press_q = "  [q] to quit...",
    prompt = "  🐍 Project name: ",
    title_ui = " Python Project Creation ",
    waiting = "  ⏳ Please wait while the project is being created...",
  },
}

