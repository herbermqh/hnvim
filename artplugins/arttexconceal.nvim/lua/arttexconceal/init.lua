local toggle = require("arttexconceal.toggle")

local M = {}

function M.setup()
    -- Colores Premium para los símbolos ocultos
    vim.api.nvim_set_hl(0, "TexConceal", { fg = "#bb9af7", bold = true })

    -- Crear el Autocomando que inyectará la regla a los archivos LaTeX
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "sty", "cls", "dtx" },
        callback = function(args)
            -- Asignamos el nuevo color brillante solo a las ventanas que abran LaTeX
            vim.opt_local.winhl:append("Conceal:TexConceal")
            
            -- Por defecto lo activamos (nivel 2)
            toggle.enable()
        end
    })
end

M.toggle = toggle.toggle
M.enable = toggle.enable
M.disable = toggle.disable

return M
