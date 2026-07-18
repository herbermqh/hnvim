local M = {}

local uv = vim.uv or vim.loop
local function fast_resolve(path)
  return uv.fs_realpath(path) or path
end

local function file_exists(path)
  local stat = (vim.uv or vim.loop).fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

local function is_private_file(abs_path, root_dir)
  if abs_path:sub(1, #root_dir) == root_dir then return true end
  local sys_keywords = { "texmf%-dist", "texlive", "miktex", "mactex", "texmf%-local", "/usr/", "/opt/", "/var/lib/" }
  local lower_path = abs_path:lower()
  for _, kw in ipairs(sys_keywords) do
    if lower_path:match(kw) then return false end
  end
  return true
end

-- 1. Parse FLS File (The absolute truth from the compiler)
-- Filtra automáticamente archivos públicos/del sistema
local function parse_fls(fls_path, root_dir)
  local f = io.open(fls_path, "r")
  if not f then return nil end
  local deps = {}
  for line in f:lines() do
    local input_path = line:match("^INPUT%s+(.*)$")
    if input_path then
      if input_path:match("%.tex$") or input_path:match("%.cls$") or input_path:match("%.sty$") or input_path:match("%.def$") then
        local abs_path = fast_resolve(input_path)
        -- Solo aceptar archivos PRIVADOS (del usuario o librerías personales)
        if file_exists(abs_path) and is_private_file(abs_path, root_dir) then
          deps[abs_path] = true
        end
      end
    end
  end
  f:close()
  local list = {}
  for k, _ in pairs(deps) do table.insert(list, k) end
  return list
end

local semantic_parser = require("arttexworkspace.parsers.semantic")

-- 3. Write dummy FLS for TexLab
-- This forces TexLab to understand custom structures even before latexmk runs!
local function write_dummy_fls(fls_path, deps)
  local f = io.open(fls_path, "w")
  if f then
    for _, dep in ipairs(deps) do
      f:write("INPUT " .. dep .. "\n")
    end
    f:close()
  end
end

--- Devuelve la lista de dependencias de un proyecto (archivos .tex)
--- y el método usado ("fls" o "semantic")
function M.get_dependencies(main_path)
  local fls_path = main_path:gsub("%.tex$", ".fls")
  
  local final_deps = {}
  local deps_map = {}
  local method = "semantic"
  
  -- Prioridad 1: Configuración unificada (.arttex.json aisalada por main) y Parseo Semántico
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
        -- Preserve ALL existing properties (like `compiler` from arttexcompiler)
        for k, v in pairs(parsed) do
          config[k] = v
        end
        config.estructura_manual_usuario = parsed.estructura_manual_usuario or {}
        config.estructura_aprendida_ia = parsed.estructura_aprendida_ia or {}
        config.packages = parsed.packages or {}
        config.commands = parsed.commands or {}
        config.environments = parsed.environments or {}
        config.counters = parsed.counters or {}
        config.lengths = parsed.lengths or {}
      else
        -- ¡ABORTAR! El JSON tiene un error de sintaxis, no podemos sobreescribirlo o borraremos el contenido manual
        return nil
      end
    end
  end
  
  local semantic_deps, semantic_tree = semantic_parser.parse(main_path, config)
  if semantic_deps then
    for _, dep in ipairs(semantic_deps) do
      deps_map[dep] = true
    end
  end
  
  -- Prioridad 2: Fusionar con FLS (Bitácora del compilador)
  if file_exists(fls_path) then
    local fls_deps = parse_fls(fls_path, project_root)
    if fls_deps and #fls_deps > 1 then 
      method = "hybrid (fls + semantic)"
      for _, dep in ipairs(fls_deps) do
        deps_map[dep] = true
      end
    end
  end
  
  -- Convertir a lista
  for dep, _ in pairs(deps_map) do
    table.insert(final_deps, dep)
  end
  
  -- Sincronizar el árbol resuelto de vuelta al JSON (Caché de Estructura)
  config.project_tree = final_deps
  local f_out = io.open(config_path, "w")
  if f_out then
    f_out:write(require("arttexworkspace.core.json").encode(config))
    f_out:close()
  end
  

  
  -- Generar FLS Sintético para inyectar la estructura actualizada a TexLab
  if final_deps and #final_deps > 0 then
    write_dummy_fls(fls_path, final_deps)
  end
  
  return final_deps, method, semantic_tree
end

return M
