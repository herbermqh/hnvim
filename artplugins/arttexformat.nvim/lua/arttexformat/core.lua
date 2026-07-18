local M = {}
local config = require("arttexformat.config")
local latexindent = require("arttexformat.backends.latexindent")

function M.format_buffer(is_manual)
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  
  if filetype ~= "tex" and filetype ~= "plaintex" and filetype ~= "latex" then
    if is_manual then
      vim.notify("ArtTex Format: Solo se pueden formatear archivos de LaTeX.", vim.log.levels.WARN)
    end
    return
  end

  if config.options.backend == "latexindent" then
    latexindent.format(bufnr, is_manual)
  end
end

return M
