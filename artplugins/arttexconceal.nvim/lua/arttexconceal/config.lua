local M = {}

M.options = {
    enable_on_startup = true,
    enable_math_conceal = true,
    enable_format_bold = true,
    enable_format_italic = true,
    enable_format_mathsf = true,
    enable_script_conceal = true, -- Permite ocultar subíndices y superíndices (ej. _n -> ₙ)
    enable_env_conceal = false, -- Permite ocultar entornos (ej. \begin{...} -> 󰐊)
    math_alphabets_as_ascii = true, -- Fallback para fuentes que no soportan Unicode Math Alphanumeric
    theme = "tokyonight",
    custom_symbols = {
        -- Puedes crear tus propios conceals aquí
    },
}

function M.setup(opts)
    if opts then
        M.options = vim.tbl_deep_extend("force", M.options, opts)
        
        -- If user provided custom themes, merge them into themes palette
        if opts.themes then
            local themes = require("arttexconceal.themes")
            for theme_name, theme_data in pairs(opts.themes) do
                themes.palette[theme_name] = vim.tbl_deep_extend("force", themes.palette[theme_name] or {}, theme_data)
            end
        end
    end
    M.load_prefs()
end

M.prefs_file = vim.fn.stdpath("data") .. "/arttexconceal_prefs.json"

function M.save_prefs()
    local ok, err = pcall(function()
        local prefs = {
            enable_math_conceal = M.options.enable_math_conceal,
            enable_format_bold = M.options.enable_format_bold,
            enable_format_italic = M.options.enable_format_italic,
            enable_format_mathsf = M.options.enable_format_mathsf,
            enable_script_conceal = M.options.enable_script_conceal,
            enable_env_conceal = M.options.enable_env_conceal,
            math_alphabets_as_ascii = M.options.math_alphabets_as_ascii,
            theme = M.options.theme,
        }
        local f = io.open(M.prefs_file, "w")
        if f then
            f:write(vim.fn.json_encode(prefs))
            f:close()
        end
    end)
    if not ok then
        require("arttexconceal.logger").error("Error in save_prefs: " .. tostring(err))
    end
end

function M.load_prefs()
    local ok, err = pcall(function()
        local f = io.open(M.prefs_file, "r")
        if f then
            local content = f:read("*a")
            f:close()
            local json_ok, prefs = pcall(vim.fn.json_decode, content)
            if json_ok and type(prefs) == "table" then
                M.options = vim.tbl_deep_extend("force", M.options, prefs)
            end
        end
    end)
    if not ok then
        require("arttexconceal.logger").error("Error in load_prefs: " .. tostring(err))
    end
end

return M
