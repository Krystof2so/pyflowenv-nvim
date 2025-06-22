-- *********************************************************************
-- ** lua/pyflowenv/init.lua                                          **
-- ** --------------------------------------------------------------- **
-- ** FR : Ce fichier expose l’API publique, configure les options,   **
-- ** crée la commande utilisateur, et contient la logique principale **
-- ** de création du projet Python.                                   **
-- ** --------------------------------------------------------------- **
-- ** EN : This file exposes the public API, configures options,      **
-- ** creates the user command, and contains the main logic for       **
-- ** creating the Python project.                                    **
-- *********************************************************************

-- FR : Eviter les faux positifs du Language Server Protocol : 'vim.loop.fs_stat'.
-- EN : Avoiding false positives in the Language Server Protocol: ‘vim.loop.fs_stat’.
---@diagnostic disable: undefined-field

-- FR : Chargement des modules
-- EN : Loading modules
local M = {}
local utils = require("pyflowenv.utils")
local ui = require("pyflowenv.ui.ui_init")
local lang_module = require("pyflowenv.lang")
local gitignore_template = require("pyflowenv.templates.file_gitignore")


-- *******************************
-- * Default options and setup() *
-- *******************************
-- FR : Permet à l'utilisateur de surcharger la configuration via require("pyflowenv").setup({...})
-- EN : Allows the user to override the configuration via require(“pyflowenv”).setup({...})
M.options = {
  venv_dir = ".venv",
  lang = "fr",
}

-- FR : Setup utilisateur
-- EN : User setup
function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})

  -- FR : Configuration de la langue (doit être appelée ici pour que get() reflète la bonne langue).
  -- EN : Language configuration (must be called here for get() to reflect the correct language).
  lang_module.setup(M.options.lang)
end


-- ***************************************
-- * Integration of internationalization *
-- ***************************************
-- FR : Récupère la langue actuelle (à utiliser après setup())
-- EN : Retrieves the current language (to be used after setup())
local lang = lang_module.get()


-- *************************
-- * Function 'dir_exists' *
-- *************************
local function dir_exists(path)
  local stat = vim.loop.fs_stat(path)  -- 'vim.loop' for check if directory exists
  return stat and stat.type == "directory"
end


-- ************************************
-- * Function 'create_python_project' *
-- ************************************
-- FR : Cette fonction réalise toute la logique de création du projet, de façon séquentielle.
-- EN : This function performs all the logic for creating the project sequentially.
function M.create_python_project(project_name, buf)

  -- FR : Initialisation des chemins pour le projet.
  -- EN : Initializing paths for the project.
  local venv_dir = M.options.venv_dir or ".venv"
  local current_dir = vim.fn.getcwd()
  local project_dir = current_dir .. "/" .. project_name

  -- FR : Vérifie si le répertoire existe déjà.
  -- EN : Check if the directory already exists.
  if dir_exists(project_dir) then
    ui.append_lines(buf, { "", lang.errors.dir_exists, "", lang.ui.press_q })
    return
  end

  -- FR : Création répertoire du projet.
  -- EN : Creating a project directory.
  local mkdir_success = vim.fn.mkdir(project_dir, "p")
  if mkdir_success ~= 1 then
    ui.append_lines(buf, { "", lang.errors.mkdir_failed, "", lang.ui.press_q })
    return
  end
  ui.append_lines(buf, { lang.success.dir_created(project_dir) })

  -- FR : Création de l'environnement virtuel.
  -- EN : Creating the virtual environment.
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  local ok = utils.check_run_in_shell(venv_cmd)
  if not ok then
    ui.append_lines(buf, { "", lang.errors.venv_failed, "", lang.ui.press_q })
    return
  end
  ui.append_lines(buf, { lang.success.venv_created })

  -- FR : Création du fichier '.gitignore'.
  -- EN : Creating file '.gitignore'
  local gitignore_path = project_dir .. "/.gitignore"
  local f = io.open(gitignore_path, "w")
  if not f then
    ui.append_lines(buf, { "", lang.errors.gitignore_failed, "", lang.ui.press_q })
    return
  end
  f:write(gitignore_template.default_gitignore(venv_dir))
  f:close()
  ui.append_lines(buf, { lang.success.gitignore_created })

 -- FR : Affichage du message final dans le buffer.
 -- EN : Displaying the final message in the buffer.
  ui.append_lines(buf, {
    "",
    lang.success.project_created(project_name),
    "",
    lang.ui.press_q,
  })
end


-- ****************
-- * User command *
-- ****************
-- FR : Utilisation de l'API de Neovim.
-- EN : Using the Neovim API.
vim.api.nvim_create_user_command("CreatePythonVenv", function()

  -- FR : Création popup avec saisie + affichage résultat dans même buffer.
  -- EN : Popup creation with input + result display in the same buffer.
  ui.create_popup_with_input(function(project_name, buf)
    if not project_name or project_name == "" then
      ui.append_lines(buf, {
        lang.errors.no_project_name,
        "",
        lang.ui.cancelled,
        "",
        lang.ui.press_q,
      })
      return
    end

    M.create_python_project(project_name, buf)
  end)
end, {})


return M

