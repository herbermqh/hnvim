-- -----------------------------------Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
require'lspconfig'.html.setup {
  capabilities = capabilities
}

require'lspconfig'.texlab.setup {
  capabilities = capabilities,
  cmd = { "texlab" },
  filetypes = { "tex", "bib", "sty", "latex", "cls"},
}

--[[ require'lspconfig'.ltex.setup{
  capabilities = capabilities
} ]]

require'lspconfig'.pyright.setup{
  capabilities = capabilities
}

require'lspconfig'.ts_ls.setup{
  capabilities = capabilities,
}

require'lspconfig'.bashls.setup{
  capabilities = capabilities
}

require'lspconfig'.vimls.setup{
  capabilities = capabilities
}

require'lspconfig'.cssls.setup{
  capabilities = capabilities
}

require'lspconfig'.markdown_oxide.setup{
  capabilities = capabilities
}

-- require'lspconfig'.sumneko_lua.setup{
--   capabilities = capabilities
-- }

-- require'lspconfig'.zeta_note.setup{
  -- capabilities = capabilities
-- }
--
--


