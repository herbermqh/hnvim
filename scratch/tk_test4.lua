-- Disable arttexsourcecolor from loading by removing it from rtp or not calling setup
vim.cmd("colorscheme tokyonight")
local hl = vim.api.nvim_get_hl(0, {name = "@markup.strong"})
print("strong:", vim.inspect(hl))
local hl2 = vim.api.nvim_get_hl(0, {name = "@markup.italic"})
print("italic:", vim.inspect(hl2))
