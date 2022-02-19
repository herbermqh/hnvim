require('plugins')
require('treesitter-config')
require('dashboard')
require('floaterm')

require('babar')
require('telescope-config')
require('dap')
require('autosave')

require('icons')

require('nvim-tree-config')
--require('providers')

require('gitsigns-config')

require('utils')
 
require('settings')
require('mappings')
require('gui')

require('hgalaxyline')

require('lsp')
require('compe-config')

vim.cmd[[
-- set foldmethod=expr
-- set foldexpr=nvim_treesitter#foldexpr()
-- ]]

