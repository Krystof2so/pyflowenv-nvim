-- *******************************************************
-- ** pyflowenv/ui/ui_highlights.lua                    **
-- ** --------------------------------------------------**
-- ** - Surbrillances.                                  **
-- ** - Table centralisée pour les couleurs par défaut. **
-- *******************************************************

local M = {}

-- Table des groupes de surbrillance par défaut
M.highlight_defaults = {
  FloatBorder = { name = "CustomBlueBorder", opts = { fg = "#5E81AC" } },
  FloatTitle  = { name = "CustomYellowTitle", opts = { fg = "#EBCB8B", bold = true } },
}

-- Fonction pour appliquer tous les groupes de surbrillance
function M.setup_ui_colors()
  for _, group in pairs(M.highlight_defaults) do
    vim.api.nvim_set_hl(0, group.name, group.opts)
  end
end

-- Renvoie la chaîne de configuration winhl à appliquer à une fenêtre
function M.get_winhl_string()
  return string.format(
    "Normal:Normal,FloatBorder:%s,FloatTitle:%s",
    M.highlight_defaults.FloatBorder.name,
    M.highlight_defaults.FloatTitle.name
  )
end

return M



