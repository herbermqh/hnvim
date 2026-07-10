--- Módulo para extraer ecuaciones matemáticas bajo el cursor.
--- @class arttexpreview.extractor
local M = {}

--- Obtiene la ecuación matemática bajo el cursor
--- @return string|nil, number|nil, number|nil # La ecuación, start_row, end_row
function M.get_math_at_cursor()
  local ok_ts, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if ok_ts then
    local node = ts_utils.get_node_at_cursor()
    while node do
      local type = node:type()
      if type == "math_environment" or type == "inline_formula" or type == "displayed_equation" then
        local bufnr = vim.api.nvim_get_current_buf()
        local text = vim.treesitter.get_node_text(node, bufnr)
        local start_row, _, end_row, _ = node:range()
        return text, start_row, end_row + 1
      end
      node = node:parent()
    end
  end
  
  return nil, nil, nil
end

--- Extrae la ruta de una imagen bajo el cursor (e.g. \includegraphics{ruta.png})
--- @return string|nil # La ruta del archivo o nil
function M.get_image_at_cursor()
  local line = vim.api.nvim_get_current_line()
  
  -- Buscar \includegraphics[...]{ruta} o \includegraphics{ruta}
  local ruta = line:match("\\includegraphics%[[^%]]*%]{([^}]+)}")
  if not ruta then
    ruta = line:match("\\includegraphics{([^}]+)}")
  end
  
  -- Si no es LaTeX, buscar cualquier cadena que parezca una ruta de imagen
  if not ruta then
    ruta = line:match("[\"']([^\"']+\\.png)[\"']") or 
           line:match("[\"']([^\"']+\\.jpg)[\"']") or 
           line:match("[\"']([^\"']+\\.jpeg)[\"']")
  end
  
  if ruta then
    -- Expandir ruta si es relativa
    if not ruta:match("^/") and not ruta:match("^~") then
      local current_dir = vim.fn.expand("%:p:h")
      ruta = current_dir .. "/" .. ruta
    end
    ruta = vim.fn.expand(ruta)
    return ruta
  end
  
  return nil
end

return M
