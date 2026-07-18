local M = {}
local config = require("arttexhover.config")
local menu_builder = require("arttexworkspace.ui.menu_builder")

function M.open_menu()
  local auto_hover_status = config.options.auto_hover and "Activado" or "Desactivado"
  
  local options = {
    {
      text = "1. Toggle Auto-Hover Global (Actual: " .. auto_hover_status .. ")",
      action = function() 
        config.options.auto_hover = not config.options.auto_hover
        config.save_json({
          auto_hover = config.options.auto_hover,
          citation_commands = config.options.citation_commands,
          reference_commands = config.options.reference_commands
        })
        vim.notify("ArtTex: Auto-Hover " .. (config.options.auto_hover and "Activado" or "Desactivado"), vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 100)
      end
    },
    {
      text = "2. Macros de Citas (Ej: cite, artcite)",
      action = function() M.edit_list("citation_commands", "Comandos de Citas") end
    },
    {
      text = "3. Macros de Referencias (Ej: ref, artref)",
      action = function() M.edit_list("reference_commands", "Comandos de Referencias") end
    },
    {
      text = "4. Restablecer valores por defecto",
      action = function() 
        os.remove(config.config_file)
        config.options.auto_hover = true
        config.options.citation_commands = { "cite", "parencite", "footcite", "textcite", "smartcite", "autocite" }
        config.options.reference_commands = { "ref", "eqref", "autoref", "nameref", "pageref", "cref", "Cref" }
        config.rebuild_sets()
        vim.notify("ArtTex: Configuración restablecida", vim.log.levels.INFO)
      end
    }
  }

  menu_builder.create_menu({
    title = "ArtTeX Hover: Configuración",
    prompt = "Selecciona la categoría de comandos a personalizar:",
    options = options
  })
end

function M.edit_list(key, title)
  local current_list = config.options[key] or {}
  local default_val = table.concat(current_list, ", ")

  menu_builder.create_input({
    title = title,
    prompt = "Ingresa comandos separados por coma:",
    default = default_val
  }, function(input)
    if not input or input == "" then return end
    
    local new_list = {}
    for cmd in string.gmatch(input, "([^,%s]+)") do
      table.insert(new_list, cmd)
    end
    
    config.options[key] = new_list
    config.save_json({
      auto_hover = config.options.auto_hover,
      citation_commands = config.options.citation_commands,
      reference_commands = config.options.reference_commands
    })
    
    config.rebuild_sets()
    vim.notify("ArtTex: Actualizado hover", vim.log.levels.INFO)
    vim.defer_fn(M.open_menu, 100)
  end)
end

return M
