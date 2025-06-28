--
--
--
--
require'nvim-treesitter.configs'.setup{
  ensure_installed = {"python","lua","latex","html", "css", "javascript","markdown"},
  sync_install=true,
  auto_install=true,
  incremental_selection = {
    enable = true,
  },
  highlight = {
    enable = true,
    -- disable = {"latex"},
    additional_vim_regex_highlighting = true,
  },
  indent = {enable = true, disable = {"yaml"}},
  autotag={
    enable = true,
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
  },
}



  -- rainbow = {
  --   enable = true,
  --   query = {
  --     'rainbow-parens',
  --     html = 'rainbow-tags',
  --     latex = 'rainbow-art',
  --   },
  --   extended_mode = true,
  --   -- strategy = require('ts-rainbow').strategy.global,
  --   strategy = {
  --       -- Use global strategy by default
  --       rainbow.strategy['global'],
  --       -- Use local for HTML
  --       html = rainbow.strategy['local'],
  --       -- Pick the strategy for LaTeX dynamically based on the buffer size
  --       -- latex = function()
  --       --     if vim.fn.line('$') > 10000 then
  --       --         return nil
  --       --     elseif vim.fn.line('$') > 1000 then
  --       --         return rainbow.strategy['global']
  --       --     end
  --       --     return rainbow.strategy['local']
  --       -- end
  --   },
  --   hlgroups = {
  --              'TSRainbowGreen',
  --              'TSRainbowYellow',
  --              'TSRainbowOrange',
  --              'TSRainbowRed',
  --              'TSRainbowViolet',
  --              'TSRainbowCyan',
  --              'TSRainbowBlue',
  --           },
  -- },


