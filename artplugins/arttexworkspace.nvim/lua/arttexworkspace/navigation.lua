local M = {}

local function fallback_lsp()
  -- Intenta ejecutar la acción gd de Neovim por defecto (LSP)
  -- vim.lsp.buf.definition() es el estándar, pero algunos usan atajos.
  -- Simplemente mandamos a llamar a la función nativa del LSP si hay clientes atachados.
  local clients = vim.lsp.get_active_clients({ bufnr = 0 })
  local has_texlab = false
  for _, client in ipairs(clients) do
    if client.name == "texlab" then
      has_texlab = true
      break
    end
  end

  if has_texlab then
    vim.lsp.buf.definition()
  else
    vim.notify("ArtTex Workspace: No se encontró el archivo y TexLab no está activo.", vim.log.levels.WARN)
  end
end

local function find_node_in_tree(node, target_path)
  if node.filepath == target_path then return node end
  for _, child in ipairs(node.children) do
    local found = find_node_in_tree(child, target_path)
    if found then return found end
  end
  return nil
end

function M.smart_goto_file()
  -- Redirigir al módulo interactivo original que maneja Telescope y heurísticas de IA
  require("arttexworkspace.ui.goto_file").goto_file_under_cursor("gf")
end

local function search_definition_in_tree(node, target_name)
  if node.definitions then
    for _, def in ipairs(node.definitions) do
      if def.name == target_name then
        return node.filepath, def.line
      end
    end
  end
  for _, child in ipairs(node.children) do
    local path, line = search_definition_in_tree(child, target_name)
    if path then return path, line end
  end
  return nil, nil
end

local function get_macro_under_cursor()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1
  
  local start_col = col
  while start_col > 1 do
    local char = line:sub(start_col - 1, start_col - 1)
    if char:match("[%a@_]") then
      start_col = start_col - 1
    elseif char == "\\" then
      start_col = start_col - 1
      break
    else
      break
    end
  end
  
  local end_col = col
  while end_col <= #line do
    local char = line:sub(end_col, end_col)
    if char:match("[%a@_]") then
      end_col = end_col + 1
    else
      break
    end
  end
  
  local word = line:sub(start_col, end_col - 1)
  if word:sub(1, 1) == "\\" then
    word = word:sub(2)
  end
  return word
end

function M.smart_goto_definition()
  local bufnr = vim.api.nvim_get_current_buf()
  local word = get_macro_under_cursor()
  
  local api = require("arttexworkspace.init").api
  local root = api.get_root_file(bufnr)
  
  if root and word and word ~= "" then
    local _, _, tree = require("arttexworkspace.discovery.project_tree").get_dependencies(root)
    if tree then
      local path, line = search_definition_in_tree(tree, word)
      if path then
        vim.cmd("edit " .. vim.fn.fnameescape(path))
        vim.api.nvim_win_set_cursor(0, {line, 0})
        return
      end
    end
  end
  
  fallback_lsp()
end

function M.setup_keymaps()
  -- Placeholder
end

return M
