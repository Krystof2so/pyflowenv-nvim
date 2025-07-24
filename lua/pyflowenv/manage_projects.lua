-- **************************************************************
-- ** pyflowenv/manage_projects.lua                            **
-- ** -------------------------------------------------------- **
-- ** FR : Gestion des projets créés                           **
-- ** EN : Management of created projects                      **
-- **************************************************************

local M = {}

local lang = require("pyflowenv.lang").get()
local highlights = require "pyflowenv.ui.ui_highlights"
local utils = require "pyflowenv.utils"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local fb = require("telescope").extensions.file_browser

local config_dir = vim.fn.expand "~/.config/pyflowenv"
local file_path = config_dir .. "/list_projects.json"

local project_lookup = {} -- table : line → project)

-- *****************************************
-- * Savce projetc in 'projects_list.json' *
-- *****************************************
---@param name string Name of project
---@param path string Path of project
function M.save_project(name, path)
  local content = vim.fn.readfile(file_path)
  local projects = {}
  local now = os.date "%Y-%m-%d %H:%M:%S" -- Add date

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

  table.insert(projects, { name = name, path = path, modified = now })

  ::save::
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
  local decoded = vim.fn.json_decode(table.concat(content, "\n")) or {}

  -- FR : Tri du plus récent au plus ancien
  -- EN : Sort from most recent to oldestœ
  table.sort(decoded, function(a, b)
    return (a.modified or "") > (b.modified or "")
  end)

  return decoded
end

-- *******************************************************
-- * Update the modification date of an existing project *
-- *******************************************************
local function update_modified_date(name, path)
  local projects = get_projects()
  local now = os.date "%Y-%m-%d %H:%M:%S"

  for _, proj in ipairs(projects) do
    if proj.name == name and proj.path == path then
      proj.modified = now
      break
    end
  end

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
  local proj = project_lookup[row]

  if not proj or not proj.path then
    vim.notify(lang.errors.no_path, vim.log.levels.ERROR)
    return
  end

  -- Update date
  update_modified_date(proj.name, proj.path)

  -- FR : Fermer la fenêtre UI
  -- EN : Close UI window
  vim.api.nvim_win_close(win_id, true)
  vim.api.nvim_buf_delete(buf_id, { force = true })

  -- FR : Se positionner dans le répertoire du projet et ouvrir nvim-tree
  -- EN : Position oneself in the project directory and open nvim-tree
  vim.cmd("cd " .. proj.path)
  vim.cmd("NvimTreeOpen " .. proj.path)
end

-- ************************************************
-- * Delete a project via the 'd' key from the UI *
-- ************************************************
local function delete_selected_project(win_id, buf_id)
  local cursor = vim.api.nvim_win_get_cursor(win_id)
  local row = cursor[1]
  local proj = project_lookup[row]

  if not proj or not proj.name or not proj.path then
    return
  end

  local confirm = vim.fn.confirm(lang.ui.delete_project .. proj.name .. "' ?", lang.ui.yes_no, 2)
  if confirm == 1 then
    delete_project(proj.name, proj.path)
    vim.api.nvim_win_close(win_id, true)
    vim.api.nvim_buf_delete(buf_id, { force = true })
    vim.defer_fn(function()
      M.show_project_list()
    end, 100)
  end
end

-- ***********************************************
-- * Launch Telescope to add an existing project *
-- ***********************************************
local function add_existing_project_from_ui(win_id, buf_id)
  fb.file_browser {
    prompt_title = lang.ui.select_existing_folder,
    cwd = vim.fn.expand "~", -- Systematic opening in the user’s home
    select_buffer = true,
    files = false,
    hidden = false,
    attach_mappings = function(prompt_bufnr, map)
      local function on_select()
        local entry = action_state.get_selected_entry()
        local path = entry and entry.path or entry.filename
        if not path or vim.fn.isdirectory(path) == 0 then
          vim.notify(lang.errors.no_path, vim.log.levels.ERROR)
          return
        end

        local name = vim.fn.fnamemodify(path, ":t") -- basename du dossier
        M.save_project(name, path)

        actions.close(prompt_bufnr)
        vim.notify(lang.success.project_added(name), vim.log.levels.INFO)

        -- Fermer l'UI et la rouvrir pour mettre à jour
        if vim.api.nvim_win_is_valid(win_id) then
          vim.api.nvim_win_close(win_id, true)
        end
        if vim.api.nvim_buf_is_valid(buf_id) then
          vim.api.nvim_buf_delete(buf_id, { force = true })
        end

        vim.defer_fn(function()
          M.show_project_list()
        end, 100)
      end

      map("i", "<CR>", on_select)
      map("n", "<CR>", on_select)
      return true
    end,
  }
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
  project_lookup = {}
  table.insert(lines, "") -- Empty line under title
  for _, proj in ipairs(projects) do
    local date = utils.format_relative_time(proj.modified)
    local line = string.format("  • %s       (%s)", proj.name, date)
    table.insert(lines, line)
    local current_line = #lines
    project_lookup[current_line] = proj -- Associate project with the line
  end
  table.insert(lines, "") -- Empty lines
  table.insert(lines, "")
  table.insert(lines, lang.ui.ui_menu)

  -- FR : Création d’un buffer temporaire
  -- EN : Creation of a temporary buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- FR : Appliquer les highlights au buffer
  -- EN : Apply the highlights to the buffer
  for line_num, proj in pairs(project_lookup) do
    local line = lines[line_num]
    local start_col, end_col = string.find(line, proj.name, 1, true)
    if start_col and end_col then
      vim.api.nvim_buf_add_highlight(
        buf,
        -1,
        highlights.highlight_defaults.ProjectName.name,
        line_num - 1,
        start_col - 1,
        end_col
      )
    end
  end

  -- FR : Dimensions et position
  -- EN : Size and position
  local width = math.floor(vim.o.columns * 0.5)
  local min_height = 10
  local height = math.max(#lines + 2, min_height)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- FR : Création de la fenêtre flottante
  -- EN : Creation of the floating window
  highlights.setup_ui_colors() -- Configure colors
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

  vim.keymap.set("n", "a", function()
    add_existing_project_from_ui(win, buf)
  end, { buffer = buf, nowait = true })

  -- FR : Curseur sur la première entrée
  -- EN : Cursor on the first entry
  vim.api.nvim_win_set_cursor(win, { 2, 0 }) -- line 3 = first line project
end

return M
