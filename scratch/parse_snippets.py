import re
import sys
import os

def parse_file(filepath, output_md):
    if not os.path.exists(filepath):
        print(f"File {filepath} not found.")
        return

    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    snippets = []

    # Match parse_snippet({trig = "...", name = "..."}
    # We will use regex to find trig and name
    # trig can be enclosed in "", '', or [=[ ]=]
    
    # regex for trig
    trig_pattern = r'trig\s*=\s*(?:"([^"]+)"|\'([^\']+)\'|\[=\[([^\]]+)\]=\])'
    name_pattern = r'name\s*=\s*(?:"([^"]+)"|\'([^\']+)\'|\[=\[([^\]]+)\]=\])'
    
    # Split by snippet definitions
    chunks = re.split(r'parse_snippet\(|s\(', content)
    
    for chunk in chunks[1:]:
        trig_match = re.search(trig_pattern, chunk)
        name_match = re.search(name_pattern, chunk)
        
        if trig_match:
            trig = trig_match.group(1) or trig_match.group(2) or trig_match.group(3)
            name = ""
            if name_match:
                name = name_match.group(1) or name_match.group(2) or name_match.group(3)
            snippets.append((trig, name))

    if not snippets:
        return

    # Write to Markdown
    with open(output_md, 'w', encoding='utf-8') as f:
        title = os.path.basename(filepath).replace('.lua', '').capitalize()
        f.write(f"# Manual de Snippets: {title}\n\n")
        f.write("| Activador (Trigger) | Descripción (Name) |\n")
        f.write("| :--- | :--- |\n")
        for trig, name in snippets:
            # Escape pipes and backticks
            t = str(trig).replace('|', '\\|').replace('`', '\\`')
            n = str(name).replace('|', '\\|').replace('`', '\\`')
            f.write(f"| `{t}` | {n} |\n")

    print(f"Generated {output_md} with {len(snippets)} snippets.")

if __name__ == '__main__':
    base_dir = "/home/userh/.config/nvim/lua/luasnippets"
    out_dir = "/home/userh/.gemini/antigravity-cli/brain/638350e7-ee12-48b5-bc64-5670d89aa5f8"
    
    # User snippets
    parse_file(f"{base_dir}/general.lua", f"{out_dir}/manual_general.md")
    parse_file(f"{base_dir}/quimica.lua", f"{out_dir}/manual_quimica.md")
    parse_file(f"{base_dir}/algebra.lua", f"{out_dir}/manual_algebra.md")
    
    # Gilles Castel Snippets
    castel_dir = "/home/userh/.config/nvim/lua/luasnip-latex-snippets"
    castel_files = ["math_i.lua", "math_iA.lua", "math_iA_no_backslash.lua", "math_rA_no_backslash.lua", "math_wA_no_backslash.lua", "math_wRA_no_backslash.lua", "math_wrA.lua", "wA.lua", "bwA.lua"]
    
    castel_snippets = []
    
    for cf in castel_files:
        filepath = f"{castel_dir}/{cf}"
        if not os.path.exists(filepath): continue
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        chunks = re.split(r'parse_snippet\(|s\(', content)
        for chunk in chunks[1:]:
            trig_pattern = r'trig\s*=\s*(?:"([^"]+)"|\'([^\']+)\'|\[=\[([^\]]+)\]=\])'
            name_pattern = r'name\s*=\s*(?:"([^"]+)"|\'([^\']+)\'|\[=\[([^\]]+)\]=\])'
            trig_match = re.search(trig_pattern, chunk)
            name_match = re.search(name_pattern, chunk)
            if trig_match:
                trig = trig_match.group(1) or trig_match.group(2) or trig_match.group(3)
                name = ""
                if name_match:
                    name = name_match.group(1) or name_match.group(2) or name_match.group(3)
                castel_snippets.append((trig, name, cf))
                
    if castel_snippets:
        with open(f"{out_dir}/manual_gilles_castel.md", 'w', encoding='utf-8') as f:
            f.write(f"# Manual de Snippets: Gilles Castel\n\n")
            f.write("| Activador (Trigger) | Descripción (Name) | Archivo Origen |\n")
            f.write("| :--- | :--- | :--- |\n")
            for trig, name, cf in castel_snippets:
                t = str(trig).replace('|', '\\|').replace('`', '\\`')
                n = str(name).replace('|', '\\|').replace('`', '\\`')
                f.write(f"| `{t}` | {n} | `{cf}` |\n")
        print(f"Generated manual_gilles_castel.md with {len(castel_snippets)} snippets.")
