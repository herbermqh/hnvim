-- vim.env.PATH = "/home/userh/.local/bin:" .. vim.env.PATH
-- Configuracion de teclas y copilot
vim.g.copilot_no_tab_map = true

require('plugins')
-- require('floaterm')
-- require('dap')
require('icons')
require('utils')
require('settings')
require('mappings')
require('gui')
require('cpu-ram-optimizer')

-- require('hgalaxyline')
-- require('compe-config')
-- require('lspkind-config')

-- require('wildermenu-config')
-- require('alpha-nvim-config')
-- require('cmdline')
require('devscript')
require('latextoillustrator')


-- require('alpha-nvim-config')
vim.deprecate = function() end
