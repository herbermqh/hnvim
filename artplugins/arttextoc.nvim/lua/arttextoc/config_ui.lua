local M = {}

function M.open()
  local menu_builder_ok, menu_builder = pcall(require, "arttexworkspace.ui.menu_builder")
  if not menu_builder_ok then
    vim.notify("[ArtTex] arttexworkspace.ui.menu_builder no encontrado.", vim.log.levels.ERROR)
    return
  end
  
  local main_plugin = require("arttextoc")
  local custom_levels = vim.deepcopy(main_plugin.opts.custom_levels or {})
  
  local function get_level_menu_options(cmd_name, callback)
    local levels_def = {
      { l = -1, t = "󰉖 Partes" },
      { l = 0, t = "󰈙 Capítulos" },
      { l = 1, t = "󰠱 Secciones" },
      { l = 2, t = "󰅂 Subsecciones" },
      { l = 3, t = "󰄾 Sub-subsecciones" },
      { l = 4, t = "󰍡 Párrafos" },
      { l = 5, t = "󰍡 Subpárrafos" },
    }
    local opts = {}
    for _, def in ipairs(levels_def) do
      table.insert(opts, {
        text = string.format("  %s (Nivel %d)", def.t, def.l),
        action = function() callback(def.l) end
      })
    end
    return opts
  end
  
  local options = {}
  
  -- Opción para añadir uno nuevo
  table.insert(options, {
    text = "    Añadir nueva regla de sección...",
    action = function()
      menu_builder.create_input({ title = "Nueva Sección", prompt = "Nombre del comando LaTeX (ej: mychapter):" }, function(name)
        if not name or name == "" then return end
        
        menu_builder.create_menu({
          title = "Jerarquía de \\" .. name,
          prompt = "Selecciona el nivel equivalente:",
          options = get_level_menu_options(name, function(level)
            custom_levels[name] = level
            main_plugin.save_json_config(custom_levels)
            vim.notify("[ArtTex] Regla añadida: \\" .. name .. " -> Nivel " .. level, vim.log.levels.INFO)
            vim.defer_fn(function() M.open() end, 100)
          end)
        })
      end)
    end
  })
  
  -- Listar las reglas existentes
  for cmd, level in pairs(custom_levels) do
    table.insert(options, {
      text = string.format("  󰆍  \\%s (Nivel %d)", cmd, level),
      action = function()
        menu_builder.create_menu({
          title = "Modificar Regla: \\" .. cmd,
          prompt = "¿Qué deseas hacer?",
          options = {
            {
              text = "    Cambiar Nivel",
              action = function()
                menu_builder.create_menu({
                  title = "Nuevo Nivel para \\" .. cmd,
                  prompt = "Selecciona el nivel equivalente:",
                  options = get_level_menu_options(cmd, function(lvl)
                    custom_levels[cmd] = lvl
                    main_plugin.save_json_config(custom_levels)
                    vim.notify("[ArtTex] Regla actualizada.", vim.log.levels.INFO)
                    vim.defer_fn(function() M.open() end, 100)
                  end)
                })
              end
            },
            {
              text = "    Eliminar Regla",
              action = function()
                custom_levels[cmd] = nil
                main_plugin.save_json_config(custom_levels)
                vim.notify("[ArtTex] Regla eliminada.", vim.log.levels.INFO)
                vim.defer_fn(function() M.open() end, 100)
              end
            }
          }
        })
      end
    })
  end

  menu_builder.create_menu({
    title = " Configuración de TOC (ArtTeX) ",
    prompt = "Niveles Personalizados:",
    options = options
  })
end

return M
