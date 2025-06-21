-- ***************************************************************
-- ** pyflowenv/ui/ui_init.lua                                  **
-- ** --------------------------------------------------------- **
-- ** - Point d’entrée de l’UI.                                 **
-- ** - Responsable des composants UI spécifiques.              **
-- ** - Contient diverses fonctions générales et réutilisables. **
-- ***************************************************************

local utils = require("pyflowenv.ui.ui_utils")
local highlights = require("pyflowenv.ui.ui_highlights")
local lang = require("pyflowenv.lang").get()
local M = {}

-- Configure les paramètres communs pour un buffer et une fenêtre
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

-- Crée une fenêtre avec des paramètres communs
local function create_popup_window(lines, opts)
  highlights.setup_ui_colors()
  local buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * opts.width_factor)
  local height = math.max(opts.min_height, #lines + 2)
  local row, col = utils.get_centered_coords(width, height)
  local win = utils.create_window(buf, {
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

-- Crée un buffer d'affichage (log, retour utilisateur)
function M.create_popup(lines)
  local buf, win = create_popup_window(lines, { width_factor = 0.6, min_height = 10 })
  setup_buffer_and_window(buf, win, lines)
  return buf, win
end

-- Ajoute des lignes à un buffer existant
function M.append_lines(buf, new_lines)
  vim.bo[buf].modifiable = true
  local curr = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend(curr, new_lines))
end

-- Popup avec saisie utilisateur (même buffer réutilisé ensuite)
function M.create_popup_with_input(callback)
  local prompt = lang.ui.prompt
  local buf, win = create_popup_window({ prompt }, { width_factor = 0.6, min_height = 12})
  vim.bo[buf].buftype = "prompt"

  vim.fn.prompt_setprompt(buf, prompt)
  vim.fn.prompt_setcallback(buf, function(input)
    -- On désactive le mode prompt immédiatement après la saisie
    vim.bo[buf].buftype = ""
    -- Affiche immédiatement "Veuillez patienter..."
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      prompt .. input,
      "", "  ⏳ Veuillez patienter pendant la création du projet...", "",
    })

    -- Réactive le mode normal (sort du mode insert)
    vim.cmd("stopinsert")

    -- Déclenche la logique de création après un léger délai
    vim.defer_fn(function()
      if callback then
        callback(input, buf)
      end
    end, 100) -- délai de 100 ms
  end)

  -- Permet de quitter avec "q" à tout moment
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

