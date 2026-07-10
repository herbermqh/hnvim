local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
  return
end

trouble.setup({
  auto_close = false,      -- auto close when there are no items
  auto_preview = true,     -- automatically open preview when on an item
  auto_refresh = true,     -- auto refresh when open
  focus = true,            -- Focus the window when opened
  restore = true,          -- restores the last window in a new tab
  follow = true,           -- Follow the current item
  indent_guides = true,    -- show indent guides
  max_items = 200,         -- limit number of items that can be displayed per section
  multiline = true,        -- render multi-line messages
  pinned = false,          -- When pinned, the opened trouble window will be bound to the current buffer
  warn_no_results = true,  -- show a warning when there are no results
  open_no_results = false, -- open the trouble window when there are no results

  -- A stunning floating window setup
  modes = {
    diagnostics = {
      auto_close = false,
      auto_preview = true,
      focus = true,
      win = {
        type = "float",
        border = "rounded",
        title = " 󰒡 Diagnostics ",
        title_pos = "center",
        position = { 0.5, 0.5 },
        size = { width = 0.8, height = 0.8 },
        zindex = 200,
      },
    },
    symbols = {
      win = {
        type = "float",
        border = "rounded",
        title = " 󰌗 Symbols ",
        title_pos = "center",
        position = { 0.5, 0.5 },
        size = { width = 0.4, height = 0.6 },
        zindex = 200,
      },
    },
    lsp_references = {
      win = {
        type = "float",
        border = "rounded",
        title = " 󰈙 References ",
        title_pos = "center",
        position = { 0.5, 0.5 },
        size = { width = 0.8, height = 0.8 },
      }
    },
    qflist = {
      auto_close = false,
      auto_preview = true,
      focus = true,
      win = {
        type = "float",
        border = "rounded",
        title = " 󰒡 Errores ArtTeX (Quickfix) ",
        title_pos = "center",
        position = { 1, 0.5 },
        size = { width = 0.9, height = 0.15 },
        zindex = 200,
      }
    }
  },

  -- Custom icons to match the rich visual setup
  icons = {
    indent = {
      top         = "│ ",
      middle      = "├╴",
      last        = "└╴",
      fold_open   = "▼ ",
      fold_closed = "▶ ",
      ws          = "  ",
    },
    folder_closed = " ",
    folder_open   = " ",
    kinds = {
      Array         = " ",
      Boolean       = "󰨙 ",
      Class         = " ",
      Constant      = "󰏿 ",
      Constructor   = " ",
      Dictionary    = " ",
      Enum          = " ",
      EnumMember    = " ",
      Event         = " ",
      Field         = " ",
      File          = " ",
      Function      = "󰊕 ",
      Interface     = " ",
      Key           = " ",
      Method        = "󰊕 ",
      Module        = " ",
      Namespace     = "󰦮 ",
      Null          = " ",
      Number        = "󰎠 ",
      Object        = " ",
      Operator      = " ",
      Package       = " ",
      Property      = " ",
      String        = " ",
      Struct        = "󰆼 ",
      TypeParameter = " ",
      Variable      = "󰀫 ",
    },
  },
})

-- Force Trouble floats to be transparent to align with tokyonight's float settings
vim.api.nvim_create_autocmd({ "ColorScheme", "UIEnter" }, {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      pcall(vim.api.nvim_set_hl, 0, "TroubleNormal", { bg = "none" })
      pcall(vim.api.nvim_set_hl, 0, "TroubleNormalNC", { bg = "none" })
      pcall(vim.api.nvim_set_hl, 0, "TroubleNormalFloat", { bg = "none" })
      pcall(vim.api.nvim_set_hl, 0, "TroubleNormalFloatNC", { bg = "none" })
    end)
  end,
})
