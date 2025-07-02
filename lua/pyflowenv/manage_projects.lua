-- **************************************************************
-- ** pyflowenv/manage_projects.lua                            **
-- ** -------------------------------------------------------- **
-- ** FR : Gestion des projets créés                           **
-- ** EN : Management of created projects                      **
-- **************************************************************

local M = {}

local lang = require("pyflowenv.lang").get()
local highlights = require("pyflowenv.ui.ui_highlights")

local config_dir = vim.fn.expand("~/.config/pyflowenv")
local file_path = config_dir .. "/list_projects.json"


-- *****************************************
-- * Savce projetc in 'projects_list.json' *
-- *****************************************
---@param name string Name of project
---@param path string Path of project
function M.save_project(name, path)
  local content = vim.fn.readfile(file_path)
  local projects = {}

  if content and #content > 0 then
    local ok, decoded = pcall(vim.fn.json_decode, table.concat(content, "\n"))
    if ok and type(decoded) == "table" then
      projects = decoded
    end
  end

  -- FR : Empêche les doublons
  -- EN : Prevents duplicates
  for _, proj in ipairs(projects) do
    if proj.name == name and proj.path == path then
      return
    end
  end

  table.insert(projects, { name = name, path = path })

  local ok, encoded = pcall(vim.fn.json_encode, projects)
  if not ok then
    vim.notify(lang.errors.no_encode_json, vim.log.levels.ERROR)
    return
  end

  local file = io.open(file_path, "w")
  if file then
    file:write(encoded)
    file:close()
  else
    vim.notify(lang.errors.no_write_in_json, vim.log.levels.ERROR)
  end
end


-- **********************************
-- * Return table of saved projects *
-- **********************************
local function get_projects()
  if vim.fn.filereadable(file_path) == 0 then
    return {}
  end

  local content = vim.fn.readfile(file_path)
  local decoded = vim.fn.json_decode(table.concat(content, "\n"))
  return decoded or {}
end


-- ******************************************************
-- * Removes a project from the list_projects.json file *
-- ******************************************************
local function delete_project(name, path)
  local projects = get_projects()
  local updated = {}

  for _, proj in ipairs(projects) do
    if not (proj.name == name and proj.path == path) then
      table.insert(updated, proj)
    end
  end

  local ok, encoded = pcall(vim.fn.json_encode, updated)
  if ok then
    local file = io.open(file_path, "w")
    if file then
      file:write(encoded)
      file:close()
    end
  else
    vim.notify(lang.errors.failed_record_changes, vim.log.levels.ERROR)
  end
end


-- ********************************************************
-- * Open project path using nvim-tree (triggered by 'o') *
-- ********************************************************
local function open_selected_project(win_id, buf_id)
  local cursor = vim.api.nvim_win_get_cursor(win_id)
  local row = cursor[1]
  local line = vim.api.nvim_buf_get_lines(buf_id, row - 1, row, false)[1]

  if not line then return end

  local path = line:match("→%s*(.+)$")
  if not path or vim.fn.isdirectory(path) == 0 then
    vim.notify(lang.errors.no_path, vim.log.levels.ERROR)
    return
  end

  -- FR : Fermer la fenêtre UI
  -- EN : Close UI window
  vim.api.nvim_win_close(win_id, true)
  vim.api.nvim_buf_delete(buf_id, { force = true })

  -- FR : Se positionner dans le répertoire du projet et ouvrir nvim-tree
  -- EN : Position oneself in the project directory and open nvim-tree
  vim.cmd("cd " .. path)
  vim.cmd("NvimTreeOpen " .. path)
end


-- ************************************************
-- * Delete a project via the 'd' key from the UI *
-- ************************************************
local function delete_selected_project(win_id, buf_id)
  local cursor = vim.api.nvim_win_get_cursor(win_id)
  local row = cursor[1]
  local line = vim.api.nvim_buf_get_lines(buf_id, row - 1, row, false)[1]

  if not line then return end

  local name = line:match("•%s*(.-)%s*→")
  local path = line:match("→%s*(.+)$")
  if not name or not path then
    return
  end

  local confirm = vim.fn.confirm(lang.ui.delete_project .. name .. "' ?", lang.ui.yes_no, 2)
  if confirm == 1 then
    delete_project(name, path)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_buf_delete(buf_id, { force = true })
    vim.defer_fn(function()
      M.show_project_list()
    end, 100)
  end
end


-- ************************************
-- * Display the projects saved in UI *
-- ************************************
function M.show_project_list()
  local projects = get_projects()

  if #projects == 0 then
    vim.notify(lang.errors.no_project_saved, vim.log.levels.INFO)
    return
  end

  -- FR : Préparer les lignes du buffer
  -- EN : Prepare the buffer lines
  local lines = {}
  table.insert(lines, "")  -- Empty line under title
  for _, proj in ipairs(projects) do
    table.insert(lines, "• " .. proj.name .. " → " .. proj.path)
  end
  table.insert(lines, "")  -- Empty lines
  table.insert(lines, "")
  table.insert(lines, lang.ui.ui_menu)

  -- FR : Création d’un buffer temporaire
  -- EN : Creation of a temporary buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- FR : Dimensions et position
  -- EN : Size and position
  local width = math.floor(vim.o.columns * 0.5)
  local min_height = 10
  local height = math.max(#lines + 2, min_height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- FR : Création de la fenêtre flottante
  -- EN : Creation of the floating window
  highlights.setup_ui_colors()  -- Configure colors
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "double",
    title = lang.ui.title_projects_list,
    title_pos = "center",
  })
  vim.defer_fn(function()
    vim.wo[win].winhl = highlights.get_winhl_string()
  end, 0)

  -- FR : Touches : q = quitter, o = ouvrir, d = supprimer
  -- EN : Keys: q = quit, o = open, d = delete
  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "o", function()
    open_selected_project(win, buf)
  end, { buffer = buf, nowait = true })

  vim.keymap.set("n", "d", function()
    delete_selected_project(win, buf)
  end, { buffer = buf, nowait = true })

  -- FR : Curseur sur la première entrée
  -- EN : Cursor on the first entry
  vim.api.nvim_win_set_cursor(win, { 2, 0 }) -- line 3 = first line project
end

return M

