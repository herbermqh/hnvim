local M = {}

M.api = {}

M.setup = function(opts)
  require("arttexcmp.config").setup(opts)
  -- Intentamos cargar nvim-cmp
  local has_cmp, cmp = pcall(require, "cmp")
  if not has_cmp then
    vim.notify("arttexcmp: nvim-cmp no está instalado o cargado", vim.log.levels.WARN)
    return
  end

  local source = require("arttexcmp.source")
  
  -- Registramos la fuente de completado "arttex"
  cmp.register_source("arttex", source.new())
  
  -- Crear comando de configuración
  vim.api.nvim_create_user_command("ArtCmpConfig", function()
    require("arttexcmp.ui").open_menu()
  end, { desc = "Abre la configuración interactiva de ArtTeX Cmp" })
  -- Opcional: configurar automáticamente la fuente para archivos tex
  -- cmp.setup.filetype('tex', {
  --   sources = cmp.config.sources({
  --     { name = 'arttex' },
  --     { name = 'buffer' },
  --   })
  -- })
end

return M
