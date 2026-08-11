local p = vim.treesitter.get_string_parser("$\\sqrt[3]{\\sqrt{x}} \\left( \\right)$", "latex")
local tree = p:parse()[1]
local root = tree:root()
local q_str = [[
    ["{" "}" "[" "]" "(" ")"] @bracket
    "\\left" @left
    "\\right" @right
    ((command_name) @sqrt (#eq? @sqrt "\\sqrt"))
]]
local q = vim.treesitter.query.parse("latex", q_str)
for id, node in q:iter_captures(root, "$\\sqrt[3]{\\sqrt{x}} \\left( \\right)$") do
    print(q.captures[id], node:type())
end
