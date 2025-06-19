-- ****************
-- *** init.lua ***
-- ****************

---@diagnostic disable: undefined-field

local M = {}
local utils = require("pyflowenv.utils")
local ui = require("pyflowenv.ui.ui_init")
local lang = require("pyflowenv.lang").get()


-- Configuration utilisateur (optionnelle)
function M.setup(opts)
  opts = opts or {}
  local defaults = {
    venv_dir = ".venv",
    lang = "fr",
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

  ui.append_lines(buf, { lang.ui.prompt .. project_name })

  -- Création répertoire si nécessaire
  if dir_exists(project_dir) then
    ui.append_lines(buf, { lang.errors.dir_exists, "", lang.ui.press_q })
    return
  else
    local mkdir_success = vim.fn.mkdir(project_dir, "p")
    if mkdir_success ~= 1 then
        ui.append_lines(buf, { lang.errors.mkdir_failed, "", lang.ui.press_q })
        return
    else
        ui.append_lines(buf, { lang.success.dir_created(project_dir) })
    end
  end

  local venv_dir = ".venv"
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  local return_code = utils.check_run_in_shell(venv_cmd)  -- Exécution de la commande de création de l'environnement virtuel
  if not return_code then  -- Vérifie si la commande a rnussi
    ui.append_lines(buf, { lang.errors.venv_failed, "", lang.ui.press_q })
    return
  else
    ui.append_lines(buf, { lang.success.venv_created })
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
    ui.append_lines(buf, { lang.success.gitignore_created })
  else
    ui.append_lines(buf, { lang.errors.gitignore_failed, "", lang.ui.press_q })
    return
  end

  ui.append_lines(buf, {
    "", lang.success.project_created(project_name),
    "", lang.ui.press_q
  })
end

-- Commande utilisateur :CreatePythonVenv
vim.api.nvim_create_user_command("CreatePythonVenv", function()
  ui.create_popup_with_input(function(project_name, buf)
    if not project_name or project_name == "" then
      ui.append_lines(buf, {
                lang.errors.no_project_name, "",
                lang.ui.cancelled, "",
                "", lang.ui.press_q
      })
      return
    end
    M.create_python_project(project_name, buf)
  end)
end, {})

return M
