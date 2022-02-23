vim.opt.list = true
-- vim.opt.listchars:append("eol:↴")

require("indent_blankline").setup {
    show_current_context = true,
    filetype_exclude = {"help", "terminal", "dashboard"},
    show_current_context_start = true,
}
