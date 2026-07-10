-- =========================================================================
-- MODERN LSP & AUTOCOMPLETION CONFIGURATION (Ultra Clean & Managed)
-- =========================================================================

-- 1. Setup Mason (Automatic LSP Installer)
require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

require("mason-lspconfig").setup({
  -- Ensure these language servers are automatically installed
  ensure_installed = { 
    "html", "pyright", "ts_ls", "bashls", "vimls", "cssls", "marksman" 
  },
})



-- 3. LSP Configuration (Applying to all servers)
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup handlers for UI (Rounded borders for hover)
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

local servers = { "html", "pyright", "ts_ls", "bashls", "vimls", "cssls", "marksman" }
for _, server in ipairs(servers) do
  lspconfig[server].setup({
    capabilities = capabilities,
  })
end

-- Texlab manual override
lspconfig.texlab.setup({
  capabilities = capabilities,
  cmd = { "texlab" },
  filetypes = { "tex", "bib", "sty", "latex", "cls"},
})

-- 4. Diagnostics & Visuals
vim.diagnostic.config({
  virtual_text = false, -- Clean code, no distracting text
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "  ",
  },
})

vim.o.updatetime = 250
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

local signs = { Error = " ", Warn  = " ", Hint  = " ", Info  = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 5. Keymaps (only load when LSP attaches to a buffer)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  end,
})


