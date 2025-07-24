-- *****************************************************************************
-- ** lua/pyflowenv/lang.lua                                                  **
-- ** ----------------------------------------------------------------------- **
-- ** FR : Ce module est responsable de gérer la langue des messages affiché. **
-- ** Il permet de également de configurer dynamiquement la langue utilisée   **
-- ** et de récupérer les textes traduits correspondants.                     **
-- ** ----------------------------------------------------------------------- **
-- ** EN : This module is responsible for managing the language of the        **
-- ** messages displayed. It also allows you to dynamically configure the     **
-- ** language used and retrieve the corresponding translated texts.          **
-- *****************************************************************************

-- FR : Table locale M qui contiendra les fonctions exportées du module.
-- EN : Local table M that will contain the exported functions of the module.
local M = {}

-- FR : Langues disponibles et leurs modules de message
-- EN : Available languages and their message modules
local LANG_MAP = {
  fr = "pyflowenv.text.messages_fr",
  en = "pyflowenv.text.messages_en",
  es = "pyflowenv.text.messages_es",
}

---@type string
M.current_lang = "fr" -- by default

-- ******************
-- * Setup language *
-- ******************
-- FR : Définit la langue courante que le plugin doit utiliser.
-- EN : Sets the default language that the plugin should use.
---@param lang string Langue au format "fr", "es", etc.
function M.setup(lang)
  if LANG_MAP[lang] then
    M.current_lang = lang -- if check type --> update 'current lang'
  else
    vim.notify( -- Otherwise: displays a warning notification
      "[pyflowenv] Langue inconnue. Utilisation du français par défaut.\n[pyflowenv] Unknown language. Defaulting to French.",
      vim.log.levels.WARN
    )
    M.current_lang = "fr" -- Default language
  end
end

-- ******************
-- * Function get() *
-- ******************
-- FR : Retourner la table des messages traduits
-- EN : Return translated messages table
---@return table
function M.get()
  local module_path = LANG_MAP[M.current_lang] or LANG_MAP.fr
  local ok, messages = pcall(require, module_path)
  if not ok then -- if loading fails
    vim.notify(
      "[pyflowenv] Erreur de chargement des messages. Repli sur le français.\n[pyflowenv] Failed to load translations. Falling back to French.",
      vim.log.levels.WARN
    )
    messages = require "pyflowenv.text.messages_fr"
  end
  return messages -- Returns the message table
end

return M
