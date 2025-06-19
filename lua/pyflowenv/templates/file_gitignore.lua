-- ********************************************
-- ** pyflowenv/templates/file_gitignore.lua **
-- ********************************************

local M = {}

function M.default_gitignore(venv_dir)
    return [[
# Environnement virtuel :
]] .. venv_dir .. [[

# Fichiers Python compilés :
__pycache__/
# Fichiers de cache et de logs :
*.log
*.cache
# Fichiers de données :
*.csv
*.json
*.sqlite
*.db
]]
end

return M
