vim.g.completeopt = "menu,menuone,noselect,noinsert"

local cmp = require('cmp')



local kind_icons = {
  Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
  Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
  Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
  Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
  File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
  Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
  TypeParameter = "",
}

local luasnip = require('luasnip')

luasnip.config.set_config({
  enable_autosnippets = true,
  update_events = "TextChanged,TextChangedI",
  store_selection_keys = "<Tab>",
})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'arttex' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    -- { name = 'copilot' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'latex_symbols' },
  }, {
    { name = 'buffer' },
  }),
  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind] or "", vim_item.kind)
      return vim_item
    end
  },
  window = {
    completion = {
      border = 'rounded',
      scrollbar = false,
      winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None'
    },
    documentation = {
      border = 'rounded',
      scrollbar = false,
      winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None'
    },
  },
})

-- Cmdline search /
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Cmdline command :
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Config for luasnip (VSCode snippets loading only)

-- Config for ArtTeX Snippets (Zero-Config, auto-cargado por el plugin)

require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.expand("~/.config/nvim/lua/luasnippets/vscode") } })
