-- ***************************************
-- ** pyflowenv/utils.lua               **
-- ** --------------------------------- **
-- ** FR : Fonctions génériques liées : **
-- ** - Exécution de commandes shell.   **
-- ** --------------------------------- **
-- ** EN : Related generic functions:   **
-- ** - Shell command execution.        **
-- ***************************************


local M = {}


-- *********************************
-- * Function check_run_in_shell() *
-- *********************************
-- FR : Prend en paramètre une commande shell ('cmd')
-- EN : Takes a shell command (‘cmd’) as a parameter
function M.check_run_in_shell(cmd)
  vim.fn.system(cmd)  -- executes the command.
  local success = vim.v.shell_error == 0  -- checks whether the execution was successful
  return success
end


return M
