local M = {}
local config = require("arttexformat.config")

function M.open_menu()
  local menu_builder_ok, menu_builder = pcall(require, "arttexworkspace.ui.menu_builder")
  if not menu_builder_ok then
    vim.notify("ArtTex Format requiere arttexworkspace para los menús visuales.", vim.log.levels.ERROR)
    return
  end

  local auto_save_status = config.options.auto_format_on_save and "Activado" or "Desactivado"
  local indent_status = config.options.use_realtime_indent and "Activado" or "Desactivado"
  
  local options = {
    {
      text = "1. Toggle Auto-Formato al Guardar (Actual: " .. auto_save_status .. ")",
      action = function() 
        config.options.auto_format_on_save = not config.options.auto_format_on_save
        config.save_json(config.options)
        vim.notify("Auto-Formato: " .. (config.options.auto_format_on_save and "Activado" or "Desactivado"), vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 100)
      end
    },
    {
      text = "2. Toggle Indentación Dinámica en Tiempo Real (Actual: " .. indent_status .. ")",
      action = function() 
        config.options.use_realtime_indent = not config.options.use_realtime_indent
        config.save_json(config.options)
        vim.notify("Indentación en Tiempo Real: " .. (config.options.use_realtime_indent and "Activado" or "Desactivado"), vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 100)
      end
    },
    {
      text = "3. Formatear el archivo completo AHORA",
      action = function()
        require("arttexformat.core").format_buffer(true)
      end
    },
    {
      text = "4. Editar reglas de Formateo (setting_latexindent.yaml)",
      action = function()
        vim.cmd("ArtFormatEditRules")
      end
    },
    {
      text = "5. Restablecer valores por defecto",
      action = function() 
        os.remove(config.config_file)
        config.options.auto_format_on_save = false
        config.options.use_realtime_indent = true
        vim.notify("ArtTex Format: Configuración restablecida", vim.log.levels.INFO)
      end
    }
  }

  menu_builder.create_menu({
    title = "ArtTeX Format: Configuración",
    prompt = "Selecciona una opción para el formateo:",
    options = options
  })
end

return M
