local M = {}

local uv = vim.uv or vim.loop

local function fast_resolve(path)
  return uv.fs_realpath(path) or path
end

local function file_exists(path)
  local stat = uv.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

local function dir_exists(path)
  local stat = uv.fs_stat(path)
  return stat ~= nil and stat.type == "directory"
end

local state = require("arttexworkspace.core.state")



local local_packages_cache = nil
local function get_local_packages()
  if not local_packages_cache then
    local_packages_cache = {}
    if vim.fn.executable("rg") == 1 then
      local plugin_config = require("arttexworkspace.core.config").options
      local library_paths = plugin_config.library_paths or {}
      
      for _, search_dir in ipairs(library_paths) do
        local expanded_dir = vim.fn.expand(search_dir)
        if dir_exists(expanded_dir) then
          local rg_cmd = string.format("rg -j 1 --files -g '*.sty' -g '*.cls' -g '*.def' %s", vim.fn.shellescape(expanded_dir))
          local output = vim.fn.system(rg_cmd)
          if vim.v.shell_error == 0 and type(output) == "string" then
            for p in output:gmatch("[^\r\n]+") do
              local clean_path = p:gsub("^%s*(.-)%s*$", "%1")
              local basename = clean_path:match("([^/]+)$")
              if basename then
                local_packages_cache[basename] = clean_path
              end
            end
          end
        end
      end
    end
  end
  return local_packages_cache
end

function M.parse(main_path, config)
  local visited = {}
  local deps = {}
  local project_root = vim.fn.fnamemodify(main_path, ":p:h")

  local custom_macros = {}
  
  if config.estructura_aprendida_ia then
    for k, v in pairs(config.estructura_aprendida_ia) do
      custom_macros[k] = v
    end
  end
  
  if config.estructura_manual_usuario then
    for k, v in pairs(config.estructura_manual_usuario) do
      custom_macros[k] = v
    end
  end
  
  local resolve_patterns = config.resolve_patterns or { "%s.tex", "%s/CAPITULO.tex" }
  local custom_includes = config.custom_includes or { "chapterfile", "subfile", "import", "subimport", "includefrom", "subincludefrom" }
  local inc_map = {}
  for _, v in ipairs(custom_includes) do inc_map[v] = true end
  inc_map["input"] = true
  inc_map["include"] = true
  
  local asset_macros = config.asset_macros or {
    includegraphics = { "%s.png", "%s.jpg", "%s.jpeg", "%s.pdf", "%s" },
    addbibresource = { "%s.bib", "%s" },
    bibliography = { "%s.bib", "%s" }
  }

  local package_macros = config.package_macros or {
    documentclass = { "%s.cls" },
    LoadClass = { "%s.cls" },
    usepackage = { "%s.sty" },
    RequirePackage = { "%s.sty" }
  }

  local function parse_file(filepath, is_commented)
    if visited[filepath] then return nil end
    visited[filepath] = true
    table.insert(deps, filepath)
    
    local node = {
      filepath = filepath,
      is_commented = is_commented or false,
      children = {},
      resolved_includes = {},
      is_asset = false
    }

    local stat = uv.fs_stat(filepath)
    local mtime = stat and stat.mtime.sec or 0
    local cached = state.file_nodes[filepath]

    if not cached or cached.mtime ~= mtime then
      local includes = {}
      local defs = {}
      
      local f = io.open(filepath, "r")
      if f then
        local raw_content = f:read("*all")
        f:close()
        if raw_content then
          -- Strip verbatim environments before parsing so we don't extract fake macros/includes
          local verbatim_envs = config.verbatim_envs or require("arttexworkspace.core.config").options.verbatim_envs or {}
          local content = require("arttexworkspace.parsers.verbatim").strip_verbatim(raw_content, verbatim_envs)
          
          -- Extraer definiciones de comandos y entornos (Símbolos Locales)
          local lnum = 0
          
          -- Optimización CPU/RAM: Tablas Hash (O(1)) para búsquedas rápidas en lugar de iterar arrays
          local cmd_kws_set = {
            newcommand = true, renewcommand = true, providecommand = true,
            DeclareDocumentCommand = true, NewDocumentCommand = true, ProvideDocumentCommand = true,
            DeclareMathOperator = true
          }
          local env_kws_set = {
            newenvironment = true, renewenvironment = true,
            NewDocumentEnvironment = true, DeclareDocumentEnvironment = true, ProvideDocumentEnvironment = true
          }

          for line in content:gmatch("([^\n]*)\n?") do
            lnum = lnum + 1
            
            -- Súper optimización: Si no hay backslash, es texto puro. Omitimos la línea entera.
            if line:find("\\", 1, true) then
              -- Extraer comandos tipo \newcommand{\name} o \newcommand\name
              for kw, arg in line:gmatch("\\([a-zA-Z@_]+)%*?%s*[{]?%s*\\([a-zA-Z@_]+)[}]?") do
                if cmd_kws_set[kw] then
                  table.insert(defs, { name = arg, line = lnum, type = "command" })
                end
              end
              
              -- Extraer \def\name y \let\name
              for cmd in line:gmatch("\\def%s*\\([a-zA-Z@_]+)") do table.insert(defs, { name = cmd, line = lnum, type = "command" }) end
              for cmd in line:gmatch("\\let%s*\\([a-zA-Z@_]+)") do table.insert(defs, { name = cmd, line = lnum, type = "command" }) end
              
              -- Extraer entornos tipo \newenvironment{name}
              for kw, env in line:gmatch("\\([a-zA-Z@_]+)%*?%s*[{]%s*([a-zA-Z@_]+)%s*[}]") do
                if env_kws_set[kw] then
                  table.insert(defs, { name = env, line = lnum, type = "environment" })
                end
              end
            end
          end

          local dir = vim.fn.fnamemodify(filepath, ":p:h")
          local function add_include(cmd, file, commented)
            if package_macros[cmd] then
              for part in file:gmatch("[^,]+") do
                local clean_part = vim.trim(part)
                if clean_part ~= "" then
                  table.insert(includes, {cmd = cmd, file = clean_part, commented = commented, is_asset = false})
                end
              end
            elseif inc_map[cmd] or custom_macros[cmd] then
              table.insert(includes, {cmd = cmd, file = vim.trim(file), commented = commented, is_asset = false})
            elseif asset_macros[cmd] then
              table.insert(includes, {cmd = cmd, file = vim.trim(file), commented = commented, is_asset = true})
            else
              -- HEURÍSTICA CERO-CONFIGURACIÓN (Zero-config inference):
              -- Si el macro es desconocido, pero su argumento coincide exactamente con un archivo local,
              -- asumimos que es un macro de inclusión (como \foreachproblem[EJERCICIOS]).
              local clean_file = vim.trim(file)
              -- Excluir textos largos o con espacios, un nombre de archivo no suele tener espacios en LaTeX puro
              if clean_file ~= "" and not clean_file:match("%s") and clean_file:len() < 50 then
                local test_path = clean_file
                if not test_path:match("%.(%w+)$") then test_path = test_path .. ".tex" end
                local full_test = dir .. "/" .. test_path
                if file_exists(full_test) then
                  table.insert(includes, {cmd = cmd, file = clean_file, commented = commented, is_asset = false})
                end
              end
            end
          end
          
          -- Extraer llaves balanceadas
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
          
          -- Escanear todo el contenido buscando macros estructurales, incluso si están anidados
          local pos = 1
          while pos <= #content do
            local start_idx, finish_idx, cmd = content:find("\\([a-zA-Z_@]+)%s*", pos)
            if not start_idx then break end
            
            -- Saltar posibles opciones [...] y extraer su valor
            local bracket_pos = finish_idx + 1
            local opt_arg = nil
            local char_after = content:sub(bracket_pos, bracket_pos)
            if char_after == "[" then
              local close_bracket = content:find("]", bracket_pos)
              if close_bracket then
                opt_arg = content:sub(bracket_pos + 1, close_bracket - 1)
                bracket_pos = close_bracket + 1
              end
            end
            
            -- Buscar dónde abren las llaves
            local brace_start = content:find("{", bracket_pos)
            if brace_start and (brace_start - bracket_pos) < 5 then
              local arg, brace_end = extract_braces(content, brace_start)
              if arg then
                -- Comprobar si el macro estaba comentado
                local is_commented = false
                local i = start_idx - 1
                while i > 0 do
                  local c = content:sub(i, i)
                  if c == "\n" then break end
                  if c == "%" then
                    if i == 1 or content:sub(i-1, i-1) ~= "\\" then
                      is_commented = true
                    end
                  end
                  i = i - 1
                end
                
                -- Si es un import/subimport, requiere un segundo par de llaves
                if cmd:match("import$") then
                  local brace_start2 = content:find("{", brace_end + 1)
                  if brace_start2 and (brace_start2 - brace_end) < 5 then
                    local arg2, brace_end2 = extract_braces(content, brace_start2)
                    if arg2 then
                      add_include(cmd, arg .. arg2, is_commented)
                    end
                  end
                  pos = start_idx + 1
                else
                  if opt_arg then add_include(cmd, opt_arg, is_commented) end
                  add_include(cmd, arg, is_commented)
                  pos = start_idx + 1
                end
              else
                pos = start_idx + 1
              end
            else
              pos = start_idx + 1
            end
          end
        end
      end
      cached = { mtime = mtime, includes = includes, definitions = defs }
      state.file_nodes[filepath] = cached
    end

    node.definitions = cached.definitions

    local dir = vim.fn.fnamemodify(filepath, ":p:h")
    
    for _, file_req in ipairs(cached.includes) do
      local cmd_name = file_req.cmd
      local target_file = file_req.file
      
      local active_patterns = resolve_patterns
      if custom_macros[cmd_name] then
        active_patterns = custom_macros[cmd_name]
      elseif asset_macros[cmd_name] then
        active_patterns = asset_macros[cmd_name]
      elseif package_macros[cmd_name] then
        active_patterns = package_macros[cmd_name]
      end
      
      local is_custom_multi = custom_macros[cmd_name] ~= nil
      local seen_paths = {}
      
      for _, pat in ipairs(active_patterns) do
        local mapped = pat:gsub("%%s", target_file)
        local p1 = dir .. "/" .. mapped
        local p2 = project_root .. "/" .. mapped
        local p3 = nil
        
        if package_macros[cmd_name] then
          local cache = get_local_packages()
          if cache[mapped] then
            p3 = cache[mapped]
          end
        end
        
        local abs_path = nil
        if file_exists(p1) then abs_path = fast_resolve(p1)
        elseif file_exists(p2) then abs_path = fast_resolve(p2)
        elseif file_exists(mapped) then abs_path = fast_resolve(mapped)
        elseif p3 and file_exists(p3) then abs_path = fast_resolve(p3)
        end
        
        if abs_path and not seen_paths[abs_path] then
          seen_paths[abs_path] = true
          if file_req.is_asset then
            if not visited[abs_path] then
              visited[abs_path] = true
              table.insert(deps, abs_path)
            end
            local child_node = { filepath = abs_path, is_commented = is_commented or file_req.commented, children = {}, resolved_includes = {}, is_asset = true }
            node.resolved_includes = node.resolved_includes or {}
            
            if not node.resolved_includes[target_file] then
              node.resolved_includes[target_file] = child_node
            else
              if node.resolved_includes[target_file].filepath then
                node.resolved_includes[target_file] = { node.resolved_includes[target_file] }
              end
              table.insert(node.resolved_includes[target_file], child_node)
            end
            table.insert(node.children, child_node)
          else
            local child_node = parse_file(abs_path, is_commented or file_req.commented)
            if child_node then
              node.resolved_includes = node.resolved_includes or {}
              if not node.resolved_includes[target_file] then
                node.resolved_includes[target_file] = child_node
              else
                if node.resolved_includes[target_file].filepath then
                  node.resolved_includes[target_file] = { node.resolved_includes[target_file] }
                end
                table.insert(node.resolved_includes[target_file], child_node)
              end
              table.insert(node.children, child_node)
            end
          end
          
          if not is_custom_multi then
            break
          end
        end
      end
    end
    
    return node
  end
  
  local tree = parse_file(main_path, false)
  
  -- Extraer información del preámbulo para arttexcompiler
  local project = state.get_project(main_path)
  if project then
      local f = io.open(main_path, "r")
      if f then
        local raw_content = f:read("*all")
        f:close()
        
        local verbatim_envs = config.verbatim_envs or require("arttexworkspace.core.config").options.verbatim_envs or {}
        local content = require("arttexworkspace.parsers.verbatim").strip_verbatim(raw_content, verbatim_envs)
        
        local preamble = ""
        for line in content:gmatch("([^\n]*)\n?") do
          if line:match("\\begin{document}") then break end
          local engine = line:match("^%s*%%%s*!?%s*[tT][eE][xX]%s+[pP][rR][oO][gG][rR][aA][mM]%s*[=:]%s*(.+)%s*$")
          if engine then project.engine = engine end
          local clean_line = line:gsub("%%.*$", "")
          preamble = preamble .. " " .. clean_line
        end
      
      local class = preamble:match("\\documentclass%[?.-%]?%{([^}]+)%}")
      if class then project.document_class = class end
      
      for pkgs in preamble:gmatch("\\usepackage%[.-%]%{([^}]+)%}") do
        for pkg in pkgs:gmatch("[^,]+") do project.packages[vim.trim(pkg)] = true end
      end
      for pkgs in preamble:gmatch("\\usepackage%{([^}]+)%}") do
        for pkg in pkgs:gmatch("[^,]+") do project.packages[vim.trim(pkg)] = true end
      end
      local paths = preamble:match("\\graphicspath%{%s*(.-)%s*%}")
      if paths then
        for path in paths:gmatch("%{([^}]+)%}") do
          table.insert(project.graphicspath, path)
        end
      end
      
      if not project.ready then
        project.ready = true
        vim.schedule(function()
          pcall(vim.api.nvim_exec_autocmds, "User", {
            pattern = "ArtTexWorkspaceReady",
            data = { main_path = main_path }
          })
        end)
      end
    end
  end

  return deps, tree
end

return M
