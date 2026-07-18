local M = {}

M.setup = function(opts)
  local config = require("arttexlinter.config")
  config.setup(opts)
  
  local core = require("arttexlinter.core")
  
  -- Comando de UI
  vim.api.nvim_create_user_command("ArtLinterConfig", function()
    require("arttexlinter.ui").open_menu()
  end, { desc = "Abre la configuración interactiva de ArtTeX Linter" })
  
  -- Comando de Lint manual
  vim.api.nvim_create_user_command("ArtTexLint", function()
    core.lint()
  end, { desc = "Fuerza un análisis estático de linter en el archivo actual" })
  
  -- Autocmds para Lint automático asíncrono
  vim.api.nvim_create_augroup("ArtTexAutoLinter", { clear = true })
  
  for _, event in ipairs(config.options.events) do
    vim.api.nvim_create_autocmd(event, {
      group = "ArtTexAutoLinter",
      pattern = "*.tex",
      callback = function()
        core.lint()
      end
    })
  end
  
  -- Lanzar inicial si se carga
  vim.defer_fn(function()
    if vim.bo.filetype == "tex" then
      core.lint()
    end
  end, 500)
end

return M
