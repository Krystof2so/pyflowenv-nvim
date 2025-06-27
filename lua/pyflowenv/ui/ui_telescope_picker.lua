-- ***************************************************************
-- ** pyflowenv/ui/ui_telescope_picker.lua                       **
-- ** --------------------------------------------------------- **
-- ** FR : Choix interactif d’un dossier avec Telescope         **
-- ** EN : Interactive folder selection using Telescope         **
-- ***************************************************************

---@diagnostic disable: undefined-field

local M = {}

local lang = require("pyflowenv/lang").get()

local function select_directory(callback)
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify(lang.errors.no_telescope, vim.log.levels.ERROR)
    return
  end

  local fb_ok = pcall(telescope.load_extension, "file_browser")
  if not fb_ok then
    vim.notify(lang.errors.no_file_browser, vim.log.levels.ERROR)
    return
  end

  telescope.extensions.file_browser.file_browser({
    prompt_title = lang.ui.rep_choice,
    path = vim.loop.os_homedir(),
    cwd = vim.loop.os_homedir(),
    hidden = true,
    files = false,            --  Does not show files
    depth = false,                --  Don't go into subfolders
    previewer = false,        --  Disables the preview window
    grouped = false,
    hijack_netrw = true,
    select_buffer = true,
    respect_gitignore = false,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(bufnr)

        if callback and entry then
          local selected_path = entry.Path and entry.Path:absolute() or entry[1]
          callback(selected_path)
        end
      end)
      return true
    end,
  })
end

M.select_directory = select_directory

return M

