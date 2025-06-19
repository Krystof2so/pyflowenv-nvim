-- *************************************
-- ** pyflowenv/utils.lua             **
-- ** ------------------------------- **
-- ** - Fonctions génériques liées :  **
-- ** - Exécution de commandes shell. **
-- *************************************


local M = {}

function M.check_run_in_shell(cmd)
  vim.fn.system(cmd)
  local success = vim.v.shell_error == 0
  return success
end

return M

