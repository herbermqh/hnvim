import re

filepath = "/home/userh/.config/nvim/lua/luasnippets/manual_completo.md"
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

# Replace any occurrence of the lua files with a Gilles Castel badge
castel_files = [
    "math_i.lua", "math_iA.lua", "math_iA_no_backslash.lua", 
    "math_rA_no_backslash.lua", "math_wA_no_backslash.lua", 
    "math_wRA_no_backslash.lua", "math_wrA.lua", "wA.lua", "bwA.lua"
]

for cf in castel_files:
    # the column might just be `bwA.lua` or bwA.lua
    content = content.replace(f" {cf} |", f" Gilles Castel ({cf}) |")
    content = content.replace(f"`{cf}` |", f"Gilles Castel ({cf}) |")

with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)

print("Marked Gilles Castel snippets.")
