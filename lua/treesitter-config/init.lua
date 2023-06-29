local rainbow = require('ts-rainbow')
require'nvim-treesitter.configs'.setup{
  ensure_installed = {"python","lua","latex","html", "css"},
  sync_install=true,
  auto_install=true,
  incremental_selection = {
    enable = true,
  },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = {"yaml"}},
  rainbow = {
    enable = true,
    query = {
      'rainbow-parens',
      html = 'rainbow-tags',
      latex = 'rainbow-art',
    },
    -- extended_mode = true,
    strategy = {
      rainbow.strategy['global'],
    },
    hlgroups = {
               'TSRainbowBlue',
               'TSRainbowGreen',
               'TSRainbowCyan',
               'TSRainbowOrange',
               'TSRainbowYellow',
               'TSRainbowViolet',
               'TSRainbowRed',
            },
  },
  autotag={
    enable = false,
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}
