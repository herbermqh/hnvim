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

--- Parsea un archivo y extrae la estructura de secciones (y recursivamente las dependencias del árbol)
function M.parse_file(filepath, is_inherited_comment, visited, tree_node)
  visited = visited or {}
  if visited[filepath] then return {} end
  visited[filepath] = true

  local toc_items = {}
  local file = io.open(filepath, "r")
  if not file then return toc_items end
  local content = file:read("*all")
  file:close()
  
  if not content or content == "" then return toc_items end
  
  local verbatim_envs = {}
  pcall(function()
    verbatim_envs = require("arttexworkspace.core.config").options.verbatim_envs or {}
  end)
  
  local clean_content = content
  pcall(function()
    clean_content = require("arttexworkspace.parsers.verbatim").strip_verbatim(content, verbatim_envs)
  end)
  
  local main_plugin = require("arttextoc")
  local custom_levels = (main_plugin.opts and main_plugin.opts.custom_levels) or {}
  
  local i = 0
  for line in clean_content:gmatch("([^\n]*)\n?") do
    i = i + 1
    
    local has_slash = line:find("\\", 1, true)
    local has_percent = line:find("%", 1, true)
    
    if has_slash or has_percent then
      local might_have_sec = line:find("section", 1, true) or line:find("chapter", 1, true) or line:find("part", 1, true) or line:find("paragraph", 1, true)
      if not might_have_sec then
        for k, _ in pairs(custom_levels) do
          if line:find(k, 1, true) then might_have_sec = true; break end
        end
      end
      if tree_node and tree_node.resolved_includes then
        for k, _ in pairs(tree_node.resolved_includes) do
          if line:find(k, 1, true) then
            might_have_inc = true
            break
          end
        end
      end
      
      if might_have_sec or might_have_inc then
        local line_is_comment = has_percent and line:match("^%s*%%") ~= nil
        local is_commented = is_inherited_comment or line_is_comment
        
        -- Función local para extraer llaves balanceadas
        local function extract_braces(text, start_pos)
          local open_braces = 0
          local end_pos = start_pos
          for j = start_pos, #text do
            local char = text:sub(j, j)
            if char == "{" then open_braces = open_braces + 1
            elseif char == "}" then
              open_braces = open_braces - 1
              if open_braces == 0 then return text:sub(start_pos + 1, j - 1), j end
            end
          end
          return nil, nil
        end
        
        -- Escáner de comandos (soporta anidamiento infinito, ej: \foreach{\section{}})
        local function scan_line(text, is_com)
          local pos = 1
          while pos <= #text do
            -- Encontrar el próximo macro, ignorando el `\` o `%` inicial
            local start_idx, finish_idx, cmd
            if not is_com then
              start_idx, finish_idx, cmd = text:find("\\([a-zA-Z]+)%*?%s*", pos)
            else
              start_idx, finish_idx, cmd = text:find("%%%s*([a-zA-Z]+)%*?%s*", pos)
            end
            
            if not start_idx then break end
            
            -- Saltar posibles opciones [...] y extraer su valor
            local bracket_pos = finish_idx + 1
            local opt_arg = nil
            local char_after = text:sub(bracket_pos, bracket_pos)
            if char_after == "[" then
              local close_bracket = text:find("]", bracket_pos)
              if close_bracket then 
                opt_arg = text:sub(bracket_pos + 1, close_bracket - 1)
                bracket_pos = close_bracket + 1 
              end
            end
            
            local brace_start = text:find("{", bracket_pos)
            if brace_start and (brace_start - bracket_pos) < 5 then
              local arg, brace_end = extract_braces(text, brace_start)
              if arg then
                -- 1. ¿Es una sección?
                local level = M.levels[cmd] or custom_levels[cmd]
                if might_have_sec and level then
                  table.insert(toc_items, { type = cmd, level = level, title = arg, lnum = i, filepath = filepath, is_commented = is_commented })
                end
                
                -- 2. ¿Es un include?
                if might_have_inc and tree_node and tree_node.resolved_includes then
                  local function check_resolved_child(child_name)
                    if not child_name then return false end
                    local resolved_child = tree_node.resolved_includes[child_name]
                    if resolved_child then
                      if resolved_child.filepath then
                        local sub_items = M.parse_file(resolved_child.filepath, is_inherited_comment or resolved_child.is_commented, visited, resolved_child)
                        for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                      else
                        for _, child in ipairs(resolved_child) do
                          local sub_items = M.parse_file(child.filepath, is_inherited_comment or child.is_commented, visited, child)
                          for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                        end
                      end
                      return true
                    end
                    return false
                  end
                  
                  local found = check_resolved_child(opt_arg)
                  if not found then check_resolved_child(arg) end
                end
                
                -- MAGIA: Avanzamos solo +1 para macros ANIDADOS
                pos = start_idx + 1
              else
                pos = start_idx + 1
              end
            else
              pos = start_idx + 1
            end
          end
        end

        if has_slash then scan_line(line, false) end
        if line_is_comment then scan_line(line, true) end
      end
    end
  end
  return toc_items
end

function M.parse_buffer(bufnr, tree_node)
  local lines_table = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines_table, "\n")
  
  local verbatim_envs = {}
  pcall(function()
    verbatim_envs = require("arttexworkspace.core.config").options.verbatim_envs or {}
  end)
  
  local clean_content = content
  pcall(function()
    clean_content = require("arttexworkspace.parsers.verbatim").strip_verbatim(content, verbatim_envs)
  end)
  
  local lines = {}
  for line in clean_content:gmatch("([^\n]*)\n?") do
    table.insert(lines, line)
  end
  
  local toc_items = {}
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  
  local main_plugin = require("arttextoc")
  local custom_levels = (main_plugin.opts and main_plugin.opts.custom_levels) or {}
  local visited = {}
  visited[filepath] = true
  
  for i, line in ipairs(lines) do
    local has_slash = line:find("\\", 1, true)
    local has_percent = line:find("%", 1, true)
    
    if has_slash or has_percent then
      local might_have_sec = line:find("section", 1, true) or line:find("chapter", 1, true) or line:find("part", 1, true) or line:find("paragraph", 1, true)
      if not might_have_sec then
        for k, _ in pairs(custom_levels) do
          if line:find(k, 1, true) then might_have_sec = true; break end
        end
      end
      if tree_node and tree_node.resolved_includes then
        for k, _ in pairs(tree_node.resolved_includes) do
          if line:find(k, 1, true) then
            might_have_inc = true
            break
          end
        end
      end
      
      if might_have_sec or might_have_inc then
        local line_is_comment = has_percent and line:match("^%s*%%") ~= nil
        local is_commented = line_is_comment
        
        if might_have_sec and has_slash then
          for sec_type, title in line:gmatch("\\([a-zA-Z]+)%*?%s*%{(.-)%}") do
            local level = M.levels[sec_type] or custom_levels[sec_type]
            if level then
              table.insert(toc_items, { type = sec_type, level = level, title = title, lnum = i, filepath = filepath, is_commented = is_commented })
            end
          end
        end
        
        if might_have_sec and line_is_comment then
          for sec_type, title in line:gmatch("%%%s*([a-zA-Z]+)%*?%s*%{(.-)%}") do
            local level = M.levels[sec_type] or custom_levels[sec_type]
            if level then
              table.insert(toc_items, { type = sec_type, level = level, title = title, lnum = i, filepath = filepath, is_commented = true })
            end
          end
        end

        -- Procesar includes en el buffer
        if might_have_inc and tree_node and tree_node.resolved_includes then
          if has_slash then
            for target_file in line:gmatch("\\%a+%*?%s*%{(.-)%}") do
              local resolved_child = tree_node.resolved_includes[target_file]
              if resolved_child then
                if resolved_child.filepath then
                  local sub_items = M.parse_file(resolved_child.filepath, is_commented or resolved_child.is_commented, visited, resolved_child)
                  for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                else
                  for _, child in ipairs(resolved_child) do
                    local sub_items = M.parse_file(child.filepath, is_commented or child.is_commented, visited, child)
                    for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                  end
                end
              end
            end
          end
          if line_is_comment then
            for target_file in line:gmatch("%%%s*%a+%*?%s*%{(.-)%}") do
              local resolved_child = tree_node.resolved_includes[target_file]
              if resolved_child then
                if resolved_child.filepath then
                  local sub_items = M.parse_file(resolved_child.filepath, is_commented or resolved_child.is_commented, visited, resolved_child)
                  for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                else
                  for _, child in ipairs(resolved_child) do
                    local sub_items = M.parse_file(child.filepath, is_commented or child.is_commented, visited, child)
                    for _, sub_it in ipairs(sub_items) do table.insert(toc_items, sub_it) end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  return toc_items
end

return M
