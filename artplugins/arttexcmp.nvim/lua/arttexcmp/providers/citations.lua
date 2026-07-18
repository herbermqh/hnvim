local M = {}
local cmp = require("cmp")
local workspace = require("arttexworkspace")

-- Caché por archivo para no re-parsear bibliografías grandes no modificadas
local cache = { files = {}, last_update = 0 }

function M.get_citations(bufnr, callback)
  local config = workspace.api.get_project_config(bufnr)
  if not config or not config.project_tree then
    callback({})
    return
  end
  
  local items = {}
  local seen = {}
  local uv = vim.uv or vim.loop
  
  for _, filepath in ipairs(config.project_tree) do
    if filepath:match("%.bib$") then
      local stat = uv.fs_stat(filepath)
      local mtime = stat and stat.mtime.sec or 0
      
      if cache.files[filepath] and cache.files[filepath].mtime == mtime then
        for _, key in ipairs(cache.files[filepath].keys) do
          if not seen[key] then
            seen[key] = true
            table.insert(items, {
              label = key,
              kind = cmp.lsp.CompletionItemKind.Reference,
              detail = "Cita Bibliográfica"
            })
          end
        end
      else
        local f = io.open(filepath, "r")
        if f then
          local content = f:read("*all")
          f:close()
          
          local file_keys = {}
          for key in content:gmatch("@%a+%s*%{%s*([^,]+)%s*,") do
            table.insert(file_keys, key)
            if not seen[key] then
              seen[key] = true
              table.insert(items, {
                label = key,
                kind = cmp.lsp.CompletionItemKind.Reference,
                detail = "Cita Bibliográfica"
              })
            end
          end
          
          cache.files[filepath] = {
            mtime = mtime,
            keys = file_keys
          }
        end
      end
    end
  end
  
  cache.last_update = os.time()
  callback(items)
end

return M
