-- **************************************************
-- ** pyflowenv/creator/project.lua                **
-- ** -------------------------------------------- **
-- ** - Crée la structure de projet Python         **
-- ** - Crée main.py, README.md, .gitignore, venv **
-- ** - Initialise Git                              **
-- **************************************************

-- FR : Eviter les faux positifs du Language Server Protocol : 'vim.loop.fs_stat'.
-- EN : Avoiding false positives in the Language Server Protocol: ‘vim.loop.fs_stat’.
---@diagnostic disable: undefined-field


local M = {}
local ui = require("pyflowenv.ui.ui_init")
local utils = require("pyflowenv.utils")
local gitignore_template = require("pyflowenv.templates.file_gitignore")
local lang = require("pyflowenv.lang").get()


local function dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end


-- FR : Crée la structure de projet Python
-- EN : Create the Python project structure
---@param project_dir string Full path of the project
---@param project_name string
---@param buf number Display buffer
---@param options table User options (venv_dir...)
function M.create_python_project(project_dir, project_name, buf, options)
  local venv_dir = options.venv_dir or ".venv"
  local package_name = project_name:gsub("%-", "_")

  -- Step 1
  -- FR : Vérifier si le répertoire existe déjà
  -- EN : Check if the directory already exists
  if dir_exists(project_dir) then
    ui.append_lines(buf, { "", lang.errors.dir_exists, "", lang.ui.press_q })
    return
  end

  -- Step 2
  -- FR : Création de la structure du projet
  -- EN : Creating the project structure
  local paths = {
    project_dir .. "/assets",
    project_dir .. "/src/" .. package_name,
    project_dir .. "/tests",
  }

  for _, path in ipairs(paths) do
    local ok = vim.fn.mkdir(path, "p")
    if ok ~= 1 then
      ui.append_lines(buf, { "", lang.errors.mkdir_failed .. ": " .. path, "", lang.ui.press_q })
      return
    end
  end
  ui.append_lines(buf, { lang.success.dir_created(project_dir) })

  -- Step 3
  -- FR : Création de main.py
  -- EN : Create main.py
  local main_path = project_dir .. "/src/" .. package_name .. "/main.py"
  local main_file = io.open(main_path, "w")
  if main_file then
    main_file:write([[
def main():
    print("Hello from ]] .. project_name .. [[")

if __name__ == '__main__':
    main()
]])
    main_file:close()
    ui.append_lines(buf, { "  ✅ main.py créé." })
  else
    ui.append_lines(buf, { "", "  ❌ Impossible de créer main.py", "", lang.ui.press_q })
    return
  end

  -- Step 4
  -- FR : Création README.md
  -- EN : Create README.md
  local readme = io.open(project_dir.. "/README.md", "w")
  if readme then
    readme:write("# " .. project_name:gsub("%-", " "))
    readme:close()
    ui.append_lines(buf, { "  ✅ README.md créé." })
  end

  -- Step 5
  -- FR : Création du .gitignore
  -- EN : Creat .gitignore
  local gitignore_path = project_dir .. "/.gitignore"
  local f = io.open(gitignore_path, "w")
  if f then
    f:write(gitignore_template.default_gitignore(venv_dir))
    f:close()
    ui.append_lines(buf, { lang.success.gitignore_created })
  else
    ui.append_lines(buf, { lang.errors.gitignore_failed, "", lang.ui.press_q })
    return
  end

  -- Step 6
  -- FR : Création de l'environnement virtuel
  -- EN : Creation of the virtual environment
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  if not utils.check_run_in_shell(venv_cmd) then
    ui.append_lines(buf, { lang.errors.venv_failed, "", lang.ui.press_q })
    return
  else
    ui.append_lines(buf, { lang.success.venv_created })
  end

  -- Step 7
  -- FR : Initialisation Git
  -- EN : Initialize Git
  local cmds = {
    string.format("cd '%s' && git init", project_dir),
    string.format("cd '%s' && git add .", project_dir),
    string.format("cd '%s' && git commit -m 'initial commit'", project_dir),
  }

  for i, cmd in ipairs(cmds) do
    local ok = utils.check_run_in_shell(cmd)
    if not ok then
      ui.append_lines(buf, { lang.errors.git_failed })
      return
    end
  end
  ui.append_lines(buf, { lang.success.git_local("initial commit") })

  -- Fin
  ui.append_lines(buf, {
    "",
    lang.success.project_created(project_name),
    "",
    lang.ui.press_q,
  })
end


return M
