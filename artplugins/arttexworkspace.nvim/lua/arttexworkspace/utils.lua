local M = {}

--- Verifica si una coordenada específica está dentro de una zona matemática utilizando Treesitter
---@param bufnr number ID del buffer
---@param row number Fila (0-indexed)
---@param col number Columna (0-indexed)
---@return boolean true si está en zona matemática, false en caso contrario
function M.in_mathzone(bufnr, row, col)
    local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col } })
    if ok and node then
        local current = node
        while current do
            local type = current:type()
            if type == "math_environment" or type == "inline_formula" or type == "displayed_equation" or type == "math_mode" then
                return true
            end
            current = current:parent()
        end
    end
    
    -- Fallback robusto a Vim syntax si Treesitter no detecta math zone (ej. macros personalizadas o errores de parseo)
    local ok_syn, syn_id = pcall(vim.fn.synID, row + 1, col + 1, 1)
    if ok_syn and syn_id then
        local syn_name = vim.fn.synIDattr(syn_id, "name")
        if string.find(syn_name, "Math") or string.find(syn_name, "math") or string.find(syn_name, "texMath") then
            return true
        end
    end

    -- Si ninguno lo detecta, pero TS falló completamente, confiar en syntax ID (que arriba ya fue false) o simplemente false
    -- Esto evita el "falso positivo" global si TS está roto.
    return false
end

--- Verifica si una coordenada específica está dentro de un entorno verbatim/código utilizando Treesitter
---@param bufnr number ID del buffer
---@param row number Fila (0-indexed)
---@param col number Columna (0-indexed)
---@return boolean true si está en zona verbatim, false en caso contrario
function M.in_verbatim(bufnr, row, col)
    local ok, node = pcall(vim.treesitter.get_node, { bufnr = bufnr, pos = { row, col } })
    if not ok or not node then return false end
    
    while node do
        local type = node:type()
        if type == "verbatim_environment" or type == "minted_environment" or type == "lstlisting_environment" then
            return true
        end
        node = node:parent()
    end
    return false
end

return M
