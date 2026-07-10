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
      sidebars = { "qf", "help", "terminal", "lazy", "NvimTree"}, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
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
        hl.StatusLine = {
          bg = "none",
        }
        hl.StatusLineNC = {
          bg = "none",
        }
        
        -- Make the active tab heavily stand out (resaltante)
        hl.BufferCurrent = { bg = c.blue, fg = c.bg_dark, bold = true }
        hl.BufferCurrentSign = { fg = c.blue, bg = "none" }
        hl.BufferCurrentSignRight = { fg = c.blue, bg = "none" }
        
        -- Usar colores explícitos en lugar de 'link' para que barbar no los sobreescriba
        hl.BufferCurrentMod = { bg = c.blue, fg = c.bg_dark }
        hl.BufferCurrentIcon = { bg = c.blue, fg = c.bg_dark }
        hl.BufferCurrentBtn = { bg = c.blue, fg = c.bg_dark }
        hl.BufferCurrentModBtn = { bg = c.blue, fg = c.bg_dark }
        hl.BufferCurrentPinBtn = { bg = c.blue, fg = c.bg_dark }
        
        -- Fijar los colores de diagnóstico generados por LSP para que el fondo sea igual a la pestaña
        hl.BufferCurrentERROR = { bg = c.blue, fg = c.error }
        hl.BufferCurrentWARN = { bg = c.blue, fg = c.warning }
        hl.BufferCurrentINFO = { bg = c.blue, fg = c.info }
        hl.BufferCurrentHINT = { bg = c.blue, fg = c.hint }

        -- Keep it visible but clearly inactive (muted) when focus is on NvimTree
        hl.BufferVisible = { bg = c.bg_highlight, fg = c.blue, bold = false }
        hl.BufferVisibleSign = { fg = c.bg_highlight, bg = "none" }
        hl.BufferVisibleSignRight = { fg = c.bg_highlight, bg = "none" }
        
        hl.BufferVisibleMod = { bg = c.bg_highlight, fg = c.blue }
        hl.BufferVisibleIcon = { bg = c.bg_highlight, fg = c.blue }
        hl.BufferVisibleBtn = { bg = c.bg_highlight, fg = c.blue }
        hl.BufferVisibleModBtn = { bg = c.bg_highlight, fg = c.blue }
        hl.BufferVisiblePinBtn = { bg = c.bg_highlight, fg = c.blue }
        
        -- Fijar también los diagnósticos de pestañas visibles pero inactivas
        hl.BufferVisibleERROR = { bg = c.bg_highlight, fg = c.error }
        hl.BufferVisibleWARN = { bg = c.bg_highlight, fg = c.warning }
        hl.BufferVisibleINFO = { bg = c.bg_highlight, fg = c.info }
        hl.BufferVisibleHINT = { bg = c.bg_highlight, fg = c.hint }
        
        -- NvimTree full width cursor block
        hl.NvimTreeCursorLine = { bg = "#292e42", bold = true }
        
        -- LSP Virtual Text (hacer que el fondo de las advertencias sea transparente)
        hl.DiagnosticVirtualTextError = { bg = "none", fg = c.error }
        hl.DiagnosticVirtualTextWarn = { bg = "none", fg = c.warning }
        hl.DiagnosticVirtualTextInfo = { bg = "none", fg = c.info }
        hl.DiagnosticVirtualTextHint = { bg = "none", fg = c.hint }
      end,
    })
--





vim.cmd[[colorscheme tokyonight]]

-- Forzar que los símbolos de diagnóstico y modificación de Barbar compartan el fondo de la pestaña.
-- Usamos vim.schedule para asegurar que esto se aplique DESPUÉS de que Barbar calcule sus propios colores.
vim.api.nvim_create_autocmd({"UIEnter", "ColorScheme"}, {
  pattern = "*",
  callback = function()
    vim.schedule(function()
      local blue = "#7aa2f7"
      local bg_highlight = "#292e42"
      local bg_dark = "#1f2335" -- Color del texto en la pestaña activa
      
      local set_hl = vim.api.nvim_set_hl
      
      -- Símbolos en pestaña activa (fondo celeste, texto oscuro para legibilidad)
      set_hl(0, "BufferCurrentWARN", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentERROR", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentINFO", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentHINT", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentDiagnosticWarn", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentDiagnosticError", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentDiagnosticInfo", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentDiagnosticHint", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentMod", { bg = blue, fg = bg_dark, bold = true })
      set_hl(0, "BufferCurrentModBtn", { bg = blue, fg = bg_dark, bold = true })
      
      -- Símbolos en pestaña visible pero inactiva (fondo gris oscuro, texto azul para armonizar con el tema)
      set_hl(0, "BufferVisibleWARN", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleERROR", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleINFO", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleHINT", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleDiagnosticWarn", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleDiagnosticError", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleDiagnosticInfo", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleDiagnosticHint", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleMod", { bg = bg_highlight, fg = blue })
      set_hl(0, "BufferVisibleModBtn", { bg = bg_highlight, fg = blue })
      
      -- Símbolos en pestaña inactiva (fondo transparente, texto azul)
      set_hl(0, "BufferInactiveWARN", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveERROR", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveINFO", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveHINT", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveDiagnosticWarn", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveDiagnosticError", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveDiagnosticInfo", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveDiagnosticHint", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveMod", { bg = "none", fg = blue })
      set_hl(0, "BufferInactiveModBtn", { bg = "none", fg = blue })
    end)
  end
})
