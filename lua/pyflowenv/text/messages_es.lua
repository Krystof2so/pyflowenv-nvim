-- ************************************
-- ** pyflowenv/text/messages_fr.lua **
-- ************************************

return {
  errors = {
    no_encode_json = " ❌ Fallo de codificación JSON",
    no_repertory = " ❌ Ninguna carpeta seleccionada.",
    no_save_file = " ❌ No se puede crear list_projects.json",
    no_file_browser = " ❌ telescope-file-browser.nvim no se ha cargado",
    not_fd = "❌ Se requiere 'fd' para listar directorios.",
    no_project_name = "  ❌ No se ingresó ningún nombre de proyecto.",
    no_telescope = " ❌ No se ha encontrado el plugin Telescope.",
    no_write_in_json = " ❌ Error de escritura en 'list_projects.json'",
    not_main = "  ❌ No se puede crear el archivo main.py",
    dir_exists = "  El directorio ya existe.",
    mkdir_failed = "  ❌ Error: no se pudo crear el directorio.",
    venv_failed = "  ❌ Error al crear el entorno virtual.",
    git_failed = "  ❌ No se pudo inicializar Git.",
    git_commit_failed = "  ❌ Falló el primer commit. ¿Has configurado Git?",
    gitignore_failed = "  ❌ Error al crear el archivo .gitignore.",
  },
  success = {
    dir_created = function(path) return "  📂 Directorio creado: " .. path end,
    venv_created = "  ✅ Entorno virtual creado.",
    gitignore_created = "  ✅ Archivo .gitignore creado.",
    git_initialized = "  ✅ Repositorio Git inicializado.",
    git_local = function(msg) return "  ✅ Commit creado: \"" .. msg .. "\"" end,
    main_created = "  ✅ Archivo main.py creado.",
    readme_created = "  ✅ Archivo README.md creado.",
    project_created = function(name) return "  ✅ Proyecto '" .. name .. "' creado." end,
  },
  ui = {
    cancelled = "  Abandono 'Creación de proyecto'",
    press_q = "  [q] para salir...",
    prompt = "  🐍 Nombre del proyecto: ",
    rep_choice = "📁 Seleccionar un directorio de destino",
    title_ui = " Creación de un proyecto Python ",
    waiting = "  ⏳ Espere mientras se crea el proyecto...",
  },
}
