local engine = require("arttexsourcecolor.engine")

local M = {}

function M.setup()
    -- Definir los colores ultra-avanzados para Kernel y Expl3
    vim.api.nvim_set_hl(0, "LatexKernelMacro", { fg = "#ff007c", bold = true, italic = true }) -- Macros con @
    vim.api.nvim_set_hl(0, "LatexExpl3", { fg = "#00dfff", bold = true }) -- Código expl3 (_ y :)
    vim.api.nvim_set_hl(0, "LatexPrimitive", { fg = "#ff9e64", bold = true }) -- Primitivas de TeX (\def, \let, \expandafter)
    vim.api.nvim_set_hl(0, "LatexDeepBracket", { fg = "#e0af68", bold = true }) -- Llaves ultra profundas
    
    -- Colores de alto nivel para libros y documentos
    vim.api.nvim_set_hl(0, "LatexChapter", { fg = "#bb9af7", bold = true, reverse = true }) -- Capítulos gigantescos
    vim.api.nvim_set_hl(0, "LatexSection", { fg = "#7aa2f7", bold = true, italic = true }) -- Secciones
    vim.api.nvim_set_hl(0, "LatexPackage", { fg = "#9ece6a", italic = true }) -- Paquetes

    -- Crear el Autocomando que activará nuestro motor en archivos de LaTeX y clases
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "tex", "sty", "cls", "dtx" },
        callback = function(args)
            -- Adjuntar el motor al buffer actual
            engine.attach(args.buf)
        end
    })
end

return M
