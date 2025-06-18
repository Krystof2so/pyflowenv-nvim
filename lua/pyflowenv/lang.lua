-- *************************************
-- ** pyflowenv/lang.lua              **
-- ** ------------------------------- **
-- ** - Permet le choix de la langue. **
-- *************************************

local M = {}

-- Langue par défaut (choix à prévoir via le 'setup()') :
local current_lang = "fr"

local map = {
  fr = "pyflowenv.text.messages_fr",
  es = "pyflowenv.text.messages_es",
}

--- Récupère les messages dans la langue choisie :
function M.get()
  local ok, messages = pcall(require, map[current_lang] or map.fr)
  if not ok then
    vim.notify("[pyflowenv] Langue invalide ou fichier manquant. Repli sur le français.", vim.log.levels.WARN)
    messages = require("pyflowenv.text.messages_fr")
  end
  return messages
end

return M
