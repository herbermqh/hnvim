-- fs_cache.lua
-- Data Access Layer: Gestiona la lectura de archivos con caché basado en mtime
-- Minimiza el consumo de CPU y RAM al 100% si el archivo no ha sido modificado.
local M = {}

local cache = { files = {} }

--- Lee un archivo del disco de forma optimizada.
--- Solo lee si el archivo fue modificado (mtime) desde la última lectura.
--- @param filepath string Ruta absoluta al archivo
--- @return string|nil Contenido del archivo o nil si hubo error
function M.read_file_cached(filepath)
  local uv = vim.uv or vim.loop
  local stat = uv.fs_stat(filepath)
  local mtime = stat and stat.mtime.sec or 0
  
  -- Verificar caché en O(1)
  if cache.files[filepath] and cache.files[filepath].mtime == mtime then
    return cache.files[filepath].content
  end
  
  -- Cache miss: leer de disco
  local f = io.open(filepath, "r")
  if f then
    local content = f:read("*all")
    f:close()
    
    -- Actualizar caché
    cache.files[filepath] = {
      mtime = mtime,
      content = content
    }
    return content
  end
  
  return nil
end

--- Itera sobre el árbol del proyecto para archivos con una extensión específica
--- y devuelve un iterador de contenidos cacheados.
--- @param project_tree table Lista de rutas absolutas
--- @param extension string Extensión a buscar (ej: "%.bib$")
--- @return function Iterador que devuelve (filepath, content)
function M.iter_cached_files(project_tree, extension)
  local i = 0
  local n = #project_tree
  
  return function()
    while i < n do
      i = i + 1
      local filepath = project_tree[i]
      if filepath:match(extension) then
        local content = M.read_file_cached(filepath)
        if content then
          return filepath, content
        end
      end
    end
    return nil
  end
end

return M
