--- @module arttexsourcecolor
--- @description Punto de entrada principal. Organiza la inicialización perezosa (lazy-loading)
--- e inyecta las configuraciones base. Coordina el sistema de eventos.
local M = {}
local config = require("arttexsourcecolor.config")
local highlights = require("arttexsourcecolor.highlights")
local bridge = require("arttexsourcecolor.workspace_bridge")
local ui = require("arttexsourcecolor.ui")

local augroup = vim.api.nvim_create_augroup("ArtTexSourceColorAuto", { clear = true })

function M.setup(opts)
  -- 0. Inject dynamic queries path into runtimepath
  local dynamic_queries_dir = vim.fn.stdpath("data") .. "/arttex_dynamic_queries"
  if not vim.tbl_contains(vim.opt.runtimepath:get(), dynamic_queries_dir) then
    vim.opt.runtimepath:prepend(dynamic_queries_dir)
  end

  -- 1. Load config state
  config.setup(opts)

  -- 2. Define global colors immediately to prevent FOUC
  highlights.apply_globals()

  -- Apply dynamic highlighting instantly if already in a LaTeX buffer
  local ft = vim.bo.filetype
  if (ft == "tex" or ft == "latex") and config.options.enabled then
    bridge.sync_with_workspace(0)
  end

  -- 3. Register Commands
  vim.api.nvim_create_user_command("ArtSourceColorConfig", function()
    ui.open_menu()
  end, { desc = "Abrir configuración de ArtTeX SourceColor" })

  vim.api.nvim_create_user_command("ArtSourceColorSync", function()
    if config.options.enabled then
      bridge.sync_with_workspace(0)
    end
  end, { desc = "Sincronizar colores con ArtTex Workspace" })

  -- 4. Persist globals on ColorScheme change
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = augroup,
    pattern = "*",
    callback = function() 
      highlights.apply_globals()
    end
  })

  -- 5. Link with Workspace on Buffer Enter
  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    group = augroup,
    pattern = { "*.tex", "*.latex", "*.sty", "*.cls" },
    callback = function(args)
      local bufnr = args.buf

      if config.options.enabled then
        bridge.sync_with_workspace(bufnr)
        -- Activar cursorline solo para el número de línea para que se vea el color resaltante
        vim.wo.cursorline = true
        if vim.wo.cursorlineopt == "" or vim.wo.cursorlineopt == "both" or vim.wo.cursorlineopt == "line" then
          -- Si no está configurado, o está configurado para la línea entera,
          -- podríamos querer solo el número, pero para no romper otras configuraciones
          -- solo nos aseguramos de que incluya "number".
          if not string.find(vim.wo.cursorlineopt, "number") then
            vim.wo.cursorlineopt = "number"
          end
        end
      end
    end
  })

  -- 6. Setup High-Performance Virtual Engine (Decoration Provider)
  require("arttexsourcecolor.virtual_engine").setup()
end

return M
