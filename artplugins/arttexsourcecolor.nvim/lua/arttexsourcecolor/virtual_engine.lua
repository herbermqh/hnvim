--- @module arttexsourcecolor.virtual_engine
--- @description Motor de renderizado visual de alto rendimiento.
--- Utiliza Decoration Providers para inyectar marcas efímeras directamente en el ciclo de dibujado de Neovim.
--- Coste de CPU: 0% en reposo. O(V) donde V es el número de líneas visibles en pantalla.
local M = {}
local config = require("arttexsourcecolor.config")
local ns_id = vim.api.nvim_create_namespace("arttexsourcecolor_virt")

M.active_trees = {}
local rb_query_cache = nil

local container_types = {
  curly_group = true,
  curly_group_text = true,
  curly_group_math = true,
  curly_group_text_math = true,
  curly_group_author = true,
  curly_group_title = true,
  bracket_group = true,
  generic_environment = true,
  math_environment = true,
  inline_formula = true,
  displayed_equation = true,
}

local frame_cache = {}

local function get_container_flat_depths(container, buf)
  local container_id = container:id()
  if frame_cache[container_id] then
    return frame_cache[container_id]
  end

  local depths = {}
  local current_flat_depth = 0

  local function traverse(n)
    depths[n:id()] = current_flat_depth
    
    local t = n:type()
    local is_boundary = false
    local pt = n:parent() and n:parent():type()
    if pt == "math_delimiter" and (t == "(" or t == ")" or t == "[" or t == "]") then
      is_boundary = true
    end
    
    if not is_boundary then
      if t == "(" or t == "[" then
        current_flat_depth = current_flat_depth + 1
      elseif t == ")" or t == "]" then
        current_flat_depth = current_flat_depth - 1
      elseif t == "command_name" then
        local txt = vim.treesitter.get_node_text(n, buf)
        if txt == "\\{" then current_flat_depth = current_flat_depth + 1
        elseif txt == "\\}" then current_flat_depth = current_flat_depth - 1
        end
      end
    end
    
    for child in n:iter_children() do
      local ct = child:type()
      if ct ~= "curly_group" and ct ~= "curly_group_text" and ct ~= "math_delimiter" and ct ~= "math_environment" and ct ~= "inline_formula" and ct ~= "displayed_equation" and ct ~= "generic_environment" then
        traverse(child)
      end
    end
  end

  for child in container:iter_children() do
    local ct = child:type()
    if ct ~= "curly_group" and ct ~= "curly_group_text" and ct ~= "math_delimiter" and ct ~= "math_environment" and ct ~= "inline_formula" and ct ~= "displayed_equation" and ct ~= "generic_environment" then
      traverse(child)
    end
  end

  frame_cache[container_id] = depths
  return depths
end

local function get_unified_depth(target_node, buf)
  local depth = 1
  
  local p = target_node:parent()
  while p do
    local pt = p:type()
    if pt == "curly_group" or pt == "curly_group_text" or pt == "math_delimiter" or pt == "generic_environment" or pt == "math_environment" then
      depth = depth + 1
    end
    p = p:parent()
  end
  
  local is_structural_boundary = false
  local node_type = target_node:type()
  if node_type == "{" or node_type == "}" or node_type == "\\left" or node_type == "\\right" or node_type == "\\begin" or node_type == "\\end" then
    is_structural_boundary = true
  end
  
  local parent_type = target_node:parent() and target_node:parent():type()
  if parent_type == "math_delimiter" and (node_type == "(" or node_type == ")" or node_type == "[" or node_type == "]") then
    is_structural_boundary = true
  end
  
  if is_structural_boundary then
    depth = depth - 1
  end

  local container = target_node:parent()
  while container do
    local ct = container:type()
    if ct == "curly_group" or ct == "curly_group_text" or ct == "math_delimiter" or ct == "math_environment" or ct == "inline_formula" or ct == "displayed_equation" or ct == "generic_environment" or ct == "source_file" then
      break
    end
    container = container:parent()
  end
  
  if container then
    local flat_depths = get_container_flat_depths(container, buf)
    local flat_depth = flat_depths[target_node:id()] or 0
    local is_close = (node_type == ")" or node_type == "]")
    
    if is_close and not is_structural_boundary then
      flat_depth = flat_depth - 1
    end
    
    depth = depth + math.max(0, flat_depth)
  end
  
  return math.max(1, depth)
end

local virt_query_cache = nil
function M.get_virt_query()
  if not virt_query_cache then
    local query_str = ""
    local f = config.options.features
    
    if f.virtual_text.structs then
      query_str = query_str .. [[
((command_name) @ArtTexVirtChapter (#eq? @ArtTexVirtChapter "\\chapter"))
((command_name) @ArtTexVirtSection (#eq? @ArtTexVirtSection "\\section"))
((command_name) @ArtTexVirtTodo (#eq? @ArtTexVirtTodo "\\todo"))
]]
    end

    if f.rainbow_brackets then
      query_str = query_str .. [[
(generic_environment (begin "\\begin" @ArtTexRainbowBracket))
(generic_environment (end "\\end" @ArtTexRainbowBracket))
(math_environment (begin "\\begin" @ArtTexRainbowBracket))
(math_environment (end "\\end" @ArtTexRainbowBracket))
"{" @ArtTexRainbowBracket
"}" @ArtTexRainbowBracket
"(" @ArtTexRainbowBracket
")" @ArtTexRainbowBracket
"[" @ArtTexRainbowBracket
"]" @ArtTexRainbowBracket
"\\left" @ArtTexRainbowBracket
"\\right" @ArtTexRainbowBracket
(command_name) @ArtTexRainbowCmd
]]
    end

    if f.semantic_envs then
      -- Environment name semantic highlighting
      query_str = query_str .. [[
(begin name: (curly_group_text (text) @ArtTexEnvName))
(end name: (curly_group_text (text) @ArtTexEnvName))
]]
      
      -- Background colors dynamically from user configured env keywords
      local envs = config.options.env_keywords
      if envs then
        if envs.theorem and #envs.theorem > 0 then
          query_str = query_str .. string.format([[
((generic_environment (begin (curly_group_text (text) @env_thm_name)) @ArtTexEnvTheorem)
 (#any-of? @env_thm_name %s))
]], table.concat(vim.tbl_map(function(s) return '"' .. s .. '"' end, envs.theorem), " "))
        end
        if envs.math_block and #envs.math_block > 0 then
          query_str = query_str .. string.format([[
((math_environment (begin (curly_group_text (text) @env_math_name)) @ArtTexEnvMathBlock)
 (#any-of? @env_math_name %s))
]], table.concat(vim.tbl_map(function(s) return '"' .. s .. '"' end, envs.math_block), " "))
        end
        if envs.box and #envs.box > 0 then
          query_str = query_str .. string.format([[
((generic_environment (begin (curly_group_text (text) @env_box_name)) @ArtTexEnvBox)
 (#any-of? @env_box_name %s))
]], table.concat(vim.tbl_map(function(s) return '"' .. s .. '"' end, envs.box), " "))
        end
      end
    end
    if config.options.custom_groups then
      for _, group in ipairs(config.options.custom_groups) do
        if group.name and group.commands and #group.commands > 0 then
          local escaped_cmds = {}
          for _, cmd in ipairs(group.commands) do
            -- Reemplazar \ con \\ para Treesitter regex si se requieren pero el usuario ya pasará \\comando
            -- asumiendo comandos literales tipo "\mycmd" o "\\mycmd" en el json
            -- Solo escapamos si es necesario, pero #eq? es coincidencia exacta
            table.insert(escaped_cmds, '"' .. string.gsub(cmd, "\\", "\\\\") .. '"')
          end
          local hl_name = "ArtTexCustomGroup_" .. group.name
          query_str = query_str .. string.format([[
((command_name) @%s
 (#any-of? @%s %s))
]], hl_name, hl_name, table.concat(escaped_cmds, " "))
        end
      end
    end

    if f.syntax_errors then
      query_str = query_str .. "(ERROR) @ArtTexError\n"
    end

    if f.virtual_text.references then
      query_str = query_str .. [[
(label_definition (curly_group_text (text) @ArtTexLabelTarget))
(label_reference (curly_group_text_list (text) @ArtTexRefTarget))
(citation (curly_group_text_list (text) @ArtTexCiteTarget))
]]
    end

    if f.virtual_text.resources then
      query_str = query_str .. [[
(graphics_include (curly_group_path (path) @ArtTexResourceTarget))
(latex_include (curly_group_path (path) @ArtTexResourceTarget))
]]
    end

    local ok, q = pcall(vim.treesitter.query.parse, "latex", query_str)
    if ok then virt_query_cache = q end
  end
  return virt_query_cache
end

M.labels_cache = {}

-- Función para recolectar labels de un bufer (se ejecuta en BufWritePost)
function M.collect_labels(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "latex")
  if not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end
  
  local query = M.get_virt_query()
  if not query then return end
  
  local labels = {}
  for id, node, _ in query:iter_captures(tree:root(), bufnr, 0, -1) do
    if query.captures[id] == "ArtTexLabelTarget" then
      local label_text = vim.treesitter.get_node_text(node, bufnr)
      if label_text then labels[label_text] = true end
    end
  end
  M.labels_cache[bufnr] = labels
end

-- Cursor Matcher (Iluminación de Pares)
local function get_node_at_cursor(bufnr)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  local root = M.active_trees[bufnr]
  if not root then return nil end
  return root:named_descendant_for_range(row, col, row, col)
end

function M.highlight_matching_pair(bufnr)
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_id, 0, -1)
  
  local node = get_node_at_cursor(bufnr)
  if not node then return end
  
  local target_node = nil
  local current = node
  for i = 1, 4 do
    if current and (current:type() == "begin" or current:type() == "end") then
      target_node = current
      break
    end
    if current then
      current = current:parent()
    end
  end
  
  if target_node then
    local parent = target_node:parent()
    if parent and (parent:type() == "generic_environment" or parent:type() == "math_environment") then
      for child in parent:iter_children() do
        if child:type() == "begin" or child:type() == "end" then
          local r1, c1, r2, c2 = child:range()
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
            end_row = r2, end_col = c2,
            hl_group = "ArtTexMatchParen",
            priority = 250,
          })
        end
      end
    end
  end
end

-- Configura el proveedor de decoraciones de alto rendimiento
local virtual_group = vim.api.nvim_create_augroup("ArtTexSourceColorVirtual", { clear = true })

function M.setup()
  virt_query_cache = nil -- Forzar reconstrucción de query basada en opciones dinámicas
  
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    group = virtual_group,
    pattern = {"*.tex", "*.latex", "*.sty"},
    callback = function(args)
      if config.options.enabled and config.options.features.match_paren then
        M.highlight_matching_pair(args.buf)
      end
    end
  })
  
  vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {
    group = virtual_group,
    pattern = {"*.tex", "*.latex", "*.sty"},
    callback = function(args)
      if config.options.enabled and config.options.features.virtual_text.references then
        M.collect_labels(args.buf)
      end
    end
  })

  vim.api.nvim_set_decoration_provider(ns_id, {
    on_win = function(_, winid, bufnr, topline, botline)
      frame_cache = {} -- clear cache for this frame
      if not config.options.enabled then return false end
      local ft = vim.bo[bufnr].filetype
      if ft ~= "tex" and ft ~= "latex" and ft ~= "sty" then return false end

      local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "latex")
      if not ok or not parser then return false end
      
      local tree = parser:parse()[1]
      if not tree then return false end
      
      M.active_trees[bufnr] = tree:root()
      if not M.labels_cache[bufnr] then M.collect_labels(bufnr) end
      return true
    end,
    
    on_line = function(_, winid, bufnr, row)
      local root = M.active_trees[bufnr]
      if not root then return end
      
      local query = M.get_virt_query()
      if not query then return end
      
      local labels = M.labels_cache[bufnr] or {}

      for id, node, _ in query:iter_captures(root, bufnr, row, row + 1) do
        local name = query.captures[id]
        local r1, c1, r2, c2 = node:range()
        
        -- Nodos de bloque (pueden abarcar múltiples líneas, se dibujan en cada on_line)
        if name == "ArtTexEnvTheorem" or name == "ArtTexEnvMathBlock" or name == "ArtTexEnvBox" then
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
            end_row = r2, end_col = c2,
            hl_group = name, priority = 150, ephemeral = true,
          })
          
        elseif name == "ArtTexError" then
          if not _G.arttex_error_ignore_cache then _G.arttex_error_ignore_cache = {} end
          if _G.arttex_error_ignore_cache[bufnr] == nil then
            local fname = vim.api.nvim_buf_get_name(bufnr)
            local ext = fname:match("%.([^%.]+)$") or ""
            local is_package = (ext == "sty" or ext == "cls")
            
            -- Check if it's in preamble files
            if _G.arttex_preamble_files and _G.arttex_preamble_files[fname] then
              is_package = true
            end
            
            -- Check if it's in library_paths
            if not is_package then
              local ok, ws_cfg = pcall(require, "arttexworkspace.core.config")
              if ok and ws_cfg and ws_cfg.options and ws_cfg.options.library_paths then
                for _, lib_path in ipairs(ws_cfg.options.library_paths) do
                  local expanded = vim.fn.expand(lib_path)
                  if string.find(fname, expanded, 1, true) then
                    is_package = true
                    break
                  end
                end
              end
            end
            _G.arttex_error_ignore_cache[bufnr] = is_package
          end
          
          if not _G.arttex_error_ignore_cache[bufnr] then
            -- Prevenir que errores masivos (ej. \begin sin \end) subrayen todo el documento
            -- Solo mostramos errores si abarcan un máximo de 1 línea
            if (r2 - r1) <= 1 then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
                end_row = r2, end_col = c2,
                hl_group = "ArtTexError", priority = 300, ephemeral = true,
              })
            else
              -- Si abarca más de una línea, solo subrayamos el inicio del error
              if r1 == row then
                pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
                  end_row = r1, end_col = -1,
                  hl_group = "ArtTexError", priority = 300, ephemeral = true,
                })
              end
            end
          end
          
        elseif r1 == row then
          if name == "ArtTexRainbowBracket" then
            local depth = get_unified_depth(node, bufnr)
            local hl_group = "ArtTexRainbow" .. ((depth - 1) % 6 + 1)
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              end_row = r2, end_col = c2,
              hl_group = hl_group, priority = 200, ephemeral = true,
            })
            
          elseif name == "ArtTexRainbowCmd" then
            local txt = vim.treesitter.get_node_text(node, bufnr)
            if txt == "\\{" or txt == "\\}" or txt == "\\sqrt" or txt == "\\frac" or txt == "\\dfrac" or txt == "\\tfrac" or txt == "\\cfrac" or txt == "\\binom" or txt == "\\dbinom" or txt == "\\tbinom" then
              local depth = get_unified_depth(node, bufnr)
              local hl_group = "ArtTexRainbow" .. ((depth - 1) % 6 + 1)
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
                end_row = r2, end_col = c2,
                hl_group = hl_group, priority = 200, ephemeral = true,
              })
            end
            
          elseif name:match("^ArtTexCustomGroup_") then
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              end_row = r2, end_col = c2,
              hl_group = name, priority = 210, ephemeral = true,
            })

          elseif name == "ArtTexEnvName" then
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              end_row = r2, end_col = c2,
              hl_group = "ArtTexEnvName", priority = 210, ephemeral = true,
            })
            
          elseif name == "ArtTexRefTarget" or name == "ArtTexCiteTarget" then
            local text = vim.treesitter.get_node_text(node, bufnr)
            local hl = labels[text] and "ArtTexRefValid" or "ArtTexRefInvalid"
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              end_row = r2, end_col = c2,
              hl_group = hl, priority = 210, ephemeral = true,
            })
            if not labels[text] then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c2, {
                virt_text = {{" ❌ No hallado", "ArtTexRefInvalid"}},
                virt_text_pos = "inline",
                ephemeral = true,
              })
            end
            
          elseif name == "ArtTexResourceTarget" then
            local text = vim.treesitter.get_node_text(node, bufnr)
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c2, {
              virt_text = {{" 🔗 " .. text, "ArtTexResourceVirt"}},
              virt_text_pos = "eol",
              ephemeral = true,
            })
            
          elseif name == "ArtTexVirtChapter" then
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              virt_text = {{" 📖 CAPÍTULO", "ArtTexStructCmd"}}, virt_text_pos = "eol", hl_mode = "combine", ephemeral = true,
            })
          elseif name == "ArtTexVirtSection" then
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              virt_text = {{" 📌 SECCIÓN", "ArtTexCustomEnv"}}, virt_text_pos = "eol", hl_mode = "combine", ephemeral = true,
            })
          elseif name == "ArtTexVirtTodo" then
            pcall(vim.api.nvim_buf_set_extmark, bufnr, ns_id, r1, c1, {
              virt_text = {{" 🚨 TAREA PENDIENTE", "ErrorMsg"}}, virt_text_pos = "eol", hl_mode = "combine", ephemeral = true,
            })
          end
        end
      end
    end
  })
end

function M.clear(bufnr)
  pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_id, 0, -1)
  pcall(vim.cmd, "redraw")
end

function M.apply_virtuals(bufnr) end

return M
