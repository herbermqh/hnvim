require'nvim-treesitter.configs'.setup{
  ensure_installed = {"python","lua","latex","html", "css"},
  sync_install=true,
  auto_install=true,
  disable = {"latex"},
  incremental_selection = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = {""},
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = {"yaml"}},
  rainbow = {
    enable = true,
    query = 'rainbow-parens',
    extended_mode = true,
    strategy = require('ts-rainbow').strategy.global,
  },
  autotag={
    enable = true,
    filetypes = {"latex", "tex"}
  },
}
