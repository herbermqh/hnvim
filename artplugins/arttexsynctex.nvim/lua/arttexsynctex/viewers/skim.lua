local M = {}

function M.build_forward_search(pdf_file, tex_file, line, col)
  -- Skim (macOS) usa la herramienta de línea de comandos 'displayline'
  local args = {
    "-r", -- revertir al documento si ya está abierto
    "-b", -- no traer al frente (opcional, pero útil para evitar perder foco)
    tostring(line),
    pdf_file,
    tex_file
  }
  
  return "displayline", args
end

return M
