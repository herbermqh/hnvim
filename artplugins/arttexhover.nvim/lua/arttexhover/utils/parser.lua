-- parser.lua
-- Utility Layer: Contiene la lógica para extraer macros y texto bajo el cursor
local M = {}

--- Extrae el texto dentro de { ... } donde está el cursor, y el macro que lo invoca.
--- Ejemplo: línea = "Hola \cite{autor2023, otro}", cursor = "o" -> devuelve "cite", "autor2023" o "otro"
--- @return string|nil macro El comando que encierra el cursor
--- @return string|nil key La llave bajo el cursor
function M.get_context_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-indexed
  
  local cursor_ctx = nil
  local cursor_key = nil
  
  local start_idx = 1
  while true do
    -- Encuentra el inicio de un macro: ej \cite{ o \cite[opt]{
    local m_start, m_end, macro, options, keys = line:find("\\([%a@_]+)%*?%s*(%[?[^%]]*%]?)%s*%{([^}]*)%}", start_idx)
    if not m_start then break end
    
    local keys_start = m_end - #keys
    local keys_end = m_end - 1
    
    if col >= keys_start and col <= keys_end then
      local local_col = col - keys_start + 1
      local key_start = 1
      
      for k in string.gmatch(keys, "([^,]+)") do
        local k_trim = vim.trim(k)
        local find_start, find_end = keys:find(k, key_start, true)
        
        if local_col >= find_start and local_col <= find_end then
          cursor_ctx = macro
          cursor_key = k_trim
          break
        end
        key_start = find_end + 1
      end
      
      if not cursor_key then
        cursor_ctx = macro
        for k in string.gmatch(keys, "([^,]+)") do
          cursor_key = vim.trim(k)
          break
        end
      end
      break
    end
    start_idx = m_end + 1
  end
  
  return cursor_ctx, cursor_key
end

return M
