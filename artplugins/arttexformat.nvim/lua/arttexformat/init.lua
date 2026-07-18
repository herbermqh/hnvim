local M = {}
local config = require("arttexformat.config")
local core = require("arttexformat.core")
local ui = require("arttexformat.ui")
local indent = require("arttexformat.indent")

local augroup = vim.api.nvim_create_augroup("ArtTexFormatAuto", { clear = true })

function M.setup(opts)
  -- 1. Cargar configuración
  config.setup(opts)

  -- 2. Registrar Comandos de Usuario
  vim.api.nvim_create_user_command("ArtFormatConfig", function()
    ui.open_menu()
  end, { desc = "Abre la configuración del formateador de ArtTeX" })

  vim.api.nvim_create_user_command("ArtFormatEditRules", function()
    local yaml_path = config.options.latexindent_config_dir .. "/setting_latexindent.yaml"
    vim.cmd("edit " .. yaml_path)
  end, { desc = "Abre el archivo de reglas de latexindent para editarlo" })

  vim.api.nvim_create_user_command("ArtTexFormat", function()
    core.format_buffer(true)
  end, { desc = "Fuerza el formateo del archivo actual usando latexindent" })

  -- 3. Registrar eventos automáticos para archivos de LaTeX
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "tex", "latex", "plaintex" },
    callback = function(args)
      local bufnr = args.buf

      -- A) Activar indentación en tiempo real (0% CPU cost, puramente nativo)
      if config.options.use_realtime_indent then
        indent.setup_buffer(bufnr)
      end

      -- Ya no se inyectan atajos de teclado dinámicamente.
      -- Los atajos deben ser configurados por el usuario en su archivo de configuración (ej. which-key).
    end
  })

  -- 4. Evento para Auto-Formato al Guardar
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = augroup,
    pattern = { "*.tex", "*.latex", "*.cls", "*.sty" },
    callback = function()
      if config.options.auto_format_on_save then
        core.format_buffer(false)
      end
    end
  })
end

return M
