-- *********************************************************************
-- ** lua/pyflowenv/init.lua                                          **
-- ** --------------------------------------------------------------- **
-- ** FR : Ce fichier expose l’API publique, configure les options,   **
-- ** crée les commandes utilisateur, et contient la logique          **
-- ** principale du plugin.                                           **
-- ** --------------------------------------------------------------- **
-- ** EN: This file exposes the public API, configures the options,   **
-- ** creates the user commands, and contains the logic main plugin.  **
-- *********************************************************************


-- FR : Chargement des modules
-- EN : Loading modules
local M = {}
local utils = require("pyflowenv.utils")
local ui = require("pyflowenv.ui.ui_init")
local ui_utils = require("pyflowenv.ui.ui_utils")
local picker = require("pyflowenv.ui.ui_telescope_picker")
local lang_module = require("pyflowenv.lang")
local creator = require("pyflowenv.creator.project_creator")
local manager = require("pyflowenv.manage_projects")


-- *******************************
-- * Default options and setup() *
-- *******************************
-- FR : Permet à l'utilisateur de surcharger la configuration via require("pyflowenv").setup({...})
-- EN : Allows the user to override the configuration via require(“pyflowenv”).setup({...})
---@class PyflowOptions
---@field venv_dir string Name of the virtual environment folder
---@field lang "fr"|"en"|"es" interface language

---@type PyflowOptions
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


-- **********************************************************
-- * Project creation                                       *
-- * ------------------------------------------------------ *
-- * FR :                                                   *
-- * - Initialisation du fichier JSON des projets.          *
-- * - Sélection interactive du répertoire (via Telescope). *
-- * - Saisie du nom via popup.                             *
-- * - Création du projet physique (structure).             *
-- * - Sauvegarde dans le fichier JSON.                     *
-- * ------------------------------------------------------ *
-- * EN :                                                   *         
-- * - Initialization of the JSON file of projects.         *
-- * - Interactive directory selection (via Telescope).     *
-- * - Enter the name via popup.                            *
-- * - Creation of the physical project (structure).        *
-- * - Save in JSON file.                                   *
-- **********************************************************
function M.create_project()
  local lang = lang_module.get()
  utils.ensure_project_list_file()

  local function on_project_name_entered(project_name, buf, target_dir)
    if utils.is_empty(project_name) then
      ui.append_lines(buf, {
        lang.errors.no_project_name,
        "",
        lang.ui.cancelled,
        "",
        lang.ui.press_q,
      })
      return
    end

    local full_path = vim.fs.joinpath(target_dir, project_name)
    local ok = creator.create_python_project(full_path, project_name, buf, M.options)
    if ok then
      manager.save_project(project_name, full_path)
    end
  end

  local function on_directory_selected(target_dir)
    if utils.is_empty(target_dir) then
      ui_utils.notify(lang.errors.no_directory, vim.log.levels.WARN)
      return
    end

    ui.create_popup_with_input(function(project_name, buf)
      on_project_name_entered(project_name, buf, target_dir)
    end)
  end

  picker.select_directory(on_directory_selected)
end


-- *******************
-- * Manage projects *
-- *******************
function M.manage_projects()
  manager.show_project_list()
end


-- *****************
-- * User commands *
-- *****************
vim.api.nvim_create_user_command("PyflowCreate", M.create_project, {})
vim.api.nvim_create_user_command("PyflowManage", M.manage_projects, {})


return M
