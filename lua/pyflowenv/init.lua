-- *********************
-- *** init.lua (plugin principal) ***
-- *********************

---@diagnostic disable: undefined-field

local M = {}
local ui = require("pyflowenv.ui")

-- Configuration utilisateur (optionnelle)
function M.setup(opts)
  opts = opts or {}
  local defaults = {
    venv_dir = ".venv",
  }

  M.options = vim.tbl_deep_extend("force", defaults, opts)
end

-- Vérifie si un dossier existe
local function dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

-- Création du projet Python avec venv
function M.create_python_project(project_name, buf)
  local current_dir = vim.fn.getcwd()
  local project_dir = current_dir .. "/" .. project_name

  ui.append_lines(buf, {
    "📁 Projet : " .. project_name,
    "📦 Initialisation de l'environnement virtuel...",
  })

  -- Création répertoire si nécessaire
  if not dir_exists(project_dir) then
    local mkdir_success = vim.fn.mkdir(project_dir, "p")
    if mkdir_success ~= 1 then
      ui.append_lines(buf, { "❌ Erreur : impossible de créer le répertoire." })
      return
    else
      ui.append_lines(buf, { "📂 Répertoire créé : " .. project_dir })
    end
  else
    ui.append_lines(buf, { "🗂️ Le répertoire existe déjà." })
  end

  local venv_dir = ".venv"
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  vim.fn.system(venv_cmd)  -- Exécution de la commande de création de l'environnement virtuel
  if vim.v.shell_error ~= 0 then  -- Vérifie si la commande a réussi
    ui.append_lines(buf, { "❌ Erreur création environnement virtuel." })
    return
  else
    ui.append_lines(buf, { "✅ Environnement virtuel créé." })
  end

  local gitignore_path = project_dir .. "/.gitignore"
  local content = [[
]] .. venv_dir .. [[
__pycache__/
*.log
*.cache
*.csv
*.json
*.sqlite
*.db
]]

  local f = io.open(gitignore_path, "w")
  if f then
    f:write(content)
    f:close()
    ui.append_lines(buf, { "✅ Fichier .gitignore créé." })
  else
    ui.append_lines(buf, { "❌ Erreur création du .gitignore." })
    return
  end

  ui.append_lines(buf, {
    "",
    "✅ Projet créé : " .. project_dir,
    "",
    "Appuyez sur 'q' pour quitter cette fenêtre."
  })
end

-- Commande utilisateur :CreatePythonVenv
vim.api.nvim_create_user_command("CreatePythonVenv", function()
  ui.create_popup_with_input(function(project_name, buf)
    if not project_name or project_name == "" then
      ui.append_lines(buf, { "❌ Aucun nom saisi." })
      return
    end
    M.create_python_project(project_name, buf)
  end)
end, {})

return M
