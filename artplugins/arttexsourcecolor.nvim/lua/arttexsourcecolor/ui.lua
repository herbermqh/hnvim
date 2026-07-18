--- @module arttexsourcecolor.ui
--- @description Interfaz de usuario para configurar el plugin en tiempo real.
local M = {}
local config = require("arttexsourcecolor.config")
local bridge = require("arttexsourcecolor.workspace_bridge")
local injector = require("arttexsourcecolor.treesitter_injector")
local highlights = require("arttexsourcecolor.highlights")
local themes = require("arttexsourcecolor.themes")
local virtual_engine = require("arttexsourcecolor.virtual_engine")

local function refresh_all()
  config.save_json()
  highlights.apply_globals()
  virtual_engine.setup() -- Re-binds autocmds and forces query rebuild
  bridge.sync_with_workspace(0)
  pcall(vim.api.nvim_exec_autocmds, "User", { pattern = "ArtTexSourceColorChanged", modeline = false })
  vim.cmd("redraw!")
end

local function select_theme_menu()
  local menu_builder = require("arttexworkspace.ui.menu_builder")
  local theme_names = {}
  for k, _ in pairs(themes) do
    table.insert(theme_names, k)
  end
  table.sort(theme_names)

  local opts = {}
  for _, tname in ipairs(theme_names) do
    local icon = (config.options.theme_name == tname) and "󰪥" or "󰝦"
    table.insert(opts, {
      text = icon .. " " .. tname,
      action = function()
        config.options.theme_name = tname
        config.options.colors = vim.tbl_deep_extend("force", config.options.colors, themes[tname])
        refresh_all()
        vim.notify("Tema aplicado: " .. tname, vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 100)
      end
    })
  end
  
  table.insert(opts, {
    text = "󰌍 Volver",
    action = function() M.open_menu() end
  })

  menu_builder.create_menu({
    title = "ArtTeX Color: Temas",
    prompt = "Selecciona un tema:",
    options = opts
  })
end

function M.open_menu()
  local menu_builder_ok, menu_builder = pcall(require, "arttexworkspace.ui.menu_builder")
  if not menu_builder_ok then
    vim.notify("ArtTex SourceColor requiere arttexworkspace para los menús visuales.", vim.log.levels.ERROR)
    return
  end

  local f = config.options.features
  
  local options = {
    {
      text = "󰐊 Toggle Coloreado General (Actual: " .. (config.options.enabled and "Activado" or "Desactivado") .. ")",
      action = function() 
        config.options.enabled = not config.options.enabled
        config.save_json()
        if not config.options.enabled then
          bridge.stop_sync()
          injector.clear_injection()
          highlights.clear_globals()
          pcall(require("arttexsourcecolor.virtual_engine").clear, 0)
        else
          highlights.apply_globals()
          bridge.sync_with_workspace(0)
        end
        vim.notify("Coloreado: " .. (config.options.enabled and "Activado" or "Desactivado"), vim.log.levels.INFO)
        vim.defer_fn(M.open_menu, 100)
      end
    },
    {
      text = "󰏘 Cambiar Tema (Actual: " .. (config.options.theme_name or "Custom") .. ")",
      action = select_theme_menu
    },
    {
      text = (f.rainbow_brackets and "" or "") .. " Rainbow Brackets (Paréntesis Arcoiris)",
      action = function()
        f.rainbow_brackets = not f.rainbow_brackets
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.match_paren and "" or "") .. " Match Paren (Resaltar Begin/End emparejado)",
      action = function()
        f.match_paren = not f.match_paren
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.semantic_envs and "" or "") .. " Entornos Semánticos (Cajas y Teoremas)",
      action = function()
        f.semantic_envs = not f.semantic_envs
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.syntax_errors and "" or "") .. " Errores de Sintaxis",
      action = function()
        f.syntax_errors = not f.syntax_errors
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.virtual_text.references and "" or "") .. " Texto Virtual: Referencias (\\ref)",
      action = function()
        f.virtual_text.references = not f.virtual_text.references
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.virtual_text.resources and "" or "") .. " Texto Virtual: Recursos (Imágenes)",
      action = function()
        f.virtual_text.resources = not f.virtual_text.resources
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = (f.virtual_text.structs and "" or "") .. " Texto Virtual: Estructura (\\chapter)",
      action = function()
        f.virtual_text.structs = not f.virtual_text.structs
        refresh_all()
        M.open_menu()
      end
    },
    {
      text = "󰑐 Restablecer valores por defecto",
      action = function() 
        bridge.stop_sync()
        injector.clear_injection()
        pcall(require("arttexsourcecolor.virtual_engine").clear, 0)
        os.remove(config.config_file)
        config.options.enabled = true
        config.options.theme_name = "tokyonight"
        config.options.colors = vim.tbl_deep_extend("force", config.options.colors, themes["tokyonight"])
        config.options.features = {
          rainbow_brackets = true, match_paren = true, semantic_envs = true,
          syntax_errors = true, virtual_text = { references = true, resources = true, structs = true }
        }
        refresh_all()
        vim.notify("ArtTex SourceColor: Configuración restablecida", vim.log.levels.INFO)
      end
    }
  }

  menu_builder.create_menu({
    title = "ArtTeX SourceColor",
    prompt = "Selecciona una opción:",
    options = options
  })
end

return M
