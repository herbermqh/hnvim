local M = {}

-- Función para serializar una tabla de Lua a JSON con formato (Pretty Print)
function M.encode(tbl, indent)
  indent = indent or ""
  local next_indent = indent .. "  "
  
  if type(tbl) == "string" then
    -- Escapar primero barras invertidas, luego comillas
    local escaped = tbl:gsub('\\', '\\\\'):gsub('"', '\\"')
    return '"' .. escaped .. '"'
  elseif type(tbl) == "number" or type(tbl) == "boolean" then
    return tostring(tbl)
  elseif type(tbl) == "table" then
    -- Check if it's an array
    local is_array = true
    local max = 0
    for k, _ in pairs(tbl) do
      if type(k) ~= "number" then
        is_array = false
        break
      end
      if k > max then max = k end
    end
    
    if is_array then
      if max == 0 then return "[]" end
      local str = "[\n"
      for i = 1, max do
        str = str .. next_indent .. M.encode(tbl[i], next_indent)
        if i < max then str = str .. "," end
        str = str .. "\n"
      end
      return str .. indent .. "]"
    else
      local keys = {}
      for k, _ in pairs(tbl) do table.insert(keys, k) end
      if #keys == 0 then return "{}" end
      
      -- Prioridad de ordenamiento para que el usuario siempre vea lo más importante arriba
      local priority = {
        estructura_manual_usuario = 1,
        estructura_aprendida_ia = 2,
        project_tree = 3,
        packages = 4,
        commands = 5,
        environments = 6,
        counters = 7,
        lengths = 8
      }
      
      table.sort(keys, function(a, b)
        local pa = priority[a] or 99
        local pb = priority[b] or 99
        if pa ~= pb then
          return pa < pb
        else
          return tostring(a) < tostring(b)
        end
      end)
      
      local str = "{\n"
      for i, k in ipairs(keys) do
        str = str .. next_indent .. '"' .. tostring(k) .. '": ' .. M.encode(tbl[k], next_indent)
        if i < #keys then str = str .. "," end
        str = str .. "\n"
      end
      return str .. indent .. "}"
    end
  else
    return "null"
  end
end

return M
