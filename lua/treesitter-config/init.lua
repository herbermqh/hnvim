local rainbow_delimiters = require 'rainbow-delimiters'
vim.g.rainbow_delimiters = {
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            commonlisp = rainbow_delimiters.strategy['local'],
            html = rainbow_delimiters.strategy['local'],
            -- Use local for HTML
            -- html = rainbow.strategy['local'],
            -- -- Pick the strategy for LaTeX dynamically based on the buffer size
            latex = function(bufnr)
                -- Disabled for very large files, global strategy for large files,
                -- local strategy otherwise
                local line_count = vim.api.nvim_buf_line_count(bufnr)
                if line_count > 10000 then
                    return nil
                elseif line_count > 1000 then
                    return rainbow_delimiters.strategy['global']
                end
                return rainbow_delimiters.strategy['local']
            end
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
            latex = 'rainbow-blocks',
        },
        priority = {
            [''] = 110,
            lua = 210,
        },
        highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
        },
        blacklist = {'c', 'cpp'},
    }

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


