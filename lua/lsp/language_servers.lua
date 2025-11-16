-- -----------------------------------Setup LSP servers using vim.lsp.config (Neovim 0.11+)
local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Configure LSP servers using the new vim.lsp.config API
local servers = {
  html = {
    capabilities = capabilities,
  },
  texlab = {
    capabilities = capabilities,
    cmd = { "texlab" },
    filetypes = { "tex", "bib", "sty", "latex", "cls" },
  },
  pyright = {
    capabilities = capabilities,
  },
  ts_ls = {
    capabilities = capabilities,
  },
  bashls = {
    capabilities = capabilities,
  },
  vimls = {
    capabilities = capabilities,
  },
  cssls = {
    capabilities = capabilities,
  },
  markdown_oxide = {
    capabilities = capabilities,
  },
}

-- Set up each server using vim.lsp.config
for server_name, config in pairs(servers) do
  vim.lsp.config(server_name, config)
end

-- Uncommented servers for reference:
-- ltex = { capabilities = capabilities }
-- sumneko_lua = { capabilities = capabilities }
-- zeta_note = { capabilities = capabilities }


