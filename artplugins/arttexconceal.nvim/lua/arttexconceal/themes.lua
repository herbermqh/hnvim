local M = {}

M.palette = {
    tokyonight = {
        ArtTexConcealMath = { fg = "#bb9af7" },
        ArtTexConcealGreek = { fg = "#9ece6a" },
        ArtTexConcealOperator = { fg = "#7dcfff" },
        ArtTexConcealRelation = { fg = "#e0af68" },
        ArtTexConcealArrow = { fg = "#ff9e64" },
        ArtTexConcealRoot = { fg = "#f7768e" },
        ArtTexConcealRoot2 = { fg = "#ff9e64" },
        ArtTexConcealRoot3 = { fg = "#e0af68" },
        ArtTexConcealRoot4 = { fg = "#9ece6a" },
        ArtTexConcealMathbb = { fg = "#7aa2f7" },
        ArtTexConcealMathsf = { fg = "#9ece6a" },
        ArtTexConcealMathfrak = { fg = "#f7768e" },
        ArtTexConcealMathcal = { fg = "#e0af68" },
        ArtTexConcealMathscr = { fg = "#e0af68" },
        ArtTexConcealFrac = { fg = "#7dcfff" },
        ArtTexConcealSuper = { fg = "#ff9e64" },
        ArtTexConcealSub = { fg = "#f7768e" },
        ArtTexConcealSpecial = { fg = "#2ac3de" },
        ArtTexConcealBold = { bold = true },
        ArtTexConcealItalic = { italic = true },
        ArtTexConcealMathsf = { fg = "#7aa2f7", italic = true },
        -- Semantic rainbow groups
        ArtTexConcealEnv = { fg = "#565f89" },
        ArtTexConcealChapter = { fg = "#bb9af7", bold = true },
        ArtTexConcealSection = { fg = "#f7768e", bold = true },
        ArtTexConcealSubSection = { fg = "#ff9e64", bold = true },
        ArtTexConcealSubSubSection = { fg = "#e0af68", bold = true },
        ArtTexConcealNote = { fg = "#9ece6a" },
        ArtTexConcealRef = { fg = "#2ac3de" },
        ArtTexConcealLabel = { fg = "#7aa2f7" },
        ArtTexConcealEngine = { fg = "#bb9af7", bold = true },
        ArtTexConcealImage = { fg = "#ff9e64" },
        ArtTexConcealRainbow1 = { fg = "#f7768e" },
        ArtTexConcealRainbow2 = { fg = "#ff9e64" },
        ArtTexConcealRainbow3 = { fg = "#e0af68" },
        ArtTexConcealRainbow4 = { fg = "#9ece6a" },
        ArtTexConcealRainbow5 = { fg = "#7dcfff" },
        ArtTexConcealRainbow6 = { fg = "#bb9af7" },

    },
    catppuccin = {
        ArtTexConcealMath = { fg = "#cba6f7" },
        ArtTexConcealGreek = { fg = "#a6e3a1" },
        ArtTexConcealOperator = { fg = "#89dceb" },
        ArtTexConcealRelation = { fg = "#f9e2af" },
        ArtTexConcealArrow = { fg = "#fab387" },
        ArtTexConcealRoot = { fg = "#f38ba8" },
        ArtTexConcealRoot2 = { fg = "#fab387" },
        ArtTexConcealRoot3 = { fg = "#f9e2af" },
        ArtTexConcealRoot4 = { fg = "#a6e3a1" },
        ArtTexConcealMathbb = { fg = "#89b4fa" },
        ArtTexConcealMathsf = { fg = "#a6e3a1" },
        ArtTexConcealMathfrak = { fg = "#f38ba8" },
        ArtTexConcealMathcal = { fg = "#f9e2af" },
        ArtTexConcealMathscr = { fg = "#f9e2af" },
        ArtTexConcealFrac = { fg = "#89dceb" },
        ArtTexConcealSuper = { fg = "#fab387" },
        ArtTexConcealSub = { fg = "#eba0ac" },
        ArtTexConcealSpecial = { fg = "#94e2d5" },
        ArtTexConcealBold = { bold = true },
        ArtTexConcealItalic = { italic = true },
        ArtTexConcealMathsf = { fg = "#89b4fa", italic = true },
        -- Semantic rainbow groups
        ArtTexConcealEnv = { fg = "#6c7086" },
        ArtTexConcealChapter = { fg = "#cba6f7", bold = true },
        ArtTexConcealSection = { fg = "#f38ba8", bold = true },
        ArtTexConcealSubSection = { fg = "#fab387", bold = true },
        ArtTexConcealSubSubSection = { fg = "#f9e2af", bold = true },
        ArtTexConcealNote = { fg = "#a6e3a1" },
        ArtTexConcealRef = { fg = "#94e2d5" },
        ArtTexConcealLabel = { fg = "#89b4fa" },
        ArtTexConcealEngine = { fg = "#cba6f7", bold = true },
        ArtTexConcealImage = { fg = "#fab387" },
        ArtTexConcealRainbow1 = { fg = "#f38ba8" },
        ArtTexConcealRainbow2 = { fg = "#fab387" },
        ArtTexConcealRainbow3 = { fg = "#f9e2af" },
        ArtTexConcealRainbow4 = { fg = "#a6e3a1" },
        ArtTexConcealRainbow5 = { fg = "#89dceb" },
        ArtTexConcealRainbow6 = { fg = "#cba6f7" },

    },
    dracula = {
        ArtTexConcealMath = { fg = "#bd93f9" },
        ArtTexConcealGreek = { fg = "#50fa7b" },
        ArtTexConcealOperator = { fg = "#8be9fd" },
        ArtTexConcealRelation = { fg = "#f1fa8c" },
        ArtTexConcealArrow = { fg = "#ffb86c" },
        ArtTexConcealRoot = { fg = "#ff5555" },
        ArtTexConcealRoot2 = { fg = "#ffb86c" },
        ArtTexConcealRoot3 = { fg = "#f1fa8c" },
        ArtTexConcealRoot4 = { fg = "#50fa7b" },
        ArtTexConcealMathbb = { fg = "#8be9fd" },
        ArtTexConcealMathsf = { fg = "#50fa7b" },
        ArtTexConcealMathfrak = { fg = "#ff5555" },
        ArtTexConcealMathcal = { fg = "#f1fa8c" },
        ArtTexConcealMathscr = { fg = "#f1fa8c" },
        ArtTexConcealFrac = { fg = "#8be9fd" },
        ArtTexConcealSuper = { fg = "#ffb86c" },
        ArtTexConcealSub = { fg = "#ff79c6" },
        ArtTexConcealSpecial = { fg = "#bd93f9" },
        ArtTexConcealBold = { bold = true },
        ArtTexConcealItalic = { italic = true },
        ArtTexConcealMathsf = { fg = "#8be9fd", italic = true },
        -- Semantic rainbow groups
        ArtTexConcealEnv = { fg = "#6272a4" },
        ArtTexConcealChapter = { fg = "#bd93f9", bold = true },
        ArtTexConcealSection = { fg = "#ff5555", bold = true },
        ArtTexConcealSubSection = { fg = "#ffb86c", bold = true },
        ArtTexConcealSubSubSection = { fg = "#f1fa8c", bold = true },
        ArtTexConcealNote = { fg = "#50fa7b" },
        ArtTexConcealRef = { fg = "#8be9fd" },
        ArtTexConcealLabel = { fg = "#bd93f9" },
        ArtTexConcealEngine = { fg = "#ff79c6", bold = true },
        ArtTexConcealImage = { fg = "#ffb86c" },
        ArtTexConcealRainbow1 = { fg = "#ff5555" },
        ArtTexConcealRainbow2 = { fg = "#ffb86c" },
        ArtTexConcealRainbow3 = { fg = "#f1fa8c" },
        ArtTexConcealRainbow4 = { fg = "#50fa7b" },
        ArtTexConcealRainbow5 = { fg = "#8be9fd" },
        ArtTexConcealRainbow6 = { fg = "#bd93f9" },

    },
    nord = {
        ArtTexConcealMath = { fg = "#b48ead" },
        ArtTexConcealGreek = { fg = "#a3be8c" },
        ArtTexConcealOperator = { fg = "#88c0d0" },
        ArtTexConcealRelation = { fg = "#ebcb8b" },
        ArtTexConcealArrow = { fg = "#d08770" },
        ArtTexConcealRoot = { fg = "#bf616a" },
        ArtTexConcealRoot2 = { fg = "#d08770" },
        ArtTexConcealRoot3 = { fg = "#ebcb8b" },
        ArtTexConcealRoot4 = { fg = "#a3be8c" },
        ArtTexConcealMathbb = { fg = "#81a1c1" },
        ArtTexConcealMathsf = { fg = "#a3be8c" },
        ArtTexConcealMathfrak = { fg = "#bf616a" },
        ArtTexConcealMathcal = { fg = "#ebcb8b" },
        ArtTexConcealMathscr = { fg = "#ebcb8b" },
        ArtTexConcealFrac = { fg = "#88c0d0" },
        ArtTexConcealSuper = { fg = "#d08770" },
        ArtTexConcealSub = { fg = "#bf616a" },
        ArtTexConcealSpecial = { fg = "#5e81ac" },
        ArtTexConcealBold = { bold = true },
        ArtTexConcealItalic = { italic = true },
        ArtTexConcealMathsf = { fg = "#81a1c1", italic = true },
        -- Semantic rainbow groups
        ArtTexConcealEnv = { fg = "#4c566a" },
        ArtTexConcealChapter = { fg = "#b48ead", bold = true },
        ArtTexConcealSection = { fg = "#bf616a", bold = true },
        ArtTexConcealSubSection = { fg = "#d08770", bold = true },
        ArtTexConcealSubSubSection = { fg = "#ebcb8b", bold = true },
        ArtTexConcealNote = { fg = "#a3be8c" },
        ArtTexConcealRef = { fg = "#88c0d0" },
        ArtTexConcealLabel = { fg = "#81a1c1" },
        ArtTexConcealEngine = { fg = "#b48ead", bold = true },
        ArtTexConcealImage = { fg = "#d08770" },
        ArtTexConcealRainbow1 = { fg = "#bf616a" },
        ArtTexConcealRainbow2 = { fg = "#d08770" },
        ArtTexConcealRainbow3 = { fg = "#ebcb8b" },
        ArtTexConcealRainbow4 = { fg = "#a3be8c" },
        ArtTexConcealRainbow5 = { fg = "#88c0d0" },
        ArtTexConcealRainbow6 = { fg = "#b48ead" },

    },
    onedark = {
        ArtTexConcealMath = { fg = "#c678dd" },
        ArtTexConcealGreek = { fg = "#98c379" },
        ArtTexConcealOperator = { fg = "#56b6c2" },
        ArtTexConcealRelation = { fg = "#e5c07b" },
        ArtTexConcealArrow = { fg = "#d19a66" },
        ArtTexConcealRoot = { fg = "#e06c75" },
        ArtTexConcealRoot2 = { fg = "#d19a66" },
        ArtTexConcealRoot3 = { fg = "#e5c07b" },
        ArtTexConcealRoot4 = { fg = "#98c379" },
        ArtTexConcealMathbb = { fg = "#61afef" },
        ArtTexConcealMathsf = { fg = "#98c379" },
        ArtTexConcealMathfrak = { fg = "#e06c75" },
        ArtTexConcealMathcal = { fg = "#e5c07b" },
        ArtTexConcealMathscr = { fg = "#e5c07b" },
        ArtTexConcealFrac = { fg = "#56b6c2" },
        ArtTexConcealSuper = { fg = "#d19a66" },
        ArtTexConcealSub = { fg = "#e06c75" },
        ArtTexConcealSpecial = { fg = "#56b6c2" },
        ArtTexConcealBold = { bold = true },
        ArtTexConcealItalic = { italic = true },
        ArtTexConcealMathsf = { fg = "#61afef", italic = true },
        -- Semantic rainbow groups
        ArtTexConcealEnv = { fg = "#5c6370" },
        ArtTexConcealChapter = { fg = "#c678dd", bold = true },
        ArtTexConcealSection = { fg = "#e06c75", bold = true },
        ArtTexConcealSubSection = { fg = "#d19a66", bold = true },
        ArtTexConcealSubSubSection = { fg = "#e5c07b", bold = true },
        ArtTexConcealNote = { fg = "#98c379" },
        ArtTexConcealRef = { fg = "#56b6c2" },
        ArtTexConcealLabel = { fg = "#61afef" },
        ArtTexConcealEngine = { fg = "#c678dd", bold = true },
        ArtTexConcealImage = { fg = "#d19a66" },
        ArtTexConcealRainbow1 = { fg = "#e06c75" },
        ArtTexConcealRainbow2 = { fg = "#d19a66" },
        ArtTexConcealRainbow3 = { fg = "#e5c07b" },
        ArtTexConcealRainbow4 = { fg = "#98c379" },
        ArtTexConcealRainbow5 = { fg = "#56b6c2" },
        ArtTexConcealRainbow6 = { fg = "#c678dd" },

    }
}

--- Returns the active theme name. Integrates with arttexsourcecolor if available.
function M.get_active_theme_name(config_theme)
    local has_sourcecolor, sourcecolor = pcall(require, "arttexsourcecolor.config")
    if has_sourcecolor and sourcecolor.options and sourcecolor.options.theme then
        return sourcecolor.options.theme
    end
    return config_theme or "tokyonight"
end

--- Apply a specific theme
function M.apply(theme_name)
    local theme = M.palette[theme_name] or M.palette["tokyonight"]
    for name, hl in pairs(theme) do
        -- Remove default = true so it OVERRIDES any existing highlight definition
        vim.api.nvim_set_hl(0, name, hl)
    end
end

--- Get list of available themes
function M.get_themes()
    local names = {}
    for k, _ in pairs(M.palette) do
        table.insert(names, k)
    end
    table.sort(names)
    return names
end

return M
