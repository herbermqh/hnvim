local M = {}

-- Namespace para nuestros colores personalizados
local ns_id = vim.api.nvim_create_namespace("CoreLatexColorizer")

-- Lista de primitivas de TeX de bajo nivel
local tex_primitives = {
    ["\\def"] = true, ["\\let"] = true, ["\\expandafter"] = true,
    ["\\futurelet"] = true, ["\\edef"] = true, ["\\xdef"] = true,
    ["\\gdef"] = true, ["\\relax"] = true, ["\\begingroup"] = true,
    ["\\endgroup"] = true, ["\\csname"] = true, ["\\endcsname"] = true,
}

local latex2e_defs = {
    ["\\newcommand"] = true, ["\\renewcommand"] = true, ["\\providecommand"] = true,
    ["\\newenvironment"] = true, ["\\renewenvironment"] = true,
    ["\\DeclareRobustCommand"] = true, ["\\DeclareMathOperator"] = true,
    ["\\makeatletter"] = true, ["\\makeatother"] = true,
}

local latex3_core = {
    ["\\ExplSyntaxOn"] = true, ["\\ExplSyntaxOff"] = true,
    ["\\ProvidesExplPackage"] = true, ["\\ProvidesExplClass"] = true,
    ["\\ProvidesExplFile"] = true,
}

local function update_highlights(bufnr)
    if not vim.api.nvim_buf_is_valid(bufnr) then return end

    -- Limpiar los colores anteriores en cada actualización
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

    local parser = vim.treesitter.get_parser(bufnr, "latex")
    if not parser then return end

    local tree = parser:parse()[1]
    local root = tree:root()

    -- Consulta Treesitter para atrapar comandos y grupos de texto
    -- Atrapamos las macros genéricas para analizarlas en Lua
    local query_string = [[
        (generic_command command: (command_name) @macro)
        (curly_group) @group
    ]]
    
    local success, query = pcall(vim.treesitter.query.parse, "latex", query_string)
    if not success then return end

    -- Iterar sobre todos los nodos capturados
    for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
        local capture_name = query.captures[id]
        
        local row1, col1, row2, col2 = node:range()
        
        if capture_name == "macro" then
            -- Obtener el texto del comando directamente del buffer
            local lines = vim.api.nvim_buf_get_text(bufnr, row1, col1, row2, col2, {})
            local text = lines[1] or ""
            
            -- LÓGICA KERNEL Y EXPL3 (Bajo Nivel)
            
            -- 1. Primitivas puras de TeX
            if tex_primitives[text] then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexPrimitive", priority = 4096,
                })
            
            -- 2. Declaraciones core de LaTeX2e
            elseif latex2e_defs[text] then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexChapter", priority = 4096,
                })

            -- 3. Entornos base de LaTeX3
            elseif latex3_core[text] then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexExpl3", priority = 4096,
                    virt_text = {{ " ⚡ EXPL3 ", "ErrorMsg" }},
                })

            -- 4. Comandos Kernel de LaTeX2e (contienen @)
            elseif string.match(text, "@") then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexKernelMacro", priority = 4096,
                })
            
            -- 5. Código LaTeX3 / Expl3 (Comandos con _ y :)
            elseif string.match(text, "_") or string.match(text, ":") then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexExpl3", priority = 4096,
                })
            
            -- LÓGICA DE ALTO NIVEL (Libros, Artículos y Paquetes)
            
            -- 4. Capítulos (Añadir texto virtual para que destaquen masivamente)
            elseif text == "\\chapter" or text == "\\part" then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexChapter", priority = 4096,
                    virt_text = {{ " 📖 " .. string.upper(string.sub(text, 2)) .. " ", "LatexChapter" }},
                    virt_text_pos = "right_align",
                })
                
            -- 5. Secciones
            elseif text == "\\section" or text == "\\subsection" then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    hl_group = "LatexSection", priority = 4096,
                    virt_text = {{ " 📌 ", "LatexSection" }},
                })
                
            -- 6. Paquetes
            elseif text == "\\usepackage" or text == "\\RequirePackage" then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row2, end_col = col2,
                    hl_group = "LatexPackage", priority = 4096,
                })
            end
            
        elseif capture_name == "group" then
            -- LÓGICA DE PROFUNDIDAD
            local depth = 0
            local parent = node:parent()
            while parent do
                if parent:type() == "curly_group" then
                    depth = depth + 1
                end
                parent = parent:parent()
            end
            
            -- Si es una llave muy profunda (ej. más de 3 niveles)
            if depth >= 3 then
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row1, col1, {
                    end_row = row1, end_col = col1 + 1, -- Pintar la llave {
                    hl_group = "LatexDeepBracket", priority = 4096,
                })
                vim.api.nvim_buf_set_extmark(bufnr, ns_id, row2, col2 - 1, {
                    end_row = row2, end_col = col2, -- Pintar la llave }
                    hl_group = "LatexDeepBracket", priority = 4096,
                })
            end
        end
    end
end

function M.attach(bufnr)
    -- Ejecutar inmediatamente
    update_highlights(bufnr)

    -- Crear un autocomando para actualizar en tiempo real mientras el usuario escribe
    vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
        buffer = bufnr,
        callback = function()
            update_highlights(bufnr)
        end
    })
end

return M
