local M = {}
local parser = require("arttextoc.parser")

M.toc_win = nil
M.toc_buf = nil
M.main_win = nil
M.items = {}

local icons = {
  [-1] = "󰉖", -- part
  [0] = "󰈙", -- chapter
  [1] = "󰠱", -- section
  [2] = "󰅂", -- subsection
  [3] = "󰄾", -- subsubsection
  [4] = "󰍡", -- paragraph
  [5] = "󰍡", -- subparagraph
}

M.file_cache = {}
M.folded_state = {}
M.drawn_items = {}

function M.draw()
  if not M.toc_buf or not vim.api.nvim_buf_is_valid(M.toc_buf) then return end
  
  -- Prevent modification errors
  vim.bo[M.toc_buf].modifiable = true
  
  local lines = {}
  local commented_lines = {}
  M.drawn_items = {}
  
  if #M.items == 0 then
    table.insert(lines, "  (No se encontraron secciones)")
  else
    local hide_level = nil
    
    for i, item in ipairs(M.items) do
      if hide_level and item.level <= hide_level then
        hide_level = nil
      end
      
      if not hide_level then
        local key = item.filepath .. ":" .. item.title
        local is_folded = M.folded_state[key]
        if is_folded == nil then is_folded = item.is_commented end
        
        local has_children = M.items[i+1] and M.items[i+1].level > item.level
        
        local fold_indicator = "  "
        if has_children then
          fold_indicator = is_folded and "▶ " or "▼ "
        end
        
        local icon = icons[item.level] or "▪"
        local indent_level = item.level > 0 and item.level or 0
        local indent = string.rep("  ", indent_level)
        
        local display_str = string.format(" %s%s%s %s", fold_indicator, indent, icon, item.title)
        table.insert(lines, display_str)
        table.insert(M.drawn_items, item)
        
        if item.is_commented then
          table.insert(commented_lines, #lines - 1)
        end
        
        if is_folded then
          hide_level = item.level
        end
      end
    end
  end

  vim.api.nvim_buf_set_lines(M.toc_buf, 0, -1, false, lines)
  
  -- Resaltar secciones comentadas con un color opaco (Comment)
  local ns_id_comment = vim.api.nvim_create_namespace("ArtTexTOC_Comments")
  vim.api.nvim_buf_clear_namespace(M.toc_buf, ns_id_comment, 0, -1)
  for _, line_idx in ipairs(commented_lines) do
    vim.api.nvim_buf_set_extmark(M.toc_buf, ns_id_comment, line_idx, 0, {
      hl_group = "Comment",
      end_row = line_idx,
      end_col = #lines[line_idx + 1],
      hl_mode = "combine",
      priority = 50,
    })
  end
  
  vim.bo[M.toc_buf].modifiable = false
end

function M.jump_to_section()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local item_idx = row
  
  if item_idx > 0 and item_idx <= #M.drawn_items then
    local item = M.drawn_items[item_idx]
    
    if M.main_win and vim.api.nvim_win_is_valid(M.main_win) then
      vim.api.nvim_set_current_win(M.main_win)
      
      if item.filepath and vim.api.nvim_buf_get_name(0) ~= item.filepath then
        vim.cmd("edit " .. vim.fn.fnameescape(item.filepath))
      end
      
      local line_count = vim.api.nvim_buf_line_count(0)
      if item.lnum <= line_count then
        vim.api.nvim_win_set_cursor(M.main_win, {item.lnum, 0})
        vim.cmd("normal! zz")
      end
    end
  end
end

function M.toggle_fold()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  if row > 0 and row <= #M.drawn_items then
    local item = M.drawn_items[row]
    local key = item.filepath .. ":" .. item.title
    if M.folded_state[key] == nil then
      M.folded_state[key] = not item.is_commented
    else
      M.folded_state[key] = not M.folded_state[key]
    end
    M.draw()
    M.highlight_current_section()
  end
end

function M.refresh()
  if not M.main_win or not vim.api.nvim_win_is_valid(M.main_win) then return end
  local bufnr = vim.api.nvim_win_get_buf(M.main_win)
  local current_filepath = vim.api.nvim_buf_get_name(bufnr)
  
  -- Solo invalidamos la caché del archivo en el que estamos trabajando (0 overhead)
  M.file_cache[current_filepath] = nil
  
  local workspace_ok, workspace = pcall(require, "arttexworkspace")
  if workspace_ok and workspace.api.is_ready(bufnr) then
    local root = workspace.api.get_root_file(bufnr)
    local deps = workspace.api.get_project_tree(bufnr)
    
    M.items = {}
    
    local function append_cache(file_path, valid_includes)
      if not M.file_cache[file_path] then
        if file_path == current_filepath then
          M.file_cache[file_path] = parser.parse_buffer(bufnr, valid_includes)
        else
          M.file_cache[file_path] = parser.parse_file(file_path, false, {}, valid_includes)
        end
      end
      for _, it in ipairs(M.file_cache[file_path]) do
        table.insert(M.items, it)
      end
    end
    
    local valid_includes = parser.get_valid_includes()
    append_cache(root, valid_includes)
    if deps then
      for _, dep in ipairs(deps) do
        append_cache(dep, valid_includes)
      end
    end
  else
    M.file_cache[current_filepath] = parser.parse_buffer(bufnr)
    M.items = M.file_cache[current_filepath]
  end
  M.draw()
  M.highlight_current_section()
end

local ns_id = vim.api.nvim_create_namespace("ArtTexTOCActive")

function M.highlight_current_section()
  if not M.toc_buf or not vim.api.nvim_buf_is_valid(M.toc_buf) then return end
  if not M.main_win or not vim.api.nvim_win_is_valid(M.main_win) then return end
  
  local cursor = vim.api.nvim_win_get_cursor(M.main_win)
  local row = cursor[1]
  local current_filepath = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(M.main_win))
  
  local best_idx = 0
  local best_lnum = -1
  for i, item in ipairs(M.drawn_items) do
    if (not item.filepath) or (item.filepath == current_filepath) then
      if item.lnum <= row and item.lnum > best_lnum then
        best_idx = i
        best_lnum = item.lnum
      end
    end
  end
  
  vim.api.nvim_buf_clear_namespace(M.toc_buf, ns_id, 0, -1)
  if best_idx > 0 and best_idx <= #M.drawn_items then
    local line_text_tbl = vim.api.nvim_buf_get_lines(M.toc_buf, best_idx - 1, best_idx, false)
    if line_text_tbl and line_text_tbl[1] then
      local line_len = #line_text_tbl[1]
      vim.api.nvim_buf_set_extmark(M.toc_buf, ns_id, best_idx - 1, 0, {
        hl_group = "Title", -- Solo resalta el texto
        end_row = best_idx - 1,
        end_col = line_len,
        hl_mode = "combine",
        priority = 100
      })
      
      -- Auto-scroll inteligente: Si la ventana del TOC está abierta, movemos su cursor para mantener la sección visible
      if M.toc_win and vim.api.nvim_win_is_valid(M.toc_win) then
        -- Movemos el cursor sin cambiar el foco de la ventana activa
        pcall(vim.api.nvim_win_set_cursor, M.toc_win, {best_idx, 0})
      end
    end
  end
end

function M.show_tooltip()
  if not M.toc_win or not vim.api.nvim_win_is_valid(M.toc_win) then return end
  local cursor = vim.api.nvim_win_get_cursor(M.toc_win)
  local row = cursor[1]
  
  if row > 0 and row <= #M.drawn_items then
    local item = M.drawn_items[row]
    local win_width = vim.api.nvim_win_get_width(M.toc_win)
    local indent_level = item.level > 0 and item.level or 0
    
    if #item.title + (indent_level * 2) + 10 > win_width then
      _G.ArtTexTOC_HoveredTitle = "󰧮 " .. item.title
    else
      _G.ArtTexTOC_HoveredTitle = ""
    end
    vim.cmd("redrawstatus")
  end
end

function M.action_cr()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  if row > 0 and row <= #M.drawn_items then
    local item = M.drawn_items[row]
    -- Determinar si tiene hijos en la lista original (M.items)
    local has_children = false
    for i, it in ipairs(M.items) do
      if it == item then
        has_children = M.items[i+1] and M.items[i+1].level > item.level
        break
      end
    end
    
    if has_children then
      M.toggle_fold()
    else
      M.jump_to_section()
    end
  end
end

function M.action_h()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  if row > 0 and row <= #M.drawn_items then
    local item = M.drawn_items[row]
    local key = item.filepath .. ":" .. item.title
    local is_folded = M.folded_state[key]
    if is_folded == nil then is_folded = item.is_commented end
    
    -- Si está expandido y tiene hijos, lo colapsamos
    local has_children = false
    for i, it in ipairs(M.items) do
      if it == item then
        has_children = M.items[i+1] and M.items[i+1].level > item.level
        break
      end
    end
    
    if has_children and not is_folded then
      M.toggle_fold()
    else
      -- Si ya está colapsado o no tiene hijos, saltar al padre
      local parent_idx = nil
      for i = row - 1, 1, -1 do
        if M.drawn_items[i].level < item.level then
          parent_idx = i
          break
        end
      end
      if parent_idx then
        vim.api.nvim_win_set_cursor(0, {parent_idx, 0})
      end
    end
  end
end

function M.action_l()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  if row > 0 and row <= #M.drawn_items then
    local item = M.drawn_items[row]
    local key = item.filepath .. ":" .. item.title
    local is_folded = M.folded_state[key]
    if is_folded == nil then is_folded = item.is_commented end
    
    local has_children = false
    for i, it in ipairs(M.items) do
      if it == item then
        has_children = M.items[i+1] and M.items[i+1].level > item.level
        break
      end
    end
    
    if has_children then
      if is_folded then
        M.toggle_fold()
      else
        -- Ya está abierto, ir al primer hijo
        if row + 1 <= #M.drawn_items then
          vim.api.nvim_win_set_cursor(0, {row + 1, 0})
        end
      end
    end
  end
end

function M.toggle()
  -- Si ya está abierto, cerrarlo
  if M.toc_win and vim.api.nvim_win_is_valid(M.toc_win) then
    if M.original_guicursor then
      vim.o.guicursor = M.original_guicursor
    end
    vim.api.nvim_win_close(M.toc_win, true)
    M.toc_win = nil
    M.toc_buf = nil
    _G.ArtTexTOC_HoveredTitle = nil
    vim.cmd("redrawstatus")
    pcall(vim.api.nvim_del_augroup_by_name, "ArtTexTOC")
    return
  end
  
  M.main_win = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Solo permitir en archivos tex
  local ft = vim.bo[bufnr].filetype
  if ft ~= "tex" and ft ~= "plaintex" then
    vim.notify("[ArtTex] La tabla de contenidos solo funciona en archivos LaTeX", vim.log.levels.WARN)
    return
  end
  
  M.toc_buf = vim.api.nvim_create_buf(false, true) -- nofile
  
  -- Configurar ventana flotante (Floating Window)
  local width = math.floor(vim.o.columns * 0.3)
  local height = math.floor(vim.o.lines * 0.8)
  local col = vim.o.columns - width - 2
  local row = math.floor((vim.o.lines - height) / 2)
  
  M.original_guicursor = vim.o.guicursor
  
  M.toc_win = vim.api.nvim_open_win(M.toc_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " 󰧮 Tabla de Contenidos (ArtTeX) ",
    title_pos = "center"
  })
  
  -- Configurar buffer
  vim.bo[M.toc_buf].buftype = "nofile"
  vim.bo[M.toc_buf].bufhidden = "wipe"
  vim.bo[M.toc_buf].swapfile = false
  vim.bo[M.toc_buf].filetype = "arttextoc"
  
  -- Configurar ventana
  vim.wo[M.toc_win].number = false
  vim.wo[M.toc_win].relativenumber = false
  vim.wo[M.toc_win].signcolumn = "no"
  vim.wo[M.toc_win].wrap = false
  vim.wo[M.toc_win].cursorline = true
  pcall(function() vim.wo[M.toc_win].cursorlineopt = "line" end)
  pcall(function() vim.wo[M.toc_win].winhl = "CursorLine:NvimTreeCursorLine" end)
  
  -- Keymaps de nvim-tree
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "<CR>", "<cmd>lua require('arttextoc.ui').action_cr()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "o", "<cmd>lua require('arttextoc.ui').jump_to_section()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "h", "<cmd>lua require('arttextoc.ui').action_h()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "l", "<cmd>lua require('arttextoc.ui').action_l()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "<Left>", "<cmd>lua require('arttextoc.ui').action_h()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "<Right>", "<cmd>lua require('arttextoc.ui').action_l()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "<Tab>", "<cmd>lua require('arttextoc.ui').toggle_fold()<CR>", opts)
  vim.api.nvim_buf_set_keymap(M.toc_buf, "n", "q", "<cmd>close<CR>", opts)
  
  local augroup = vim.api.nvim_create_augroup("ArtTexTOC", { clear = true })
  
  -- Ocultar el cursor físico en la ventana del TOC
  vim.api.nvim_set_hl(0, "ArtTexHiddenCursor", { blend = 100, nocombine = true })
  vim.o.guicursor = "n-v-c-sm:ArtTexHiddenCursor,i-ci-ve:ver25,r-cr-o:blocks"
  
  vim.api.nvim_create_autocmd("WinEnter", {
    group = augroup,
    buffer = M.toc_buf,
    callback = function()
      M.original_guicursor = vim.o.guicursor
      vim.api.nvim_set_hl(0, "ArtTexHiddenCursor", { blend = 100, nocombine = true })
      vim.o.guicursor = "n-v-c-sm:ArtTexHiddenCursor,i-ci-ve:ver25,r-cr-o:blocks"
    end
  })
  
  vim.api.nvim_create_autocmd("WinLeave", {
    group = augroup,
    buffer = M.toc_buf,
    callback = function()
      if M.original_guicursor then
        vim.o.guicursor = M.original_guicursor
      end
    end
  })
  
  -- Auto-limpieza cuando se cierra
  vim.api.nvim_create_autocmd("WinClosed", {
    buffer = M.toc_buf,
    callback = function()
      if M.original_guicursor then
        vim.o.guicursor = M.original_guicursor
      end
      M.toc_win = nil
      M.toc_buf = nil
    end,
    once = true
  })
  
  -- Refrescar el árbol (Solo al guardar el archivo, 0% CPU al escribir o pausar)
  vim.api.nvim_create_autocmd({"BufWritePost"}, {
    group = augroup,
    pattern = {"*.tex", "*.plaintex"},
    callback = function()
      if M.toc_win and vim.api.nvim_win_is_valid(M.toc_win) then
        M.refresh()
      end
    end,
  })
  
  -- Resaltar la sección actual en tiempo real mientras te mueves
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    group = augroup,
    pattern = {"*.tex", "*.plaintex"},
    callback = function()
      M.highlight_current_section()
    end,
  })
  
  -- Mostrar tooltip para títulos largos al navegar DENTRO del TOC
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = augroup,
    buffer = M.toc_buf,
    callback = function()
      M.show_tooltip()
    end,
  })
  
  M.refresh()
  M.highlight_current_section()
end

return M
