-- ****************
-- *** init.lua ***
-- ****************

---@diagnostic disable: undefined-field

local M = {}
local utils = require("pyflowenv.utils")
local ui = require("pyflowenv.ui.ui_init")
local lang = require("pyflowenv.lang").get()
local gitignore_template = require("pyflowenv.templates.file_gitignore")

M.options = {
  venv_dir = ".venv",
  lang = "fr",
}

function M.setup(opts)
  M.options = vim.tbl_deep_extend("force", M.options, opts or {})
end

local function dir_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory"
end

function M.create_python_project(project_name, buf)
  local venv_dir = M.options.venv_dir or ".venv"
  local current_dir = vim.fn.getcwd()
  local project_dir = current_dir .. "/" .. project_name

  -- Affiche le prompt initial
  --ui.append_lines(buf, { lang.ui.prompt .. project_name })

  if dir_exists(project_dir) then
    ui.append_lines(buf, { "", lang.errors.dir_exists, "", lang.ui.press_q })
    return
  end

  -- Création dossier
  local mkdir_success = vim.fn.mkdir(project_dir, "p")
  if mkdir_success ~= 1 then
    ui.append_lines(buf, { "", lang.errors.mkdir_failed, "", lang.ui.press_q })
    return
  end
  ui.append_lines(buf, { lang.success.dir_created(project_dir) })

  -- Création venv
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s", project_dir, venv_dir)
  local ok = utils.check_run_in_shell(venv_cmd)
  if not ok then
    ui.append_lines(buf, { "", lang.errors.venv_failed, "", lang.ui.press_q })
    return
  end
  ui.append_lines(buf, { lang.success.venv_created })

  -- Création .gitignore
  local gitignore_path = project_dir .. "/.gitignore"
  local f = io.open(gitignore_path, "w")
  if not f then
    ui.append_lines(buf, { "", lang.errors.gitignore_failed, "", lang.ui.press_q })
    return
  end
  f:write(gitignore_template.default_gitignore(venv_dir))
  f:close()
  ui.append_lines(buf, { lang.success.gitignore_created })

  ui.append_lines(buf, {
    "",
    lang.success.project_created(project_name),
    "",
    lang.ui.press_q,
  })
end

vim.api.nvim_create_user_command("CreatePythonVenv", function()
  -- Création popup avec saisie + affichage résultat dans même buffer
  ui.create_popup_with_input(function(project_name, buf)
    if not project_name or project_name == "" then
      ui.append_lines(buf, {
        lang.errors.no_project_name,
        "",
        lang.ui.cancelled,
        "",
        lang.ui.press_q,
      })
      return
    end

    -- Lance la création
    M.create_python_project(project_name, buf)
  end)
end, {})

return M

