local M = {}
local vim = vim

function M.build_forward_search(pdf_file, tex_file, line, col)
  -- termpdf.py es un visor de terminal muy usado en Kitty/Wezterm.
  -- Usualmente emula la API de forward search de Zathura/Sioyek.
  local server = vim.v.servername
  local inv_cmd = string.format("nvim --server %s --remote-send '<C-\\><C-N>:lua require(\"arttexsynctex\").api.handle_inverse_search(\"%%{input}\", %%{line})<CR>'", server)
  
  local args = {
    "--inverse-search", inv_cmd,
    "--synctex-forward", string.format("%d:%d:%s", line, col, tex_file), 
    pdf_file 
  }
  
  return "termpdf.py", args
end

return M
