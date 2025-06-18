-- ***************************************************************
-- ** pyflowenv/ui/ui_init.lua                                  **
-- ** --------------------------------------------------------- **
-- ** - Point d’entrée de l’UI.                                 **
-- ** - Responsable des composants UI spécifiques.              **
-- ** - Contient diverses fonctions générales et réutilisables. **
-- ***************************************************************

local utils = require("pyflowenv.ui.ui_utils")
local highlights = require("pyflowenv.ui.ui_highlights")

local M = {}

-- Crée un buffer d'affichage (log, retour utilisateur)
function M.create_popup(lines)
  highlights.setup_ui_colors()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.max(10, #lines + 2)
  local row, col = utils.get_centered_coords(width, height)

  local win = utils.create_window(buf, {
    width = width,
    height = height,
    row = row,
    col = col,
    border = "double",
    title = " Création d'un projet Python ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = true

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })

  return buf, win
end

-- Ajoute des lignes à un buffer existant
function M.append_lines(buf, new_lines)
  vim.bo[buf].modifiable = true
  local curr = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend(curr, new_lines))
end

-- Popup avec saisie utilisateur
function M.create_popup_with_input(callback)
  highlights.setup_ui_colors()
  local prompt = "  Nom du projet : "
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.5)
  local height = 2
  local row, col = utils.get_centered_coords(width, height)

  local win = utils.create_window(buf, {
    width = width,
    height = height,
    row = row,
    col = col,
    border = "double",
    title = " Création d'un projet Python ",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt })
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].modifiable = true

  vim.fn.prompt_setprompt(buf, prompt)
  vim.fn.prompt_setcallback(buf, function(input)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    if vim.api.nvim_buf_is_valid(buf) then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
    if callback then
      callback(input, M.create_popup({}))
    end
  end)

  vim.cmd("startinsert")
end

return M

