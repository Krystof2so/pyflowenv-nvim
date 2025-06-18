-- ***************************************************************
-- ** pyflowenv/ui/ui_utils.lua                                 **
-- ** --------------------------------------------------------- **
-- ** - Fonctions génériques liées à l'UI :                     **
-- ** - Calcul des dimensions, ouverture de fenêtres, style...  **
-- ***************************************************************

local M = {}

-- Applique des couleurs personnalisées
function M.set_window_highlights(win)
  vim.api.nvim_set_hl(0, 'CustomBlueBorder', { fg = '#5E81AC' })
  vim.api.nvim_set_hl(0, 'CustomYellowTitle', { fg = '#EBCB8B', bold = true })

  vim.api.nvim_set_option_value('winhl',
    'Normal:Normal,FloatBorder:CustomBlueBorder,FloatTitle:CustomYellowTitle',
    { win = win }
  )
end

-- Calcule la position pour centrer une fenêtre
function M.get_centered_coords(width, height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)
  return row, col
end

-- Crée une fenêtre flottante avec options personnalisées
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

  M.set_window_highlights(win)
  return win
end

return M

