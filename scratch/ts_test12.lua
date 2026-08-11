vim.opt.runtimepath:append("/home/userh/.config/nvim/artplugins/arttexconceal.nvim")
local scanner = require("arttexconceal.scanner")
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
  "\\textbf{hello}",
  "\\textit{world}"
})
vim.bo[buf].filetype = "tex"
-- We need to mock extmarks.set and set_hl to see what gets called!
local extmarks = require("arttexconceal.extmarks")
extmarks.set = function(b, sr, sc, er, ec, char, hl)
  print("set:", sr, sc, char, hl)
end
extmarks.set_hl = function(b, sr, sc, er, ec, hl)
  print("set_hl:", sr, sc, hl)
end
scanner.process_lines(buf, 0, 1)
