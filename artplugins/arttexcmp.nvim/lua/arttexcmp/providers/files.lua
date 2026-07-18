local M = {}
local cmp = require("cmp")
local workspace = require("arttexworkspace")

function M.get_files(bufnr, ext, callback)
  local config = workspace.api.get_project_config(bufnr)
  if not config or not config.project_tree then
    callback({})
    return
  end
  
  local root_dir = workspace.api.get_root_dir(bufnr)
  if not root_dir then
    callback({})
    return
  end
  
  local items = {}
  local seen = {}
  
  for _, filepath in ipairs(config.project_tree) do
    if filepath:match("%." .. ext .. "$") then
      -- Obtener ruta relativa al root para una mejor presentación
      local rel_path = filepath
      if filepath:sub(1, #root_dir) == root_dir then
        rel_path = filepath:sub(#root_dir + 2)
      end
      
      -- Para input/include normalmente no se pone la extensión
      local insert_text = rel_path
      if ext == "tex" then
        insert_text = rel_path:gsub("%.tex$", "")
      end
      
      if not seen[insert_text] then
        seen[insert_text] = true
        table.insert(items, {
          label = rel_path,
          insertText = insert_text,
          kind = cmp.lsp.CompletionItemKind.File,
          detail = "Archivo (" .. ext .. ")"
        })
      end
    end
  end
  
  callback(items)
end

return M
