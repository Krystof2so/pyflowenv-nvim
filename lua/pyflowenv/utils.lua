-- ***************************************
-- ** pyflowenv/utils.lua               **
-- ** --------------------------------- **
-- ** FR : Fonctions utilitaires        **
-- ** - Exécution de commandes shell    **
-- ** - Fonctions de fichiers et texte  **
-- ** --------------------------------- **
-- ** EN : Utility functions            **
-- ** - Shell command execution         **
-- ** - File and text helpers           **
-- ***************************************

local M = {}
local lang = require("pyflowenv.lang").get()


-- *********************************
-- * Function check_run_in_shell() *
-- *********************************
-- FR : Exécute une commande shell et retourne un booléen selon le succès
-- EN : Execute a shell command and return a boolean based on success
---@param cmd string
---@return boolean
function M.check_run_in_shell(cmd)
  vim.fn.system(cmd)  -- executes the command.
  local success = vim.v.shell_error == 0  -- checks whether the execution was successful
  return success
end


-- *************************
-- * Text : is_empty()     *
-- *************************
-- FR : Vérifie si une chaîne est vide ou nil
-- EN : Checks if a string is empty or nil
---@param str string|nil
---@return boolean
function M.is_empty(str)
  return str == nil or str == ""
end


-- ************************************
-- * File : ensure_project_list_file() *
-- ************************************
-- FR : Vérifie et crée le fichier JSON de projets s’il n’existe pas
-- EN : Check and create the project JSON file if it does not exist
function M.ensure_project_list_file()
  local config_dir = vim.fn.expand("~/.config/pyflowenv")
  local file_path = config_dir .. "/list_projects.json"

  -- FR : Création du répertoire ~/.config/pyflowenv s’il n’existe pas
  -- EN : Creation of the directory ~/. config/pyflowenv if it does not exist
  if vim.fn.isdirectory(config_dir) == 0 then
    vim.fn.mkdir(config_dir, "p")
  end

  -- FR : Création du fichier vide si inexistant
  -- EN : Creation of the empty file if non-existent
  if vim.fn.filereadable(file_path) == 0 then
    local file = io.open(file_path, "w")
    if file then
      file:write("[]") -- empty JSON array
      file:close()
    else
      vim.notify(lang.errors.no_save_file, vim.log.levels.ERROR)
    end
  end
end


return M
