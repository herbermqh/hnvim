local M = {}
local config = require("arttexlinter.config")
local menu_builder = require("arttexworkspace.ui.menu_builder")

function M.open_menu()
  local status = config.options.enabled and "Activado" or "Desactivado"
  local backend = config.options.backend
  
  local options = {
    {
      text = "1. Toggle Linter Global (Actual: " .. status .. ")",
      action = function() 
        config.options.enabled = not config.options.enabled
        config.save_json({
          enabled = config.options.enabled,
          backend = config.options.backend
        })
        vim.notify("ArtTex Linter: " .. (config.options.enabled and "Activado" or "Desactivado"), vim.log.levels.INFO)
        if not config.options.enabled then
          require("arttexlinter.core").clear()
        else
          require("arttexlinter.core").lint()
        end
        vim.defer_fn(M.open_menu, 100)
      end
    },
    {
      text = "2. Seleccionar Motor Backend (Actual: " .. backend .. ")",
      action = function()
        -- Por ahora solo chktex, pero preparado para expandirse a logparser o lacheck
        vim.notify("Actualmente el único motor ultra-optimizado disponible es chktex.", vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 1000)
      end
    },
    {
      text = "3. Restablecer valores por defecto",
      action = function() 
        os.remove(config.config_file)
        config.options.enabled = true
        config.options.backend = "chktex"
        vim.notify("ArtTex Linter: Configuración restablecida", vim.log.levels.INFO)
        require("arttexlinter.core").lint()
      end
    }
  }

  menu_builder.create_menu({
    title = "ArtTeX Linter: Configuración",
    prompt = "Selecciona una opción para el análisis estático:",
    options = options
  })
end

return M
