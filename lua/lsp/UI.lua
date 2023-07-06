-- ------------------------Borders

local border = {
      {"╭", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╮", "FloatBorder"},
      {"│", "FloatBorder"},
      {"╯", "FloatBorder"},
      {"─", "FloatBorder"},
      {"╰", "FloatBorder"},
      {"│", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border }),
}

-- Do not forget to use the on_attach function
-- require 'lspconfig'.myserver.setup { handlers=handlers }
-- require 'lspconfig'.texlab.setup { handlers=handlers }
-- require 'lspconfig'.pyright.setup { handlers=handlers }

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- require 'lspconfig'.myservertwo.setup {}
-- require 'lspconfig'.texlab.setup {}
-- require 'lspconfig'.pyright.setup {}


-- -------------------------------Completion kinds
-- local M = {}
-- M.icons = {
--   Class = " ",
--   Color = " ",
--   Constant = " ",
--   Constructor = " ",
--   Enum = " ",
--   EnumMember = " ",
--   Field = " ",
--   File = " ",
--   Folder = " ",
--   Function = " ",
--   Interface = "ﰮ ",
--   Keyword = " ",
--   Method = "ƒ ",
--   Module = " ",
--   Property = " ",
--   Snippet = "﬌ ",
--   Struct = " ",
--   Text = " ",
--   Unit = " ",
--   Value = " ",
--   Variable = " ",
-- }
-- function M.setup()
--   local kinds = vim.lsp.protocol.CompletionItemKind
--   for i, kind in ipairs(kinds) do
--     kinds[i] = M.icons[kind] or kind
--   end
-- end
-- return M

-- ---------------------------------Customizing how diagnostics are displayed
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})


-- --------------------------------Change diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- -------------------------------Print diagnostics to message area



-- -------------------------------Show line diagnostics automatically in hover window

vim.o.updatetime = 10
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]

-- --------------------------------Go-to definition in a split window


-- --------------------------Show source in diagnostics
vim.diagnostic.config({
  virtual_text = {
    source = "always",  -- Or "if_many"
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})

-- ------------------------------Change prefix/character preceding the diagnostics' virtual text
vim.diagnostic.config({
  virtual_text = {
    prefix = '󱎸', -- Could be '●', '▎', 'x'
  }
})



-- ------------------------------Highlight line number instead of having icons in sign column




