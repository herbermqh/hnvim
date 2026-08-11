local p = vim.treesitter.get_string_parser("\\ref{test} \\label{test}", "latex")
local tree = p:parse()[1]
local root = tree:root()
local q = vim.treesitter.query.parse("latex", "(label_reference) @ref (label_definition) @label")
for id, node in q:iter_captures(root, "\\ref{test} \\label{test}") do
    print(q.captures[id])
    for i=0, node:child_count()-1 do
        print("  ", i, node:child(i):type(), node:child(i):named())
    end
end
