local M = require("arttexconceal.scanner_new")
local buf = vim.api.nvim_create_buf(false, true)
vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
    "\\section{Intro}",
    "\\textbf{bold}",
    "\\begin{equation}",
    "\\sqrt{x}",
    "\\end{equation}"
})
vim.bo[buf].filetype = "latex"
M.process_lines(buf, 0, 5)
print("Success!")
