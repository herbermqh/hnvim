local M = {}
local uv = vim.uv or vim.loop
local log = require("arttexworkspace.core.log")

local function fast_resolve(path, root_dir)
  if path:match("^/") then return uv.fs_realpath(path) end
  return uv.fs_realpath(root_dir .. "/" .. path)
end

function M.trace_contexts(main_path, macros)
  local preamble_files = {}
  local body_files = {}
  local visited = {}
  local in_body = false
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  
  local function traverse(filepath)
    if not filepath then return end
    local abs_path = fast_resolve(filepath, root_dir) or filepath
    if visited[abs_path] then return end
    visited[abs_path] = true
    
    if in_body then
      body_files[abs_path] = true
    else
      preamble_files[abs_path] = true
    end
    
    local f = io.open(abs_path, "r")
    if not f then return end
    local content = f:read("*a")
    f:close()
    
    -- Necesitamos iterar en orden. Buscaremos la posición de las cosas.
    -- Podemos buscar todas las apariciones de \begin{document}, \input, \include y macros.
    local tokens = {}
    
    local b_start, b_end = content:find("\\begin%s*{document}")
    if b_start then
      table.insert(tokens, { pos = b_start, type = "begin_doc" })
    end
    
    -- input e include
    for s, cmd, arg in content:gmatch("()\\([a-zA-Z]*input)%s*%{([^%}]*)%}") do
      table.insert(tokens, { pos = s, type = "include", arg = arg })
    end
    for s, cmd, arg in content:gmatch("()\\([a-zA-Z]*include)%s*%{([^%}]*)%}") do
      table.insert(tokens, { pos = s, type = "include", arg = arg })
    end
    for s, cmd, arg in content:gmatch("()\\(subfile)%s*%{([^%}]*)%}") do
      table.insert(tokens, { pos = s, type = "include", arg = arg })
    end
    
    -- Macros customizadas
    if macros then
      for mac_name, patterns in pairs(macros) do
        -- mac_name es tipo "chapterfile"
        -- Escapamos para el regex
        local safe_mac = mac_name:gsub("%.", "%%.")
        for s, arg in content:gmatch("()\\" .. safe_mac .. "%s*%{([^%}]*)%}") do
          for _, pat in ipairs(patterns) do
            local resolved_arg = pat:gsub("%%s", arg)
            table.insert(tokens, { pos = s, type = "include", arg = resolved_arg })
          end
        end
      end
    end
    
    -- Ordenar por posición
    table.sort(tokens, function(a, b) return a.pos < b.pos end)
    
    for _, tok in ipairs(tokens) do
      if tok.type == "begin_doc" then
        in_body = true
      elseif tok.type == "include" then
        local target = tok.arg
        if not target:match("%.tex$") and not target:match("%.sty$") and not target:match("%.cls$") then
          target = target .. ".tex"
        end
        local prev_state = in_body
        traverse(target)
        in_body = prev_state -- restaurar estado al volver del archivo incluido (aunque típicamente in_body = true es global una vez activado, en LaTeX begin{document} es global)
        -- Corrección: en LaTeX, \begin{document} es global. Una vez que in_body es true, NUNCA vuelve a false.
        if in_body then
           -- Si se volvió true dentro del traverse, se queda true.
        end
      end
    end
  end
  
  traverse(main_path)
  
  -- Convertir a listas relativas o absolutas
  local p_list = {}
  local b_list = {}
  for f, _ in pairs(preamble_files) do table.insert(p_list, f) end
  for f, _ in pairs(body_files) do table.insert(b_list, f) end
  
  return p_list, b_list
end

return M
