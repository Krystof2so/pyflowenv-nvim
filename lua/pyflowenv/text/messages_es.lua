-- ************************************
-- ** pyflowenv/text/messages_fr.lua **
-- ************************************

return {
  errors = {
    no_project_name = "  ❌ No se ingresó ningún nombre de proyecto.",
    dir_exists = "  El directorio ya existe.",
    mkdir_failed = "  ❌ Error: no se pudo crear el directorio.",
    venv_failed = "  ❌ Error al crear el entorno virtual.",
    gitignore_failed = "  ❌ Error al crear el archivo .gitignore.",
  },
  success = {
    dir_created = function(path) return "  📂 Directorio creado: " .. path end,
    venv_created = "  ✅ Entorno virtual creado.",
    gitignore_created = "  ✅ Archivo .gitignore creado.",
    project_created = function(name) return "  ✅ Proyecto '" .. name .. "' creado." end,
  },
  ui = {
    cancelled = "  Abandono 'Creación de proyecto'",
    press_q = "  [q] para salir...",
    prompt = "  🐍 Nombre del proyecto: ",
    title_ui = " Creación de un proyecto Python "
  },
}
