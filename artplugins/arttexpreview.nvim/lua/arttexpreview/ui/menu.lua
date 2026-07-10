--- Menú de configuración para ArtTeX Preview
--- @class arttexpreview.menu
local M = {}

local config = require("arttexpreview.config")
local log_api = require("arttexworkspace.core.log")
local menu_builder = require("arttexworkspace.ui.menu_builder")

function M.open_menu()
  local math_status = tostring(config.settings.auto_math)
  local image_status = tostring(config.settings.auto_image)
  
  local options = {
    { 
      text = "1. Autoprevisualizar Matemáticas (Nabla): [" .. math_status .. "]", 
      action = function() 
        config.settings.auto_math = not config.settings.auto_math
        log_api.notify("Autoprevisualización de Matemáticas: " .. tostring(config.settings.auto_math), vim.log.levels.INFO)
        if not config.settings.auto_math then
          require("arttexpreview.ui.renderer").clear_preview()
        end
        vim.defer_fn(M.open_menu, 100)
      end 
    },
    { 
      text = "2. Autoprevisualizar Imágenes (Image.nvim): [" .. image_status .. "]", 
      action = function() 
        config.settings.auto_image = not config.settings.auto_image
        log_api.notify("Autoprevisualización de Imágenes: " .. tostring(config.settings.auto_image), vim.log.levels.INFO)
        if not config.settings.auto_image then
          require("arttexpreview.ui.renderer").clear_preview()
        end
        vim.defer_fn(M.open_menu, 100)
      end 
    },
    { 
      text = "  ⬅  Volver / Cerrar", 
      action = function() end 
    }
  }
  
  menu_builder.create_menu({
    title = "Configuración de ArtTeX Preview",
    prompt = "",
    options = options
  })
end

return M
