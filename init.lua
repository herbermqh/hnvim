-- Configuracion de teclas y copilot
vim.g.copilot_no_tab_map = true

require('plugins')
require('dashboard-config')
require('tokyonight-config')
-- require('floaterm')
-- require('dap')
require('autosave')
require('icons')
-- require('nvim-tree-config')
-- require('providers')
require('gitsigns-config')
require('utils')
require('settings')
require('mappings')
require('gui')

-- require('hgalaxyline')
-- require('compe-config')
-- require('lspkind-config')
require('config-notify')

require('config-bqf')
-- require('wildermenu-config')
-- require('alpha-nvim-config')
-- require('cmdline')
require('devscript')
require('latextoillustrator')
require('transparent-config')
-- require('telescope-config')
-- require('copilotchat-config')
require('config.copilot')

-- require('alpha-nvim-config')
vim.deprecate = function() end
