local M = {}

-- Optimización de uso de RAM: Evitamos el caché global de zonas matemáticas que causa presión en GC.
-- Computamos las zonas matemáticas en una sola pasada de Treesitter para todo el chunk,
-- consumiendo muchísima menos CPU y RAM.
function M.get_math_zones(buf, root, first_row, last_row)
    local zones = {}
    local query_str = [[
        (math_environment) @math
        (inline_formula) @math
        (displayed_equation) @math
    ]]
    local ok, q = pcall(vim.treesitter.query.parse, "latex", query_str)
    if not ok then return zones end
    for _, node in q:iter_captures(root, buf, first_row, last_row) do
        local sr, sc, er, ec = node:range()
        table.insert(zones, {sr=sr, sc=sc, er=er, ec=ec})
    end
    return zones
end

function M.is_in_mathzone_list(zones, r, c)
    for _, z in ipairs(zones) do
        if r > z.sr and r < z.er then return true end
        if r == z.sr and r == z.er then return c >= z.sc and c <= z.ec end
        if r == z.sr and c >= z.sc then return true end
        if r == z.er and c <= z.ec then return true end
    end
    -- Fallback robusto a Vim syntax si Treesitter no detecta math zone
    local ok_syn, syn_id = pcall(vim.fn.synID, r + 1, c + 1, 1)
    if ok_syn and syn_id then
        local syn_name = vim.fn.synIDattr(syn_id, "name")
        if string.find(syn_name, "Math") or string.find(syn_name, "math") or string.find(syn_name, "texMath") then
            return true
        end
    end
    return false
end

return M
