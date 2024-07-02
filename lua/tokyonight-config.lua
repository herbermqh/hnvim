require("tokyonight").setup({
      -- your configuration comes here
      -- or leave it empty to use the default settings
      style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
      light_style = "night",
      terminal_colors = true,
      transparent = true, -- Enable this to disable setting the background color
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = { italic = true },
        variables = { italic = true },
        -- Background styles. Can be "dark", "transparent" or "normal"
        sidebars = "transparent", -- style for sidebars, see below
        floats = "transparent", -- style for floating windows
      },
      sidebars = { "qf", "help", "terminal", "packer"}, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
      day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
      hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
      dim_inactive = false, -- dims inactive windows
      lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
    
      --- You can override specific color groups to use other groups or a hex color
      --- function will be called with a ColorScheme table
      ---@param colors ColorScheme
      on_colors = function(colors)
        colors.hint = colors.orange
        colors.error = "#ff0000"
      end,
    
      --- You can override specific highlights to use other groups or a hex color
      --- function will be called with a Highlights and ColorScheme table
      ---@param highlights Highlights
      ---@param colors ColorScheme
      on_highlights = function(hl, c)
        local prompt = "#2d3149"
        hl.TelescopeNormal = {
          bg = "none",
          fg = "none",
        }
        hl.TelescopeBorder = {
          bg = "none",
          fg = "none",
        }
        hl.TelescopePromptNormal = {
          bg = "none",
        }
        hl.TelescopePromptBorder = {
          bg = "none",
          fg = "none",
        }
        hl.TelescopePromptTitle = {
          bg = "none",
          fg = "none",
        }
        hl.TelescopePreviewTitle = {
          bg = "none",
          fg = "none",
        }
        hl.TelescopeResultsTitle = {
          bg = "none",
          fg = "none",
        }
      end,
    })
--





vim.cmd[[colorscheme tokyonight]]
