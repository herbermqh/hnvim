local rainbow_delimiters = require 'rainbow-delimiters'

-- Inyectamos colores personalizados vibrantes (Estilo TokyoNight Premium)
vim.api.nvim_create_autocmd({"UIEnter", "ColorScheme"}, {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#f7768e", bold = true })
vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#ff9e64", bold = true })
vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#e0af68", bold = true })
vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#9ece6a", bold = true })
vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#7dcfff", bold = true })
local blue = (vim.g.colors_name == "tknvivid" and "#689dff" or "#7aa2f7")
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = blue, bold = true })
  end
})
vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#bb9af7", bold = true })

vim.g.rainbow_delimiters = {
    strategy = {
        [''] = rainbow_delimiters.strategy['global'],
        -- Usamos estrategia local para LaTeX porque tiene entornos muy anidados
        latex = rainbow_delimiters.strategy['local'],
        tex = rainbow_delimiters.strategy['local'],
    },
    query = {
        [''] = 'rainbow-delimiters',
        -- Para LaTeX, rainbow-blocks colorea los \begin{} y \end{}
        latex = 'rainbow-blocks',
        tex = 'rainbow-blocks',
        lua = 'rainbow-blocks',
    },
    priority = {
        [''] = 110,
        latex = 210,
    },
    highlight = {
        'RainbowRed',
        'RainbowOrange',
        'RainbowYellow',
        'RainbowGreen',
        'RainbowCyan',
        'RainbowBlue',
        'RainbowViolet',
    },
    blacklist = { 'c', 'cpp' },
}
