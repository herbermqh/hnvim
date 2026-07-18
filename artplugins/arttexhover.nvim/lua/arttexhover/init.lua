local M = {}

M.setup = function(opts)
  local config = require("arttexhover.config")
  config.setup(opts)
  
  -- Comando para configurar visualmente
  vim.api.nvim_create_user_command("ArtHoverConfig", function()
    require("arttexhover.ui").open_menu()
  end, { desc = "Abre la configuración interactiva de ArtTeX Hover" })
  
  -- Comando principal para activar el hover (manual)
  vim.api.nvim_create_user_command("ArtTexHover", function()
    require("arttexhover.core").hover(true) -- 'true' fuerza el hover manual ignorando el toggle
  end, { desc = "Muestra información de hover de LaTeX" })

  -- Comando para abrir CTAN del paquete bajo el cursor
  vim.api.nvim_create_user_command("ArtTexDocCTAN", function()
    require("arttexhover.core").open_ctan()
  end, { desc = "Abre la documentación del paquete en CTAN" })
  
  -- Autocmd para el auto-hover
  vim.api.nvim_create_augroup("ArtTexAutoHover", { clear = true })
  vim.api.nvim_create_autocmd("CursorHold", {
    group = "ArtTexAutoHover",
    pattern = "*.tex",
    callback = function()
      if config.options.auto_hover then
        require("arttexhover.core").hover(false)
      end
    end
  })
  
  -- Exponer el método hover principal
  M.hover = require("arttexhover.core").hover
end

return M
