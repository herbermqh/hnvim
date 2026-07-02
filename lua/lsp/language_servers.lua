local lspconfig = require('lspconfig')
-- -----------------------------------Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
lspconfig.html.setup {
  capabilities = capabilities
}

lspconfig.texlab.setup {
  capabilities = capabilities,
  cmd = { "texlab" },
  filetypes = { "tex", "bib", "sty", "latex", "cls"},
}

--[[ require'lspconfig'.ltex.setup{
  capabilities = capabilities
} ]]

lspconfig.pyright.setup{
  capabilities = capabilities
}

lspconfig.ts_ls.setup{
  capabilities = capabilities,
}

lspconfig.bashls.setup{
  capabilities = capabilities
}

lspconfig.vimls.setup{
  capabilities = capabilities
}

lspconfig.cssls.setup{
  capabilities = capabilities
}

lspconfig.markdown_oxide.setup{
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


