-- **********************
-- *** ui.lua (module) ***
-- **********************

local M = {}

-- Crée une fenêtre flottante
function M.create_popup(lines)
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.6)
  local height = math.max(10, #lines + 2)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Création d'un projet Python",
    title_pos = "center",
  })

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = true

  -- Quitter avec 'q'
  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true })

  return buf, win
end

-- Ajouter des lignes à une popup existante
function M.append_lines(buf, new_lines)
  vim.bo[buf].modifiable = true
  local curr = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.list_extend(curr, new_lines))
  vim.bo[buf].modifiable = true
end

-- Popup avec saisie utilisateur
function M.create_popup_with_input(callback)
  local prompt = "Nom du projet : "
  local buf = vim.api.nvim_create_buf(false, true)

  local width = math.floor(vim.o.columns * 0.5)
  local height = 5
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "single",
    title = "Création d'un projet Python",
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
    -- Supprimer le tampon après utilisation :
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
