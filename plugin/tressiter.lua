require 'nvim-treesitter.configs'.setup{
  ensure_installed = 'maintained',
  incremental_selection = { enable = false },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true },

  rainbow = {
    enable = true,
    extended_mode = true,
  },
}

vim.cmd[[
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
]]
