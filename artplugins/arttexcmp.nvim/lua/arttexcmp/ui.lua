local M = {}
local config = require("arttexcmp.config")
local menu_builder = require("arttexworkspace.ui.menu_builder")

function M.open_menu()
  local options = {
    {
      text = "1. Macros de Citas (Ej: cite, artcite)",
      action = function() M.edit_list("citation_commands", "Comandos de Citas") end
    },
    {
      text = "2. Macros de Referencias (Ej: ref, artref)",
      action = function() M.edit_list("reference_commands", "Comandos de Referencias") end
    },
    {
      text = "3. Macros de Archivos (Ej: input, include)",
      action = function() M.edit_list("include_commands", "Comandos de Archivos") end
    },
    {
      text = "4. Macros de Gráficos (Ej: includegraphics)",
      action = function() M.edit_list("graphics_commands", "Comandos de Gráficos") end
    },
    {
      text = "5. Restablecer valores por defecto",
      action = function() 
        os.remove(config.config_file)
        config.options.citation_commands = { "cite", "parencite", "footcite", "textcite", "smartcite", "autocite" }
        config.options.reference_commands = { "ref", "eqref", "autoref", "nameref", "pageref", "cref", "Cref" }
        config.options.include_commands = { "input", "include", "includeonly" }
        config.options.graphics_commands = { "includegraphics" }
        config.rebuild_sets()
        vim.notify("ArtTeX Cmp: Configuración restablecida", vim.log.levels.INFO)
      end
    }
  }

  menu_builder.create_menu({
    title = "ArtTeX Cmp: Configuración",
    prompt = "Selecciona la categoría de comandos a personalizar:",
    options = options
  })
end

function M.edit_list(key, title)
  local current_list = config.options[key] or {}
  local default_val = table.concat(current_list, ", ")

  menu_builder.create_input({
    title = title,
    prompt = "Ingresa comandos separados por coma (ej: cite,mycite):",
    default = default_val
  }, function(input)
    if not input or input == "" then
      vim.notify("Entrada cancelada o vacía.", vim.log.levels.WARN)
      return
    end
    
    local new_list = {}
    for cmd in string.gmatch(input, "([^,%s]+)") do
      table.insert(new_list, cmd)
    end
    
    config.options[key] = new_list
    config.save_json({
      citation_commands = config.options.citation_commands,
      reference_commands = config.options.reference_commands,
      include_commands = config.options.include_commands,
      graphics_commands = config.options.graphics_commands
    })
    
    config.rebuild_sets()
    vim.notify("ArtTex: Actualizado cmp", vim.log.levels.INFO)
    
    -- Volver a abrir el menú principal
    vim.defer_fn(M.open_menu, 100)
  end)
end

return M
