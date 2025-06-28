local rainbow_delimiters = require 'rainbow-delimiters'
vim.g.rainbow_delimiters = {
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            commonlisp = rainbow_delimiters.strategy['local'],
            html = rainbow_delimiters.strategy['local'],
            -- Use local for HTML
            -- html = rainbow.strategy['local'],
            -- Pick the strategy for LaTeX dynamically based on the buffer size
            -- latex = function(bufnr)
            --     -- Disabled for very large files, global strategy for large files,
            --     -- local strategy otherwise
            --     local line_count = vim.api.nvim_buf_line_count(bufnr)
            --     if line_count > 10000 then
            --         return nil
            --     elseif line_count > 1000 then
            --         return rainbow_delimiters.strategy['global']
            --     end
            --     return rainbow_delimiters.strategy['local']
            -- end
            latex = rainbow_delimiters.strategy['global'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
            latex = 'rainbow-art',
            tex = 'rainbow-blocks',
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
