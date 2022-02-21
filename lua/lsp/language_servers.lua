-- -----------------------------------Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require'lspconfig'.html.setup {
  capabilities = capabilities
}

require'lspconfig'.texlab.setup {
  capabilities = capabilities
}

--[[ require'lspconfig'.ltex.setup{
  capabilities = capabilities
} ]]

require'lspconfig'.pyright.setup{
  capabilities = capabilities
}

require'lspconfig'.tsserver.setup{
  capabilities = capabilities
}

require'lspconfig'.bashls.setup{
  capabilities = capabilities
}
