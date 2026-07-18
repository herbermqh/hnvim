local M = {}

function M.open_menu()
  local config = require("arttexworkspace.core.config").options
  config.verbatim_envs = config.verbatim_envs or {}
  local envs = config.verbatim_envs
  
  local options = {}
  table.insert(options, {
    text = "󰐕  Añadir nuevo entorno",
    action = function()
      require("arttexworkspace.ui.menu_builder").create_input({
        title = "Nuevo Entorno Verbatim",
        prompt = "Nombre del entorno (sin llaves ni \\begin):",
      }, function(input)
        if input and input ~= "" then
          local clean_input = vim.trim(input)
          -- Comprobar duplicados
          local exists = false
          for _, e in ipairs(config.verbatim_envs) do
            if e == clean_input then exists = true break end
          end
          if not exists then
            table.insert(config.verbatim_envs, clean_input)
            vim.notify("ArtTeX: Entorno '" .. clean_input .. "' añadido.", vim.log.levels.INFO)
          else
            vim.notify("ArtTeX: El entorno '" .. clean_input .. "' ya existe.", vim.log.levels.WARN)
          end
        end
      end)
    end
  })
  
  for i, env in ipairs(envs) do
    table.insert(options, {
      text = "󰅖  Eliminar: " .. env,
      action = function()
        table.remove(config.verbatim_envs, i)
        vim.notify("ArtTeX: Entorno '" .. env .. "' eliminado.", vim.log.levels.INFO)
      end
    })
  end
  
  require("arttexworkspace.ui.menu_builder").create_menu({
    prompt = { "󰈙 Gestión de Entornos Verbatim (Código)", "Administra qué entornos se ignorarán al compilar/parsear:" },
    options = options
  })
end

return M
