vim.opt.runtimepath:append("/home/userh/.config/nvim/artplugins/arttexconceal.nvim")
local scanner = require("arttexconceal.scanner")
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  "\\textbf{procesar}"
})
vim.bo[buf].filetype = "tex"
vim.treesitter.start(buf, "latex")
local parser = vim.treesitter.get_parser(buf, "latex")
parser:parse()
scanner.process_lines(buf, 0, 1)

local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, {details = true})
for _, em in ipairs(extmarks) do
  print(vim.inspect(em))
end
