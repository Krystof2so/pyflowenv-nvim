-- *************************************************************************************
-- ** lua/pyflowenv/ui/ui_init.lua                                                    **
-- ** ------------------------------------------------------------------------------- **
-- ** FR : Ce module est le point d’entrée de l’interface utilisateur (UI) du plugin. **
-- ** Il gère :                                                                       **
-- ** - la création de fenêtres flottantes (popup),                                   **
-- ** - la saisie utilisateur dans un buffer,                                         **
-- ** - l’affichage dynamique de messages dans une interface dédiée.                  **
-- ** Il centralise la logique d’affichage.                                           **
-- ** ------------------------------------------------------------------------------- **
-- ** EN : This module is the entry point for the plugin's user interface (UI).       **
-- ** It manages:                                                                     **
-- ** - the creation of floating windows (popups),                                    **
-- ** - user input in a buffer,                                                       **
-- ** - the dynamic display of messages in a dedicated interface.                     **
-- ** It centralizes the display logic.                                               **
-- *************************************************************************************


-- ******************************
-- * Imports and initialization *
-- ******************************
local utils = require("pyflowenv.ui.ui_utils")
local highlights = require("pyflowenv.ui.ui_highlights")
local lang = require("pyflowenv.lang").get()
local M = {}


-- **************************************
-- * Function setup_buffer_and_window() *
-- **************************************
-- FR : Configure un buffer et une fenêtre nouvellement créés. Fonction d’initialisation générique.
-- EN : Configures a newly created buffer and window. Generic initialization function.
local function setup_buffer_and_window(buf, win, lines)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = true

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end, { buffer = buf, silent = true })
end


-- **********************************
-- * Function create_popup_window() *
-- **********************************
-- FR : Crée une  fenêtre flottante  (centrée, taille proportionnelle à la taille de l'écran, options visuelles).
-- EN : Creates a floating window (centered, size proportional to screen size, visual options).
local function create_popup_window(lines, opts)
  highlights.setup_ui_colors()  -- Configure colors
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * opts.width_factor)
  local height = math.max(opts.min_height, #lines + 2)
  local row, col = utils.get_centered_coords(width, height)
  local win = utils.create_window(buf, {  -- Call 'utils.create_window' to create the floating window.
    width = width,
    height = height,
    row = row,
    col = col,
    border = opts.border or "double",
    title = opts.title or lang.ui.title_ui,
    title_pos = "center",
  })
  return buf, win
end


-- ***************************
-- * Function create_popup() *
-- ***************************
-- FR : Crée une fenêtre d’affichage utilisateur avec du texte.
-- EN : Creates a user display window with text.
function M.create_popup(lines)
  local buf, win = create_popup_window(lines, { width_factor = 0.6, min_height = 10 })
  setup_buffer_and_window(buf, win, lines)
  return buf, win
end


-- ***************************
-- * Function append_lines() *
-- ***************************
-- FR : Ajoute dynamiquement des lignes au buffer.
-- EN : Dynamically adds lines to the buffer.
function M.append_lines(buf, new_lines)
  vim.bo[buf].modifiable = true
  local curr = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend(curr, new_lines))
end


-- **************************************
-- * Function create_popup_with_input() *
-- **************************************
-- FR : Gère l’interaction utilisateur.
-- EN : Manages user interaction.
function M.create_popup_with_input(callback)
  local prompt = lang.ui.prompt
  local buf, win = create_popup_window({ prompt }, { width_factor = 0.6, min_height = 12})
  vim.bo[buf].buftype = "prompt"

  vim.fn.prompt_setprompt(buf, prompt)
  vim.fn.prompt_setcallback(buf, function(input)
    vim.bo[buf].buftype = ""  -- Disable prompt mode immediately after input
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {  -- Immediately displays “Please wait...”
      prompt .. input,
      "", lang.ui.waiting, "",
    })

    vim.cmd("stopinsert") -- Reactivates normal mode (exits insert mode)

    -- FR : Déclenche la logique de création après un léger délai
    -- EN : Triggers the creation logic after a slight delay
    vim.defer_fn(function()
      if callback then
        callback(input, buf)
      end
    end, 100) -- 100 ms delay
  end)

  -- FR : Permet de quitter avec "q" à tout moment.
  -- EN : Allows you to quit with “q” at any time.
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end, { buffer = buf, silent = true })

  vim.cmd("startinsert")
end


return M

