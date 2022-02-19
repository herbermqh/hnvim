require 'nvim-treesitter.configs'.setup{
  ensure_installed = {"python","lua","latex"},
  incremental_selection = { enable = false },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = false },
  rainbow = {
    enable = true,
    extended_mode = true,
  },
}
