local M = {}

function M.build_forward_search(pdf_file, tex_file, line, col)
  -- Okular usa la bandera --unique y el formato de ancla #src:line archivo
  local args = {
    "--unique",
    string.format("%s#src:%d %s", pdf_file, line, tex_file)
  }
  
  return "okular", args
end

return M
