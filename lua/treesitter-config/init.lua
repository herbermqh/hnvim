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
    disable = {""},
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
    extended_mode = true,
    strategy = {
      rainbow.strategy['global'],
      latex = function()
            -- Disabled for very large files, global strategy for large files,
            -- local strategy otherwise
            if vim.fn.line('$') > 10000 then
                return nil
            elseif vim.fn.line('$') > 1000 then
                return rainbow.strategy['global']
            end
            return rainbow.strategy['local']
        end
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
    enable = true,
  },
}
