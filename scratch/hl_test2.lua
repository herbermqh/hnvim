vim.opt.termguicolors = true
vim.cmd("colorscheme tokyonight")
local hl = vim.api.nvim_get_hl(0, {name = "@markup.strong"})
print("@markup.strong", vim.inspect(hl))
local hl2 = vim.api.nvim_get_hl(0, {name = "@markup.italic"})
print("@markup.italic", vim.inspect(hl2))
