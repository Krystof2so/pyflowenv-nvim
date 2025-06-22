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

local current_lang = "fr"  -- Default language

-- FR : Table de correspondance langue → module
-- EN : Language → module correspondence table
local map = {
  fr = "pyflowenv.text.messages_fr",
  en = "pyflowenv.text.messages_en",
  es = "pyflowenv.text.messages_es",
}


-- ********************
-- * Function setup() *
-- ********************
-- FR : Définit la langue courante que le plugin doit utiliser.
-- EN : Sets the default language that the plugin should use.
---@param lang string Langue au format "fr", "es", etc.
function M.setup(lang)
  if type(lang) == "string" and map[lang] then
    current_lang = lang  -- if check type --> update 'current lang'
  else
    vim.notify( -- Otherwise: displays a warning notification
      "[pyflowenv] Langue inconnue. Utilisation du français par défaut.",
      vim.log.levels.WARN
    )
    current_lang = "fr"  -- Default language
  end
end


--- FR : Récupère les messages traduits pour la langue courante.
--- EN : Retrieves the messages translated for the current language.
---@return table


-- ******************
-- * Function get() *
-- ******************
-- FR : Utilise 'pcall(require, module_name)' pour tenter de charger le module de messages lié à 'current_lang'.
-- EN : Use 'pcall(require, module_name)' to attempt to load the message module associated with 'current_lang'.
function M.get()
  local ok, messages = pcall(require, map[current_lang] or map.fr)
  if not ok then  -- if loading fails
    vim.notify(
      "[pyflowenv] Erreur de chargement des messages. Repli sur le français.",
      vim.log.levels.WARN
    )
    messages = require("pyflowenv.text.messages_fr")
  end
  return messages  -- Returns the message table
end


return M

