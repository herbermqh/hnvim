local parser = vim.treesitter.get_string_parser("\\textbf{text}", "latex")
local tree = parser:parse()[1]
local root = tree:root()
local q = vim.treesitter.query.get("latex", "highlights")
for id, node in q:iter_captures(root, "\\textbf{text}") do
    print(q.captures[id], node:range())
end
