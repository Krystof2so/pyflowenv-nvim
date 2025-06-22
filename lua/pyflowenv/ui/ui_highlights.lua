-- *******************************************************
-- ** lua/pyflowenv/ui/ui_highlights.lua                **
-- ** ------------------------------------------------- **
-- ** FR : Surbrillances.                               **
-- ** - Table centralisée pour les couleurs par défaut. **
-- ** ------------------------------------------------- **
-- ** EN : Highlights.                                  **
-- ** - Centralized table for default colors.           **
-- *******************************************************


local M = {}

-- FR : Table des groupes de surbrillance par défaut
-- EN : Table of default highlight groups
M.highlight_defaults = {
  FloatBorder = { name = "CustomBlueBorder", opts = { fg = "#5E81AC" } },
  FloatTitle  = { name = "CustomYellowTitle", opts = { fg = "#EBCB8B", bold = true } },
}


-- ******************************
-- * Function setup_ui_colors() *
-- ******************************
-- FR : Fonction pour appliquer tous les groupes de surbrillance
-- EN : Function to apply all highlight groups
function M.setup_ui_colors()
  for _, group in pairs(M.highlight_defaults) do
    vim.api.nvim_set_hl(0, group.name, group.opts)
  end
end


-- *******************************
-- * Function get_winhl_string() *
-- *******************************
-- FR : Renvoie la chaîne de configuration winhl à appliquer à une fenêtre
-- EN : Returns the winhl configuration string to apply to a window
function M.get_winhl_string()
  return string.format(
    "Normal:Normal,FloatBorder:%s,FloatTitle:%s",
    M.highlight_defaults.FloatBorder.name,
    M.highlight_defaults.FloatTitle.name
  )
end


return M
