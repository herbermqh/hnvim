-- Auto-inicialización "Zero-Config" de ArtTeX Snippets
-- Cuando un usuario instala el plugin, Neovim lee automáticamente esta carpeta "plugin/".
-- Esto evita que el usuario tenga que escribir `require("arttexsnippets").setup()` en su init.lua.

local ok, snippets = pcall(require, "arttexsnippets")
if ok then
  -- Verificamos si LuaSnip está instalado, ya que somos un Wrapper de LuaSnip
  local ls_ok, _ = pcall(require, "luasnip")
  if ls_ok then
    -- Inicializamos con opciones por defecto (Treesitter habilitado si está disponible)
    local has_treesitter, _ = pcall(require, "nvim-treesitter")
    
    snippets.setup({
      use_treesitter = has_treesitter,
      allow_on_markdown = true,
    })
    
    -- Registrar comando de usuario interactivo
    vim.api.nvim_create_user_command("ArtTexSnippetsEdit", function()
      require("arttexsnippets.ui").open_manager()
    end, { desc = "Abre el gestor de snippets de ArtTeX para editar o crear nuevos módulos." })

    vim.api.nvim_create_user_command("ArtTexSnippetsSearch", function()
      require("arttexsnippets.search").open_search()
    end, { desc = "Busca y previsualiza los snippets cargados en memoria." })

    vim.api.nvim_create_user_command("ArtTexSnippetsConfig", function()
      require("arttexsnippets.ui").open_config()
    end, { desc = "Abre el panel interactivo de configuración de ArtTeX Snippets." })

    -- Hot Reload: Auto-recargar snippets al guardar archivos personalizados
    vim.api.nvim_create_autocmd("BufWritePost", {
      pattern = "*/arttexsnippets/custom/*.lua",
      callback = function(opts)
        -- Limpiar el caché del módulo guardado
        local filename = vim.fn.fnamemodify(opts.match, ":t:r")
        package.loaded["arttexsnippets.custom." .. filename] = nil

        -- Re-inyectar en LuaSnip si estamos en un buffer de tex
        pcall(function()
          local ls = require("luasnip")
          -- ls.cleanup() borraria TODOS los snippets de todos los lenguajes, 
          -- por seguridad solo reiniciamos los del archivo actual o forzamos recarga
          local utils = require("arttexsnippets.util.utils")
          local has_treesitter, _ = pcall(require, "nvim-treesitter")
          local is_math = utils.with_opts(utils.is_math, has_treesitter)
          local not_math = utils.with_opts(utils.not_math, has_treesitter)
          require("arttexsnippets.core.engine").setup_tex(is_math, not_math)
          vim.notify("[ArtTex] Snippets de '" .. filename .. "' recargados.", vim.log.levels.INFO)
        end)
      end,
    })
  else
    vim.schedule(function()
      vim.notify("[ArtTeX Snippets] LuaSnip no está instalado. Los snippets de LaTeX requieren LuaSnip.", vim.log.levels.WARN)
    end)
  end
end
