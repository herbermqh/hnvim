local M = {}

local function file_exists(path)
  local f = io.open(path, "r")
  if f then io.close(f) return true else return false end
end

function M.parse(main_path, config)
  local visited = {}
  local deps = {}
  local project_root = vim.fn.fnamemodify(main_path, ":p:h")

  local custom_macros = {}
  
  -- Fusionar configuración unificada (Prioridad: manual > auto)
  if config.estructura_aprendida_ia then
    for k, v in pairs(config.estructura_aprendida_ia) do
      custom_macros[k] = v
    end
  end
  
  if config.estructura_manual_usuario then
    for k, v in pairs(config.estructura_manual_usuario) do
      custom_macros[k] = v -- Sobreescribe/Prioriza el manual
    end
  end
  
  -- Para compatibilidad hacia atrás o macros simples
  local resolve_patterns = config.resolve_patterns or {
    "%s.tex",
    "%s/CAPITULO.tex"
  }
  local custom_includes = config.custom_includes or { "chapterfile", "subfile", "import" }
  local inc_map = {}
  for _, v in ipairs(custom_includes) do inc_map[v] = true end
  inc_map["input"] = true
  inc_map["include"] = true

  local function parse_file(filepath)
    if visited[filepath] then return end
    visited[filepath] = true
    table.insert(deps, filepath)

    local f = io.open(filepath, "r")
    if not f then return end

    local content = f:read("*all")
    f:close()
    if not content then return end

    local includes = {}
    
    -- Extraer macros normales (con o sin comentario, como la lectura es masiva, el patrón gmatch lo encuentra súper rápido en C)
    for cmd, file in content:gmatch("\\(%a+)%s*%{%s*([^%}]+)%s*%}") do
      if inc_map[cmd] or custom_macros[cmd] then
        table.insert(includes, {cmd = cmd, file = file})
      end
    end
    
    -- Extraer macros comentados sin barra (ej: %chapterfile{...})
    for cmd, file in content:gmatch("%%%s*(%a+)%s*%{%s*([^%}]+)%s*%}") do
      if inc_map[cmd] or custom_macros[cmd] then
        table.insert(includes, {cmd = cmd, file = file})
      end
    end

    local dir = vim.fn.fnamemodify(filepath, ":p:h")
    
    for _, file_req in ipairs(includes) do
      local cmd_name = file_req.cmd
      local target_file = file_req.file
      
      -- Determinar los patrones a usar para este macro
      local active_patterns = resolve_patterns
      if custom_macros[cmd_name] then
        active_patterns = custom_macros[cmd_name]
      end
      
      -- Resolver para cada patrón (puede haber múltiples si el macro llama a múltiples \inputs internos)
      for _, pat in ipairs(active_patterns) do
        -- Reemplazamos todos los %s por el target_file usando gsub (Soporta múltiples %s)
        local mapped = pat:gsub("%%s", target_file)
        local p1 = dir .. "/" .. mapped
        local p2 = project_root .. "/" .. mapped
        
        local abs_path = nil
        if file_exists(p1) then
          abs_path = vim.fn.resolve(p1)
        elseif file_exists(p2) then
          abs_path = vim.fn.resolve(p2)
        elseif file_exists(mapped) then
          abs_path = vim.fn.resolve(mapped)
        end
        
        if abs_path then
          parse_file(abs_path)
        end
      end
    end
  end
  
  parse_file(main_path)
  return deps
end

return M
