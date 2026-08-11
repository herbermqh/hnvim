local p = vim.treesitter.get_string_parser("$\\sqrt[3]{\\sqrt{x}} \\left( \\right)$", "latex")
local tree = p:parse()[1]
local root = tree:root()
local function print_tree(node, level)
    print(string.rep("  ", level) .. node:type() .. " " .. vim.inspect({node:range()}))
    for i=0, node:child_count()-1 do
        print_tree(node:child(i), level+1)
    end
end
print_tree(root, 0)
