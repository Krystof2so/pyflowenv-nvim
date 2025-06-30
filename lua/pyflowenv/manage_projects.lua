-- **************************************************************
-- ** pyflowenv/manage_projects.lua                            **
-- ** -------------------------------------------------------- **
-- ** FR : Gère l'enregistrement des projets créés             **
-- ** EN : Manages saving of created projects                  **
-- **************************************************************

local M = {}

local lang = require("pyflowenv.lang").get()

local config_dir = vim.fn.expand("~/.config/pyflowenv")
local file_path = config_dir .. "/list_projects.json"

--- Enregistre un projet dans list_projects.json
---@param name string Nom du projet
---@param path string Chemin absolu du projet
function M.save_project(name, path)
  local content = vim.fn.readfile(file_path)
  local projects = {}

  if content and #content > 0 then
    local ok, decoded = pcall(vim.fn.json_decode, table.concat(content, "\n"))
    if ok and type(decoded) == "table" then
      projects = decoded
    end
  end

  -- Empêche les doublons
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

return M

