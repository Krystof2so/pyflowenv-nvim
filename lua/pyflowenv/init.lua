-- ****************
-- *** init.lua ***
-- ****************

---@diagnostic disable: undefined-field

local M = {}
local ui = require("pyflowenv.ui.ui_init")


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

  ui.append_lines(buf, { "  🐍 Nom du projet à créer : " .. project_name })

  -- Création répertoire si nécessaire
  if dir_exists(project_dir) then
    ui.append_lines(buf, { "  Le répertoire existe déjà.", "", "  [q] pour quitter..." })
    return
  else
    local mkdir_success = vim.fn.mkdir(project_dir, "p")
    if mkdir_success ~= 1 then
        ui.append_lines(buf, { "  ❌ Erreur : Impossible de créer le répertoire.", "", "  [q] pour quitter..." })
        return
    else
        ui.append_lines(buf, { "", "  📂 Répertoire créé : " .. project_dir })
    end
  end

  local venv_dir = ".venv"
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  vim.fn.system(venv_cmd)  -- Exécution de la commande de création de l'environnement virtuel
  if vim.v.shell_error ~= 0 then  -- Vérifie si la commande a réussi
    ui.append_lines(buf, { "  ❌ Erreur création environnement virtuel.", "", "  [q] pour quitter..." })
    return
  else
    ui.append_lines(buf, { "  ✅ Environnement virtuel créé." })
  end

  local gitignore_path = project_dir .. "/.gitignore"
  local content = [[
# Environnement virtuel :
]] .. venv_dir .. [[

# Fichiers Python compilés :
__pycache__/

# Fichiers de cache et de logs :
*.log
*.cache

# Fichiers de données :
*.csv
*.json
*.sqlite
*.db
]]

  local f = io.open(gitignore_path, "w")
  if f then
    f:write(content)
    f:close()
    ui.append_lines(buf, { "  ✅ Fichier .gitignore créé." })
  else
    ui.append_lines(buf, { "  ❌ Erreur création du .gitignore.", "", "  [q] pour quitter..." })
    return
  end

  ui.append_lines(buf, {
    "", "  ✅ Projet '" .. project_name .. "' créé.",
    "", "  [q] pour quitter..."
  })
end

-- Commande utilisateur :CreatePythonVenv
vim.api.nvim_create_user_command("CreatePythonVenv", function()
  ui.create_popup_with_input(function(project_name, buf)
    if not project_name or project_name == "" then
      ui.append_lines(buf, {
                "  ❌ Aucun nom de projet saisi.", "",
                "     Abandon 'Création de projet'", "",
                "", "  [q] pour quitter..."
      })
      return
    end
    M.create_python_project(project_name, buf)
  end)
end, {})

return M
