local state = require("arttexworkspace.core.state")
local structure = require("arttexworkspace.discovery.project_tree")

local M = {}
local show_packages = false
local expanded_dirs = {}

local function file_exists(path)
  local f = io.open(path, "r")
  if f then io.close(f) return true else return false end
end

function M.open_tree(root)
  local proj = state.get_project(root)
  if not proj or not proj.ready then
    vim.notify("ArtTeX Workspace: Proyecto no analizado o fallido.", vim.log.levels.WARN)
    return
  end
  
  show_packages = false
  expanded_dirs = {} -- Todas las carpetas colapsadas por defecto
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'arttex_tree')
  
  local width = math.floor(vim.o.columns * 0.6)
  if width < 80 then width = 80 end
  local height = math.floor(vim.o.lines * 0.8)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' ArtTeX Real-Time Semantic Tree ',
    title_pos = 'center',
  })

  vim.wo[win].cursorline = true
  
  -- Integración con tu UI personalizado
  local pill_ok, pill = pcall(require, "pill-highlighter")
  if pill_ok then
    pill.setup({
      hl_group = "ArtTexTreeSelected",
      bg_color = "#2e3c64", -- TokyoNight Visual
      fg_color = "#7aa2f7",
      blend = 80, -- 80% de transparencia relativa
      hide_cursor = true,
      rounded = false -- Desactivamos el pill redondo para que abarque toda la ventana
    })
    pill.attach()
  end

  local line_to_node = {}

  local function render()
    local lines = {}
    line_to_node = {}
    
    table.insert(lines, " PROYECTO LATEX: " .. vim.fn.fnamemodify(root, ":t"))
    table.insert(lines, " Ruta: " .. root)
    table.insert(lines, " Clase: " .. (proj.document_class or "No detectada"))
    table.insert(lines, "")
    
    if show_packages then
      table.insert(lines, " [ Ocultar paquetes cargados ]")
      line_to_node[#lines] = { type = "package_toggle" }
      for pkg, _ in pairs(proj.packages) do table.insert(lines, "   ├─ " .. pkg) end
    else
      table.insert(lines, " [ Ver paquetes cargados ] (Enter para expandir)")
      line_to_node[#lines] = { type = "package_toggle" }
    end
    
    table.insert(lines, "")
    table.insert(lines, "󰙅 Árbol Semántico del Documento (Tiempo Real):")
    
    -- 1. Extraer Árbol Semántico en vivo desde el motor central (Caché Reactiva)
    local _, _, tree = structure.get_dependencies(root)
    if not tree then 
      tree = { filepath = root, children = {} }
    end

    -- 3. Renderizar el Árbol
    local function render_node(node, prefix, is_last, is_root)
      local pointer = is_last and "└── " or "├── "
      if is_root then pointer = "" end
      
      local display_name = node.filepath
      if is_root then
        display_name = vim.fn.fnamemodify(node.filepath, ":t")
      else
        display_name = vim.fn.fnamemodify(node.filepath, ":~:.")
        if display_name == vim.fn.fnamemodify(node.filepath, ":p") then
          display_name = vim.fn.fnamemodify(node.filepath, ":t")
        end
      end
      
      local icon = node.is_commented and "󰈉 " or " "
      if node.is_asset then
        icon = node.is_commented and "󰈉 " or " "
      end
      local suffix = node.is_commented and " (Comentado)" or ""
      
      local line = prefix .. pointer .. icon .. display_name .. suffix
      table.insert(lines, line)
      line_to_node[#lines] = { type = "file", path = node.filepath }
      
      local child_prefix = prefix
      if not is_root then
        child_prefix = prefix .. (is_last and "    " or "│   ")
      end
      
      for i, child in ipairs(node.children) do
        render_node(child, child_prefix, i == #node.children, false)
      end
    end

    render_node(tree, "", true, true)
    
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
  end

  render()
  
  -- Keymaps
  vim.keymap.set('n', 'q', function() vim.api.nvim_win_close(win, true) end, { buffer = buf, silent = true })
  vim.keymap.set('n', '<Esc>', function() vim.api.nvim_win_close(win, true) end, { buffer = buf, silent = true })
  
  -- Abrir archivos al dar Enter
  local function toggle_node()
    local cursor = vim.api.nvim_win_get_cursor(win)
    local node = line_to_node[cursor[1]]
    if node then
      if node.type == "package_toggle" then
        show_packages = not show_packages
        render()
        pcall(vim.api.nvim_win_set_cursor, win, cursor)
      elseif node.type == "file" then
        vim.api.nvim_win_close(win, true)
        vim.cmd("edit " .. vim.fn.fnameescape(node.path))
      end
    end
  end

  vim.keymap.set('n', '<CR>', toggle_node, { buffer = buf, silent = true })
  vim.keymap.set('n', '<kEnter>', toggle_node, { buffer = buf, silent = true })
  vim.keymap.set('n', '<2-LeftMouse>', toggle_node, { buffer = buf, silent = true })
end

return M
