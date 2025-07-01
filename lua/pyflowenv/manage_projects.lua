-- **************************************************************
-- ** pyflowenv/manage_projects.lua                            **
-- ** -------------------------------------------------------- **
-- ** FR : Gère l'enregistrement des projets créés             **
-- ** EN : Manages saving of created projects                  **
-- **************************************************************

local M = {}
local json = vim.fn.json_decode

local lang = require("pyflowenv.lang").get()

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


-- ************
-- *
-- ******
local function get_projects()
  if vim.fn.filereadable(file_path) == 0 then
    return {}
  end

  local content = vim.fn.readfile(file_path)
  local decoded = vim.fn.json_decode(table.concat(content, "\n"))
  return decoded or {}
end


-- *********
-- *
-- **********
function M.show_project_list()
  local projects = get_projects()

  if #projects == 0 then
    vim.notify("Aucun projet enregistré", vim.log.levels.INFO)
    return
  end

  local lines = { "📁 Projets enregistrés :", "" }
  for _, proj in ipairs(projects) do
    table.insert(lines, "• " .. proj.name .. " → " .. proj.path)
  end

  -- Création d’un buffer temporaire
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false

  -- Dimensions et position
  local width = math.floor(vim.o.columns * 0.7)
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.5))
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  -- Création de la fenêtre flottante
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
  })

  -- Fermer avec `q`
  vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = buf, nowait = true })
end


return M

