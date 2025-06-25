-- ***************************************************************
-- ** pyflowenv/ui/ui_telescope_picker.lua                       **
-- ** --------------------------------------------------------- **
-- ** FR : Choix interactif d’un dossier avec Telescope         **
-- ** EN : Interactive folder selection using Telescope         **
-- ***************************************************************

local M = {}

-- FR : Savoir si 'telescope' est installé
-- EN : Check if 'telescope' is installed
local has_telescope = pcall(require, "telescope")
if not has_telescope then
  vim.notify("[pyflowenv] Telescope n’est pas installé.", vim.log.levels.ERROR)
  return M
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values

-- FR : Ouvre Telescope pour sélectionner un répertoire
-- EN : Open Telescope with folder selected
---@param callback fun(dir: string)
function M.select_directory(callback)
  pickers.new({}, {
    prompt_title = "📁 Choisir un répertoire de destination",
    finder = finders.new_oneshot_job({
      "fd", "--type", "d", "--hidden", "--exclude", ".git"
    }, {
      ---@diagnostic disable-next-line: undefined-field
      cwd = vim.loop.os_homedir(),  -- Statting point : home
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map("i", "<CR>", function(bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(bufnr)
        if entry and callback then
          callback(entry[1])  -- Call the callback with the folder path
        end
      end)
      return true
    end,
  }):find()
end

return M

