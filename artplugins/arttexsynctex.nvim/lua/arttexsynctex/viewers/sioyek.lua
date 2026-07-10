local M = {}
local vim = vim

function M.build_forward_search(pdf_file, tex_file, line, col)
  -- Inyección automática de Búsqueda Inversa para Sioyek
  local server = vim.v.servername
  local inv_cmd = string.format("nvim --server %s --remote-send '<C-\\><C-N>:drop %%1<CR>:%%2<CR>zz'", server)
  
  local args = {
    "--inverse-search", inv_cmd,
    "--forward-search-file", tex_file, 
    "--forward-search-line", tostring(line), 
    pdf_file 
  }
  
  return "sioyek", args
end

return M
