-- Autopairs
local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')

-- npairs.add_rule(Rule("$","$","tex"))
npairs.add_rule(Rule("`","","tex"))
npairs.add_rule(Rule("'","","tex"))

-- blankline config
local highlight = {
            'RainbowDelimiterRed',
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
}
            -- 'RainbowDelimiterRed',
            -- 'RainbowDelimiterYellow',
            -- 'RainbowDelimiterBlue',
            -- 'RainbowDelimiterOrange',
            -- 'RainbowDelimiterGreen',
            -- 'RainbowDelimiterViolet',
            -- 'RainbowDelimiterCyan',

local hooks = require "ibl.hooks"
-- create the highlight groups in the highlight setup hook, so they are reset
-- every time the colorscheme changes
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup { indent = { highlight = highlight } }
-- =========================================
-- MEJORAS VISUALES PARA LATEX (Treesitter + VimTeX)
-- =========================================

-- 2. Inyección de Colores Premium (Tokyonight)
local function set_latex_highlights()
    -- Comandos y Entornos
    vim.api.nvim_set_hl(0, "@function.macro.latex", { fg = "#bb9af7", bold = true }) -- \textbf, \section (Treesitter)
    vim.api.nvim_set_hl(0, "texCmd", { fg = "#bb9af7", bold = true }) -- Comandos (VimTeX)
    
    vim.api.nvim_set_hl(0, "@markup.environment.name.latex", { fg = "#ff9e64", bold = true, italic = true }) -- {align*} (Treesitter)
    vim.api.nvim_set_hl(0, "texEnvOpt", { fg = "#ff9e64", bold = true, italic = true }) -- {align*} (VimTeX)
    
    vim.api.nvim_set_hl(0, "texCmdEnv", { fg = "#7dcfff", bold = true }) -- \begin / \end (VimTeX)

    -- Matemáticas (Color unificado para todo el bloque matemático)
    -- Le damos un tono azul celeste/verdoso para diferenciar la matemática del texto normal
    local math_color = "#86e1fc"
    vim.api.nvim_set_hl(0, "@markup.math.latex", { fg = math_color }) 
    vim.api.nvim_set_hl(0, "texMathZoneX", { fg = math_color }) 
    vim.api.nvim_set_hl(0, "texMathZoneW", { fg = math_color }) 
    vim.api.nvim_set_hl(0, "texMathZoneEnv", { fg = math_color }) 

    -- Puntuación matemática ($, \[, \]) en rojo vibrante para distinguir los límites
    vim.api.nvim_set_hl(0, "@punctuation.special.latex", { fg = "#f7768e", bold = true })
    vim.api.nvim_set_hl(0, "texMathOper", { fg = "#f7768e", bold = true })

    -- Referencias y Citas
    vim.api.nvim_set_hl(0, "@markup.link.latex", { fg = "#7aa2f7", underline = true })
    vim.api.nvim_set_hl(0, "texRefZone", { fg = "#7aa2f7", underline = true })
end

-- Ejecutamos la inyección al abrir el archivo y la anclamos por si cambia el tema
set_latex_highlights()
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = set_latex_highlights
})
