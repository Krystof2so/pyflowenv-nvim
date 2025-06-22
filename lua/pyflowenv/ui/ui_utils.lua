-- ***************************************************************
-- ** pyflowenv/ui/ui_utils.lua                                 **
-- ** --------------------------------------------------------- **
-- ** FR : Fonctions génériques liées à l'UI :                  **
-- ** - Calcul des dimensions, ouverture de fenêtres, style...  **
-- ** --------------------------------------------------------- **
-- ** EN : Generic UI-related functions:                        **
-- ** - Calculating dimensions, opening windows, styling, etc.  **
-- ***************************************************************


local M = {}
local hl = require("pyflowenv.ui.ui_highlights")


-- **********************************
-- * Function get_centered_coords() *
-- **********************************
-- FR : Calcule la position pour centrer une fenêtre
-- EN : Calculates the position to center a window
function M.get_centered_coords(width, height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return row, col
end


-- ****************************
-- * Function create_window() *
-- ****************************
-- FR : Crée une fenêtre flottante avec options personnalisées
-- EN : Creates a floating window with custom options
function M.create_window(buf, opts)
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = opts.width,
    height = opts.height,
    row = opts.row,
    col = opts.col,
    style = "minimal",
    border = opts.border or "rounded",
    title = opts.title or "",
    title_pos = opts.title_pos or "center",
  })

  -- FR : Applique le style défini dans le module de surbrillance
  -- EN : Applies the style defined in the highlight module
  vim.api.nvim_set_option_value("winhl", hl.get_winhl_string(), { win = win })

  return win
end


return M

