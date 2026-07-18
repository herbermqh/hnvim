local M = {}

--- Motor ultraligero de indentación en tiempo real (0% CPU cost).
--- Evaluado nativamente por Neovim cada vez que el usuario presiona Enter.
function M.get_indent(lnum)
  if lnum == 1 then return 0 end
  local prev_lnum = vim.fn.prevnonblank(lnum - 1)
  if prev_lnum == 0 then return 0 end

  local prev_line = vim.fn.getline(prev_lnum)
  local current_line = vim.fn.getline(lnum)
  local ind = vim.fn.indent(prev_lnum)
  local sw = vim.fn.shiftwidth()

  -- Incrementar sangría después de un \begin{...} o \[
  if prev_line:match("\\begin%{[^%}%s]+%}") or prev_line:match("\\[") then
    if not prev_line:match("\\begin%{document%}") then
      ind = ind + sw
    end
  end

  -- Decrementar sangría antes de un \end{...} o \]
  if current_line:match("^%s*\\end%{[^%}%s]+%}") or current_line:match("^%s*\\]") then
    if not current_line:match("\\end%{document%}") then
      ind = ind - sw
    end
  end

  return ind
end

function M.setup_buffer(bufnr)
  -- Vinculamos la función global para que Neovim pueda llamarla desde indentexpr
  _G._arttex_indent_expr = function()
    return M.get_indent(vim.v.lnum)
  end
  vim.bo[bufnr].indentexpr = "v:lua._arttex_indent_expr()"
  vim.bo[bufnr].indentkeys = "0{,0},0),0],!^F,o,O,e,0=\\end"
end

return M
