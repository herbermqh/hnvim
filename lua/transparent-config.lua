require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = { -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {
    "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
    "NvimTreeNormal", -- NvimTree
    "BufferTabpageFill"
  }, -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})
require('transparent').clear_prefix('BufferLine')
require('transparent').clear_prefix('NeoTree')
require('transparent').clear_prefix('lualine')
require('transparent').clear_prefix('NvimTree')

-- execute TransparentEnable
-- vim.cmd('autocmd ColorScheme * lua require("transparent").enable()')
-- `
