local log = require("arttexworkspace.core.log")
local menu = require("arttexworkspace.ui.menu_builder")
local resolver = require("arttexworkspace.discovery.root_resolver")

local M = {}

local function file_exists(path)
  local f = io.open(path, "r")
  if f then io.close(f) return true else return false end
end

local function save_learned_macro(cmd_name, pattern, config_path, config)
  config.estructura_manual_usuario = config.estructura_manual_usuario or {}
  config.estructura_manual_usuario[cmd_name] = { pattern }
  local f = io.open(config_path, "w")
  if f then
    f:write(require("arttexworkspace.core.json").encode(config))
    f:close()
  end
  -- Forzar al analizador semántico a recalcular el árbol
  local main_path = require("arttexworkspace.core.state").get_main_from_buffer(vim.api.nvim_buf_get_name(0))
  if main_path then
    require("arttexworkspace.discovery.project_tree").get_dependencies(main_path)
    log.info("Macro \\" .. cmd_name .. " aprendida y guardada.")
  end
end

local function intelligent_fallback(cmd_name, arg, config_path, config, project_root)
  -- ¡Nueva IA Heurística! Búsqueda perezosa con Ripgrep (rg) a petición del usuario.
  -- Si el macro no está en memoria, buscamos su definición en las librerías del usuario (configurable).
  if vim.fn.executable("rg") == 1 then
    local plugin_config = require("arttexworkspace.core.config").options
    local library_paths = plugin_config.library_paths or {}
    
    for _, search_dir in ipairs(library_paths) do
      local expanded_dir = vim.fn.expand(search_dir)
      if file_exists(expanded_dir) then
        -- Buscar la definición del macro (ej: \newcommand{\cmd}, \def\cmd, \NewDocumentCommand{\cmd})
        local regex = "\\\\(newcommand|def|NewDocumentCommand|providecommand|renewcommand)[^\\{]*\\\\?{?" .. cmd_name:gsub("%.", "\\.") .. "([^a-zA-Z_@]|$)"
        local rg_cmd = string.format("rg -l %s %s | head -n 1", vim.fn.shellescape(regex), vim.fn.shellescape(expanded_dir))
        local found_file = vim.fn.system(rg_cmd):gsub("%s+", "")
        
        if found_file ~= "" and file_exists(found_file) then
          log.info("rg encontró la definición de " .. cmd_name .. " en " .. found_file)
          local analyzer = require("arttexworkspace.parsers.macro_analyzer")
          local k = analyzer.analyze_file(found_file)
          if k and k.macros and k.macros[cmd_name] then
            -- ¡Se aprendió la estructura! Guardarla y reintentar perezosamente
            for _, pat in ipairs(k.macros[cmd_name]) do
              save_learned_macro(cmd_name, pat, config_path, config)
            end
            -- Volver a llamar a goto_file_under_cursor para que use el nuevo conocimiento
            vim.schedule(function() M.goto_file_under_cursor() end)
            return
          end
        end
      end
    end
  end

  -- Patrones comunes en LaTeX
  local patterns_to_test = {
    "%s.tex",
    "%s/%s.tex",
    "%s/CAPITULO.tex",
    "%s/main.tex",
    "%s/teoria.tex"
  }
  
  local current_dir = vim.fn.expand("%:p:h")
  local valid_options = {}
  
  for _, pat in ipairs(patterns_to_test) do
    local rel_target = string.format(pat, arg, arg)
    local path_root = project_root .. "/" .. rel_target
    local path_local = current_dir .. "/" .. rel_target
    
    if file_exists(path_root) then
      table.insert(valid_options, { pattern = pat, text = "󰈔 [Raíz] " .. rel_target, target = path_root })
    elseif file_exists(path_local) then
      table.insert(valid_options, { pattern = pat, text = "󰈔 [Local] " .. rel_target, target = path_local })
    end
  end
  
  -- Si encontramos exactamente UNA coincidencia válida, el plugin deduce automáticamente y aprende sin preguntar
  if #valid_options == 1 then
    save_learned_macro(cmd_name, valid_options[1].pattern, config_path, config)
    vim.cmd("edit " .. valid_options[1].target)
    vim.notify("ArtTeX: Macro \\" .. cmd_name .. " auto-deducida y aprendida con éxito.", vim.log.levels.INFO)
    return
  end
  
  -- Si hay múltiples o ninguna, construimos el menú interactivo
  local options = {}
  
  if #valid_options > 0 then
    for _, opt in ipairs(valid_options) do
      table.insert(options, {
        text = opt.text,
        action = function()
          save_learned_macro(cmd_name, opt.pattern, config_path, config)
          vim.cmd("edit " .. opt.target)
        end
      })
    end
  else
    -- Fallback si el archivo aún no existe en disco
    table.insert(options, { text = "󰈔 Crear en carpeta actual: " .. arg .. ".tex", action = function() save_learned_macro(cmd_name, "%s.tex", config_path, config); vim.cmd("edit " .. arg .. ".tex") end })
    table.insert(options, { text = "󰉋 Crear en subcarpeta: " .. arg .. "/" .. arg .. ".tex", action = function() save_learned_macro(cmd_name, "%s/%s.tex", config_path, config); vim.fn.mkdir(arg, "p"); vim.cmd("edit " .. arg .. "/" .. arg .. ".tex") end })
  end
  
  -- Siempre ofrecer la ruta manual como escape
  table.insert(options, {
    text = "󰌌 Definir patrón personalizado (Ej: docs/%s/texto.tex)...",
    action = function()
      vim.schedule(function()
        vim.ui.input({ prompt = "Patrón (Usa %s para '" .. arg .. "'): ", default = "%s.tex" }, function(input)
          if input and input ~= "" then
            save_learned_macro(cmd_name, input, config_path, config)
            local target = input:gsub("%%s", arg)
            vim.cmd("edit " .. target)
          end
        end)
      end)
    end
  })
  
  menu.create_menu({
    title = "¿Dónde va \\" .. cmd_name .. "?",
    prompt = { "IA: Analicé el disco duro.", #valid_options > 0 and "Encontré estos archivos reales:" or "El archivo '" .. arg .. "' aún no existe." },
    options = options
  })
end

-- Esta función secuestra el atajo `gf` o `gd` en Neovim
function M.goto_file_under_cursor(fallback_cmd)
  fallback_cmd = fallback_cmd or "gf"
  
  local fallback_action = function()
    if fallback_cmd == "gd" then
      if vim.lsp.buf.definition then
        vim.lsp.buf.definition()
      else
        vim.cmd("normal! gd")
      end
    else
      vim.cmd("normal! gf")
    end
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  
  -- Buscar el patrón de macro bajo el cursor, ej: \chapterfile{cinematica}
  local start_col = col
  while start_col >= 0 do
    if line:sub(start_col + 1, start_col + 1) == "\\" then break end
    start_col = start_col - 1
  end
  
  if start_col < 0 then
    fallback_action()
    return
  end
  
  local macro_match = line:sub(start_col + 1)
  local cmd_name, arg = macro_match:match("^\\(%a+)[^%}]-%{%s*([^%}]+)%s*%}")
  
  if not cmd_name or not arg then
    fallback_action()
    return
  end
  
  -- Limpiar espacios en blanco al inicio y al final del argumento
  arg = arg:match("^%s*(.-)%s*$")

  -- 1. Intentar resolver paquetes globales primero (no necesitan main_path)
  if cmd_name == "usepackage" or cmd_name == "RequirePackage" then
    local path = vim.fn.system("kpsewhich " .. arg .. ".sty"):gsub("%s+", "")
    if path ~= "" and file_exists(path) then
      vim.cmd("edit " .. vim.fn.fnameescape(path))
      return
    end
  elseif cmd_name == "documentclass" or cmd_name == "LoadClass" then
    local path = vim.fn.system("kpsewhich " .. arg .. ".cls"):gsub("%s+", "")
    if path ~= "" and file_exists(path) then
      vim.cmd("edit " .. vim.fn.fnameescape(path))
      return
    end
  end

  -- 2. Tenemos un macro local. Vamos a buscar si tenemos reglas para él.
  local main_path = require("arttexworkspace.core.state").get_main_from_buffer(vim.api.nvim_buf_get_name(0))
  if not main_path then
    vim.cmd("normal! gf")
    return
  end
  
  local project_root = vim.fn.fnamemodify(main_path, ":p:h")
  local basename = vim.fn.fnamemodify(main_path, ":t:r")
  local config_path = project_root .. "/." .. basename .. ".arttex.json"
  
  local config = { estructura_manual_usuario = {}, estructura_aprendida_ia = {} }
  if file_exists(config_path) then
    local f_in = io.open(config_path, "r")
    if f_in then
      local content = f_in:read("*all")
      f_in:close()
      local ok, parsed = pcall(vim.fn.json_decode, content)
      if ok and type(parsed) == "table" then
        config = parsed
      else
        vim.notify("ArtTex: ¡Error de .arttex.json!", vim.log.levels.ERROR)
        return
      end
    end
  end
  
  local custom_macros = {}
  if config.estructura_aprendida_ia then
    for k, v in pairs(config.estructura_aprendida_ia) do custom_macros[k] = v end
  end
  if config.estructura_manual_usuario then
    for k, v in pairs(config.estructura_manual_usuario) do custom_macros[k] = v end
  end
  
  -- Si el comando existe en nuestros macros personalizados, resolverlo
  local patterns = {}
  if custom_macros[cmd_name] then
    patterns = custom_macros[cmd_name]
  else
    -- Comportamiento fallback para comandos estándar locales
    if cmd_name == "input" or cmd_name == "include" or cmd_name == "subfile" then
      patterns = { "%s.tex", "%s" }
    else
      -- ¡IA Interactiva / Heurística!
      intelligent_fallback(cmd_name, arg, config_path, config, project_root)
      return
    end
  end
  
  local current_dir = vim.fn.expand("%:p:h")
  local valid_files = {}
  
  for _, pat in ipairs(patterns) do
    -- Soportar múltiples %s usando gsub en lugar de string.format
    local mapped = pat:gsub("%%s", arg)
    local p1 = current_dir .. "/" .. mapped
    local p2 = project_root .. "/" .. mapped
    
    if file_exists(p1) then
      table.insert(valid_files, vim.fn.resolve(p1))
    elseif file_exists(p2) then
      table.insert(valid_files, vim.fn.resolve(p2))
    elseif file_exists(mapped) then
      table.insert(valid_files, vim.fn.resolve(mapped))
    end
  end
  
  if #valid_files == 0 then
    log.warn("No se encontró ningún archivo para el macro \\" .. cmd_name .. "{" .. arg .. "}")
    return
  elseif #valid_files == 1 then
    -- Abrir el archivo inmediatamente
    vim.cmd("edit " .. vim.fn.fnameescape(valid_files[1]))
  else
    -- Múltiples archivos: Mostrar Menú Interactivo Flotante
    local options = {}
    for _, file in ipairs(valid_files) do
      table.insert(options, {
        text = "󰈔 " .. file:gsub(project_root .. "/", ""),
        action = function() vim.cmd("edit " .. vim.fn.fnameescape(file)) end
      })
    end
    
    menu.create_menu({
      title = "Archivos del Macro \\" .. cmd_name,
      prompt = { "¿Qué archivo deseas abrir?" },
      options = options
    })
  end
end

function M.setup()
  -- Configurar el atajo de teclado global para archivos tex (gf)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "tex", "plaintex" },
    callback = function(args)
      vim.keymap.set("n", "gf", function() M.goto_file_under_cursor("gf") end, { buffer = args.buf, silent = true, desc = "ArtTeX Go To File" })
      -- Mapeamos gd aquí por si no hay servidor LSP corriendo
      vim.keymap.set("n", "gd", function() M.goto_file_under_cursor("gd") end, { buffer = args.buf, silent = true, desc = "ArtTeX Go To Definition (File)" })
    end,
  })
  
  -- Secuestrar el atajo `gd` DESPUÉS de que el LSP se adjunte (para ganarle a TexLab)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local filetype = vim.bo[bufnr].filetype
      if filetype == "tex" or filetype == "plaintex" then
        vim.keymap.set("n", "gd", function() M.goto_file_under_cursor("gd") end, { buffer = bufnr, silent = true, desc = "ArtTeX Go To Definition" })
      end
    end,
  })
end

return M
