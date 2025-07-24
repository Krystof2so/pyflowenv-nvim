-- *******************************************************
-- ** lua/pyflowenv/ui/ui_highlights.lua                **
-- ** ------------------------------------------------- **
-- ** fr : surbrillances.                               **
-- ** - table centralisée pour les couleurs par défaut. **
-- ** ------------------------------------------------- **
-- ** en : highlights.                                  **
-- ** - centralized table for default colors.           **
-- *******************************************************

local M = {}

-- FR : Nom des groupes logiques utilisés dans le plugin
-- EN : Name of the logical groups used in the plugin
M.keys = {
  float_border = "float_border",
  float_title = "float_title",
  project_name = "project_name",
}

-- fr : table des groupes de surbrillance par défaut
-- en : table of default highlight groups
M.highlight_defaults = {
  [M.keys.float_border] = {
    name = "customBlueborder", -- used for popup borders
    opts = { fg = "#5e81ac" },
  },
  [M.keys.float_title] = {
    name = "customYellowtitle", -- used for popup titles
    opts = { fg = "#ebcb8b", bold = true },
  },
  [M.keys.project_name] = {
    name = "projectNamegreen", -- used to highlight project names
    opts = { fg = "#a3be8c", bold = true },
  },
}

-- ******************************
-- * function setup_ui_colors() *
-- ******************************
-- fr : fonction pour appliquer tous les groupes de surbrillance
-- en : function to apply all highlight groups
---@param overrides table<string, table>?
function M.setup_ui_colors(overrides)
  overrides = overrides or {}
  for key, group in pairs(M.highlight_defaults) do
    local user_opts = overrides[key] or {}
    local merged_opts = vim.tbl_deep_extend("force", group.opts, user_opts)
    vim.api.nvim_set_hl(0, group.name, merged_opts)
  end
end

-- *******************************
-- * function get_winhl_string() *
-- *******************************
-- fr : renvoie la chaîne de configuration winhl à appliquer à une fenêtre
-- en : returns the winhl configuration string to apply to a window
function M.get_winhl_string()
  return string.format(
    "normal:normal,floatBorder:%s,floatTitle:%s",
    M.highlight_defaults[M.keys.float_border].name,
    M.highlight_defaults[M.keys.float_title].name
  )
end

return M
