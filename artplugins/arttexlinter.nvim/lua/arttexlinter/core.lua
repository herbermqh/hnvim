local M = {}
local config = require("arttexlinter.config")
local chktex = require("arttexlinter.backends.chktex")

function M.lint()
  if not config.options.enabled then
    M.clear()
    return
  end
  
  local bufnr = vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  
  if filepath == "" or not filepath:match("%.tex$") then return end
  
  if config.options.backend == "chktex" then
    chktex.lint(bufnr, filepath)
  end
end

function M.clear()
  local bufnr = vim.api.nvim_get_current_buf()
  if config.options.backend == "chktex" then
    chktex.clear(bufnr)
  end
end

return M
