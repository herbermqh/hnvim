local M = {}
local cmp = require("cmp")
local workspace = require("arttexworkspace")

-- Caché por archivo para no re-parsear documentos no modificados
local cache = { files = {}, last_update = 0 }

function M.get_labels(bufnr, callback)
  local config = workspace.api.get_project_config(bufnr)
  if not config or not config.project_tree then
    callback({})
    return
  end
  
  -- Caché por archivo para mínimo consumo de CPU/RAM
  local items = {}
  local seen = {}
  local uv = vim.uv or vim.loop
  
  -- Iterar solo sobre los archivos realmente mapeados en el proyecto (ignorar node_modules, .git, etc.)
  for _, filepath in ipairs(config.project_tree) do
    if filepath:match("%.tex$") then
      local stat = uv.fs_stat(filepath)
      local mtime = stat and stat.mtime.sec or 0
      
      -- Si el archivo ya está en caché y no ha sido modificado, usamos las etiquetas en caché
      if cache.files[filepath] and cache.files[filepath].mtime == mtime then
        for _, label in ipairs(cache.files[filepath].labels) do
          if not seen[label] then
            seen[label] = true
            table.insert(items, {
              label = label,
              kind = cmp.lsp.CompletionItemKind.Reference,
              detail = "Etiqueta (ArtTeX)"
            })
          end
        end
      else
        -- Archivo modificado o nuevo, lo leemos
        local f = io.open(filepath, "r")
        if f then
          local content = f:read("*all")
          f:close()
          
          local file_labels = {}
          for label in content:gmatch("\\label%{([^}]+)%}") do
            table.insert(file_labels, label)
            if not seen[label] then
              seen[label] = true
              table.insert(items, {
                label = label,
                kind = cmp.lsp.CompletionItemKind.Reference,
                detail = "Etiqueta (ArtTeX)"
              })
            end
          end
          
          -- Actualizar caché
          cache.files[filepath] = {
            mtime = mtime,
            labels = file_labels
          }
        end
      end
    end
  end
  
  cache.last_update = os.time()
  callback(items)
end

return M
