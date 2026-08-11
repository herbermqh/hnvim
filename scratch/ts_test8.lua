local p = vim.treesitter.get_string_parser("$\\left\\langle x \\right\\rangle \\left| x \\right|$", "latex")
local tree = p:parse()[1]
local root = tree:root()
local q_str = [[
    (math_delimiter "\\left" @left)
    (math_delimiter "\\right" @right)
    (math_delimiter "\\left" . (_) @bracket)
    (math_delimiter "\\right" . (_) @bracket)
]]
local q = vim.treesitter.query.parse("latex", q_str)
for id, node in q:iter_captures(root, "$\\left\\langle x \\right\\rangle \\left| x \\right|$") do
    print(q.captures[id], node:type())
end
