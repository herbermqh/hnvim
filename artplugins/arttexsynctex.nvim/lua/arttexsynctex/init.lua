local M = {}

M.api = {}
local config = require("arttexsynctex.config")
local viewer = require("arttexsynctex.core.viewer")
local server = require("arttexsynctex.core.server")

M.setup = function(opts)
  -- Inicialización y Configuración central
  config.setup(opts)
  
  -- Registrar el proyecto actual para Backward Search (El Enrutador)
  vim.api.nvim_create_autocmd("User", {
    pattern = "ArtTexWorkspaceReady",
    callback = function()
      server.start_and_register()
    end,
  })
  
  -- Comandos UI
  vim.api.nvim_create_user_command("ArtTexForwardSearch", function()
    viewer.forward_search()
  end, { desc = "Sincronizar cursor con el visor PDF" })

  vim.api.nvim_create_user_command("ArtTexSelectViewer", function()
    local viewers_factory = require("arttexsynctex.viewers")
    local available_viewers = vim.tbl_keys(viewers_factory.get_all_viewers())
    local menu_builder = require("arttexworkspace.ui.menu_builder")
    
    local menu_options = {}
    
    for _, viewer_name in ipairs(available_viewers) do
      local is_current = config.options.viewer == viewer_name
      local text = string.format("  %s %s", is_current and "■" or "□", viewer_name)
      
      table.insert(menu_options, {
        text = text,
        action = function()
          config.options.viewer = viewer_name
          require("arttexworkspace").log.info("Visor PDF actualizado a: " .. viewer_name)
        end
      })
    end
    
    table.insert(menu_options, {
      text = "  ⬅  Cancelar",
      action = function() end
    })

    menu_builder.create_menu({
      title = "Visor PDF (ArtTeX)",
      prompt = "¿Qué visor PDF deseas utilizar?",
      options = menu_options
    })
  end, { desc = "Seleccionar dinámicamente el Visor PDF" })
end

M.api.forward_search = viewer.forward_search
M.api.handle_inverse_search = server.handle_inverse_search

return M
