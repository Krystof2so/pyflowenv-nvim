-- ***************************************************************
-- ** pyflowenv/ui/ui_telescope_picker.lua                       **
-- ** --------------------------------------------------------- **
-- ** FR : Choix interactif d’un dossier avec Telescope         **
-- ** EN : Interactive folder selection using Telescope         **
-- ***************************************************************

local M = {}

local M = {}

local function select_directory(callback)
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope not found", vim.log.levels.ERROR)
    return
  end

  telescope.extensions.file_browser.file_browser({
    prompt_title = "📁 Choisis un répertoire",
    path = vim.fn.getcwd(),
    select_buffer = true,
    depth = false,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local entry = require("telescope.actions.state").get_selected_entry()
        require("telescope.actions").close(bufnr)

        if callback then
          local selected_path = entry and entry[1] or vim.fn.getcwd()
          callback(selected_path)
        end
      end)
      return true
    end,
  })
end


M.select_directory = select_directory


return M


