local p = vim.treesitter.get_string_parser("$\\left| x \\right|$", "latex")
local tree = p:parse()[1]
local root = tree:root()
local q_str = [[
    "\\left" @left
    "\\right" @right
]]
local q = vim.treesitter.query.parse("latex", q_str)
for id, node in q:iter_captures(root, "$\\left| x \\right|$") do
    print(q.captures[id], node:type())
    local ns = node:next_sibling()
    if ns then
        print("  next:", ns:type(), vim.inspect({ns:range()}))
    end
end
