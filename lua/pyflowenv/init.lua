-- *********************
-- *** pyflowenv-nvim **
-- *********************

---@diagnostic disable: undefined-field


local M = {}


-- *******************************************
-- * Fonction de configuration (optionnelle) *
-- * Permet aux utilisateurs de configurer   *
-- * le plugin avec leurs propres options.   *
-- *******************************************
function M.setup(opts)
  opts = opts or {}  -- Table vide si l'utilisateur ne passe rien à 'setup()'

  -- Valeurs par défaut :
  local defaults = {
    venv_dir = ".venv",
  }

  -- Validation des types :
  if opts.venv_dir ~= nil and type(opts.venv_dir) ~= "string" then  -- Vérifie que 'venv_dir' est de type string.
    vim.notify("[pyflowenv] L'option 'venv_dir' doit être une chaîne de caractères.", vim.log.levels.ERROR)
    opts.venv_dir = nil -- ignore valeur invalide
  end

  -- Fusion des options entre valeurs par défaut et valeurs de l'utilisateur :
  M.options = vim.tbl_deep_extend("force", defaults, opts)  -- 'force' = priorité aux valeurs de l'utilisateur.
end


-- ********************************************************
-- * Fonction de vérification de l'existence d'un dossier *
-- ********************************************************
local function dir_exists(path)
  local stat = vim.loop.fs_stat(path) -- Vérifie si 'path' est un répertoire existant. 
  return stat and stat.type == "directory" -- Vérifie si répertoire.
end


-- *****************************************************************
-- * Fonction principale : création d’un projet Python avec 'venv' *
-- *****************************************************************
function M.create_python_project()
  
  -- Demande du nom du projet :
  local project_name = vim.fn.input("Nom du projet : ")
  if project_name == "" then
    print("Le nom du projet ne peut pas être vide.")
    return
  end

  -- Construction des chemins :
  local current_dir = vim.fn.getcwd()
  local project_dir = current_dir .. "/" .. project_name -- Concaténation pour création du chemin absolu du projet.

  -- Création du répertoire si inexistant :
  if not dir_exists(project_dir) then
    local mkdir_success = vim.fn.mkdir(project_dir, "p")
    if mkdir_success ~= 1 then
      print("Erreur lors de la création du répertoire du projet.")
      return
    end
  else
    print("Le répertoire du projet existe déjà.")
  end

  -- Création de l'environnement virtuel dans le répertoire du projet :
  local venv_dir = M.options and M.options.venv_dir or ".venv"  -- '.venv' par défaut ou option fournie par l"utilisateur.
  -- Crée l'environnement virtuel et supprime le fichier .gitignore créé par 'venv' :
  local venv_cmd = string.format("cd '%s' && python3 -m venv %s && rm -Rf %s/.gitignore", project_dir, venv_dir, venv_dir)
  local venv_success = os.execute(venv_cmd) -- Exécution de la commande ddns le shell.
  if venv_success ~= 0 then
    print("Erreur lors de la création de l'environnement virtuel.")
    return
  end

  -- Contenu du .gitignore :
  local gitignore_content = [[
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

  -- Ecriture du fichier '.gitignore' :
  local gitignore_path = project_dir .. "/.gitignore"
  local gitignore_file = io.open(gitignore_path, "w") -- Ouverture du fichier en écriture.
  if gitignore_file then -- Vérification existence avant écriture.
    gitignore_file:write(gitignore_content)
    gitignore_file:close()
  else
    print("Erreur lors de la création du fichier .gitignore.")
    return
  end
  print("Projet Python créé avec succès : " .. project_dir)

end


-- ********************************************************
-- * Commande 'vim' utilisateur pour exécuter la fonction *
-- ********************************************************
vim.api.nvim_create_user_command("CreatePythonVenv", function()
  M.create_python_project()
end, {})


return M

