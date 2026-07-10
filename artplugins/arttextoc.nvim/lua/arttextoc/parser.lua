local M = {}

M.levels = {
  part = -1,
  chapter = 0,
  section = 1,
  subsection = 2,
  subsubsection = 3,
  paragraph = 4,
  subparagraph = 5,
}

function M.get_valid_includes()
  local valid = { input = { "%s.tex" }, include = { "%s.tex" }, subfile = { "%s.tex" } }
  local ok, ws = pcall(require, "arttexworkspace")
  if ok and ws.api and ws.api.get_project_config then
    local bufnr = vim.api.nvim_get_current_buf()
    local config = ws.api.get_project_config(bufnr)
    
    local resolve_patterns = config.resolve_patterns or { "%s.tex", "%s/CAPITULO.tex" }
    
    if config.custom_includes then
      for _, v in ipairs(config.custom_includes) do valid[v] = resolve_patterns end
    end
    if config.estructura_manual_usuario then
      for k, v in pairs(config.estructura_manual_usuario) do valid[k] = v end
    end
    if config.estructura_aprendida_ia then
      for k, v in pairs(config.estructura_aprendida_ia) do valid[k] = v end
    end
  end
  return valid
end

--- Parsea un buffer de Neovim y extrae la estructura de secciones
--- @param bufnr number ID del buffer
--- @return table Lista de nodos de la tabla de contenidos
function M.parse_file(filepath, is_inherited_comment, visited, valid_includes)
  visited = visited or {}
  if visited[filepath] then return {} end
  visited[filepath] = true

  local toc_items = {}
  local file = io.open(filepath, "r")
  if not file then return toc_items end
  
  local main_plugin = require("arttextoc")
  local custom_levels = (main_plugin.opts and main_plugin.opts.custom_levels) or {}
  local dir = vim.fn.fnamemodify(filepath, ":p:h")
  valid_includes = valid_includes or M.get_valid_includes()
  
  local i = 0
  for line in file:lines() do
    i = i + 1
    local line_is_comment = line:match("^%s*%%") ~= nil
    local is_commented = is_inherited_comment or line_is_comment
    
    -- Extraer Secciones (soporta \section{...} y también tolerante a %section{...} sin barra)
    for sec_type, title in line:gmatch("\\([a-zA-Z]+)%*?%s*%{(.-)%}") do
      local level = M.levels[sec_type] or custom_levels[sec_type]
      if level then
        table.insert(toc_items, {
          type = sec_type,
          level = level,
          title = title,
          lnum = i, -- 1-indexed
          filepath = filepath,
          is_commented = is_commented
        })
      end
    end
    
    -- Tolerancia para secciones comentadas sin barra (ej: %section{titulo})
    if line_is_comment then
      for sec_type, title in line:gmatch("%%%s*([a-zA-Z]+)%*?%s*%{(.-)%}") do
        local level = M.levels[sec_type] or custom_levels[sec_type]
        if level then
          table.insert(toc_items, {
            type = sec_type,
            level = level,
            title = title,
            lnum = i,
            filepath = filepath,
            is_commented = true
          })
        end
      end
    end
    
    -- Si es una línea comentada y contiene un macro de importación válido, explorarlo
    if line_is_comment then
      for inc_type, target_file in line:gmatch("\\([a-zA-Z]+)%*?%s*%{(.-)%}") do
        local patterns = valid_includes[inc_type]
        if patterns then
          for _, pat in ipairs(patterns) do
            local mapped = pat:gsub("%%s", target_file)
            local p1 = dir .. "/" .. mapped
            local p2 = vim.fn.getcwd() .. "/" .. mapped
            
            local abs_path = nil
            if vim.fn.filereadable(p1) == 1 then abs_path = vim.fn.resolve(p1)
            elseif vim.fn.filereadable(p2) == 1 then abs_path = vim.fn.resolve(p2)
            elseif vim.fn.filereadable(mapped) == 1 then abs_path = vim.fn.resolve(mapped)
            end
            
            if abs_path then
              local sub_items = M.parse_file(abs_path, is_inherited_comment or line_is_comment, visited, valid_includes)
              for _, sub_it in ipairs(sub_items) do
                table.insert(toc_items, sub_it)
              end
              break -- Encontrado, no procesar más patrones
            end
          end
        end
      end
    end
  end
  file:close()
  return toc_items
end

function M.parse_buffer(bufnr, valid_includes)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local toc_items = {}
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  
  local main_plugin = require("arttextoc")
  local custom_levels = (main_plugin.opts and main_plugin.opts.custom_levels) or {}
  valid_includes = valid_includes or M.get_valid_includes()
  
  for i, line in ipairs(lines) do
    local is_commented = line:match("^%s*%%") ~= nil
    local dir = vim.fn.fnamemodify(filepath, ":p:h")
    for sec_type, title in line:gmatch("\\([a-zA-Z]+)%*?%s*%{(.-)%}") do
      local level = M.levels[sec_type] or custom_levels[sec_type]
      if level then
        table.insert(toc_items, {
          type = sec_type,
          level = level,
          title = title,
          lnum = i,
          filepath = filepath,
          is_commented = is_commented
        })
      end
    end
    
    -- Tolerancia para secciones comentadas sin barra (ej: %section{titulo})
    if is_commented then
      for sec_type, title in line:gmatch("%%%s*([a-zA-Z]+)%*?%s*%{(.-)%}") do
        local level = M.levels[sec_type] or custom_levels[sec_type]
        if level then
          table.insert(toc_items, {
            type = sec_type,
            level = level,
            title = title,
            lnum = i,
            filepath = filepath,
            is_commented = true
          })
        end
      end
    end
    
    if is_commented then
      for inc_type, target_file in line:gmatch("\\([a-zA-Z]+)%*?%s*%{(.-)%}") do
        local patterns = valid_includes[inc_type]
        if patterns then
          for _, pat in ipairs(patterns) do
            local mapped = pat:gsub("%%s", target_file)
            local p1 = dir .. "/" .. mapped
            local p2 = vim.fn.getcwd() .. "/" .. mapped
            
            local abs_path = nil
            if vim.fn.filereadable(p1) == 1 then abs_path = vim.fn.resolve(p1)
            elseif vim.fn.filereadable(p2) == 1 then abs_path = vim.fn.resolve(p2)
            elseif vim.fn.filereadable(mapped) == 1 then abs_path = vim.fn.resolve(mapped)
            end
            
            if abs_path then
              local sub_items = M.parse_file(abs_path, true, {}, valid_includes)
              for _, sub_it in ipairs(sub_items) do
                table.insert(toc_items, sub_it)
              end
              break -- Encontrado, no procesar más patrones
            end
          end
        end
      end
    end
  end
  return toc_items
end

return M
