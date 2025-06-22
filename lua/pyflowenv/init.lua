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


-- FR : Chargement des modules
-- EN : Loading modules
local M = {}
local ui = require("pyflowenv.ui.ui_init")
local lang_module = require("pyflowenv.lang")
local creator = require("pyflowenv.creator.project_creator")


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
      local lang = lang_module.get()
      ui.append_lines(buf, {
        lang.errors.no_project_name,
        "",
        lang.ui.cancelled,
        "",
        lang.ui.press_q,
      })
      return
    end

    -- Lancement de la création du projet
    creator.create_python_project(project_name, buf, M.options)
  end)
end, {})

return M
