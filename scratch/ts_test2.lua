local p = vim.treesitter.get_string_parser("\\cite{test} \\includegraphics{test} \\image{test}", "latex")
local tree = p:parse()[1]
local root = tree:root()
for i=0, root:child_count()-1 do
    local node = root:child(i)
    print(node:type())
    for j=0, node:child_count()-1 do
        print("  ", j, node:child(j):type())
    end
end
