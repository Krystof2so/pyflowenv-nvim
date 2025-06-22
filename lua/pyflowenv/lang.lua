-- ***********************************************
-- ** pyflowenv/lang.lua                        **
-- ** ----------------------------------------- **
-- ** - Gère la langue des messages affichés.   **
-- ** - Langue configurable dynamiquement.      **
-- ***********************************************

local M = {}

-- Langue par défaut
local current_lang = "fr"

-- Table de correspondance langue → module
local map = {
  fr = "pyflowenv.text.messages_fr",
  es = "pyflowenv.text.messages_es",
}

--- Définit la langue à utiliser.
---@param lang string Langue au format "fr", "es", etc.
function M.setup(lang)
  if type(lang) == "string" and map[lang] then
    current_lang = lang
  else
    vim.notify(
      "[pyflowenv] Langue inconnue. Utilisation du français par défaut.",
      vim.log.levels.WARN
    )
    current_lang = "fr"
  end
end

--- Récupère les messages traduits pour la langue courante.
---@return table
function M.get()
  local ok, messages = pcall(require, map[current_lang] or map.fr)
  if not ok then
    vim.notify(
      "[pyflowenv] Erreur de chargement des messages. Repli sur le français.",
      vim.log.levels.WARN
    )
    messages = require("pyflowenv.text.messages_fr")
  end
  return messages
end

return M

