local log = require("arttexworkspace.core.log")

local M = {}

local function file_exists(path)
  local f = io.open(path, "r")
  if f then io.close(f) return true else return false end
end

-- Función para extraer el contenido balanceado de llaves {}
local function extract_braces(text, start_pos)
  local open_braces = 0
  local end_pos = start_pos
  for i = start_pos, #text do
    local char = text:sub(i, i)
    if char == "{" then
      open_braces = open_braces + 1
    elseif char == "}" then
      open_braces = open_braces - 1
      if open_braces == 0 then
        end_pos = i
        break
      end
    end
  end
  if open_braces == 0 and end_pos > start_pos then
    return text:sub(start_pos + 1, end_pos - 1), end_pos
  end
  return nil, nil
end

-- Abre un archivo .cls, .sty o .tex y extrae Conocimiento del Proyecto
function M.analyze_file(filepath)
  local f = io.open(filepath, "r")
  if not f then return nil end
  
  local knowledge = { macros = {}, packages = {}, commands = {}, environments = {}, counters = {}, lengths = {} }
  local content = f:read("*all")
  f:close()
  
  -- Extraer paquetes (\usepackage{...} o \RequirePackage{...})
  -- Y clases (\documentclass, \LoadClass)
  local deps_to_check = {}
  
  local function add_deps(matches, ext)
    for pkgs in matches do
      for p in pkgs:gmatch("([^,%s]+)") do 
        knowledge.packages[p] = true
        table.insert(deps_to_check, p .. ext)
      end
    end
  end
  
  add_deps(content:gmatch("\\usepackage%s*%[.-%]%s*%{([^%}]+)%}"), ".sty")
  add_deps(content:gmatch("\\usepackage%s*%{([^%}]+)%}"), ".sty")
  add_deps(content:gmatch("\\RequirePackage%s*%[.-%]%s*%{([^%}]+)%}"), ".sty")
  add_deps(content:gmatch("\\RequirePackage%s*%{([^%}]+)%}"), ".sty")
  add_deps(content:gmatch("\\documentclass%s*%[.-%]%s*%{([^%}]+)%}"), ".cls")
  add_deps(content:gmatch("\\documentclass%s*%{([^%}]+)%}"), ".cls")
  add_deps(content:gmatch("\\LoadClass%s*%[.-%]%s*%{([^%}]+)%}"), ".cls")
  add_deps(content:gmatch("\\LoadClass%s*%{([^%}]+)%}"), ".cls")
  
  -- Informar sobre estas dependencias para que auto_generate_config pueda escanearlas si son privadas
  knowledge.raw_deps = deps_to_check
  knowledge.pending_aliases = {}
  
  -- Extraer comandos y macros estructurales usando extract_braces
  -- Detecta \newcommand, \renewcommand, \providecommand, \def, etc.
  local pos = 1
  while true do
    -- Buscar la próxima definición (cualquier comando que asigne macros)
    local s1, e1, c1 = content:find("\\[a-zA-Z]*[cC]ommand%s*%*?%s*[{]?%s*\\([%a_@]+)%s*[}]?", pos)
    local s2, e2, c2 = content:find("\\def%s*\\([%a_@]+)[^{]*", pos)
    
    local start_idx, cmd_start, cmd_name
    if s1 and s2 then
      if s1 < s2 then start_idx, cmd_start, cmd_name = s1, e1, c1 else start_idx, cmd_start, cmd_name = s2, e2, c2 end
    elseif s1 then start_idx, cmd_start, cmd_name = s1, e1, c1
    elseif s2 then start_idx, cmd_start, cmd_name = s2, e2, c2
    else break end
    
    local body_start = content:find("{", cmd_start)
    if body_start then
      local body_text, body_end = extract_braces(content, body_start)
      
      -- Ignorar especificadores cortos de LaTeX3 (ej: {m}, {O{}})
      if body_text and #body_text < 10 and not body_text:match("\\") then
        body_start = content:find("{", body_end)
        if body_start then
          body_text, body_end = extract_braces(content, body_start)
        end
      end
      
      if body_text then
        local has_inclusion = false
        
        -- Detectar \input, \include, \subfile, \import
        for inner_cmd, inner_arg in body_text:gmatch("\\([a-zA-Z]*input)%s*%{([^%}]*)%}") do
          has_inclusion = true
          knowledge.macros[cmd_name] = knowledge.macros[cmd_name] or {}
          local pattern = inner_arg:gsub("#%d", "%%s")
          if not pattern:match("%.tex$") then pattern = pattern .. ".tex" end
          table.insert(knowledge.macros[cmd_name], pattern)
        end
        for inner_cmd, inner_arg in body_text:gmatch("\\([a-zA-Z]*include)%s*%{([^%}]*)%}") do
          has_inclusion = true
          knowledge.macros[cmd_name] = knowledge.macros[cmd_name] or {}
          local pattern = inner_arg:gsub("#%d", "%%s")
          if not pattern:match("%.tex$") then pattern = pattern .. ".tex" end
          table.insert(knowledge.macros[cmd_name], pattern)
        end
        for inner_cmd, inner_arg in body_text:gmatch("\\(subfile)%s*%{([^%}]*)%}") do
          has_inclusion = true
          knowledge.macros[cmd_name] = knowledge.macros[cmd_name] or {}
          local pattern = inner_arg:gsub("#%d", "%%s")
          if not pattern:match("%.tex$") then pattern = pattern .. ".tex" end
          table.insert(knowledge.macros[cmd_name], pattern)
        end
        
        -- Detección de Alias (Si esta macro llama a OTRA macro ya conocida o por conocer)
        local function process_alias(inner_cmd, inner_arg)
          -- Guardar para resolución en segunda pasada
          knowledge.pending_aliases[cmd_name] = knowledge.pending_aliases[cmd_name] or {}
          table.insert(knowledge.pending_aliases[cmd_name], { cmd = inner_cmd, arg = inner_arg })
        end

        -- Caso 1: \macro{arg}
        for inner_cmd, inner_arg in body_text:gmatch("\\([a-zA-Z_@]+)%s*%{([^%}]*)%}") do
          process_alias(inner_cmd, inner_arg)
        end
        -- Caso 2: \macro[opt]{arg}
        for inner_cmd, inner_arg in body_text:gmatch("\\([a-zA-Z_@]+)%s*%[.-%]%s*%{([^%}]*)%}") do
          process_alias(inner_cmd, inner_arg)
        end
        
        if not has_inclusion then
          knowledge.commands[cmd_name] = true
        end
        pos = body_end
      else
        pos = cmd_start + 1
      end
    else
      pos = cmd_start + 1
    end
  end
  
  -- Extraer Entornos (\newenvironment{nombre})
  for env_name in content:gmatch("\\newenvironment%s*%*?%s*%{%s*([%a_]+)%s*%}") do
    knowledge.environments[env_name] = true
  end
  
  -- Extraer Contadores (\newcounter{nombre})
  for cnt_name in content:gmatch("\\newcounter%s*%{%s*([%a_]+)%s*%}") do
    knowledge.counters[cnt_name] = true
  end
  
  -- Extraer Longitudes (\newlength{\nombre})
  for len_name in content:gmatch("\\newlength%s*%{%s*\\([%a_]+)%s*%}") do
    knowledge.lengths[len_name] = true
  end
  
  return knowledge
end

-- Escanea el proyecto buscando archivos .cls, .sty, y .tex para auto-aprender
function M.auto_generate_config(main_path)
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  local basename = vim.fn.fnamemodify(main_path, ":t:r")
  local macros_found = {}
  local packages_found = {}
  local commands_found = {}
  local environments_found = {}
  local counters_found = {}
  local lengths_found = {}
  local global_pending_aliases = {}
  
  local function is_private_file(abs_path, root_dir)
    if abs_path:sub(1, #root_dir) == root_dir then return true end
    local sys_keywords = { "texmf%-dist", "texlive", "miktex", "mactex", "texmf%-local", "/usr/", "/opt/", "/var/lib/" }
    local lower_path = abs_path:lower()
    for _, kw in ipairs(sys_keywords) do
      if lower_path:match(kw) then return false end
    end
    return true
  end

  -- Leer configuración existente primero para usar el project_tree como fuente de archivos
  local config_path = root_dir .. "/." .. basename .. ".arttex.json"
  local default_manual = {
    _instruccion = "Si la IA no detecta cómo se enlazan tus módulos, defínelo aquí manualmente. Usa %s en lugar del argumento.",
    _ejemplo_de_uso = { ["miComandoPersonalizado"] = { "modulos/%s/main.tex", "caps/%s.tex" } }
  }
  local config = { estructura_manual_usuario = default_manual, estructura_aprendida_ia = {} }
  
  local f_in = io.open(config_path, "r")
  if f_in then
    local content = f_in:read("*all")
    f_in:close()
    local ok, parsed = pcall(vim.fn.json_decode, content)
    if ok and type(parsed) == "table" then
      for k, v in pairs(parsed) do
        config[k] = v
      end
      config.estructura_manual_usuario = parsed.estructura_manual_usuario or default_manual
      config.estructura_aprendida_ia = parsed.estructura_aprendida_ia or {}
      config.project_tree = parsed.project_tree or {}
      config.packages = parsed.packages or {}
      config.commands = parsed.commands or {}
      config.environments = parsed.environments or {}
      config.counters = parsed.counters or {}
      config.lengths = parsed.lengths or {}
    else
      -- ¡CRÍTICO! Si el JSON es inválido, ABORTAR
      vim.schedule(function()
        vim.notify("ArtTex: ¡Error de .arttex.json!", vim.log.levels.ERROR)
      end)
      return false
    end
  end

  local scanned_files = {}

  -- Caché global en memoria de todos los paquetes locales del usuario (O(1) lookup, 0 lag)
  local local_packages_cache = nil
  local function get_local_packages()
    if not local_packages_cache then
      local_packages_cache = {}
      if vim.fn.executable("rg") == 1 then
        local plugin_config = require("arttexworkspace.core.config").options
        local library_paths = plugin_config.library_paths or {}
        
        for _, search_dir in ipairs(library_paths) do
          local expanded_dir = vim.fn.expand(search_dir)
          if file_exists(expanded_dir) then
            -- Escaneo ultra rápido para encontrar todos los paquetes del usuario en este directorio
            local rg_cmd = string.format("rg --files -g '*.sty' -g '*.cls' -g '*.def' %s", vim.fn.shellescape(expanded_dir))
            local output = vim.fn.system(rg_cmd)
            for p in output:gmatch("[^\r\n]+") do
              local clean_path = p:gsub("^%s*(.-)%s*$", "%1")
              local basename = clean_path:match("([^/]+)$")
              if basename then
                local_packages_cache[basename] = local_packages_cache[basename] or {}
                table.insert(local_packages_cache[basename], clean_path)
              end
            end
          end
        end
      end
    end
    return local_packages_cache
  end

  local function process_file(path)
    if scanned_files[path] then return end
    scanned_files[path] = true
    local k = M.analyze_file(path)
    if k then
      if k.macros then for mac, v in pairs(k.macros) do macros_found[mac] = v end end
      if k.packages then for pkg, _ in pairs(k.packages) do packages_found[pkg] = true end end
      if k.commands then for cmd, _ in pairs(k.commands) do commands_found[cmd] = true end end
      if k.environments then for env, _ in pairs(k.environments) do environments_found[env] = true end end
      if k.counters then for cnt, _ in pairs(k.counters) do counters_found[cnt] = true end end
      if k.lengths then for len, _ in pairs(k.lengths) do lengths_found[len] = true end end
      if k.pending_aliases then
        for caller, callee_list in pairs(k.pending_aliases) do
          global_pending_aliases[caller] = global_pending_aliases[caller] or {}
          for _, c in ipairs(callee_list) do table.insert(global_pending_aliases[caller], c) end
        end
      end
      
      -- Resolución recursiva inteligente perezosa de dependencias locales (¡Caché O(1) ultrarrápida!)
      if k.raw_deps then
        local cache = get_local_packages()
        for _, dep_name in ipairs(k.raw_deps) do
          if cache[dep_name] then
            for _, resolved_path in ipairs(cache[dep_name]) do
              if file_exists(resolved_path) then
                process_file(resolved_path)
              end
            end
          end
        end
      end
    end
  end

  local function scan_dir(dir, depth)
    if depth > 2 then return end
    local handle = vim.loop.fs_scandir(dir)
    if not handle then return end
    while true do
      local name, type = vim.loop.fs_scandir_next(handle)
      if not name then break end
      if not name:match("^%.") and name ~= "build" and not name:match("^IMAGES") and not name:match("^JUPY") and not name:match("^wolframfile") then
        local path = dir .. "/" .. name
        if type == "directory" then
          scan_dir(path, depth + 1)
        elseif type == "file" and (name:match("%.cls$") or name:match("%.sty$") or name:match("%.tex$") or name:match("%.def$")) then
          process_file(path)
        end
      end
    end
  end
  
  -- Escanear los archivos que ya sabemos que pertenecen al proyecto
  if config.project_tree then
    for _, p in ipairs(config.project_tree) do
      if is_private_file(p, root_dir) then
        process_file(p)
      end
    end
  end
  
  -- Lógica principal: Intentar leer .fls para nuevos archivos
  local fls_path = main_path:gsub("%.tex$", ".fls")
  local fls_file = io.open(fls_path, "r")
  
  if fls_file then
    log.trace("Leyendo dependencias desde el archivo .fls para extracción profunda...")
    for line in fls_file:lines() do
      local input_path = line:match("^INPUT%s+(.*)$")
      if input_path then
        local abs_path = vim.fn.resolve(input_path)
        if is_private_file(abs_path, root_dir) then
          if abs_path:match("%.cls$") or abs_path:match("%.sty$") or abs_path:match("%.tex$") or abs_path:match("%.def$") then
            process_file(abs_path)
          end
        else
          local pkg_name = abs_path:match("([^/]+)%.sty$")
          if pkg_name then packages_found[pkg_name] = true end
        end
      end
    end
    fls_file:close()
  else
    if not config.project_tree or #config.project_tree == 0 then
      log.trace("Archivo .fls no encontrado y project_tree vacío. Cayendo a escaneo de directorio (Fallback).")
      scan_dir(root_dir, 0)
    end
  end
  
  -- Segunda Pasada Global: Resolver Alias de Macros
  local changed = true
  while changed do
    changed = false
    for caller, callees in pairs(global_pending_aliases) do
      for _, callee in ipairs(callees) do
        local inner_cmd = callee.cmd
        local inner_arg = callee.arg
        if macros_found[inner_cmd] then
          macros_found[caller] = macros_found[caller] or {}
          local already_has = {}
          for _, exist_pat in ipairs(macros_found[caller]) do already_has[exist_pat] = true end
          
          for _, inherited_pattern in ipairs(macros_found[inner_cmd]) do
            local pattern = inherited_pattern
            if not inner_arg:match("#%d") then
              pattern = inherited_pattern:gsub("%%s", inner_arg)
            end
            if not already_has[pattern] then
              table.insert(macros_found[caller], pattern)
              commands_found[caller] = nil -- Ya no es un comando simple, es una macro estructural
              changed = true
            end
          end
        end
      end
    end
    -- Limpiar los pendientes resueltos para no reprocesar innecesariamente si hay otra iteración
    if changed then
      -- Podríamos optimizar, pero el while es suficiente para propagar N niveles
    end
  end
  
  -- Actualizar conocimiento
  config.estructura_aprendida_ia = macros_found
  
  -- Convertir sets a listas para JSON
  local pkg_list = {}
  for pkg, _ in pairs(packages_found) do table.insert(pkg_list, pkg) end
  config.packages = pkg_list
  
  local cmd_list = {}
  for cmd, _ in pairs(commands_found) do table.insert(cmd_list, cmd) end
  config.commands = cmd_list
  
  local env_list = {}
  for env, _ in pairs(environments_found) do table.insert(env_list, env) end
  config.environments = env_list
  
  local cnt_list = {}
  for cnt, _ in pairs(counters_found) do table.insert(cnt_list, cnt) end
  config.counters = cnt_list
  
  local len_list = {}
  for len, _ in pairs(lengths_found) do table.insert(len_list, len) end
  config.lengths = len_list
  
  log.info("Knowledge Graph (Macros, Paquetes, Comandos) guardado en ." .. basename .. ".arttex.json.")
  
  -- Escribir JSON con formato (Pretty Print absoluto)
  local f_out = io.open(config_path, "w")
  if f_out then
    f_out:write(require("arttexworkspace.core.json").encode(config))
    f_out:close()
    return true
  end
  
  return false
end

return M
