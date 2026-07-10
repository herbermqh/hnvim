local M = {}

--- Plantilla base para un nuevo archivo de snippets
local snippet_template = [=[
local ls = require('luasnip')
local parse_snippet = ls.parser.parse_snippet
local utils = require('arttexsnippets.util.utils')
local is_math = utils.with_opts(utils.is_math, true)
local not_math = utils.with_opts(utils.not_math, true)
local line_begin = require('luasnip.extras.conditions.expand').line_begin
local pipe = utils.pipe

local function env(name)
  return function()
    return utils.env(name)
  end
end

local M = {}

M.retrieve = function(is_math, not_math)
  local autosnippets = {}
  local normalsnippets = {}

  -- Ejemplos de uso:
  -- table.insert(autosnippets, parse_snippet({trig = "ej", name = "Ejemplo", priority = 500}, "Ejemplo expandido $0"))
  -- table.insert(normalsnippets, parse_snippet({trig = "ejn", name = "Normal", priority = 100}, "Ejemplo normal $0"))

  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end

return M
]=]

--- Abre el gestor interactivo de Snippets
function M.open_manager()
  local script_path = debug.getinfo(1, "S").source:sub(2)
  local custom_path = vim.fn.fnamemodify(script_path, ":h") .. "/custom"
  
  if vim.fn.isdirectory(custom_path) == 0 then
    vim.notify("[ArtTex] No se encontró el directorio de snippets personalizados.", vim.log.levels.ERROR)
    return
  end

  local files = {}
  for name, type in vim.fs.dir(custom_path) do
    if type == "file" and name:match("%.lua$") then
      table.insert(files, name)
    end
  end

  table.sort(files)
  
  local menu_options = {}

  local menu_builder_ok, menu_builder = pcall(require, "arttexworkspace.ui.menu_builder")
  if not menu_builder_ok then
    vim.notify("[ArtTex] arttexworkspace.ui.menu_builder no encontrado. Asegúrate de tener instalado arttexworkspace.", vim.log.levels.ERROR)
    return
  end

  local function open_file(filename)
    local filepath = custom_path .. "/" .. filename
    vim.cmd("edit " .. filepath)
  end

  local function create_new_file()
    menu_builder.create_input({
      title = "Nuevo Módulo de Snippets",
      prompt = "Nombre del nuevo archivo (ej: fisica):",
      default = ""
    }, function(input)
      if not input or input == "" then return end
      
      -- Asegurar extensión .lua
      if not input:match("%.lua$") then
        input = input .. ".lua"
      end

      local filepath = custom_path .. "/" .. input
      
      -- Escribir plantilla si no existe
      if vim.fn.filereadable(filepath) == 0 then
        local f = io.open(filepath, "w")
        if f then
          f:write(snippet_template)
          f:close()
          vim.notify("[ArtTex] Creado nuevo módulo de snippets: " .. input, vim.log.levels.INFO)
        else
          vim.notify("[ArtTex] Error al crear el archivo.", vim.log.levels.ERROR)
          return
        end
      end

      vim.cmd("edit " .. filepath)
    end)
  end

  local function add_quick_snippet()
    menu_builder.create_menu({
      title = "¿En qué archivo guardamos el Snippet?",
      prompt = "Selecciona destino:",
      options = vim.tbl_map(function(f)
        return {
          text = "  󰈔  " .. f,
          action = function()
            -- Ahora pedimos los datos
            menu_builder.create_input({ title = "Paso 1: Trigger", prompt = "Atajo de teclado (ej: ali): "}, function(trig)
              if not trig or trig == "" then return end
              menu_builder.create_input({ title = "Paso 2: Nombre", prompt = "Descripción (ej: Align): "}, function(name)
                if not name or name == "" then return end
                menu_builder.create_input({ title = "Paso 3: Código LaTeX", prompt = "Pega el código generado ($1, $2 para cursores): "}, function(code)
                  if not code or code == "" then return end
                  
                  -- Generar código Lua
                  local lua_code = string.format("\ntable.insert(normalsnippets, parse_snippet(\n  { trig = %q, name = %q },\n  [=[\n%s\n]=]\n))", trig, name, code)
                  
                  -- Inyectar antes del 'return { autosnippets' o al final
                  local filepath = custom_path .. "/" .. f
                  local lines = vim.fn.readfile(filepath)
                  
                  local inject_idx = #lines
                  for i = #lines, 1, -1 do
                    if lines[i]:match("return %{") or lines[i]:match("return M") then
                      inject_idx = i - 1
                      break
                    end
                  end
                  
                  table.insert(lines, inject_idx, lua_code)
                  vim.fn.writefile(lines, filepath)
                  
                  -- Disparar un guardado falso para gatillar el BufWritePost de HotReload
                  vim.cmd("edit " .. filepath)
                  vim.cmd("write")
                  vim.cmd("bdelete")
                  
                  vim.notify("[ArtTex] Snippet '" .. trig .. "' añadido a " .. f .. " y recargado exitosamente.", vim.log.levels.INFO)
                end)
              end)
            end)
          end
        }
      end, files)
    })
  end

  -- Añadir opción para crear uno rápido
  table.insert(menu_options, {
    text = "  󰏫  Añadir Snippet Rápido (Visual)",
    action = add_quick_snippet
  })

  -- Añadir opción para crear uno nuevo
  table.insert(menu_options, {
    text = "  󰐕  Crear Nuevo Módulo",
    action = create_new_file
  })

  -- Añadir archivos existentes
  for _, filename in ipairs(files) do
    table.insert(menu_options, {
      text = "  󰈔  " .. filename,
      action = function() open_file(filename) end
    })
  end

  menu_builder.create_menu({
    title = "Gestor de Snippets (ArtTeX)",
    prompt = "¿Qué módulo deseas editar o crear?",
    options = menu_options
  })
end

--- Abre el panel de configuración dinámica
function M.open_config()
  local menu_builder_ok, menu_builder = pcall(require, "arttexworkspace.ui.menu_builder")
  if not menu_builder_ok then
    vim.notify("[ArtTex] menu_builder no encontrado.", vim.log.levels.ERROR)
    return
  end

  local main_plugin = require("arttexsnippets")
  local current_opts = vim.deepcopy(main_plugin.opts) or {}
  current_opts.disabled_modules = current_opts.disabled_modules or {}

  local function get_module_files(folder)
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local path = vim.fn.fnamemodify(script_path, ":h") .. "/" .. folder
    local res = {}
    if vim.fn.isdirectory(path) == 1 then
      for name, item_type in vim.fs.dir(path) do
        if item_type == "file" and name:match("%.lua$") then
          local mod_name = name:gsub("%.lua$", "")
          table.insert(res, mod_name)
        end
      end
    end
    return res
  end

  local build_menu -- pre-declaración

  local function build_modules_submenu(title, folder, modules_list)
    local options = {}
    local list = modules_list or get_module_files(folder)

    for _, mod in ipairs(list) do
      local is_enabled = not current_opts.disabled_modules[mod]
      local icon = is_enabled and "󰄲 Activado   " or "󰄱 Desactivado"
      
      table.insert(options, {
        text = "  " .. icon .. " │ " .. mod .. ".lua",
        action = function()
          current_opts.disabled_modules[mod] = is_enabled and true or false
          vim.schedule(function() build_modules_submenu(title, folder, modules_list) end)
        end
      })
    end
    
    table.insert(options, {
      text = "  ─────────────",
      action = function() build_modules_submenu(title, folder, modules_list) end
    })
    
    table.insert(options, {
      text = "  󰁍 Volver al Menú Principal",
      action = function() vim.schedule(build_menu) end
    })

    menu_builder.create_menu({
      title = "Submenú: " .. title,
      prompt = "Activa o desactiva archivos individuales:",
      options = options
    })
  end

  build_menu = function()
    local options = {}

    local function toggle(key)
      current_opts[key] = not current_opts[key]
      vim.schedule(build_menu)
    end

    local function render_bool(val)
      return val and "󰄲 Activado   " or "󰄱 Desactivado"
    end

    table.insert(options, {
      text = "  " .. render_bool(current_opts.load_core_math) .. " │ Módulo Matemático Base (Global)",
      action = function() toggle("load_core_math") end
    })
    table.insert(options, {
      text = "       󰅂 Seleccionar archivos matemáticos específicos...",
      action = function() 
        local core_list = { "math_wRA_no_backslash", "math_rA_no_backslash", "math_wA_no_backslash", "math_iA_no_backslash", "math_iA", "math_wrA", "wA", "bwA" }
        build_modules_submenu("Matemáticas Base", "math", core_list)
      end
    })

    table.insert(options, {
      text = "  " .. render_bool(current_opts.load_custom) .. " │ Módulos Personalizados (Global)",
      action = function() toggle("load_custom") end
    })
    table.insert(options, {
      text = "       󰅂 Seleccionar archivos personalizados específicos...",
      action = function() build_modules_submenu("Módulos de Usuario", "custom") end
    })

    table.insert(options, {
      text = "  " .. render_bool(current_opts.load_project_local) .. " │ Snippets Locales (.arttex/snippets)",
      action = function() toggle("load_project_local") end
    })
    table.insert(options, {
      text = "  " .. render_bool(current_opts.use_treesitter) .. " │ Detección Sintáctica con Treesitter AST",
      action = function() toggle("use_treesitter") end
    })
    table.insert(options, {
      text = "  " .. render_bool(current_opts.allow_on_markdown) .. " │ Habilitar en documentos Markdown/Quarto",
      action = function() toggle("allow_on_markdown") end
    })
    
    table.insert(options, {
      text = "  ─────────────",
      action = function() build_menu() end
    })

    table.insert(options, {
      text = "  󰆓 Aplicar y Recargar Motor",
      action = function()
        main_plugin.opts = current_opts
        
        local utils = require("arttexsnippets.util.utils")
        local is_math = utils.with_opts(utils.is_math, current_opts.use_treesitter)
        local not_math = utils.with_opts(utils.not_math, current_opts.use_treesitter)
        
        local engine = require("arttexsnippets.core.engine")
        local ft = vim.bo.filetype
        
        -- Limpiar LuaSnip
        require("luasnip").cleanup()
        
        if ft == "markdown" or ft == "quarto" then
          engine.setup_markdown(is_math, not_math, current_opts)
        else
          engine.setup_tex(is_math, not_math, current_opts)
        end
        
        vim.notify("[ArtTex] Configuraciones hiper-específicas aplicadas y motor recargado.", vim.log.levels.INFO)
      end
    })

    menu_builder.create_menu({
      title = "Configuración ArtTeX Snippets",
      prompt = "Ajusta el motor en tiempo real:",
      options = options
    })
  end

  build_menu()
end

return M
