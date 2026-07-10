import re

with open("/home/userh/.config/nvim/lua/luasnippets/manual_completo.md", "r", encoding="utf-8") as f:
    lines = f.readlines()

snippets = []
for line in lines:
    if line.startswith("| `") or line.startswith("| Activador") or line.startswith("| :---"):
        if not (line.startswith("| Activador") or line.startswith("| :---")):
            parts = [p.strip() for p in line.split("|")]
            if len(parts) >= 3:
                trig = parts[1].strip()
                name = parts[2].strip()
                source = parts[3].strip() if len(parts) > 4 and parts[3].strip() else ""
                snippets.append((trig, name, source))

cat_griegas = []
cat_codigo = []
cat_quimica = []
cat_math_env = []
cat_math_symb = []
cat_math_mod = []
cat_fig_tab = []
cat_latex_text = []

for t, n, s in snippets:
    t_raw = t.replace("`", "")
    n_lower = n.lower()
    
    if "letra griega" in n_lower:
        cat_griegas.append((t, n, s))
    elif "chemin" in n_lower or "quimica" in n_lower or "factor conversor" in n_lower or t_raw == "ce":
        cat_quimica.append((t, n, s))
    elif "code" in n_lower or "python" in n_lower or "mint" in n_lower or "sympy" in n_lower or n_lower == "math" or "mathematicablock" in n_lower or t_raw in ["tc", "tic", "casy", "ct", "pt", "ctl", "ctc", "ctcl", "cxtcl"]:
        cat_codigo.append((t, n, s))
    elif t_raw in ["dm", "mk", "ali", "matrix", "pmat", "bmat", "//", "dint", "sum", "prod", "lim", "part", "ddx", "taylor", "limsup", "case"] or "integral" in n_lower or "fraction" in n_lower or "matrix" in n_lower:
        cat_math_env.append((t, n, s))
    elif n_lower in ["bar", "hat", "dot", "underline", "overline", "vector postfix", "prima"] or "subscript" in n_lower or "power" in n_lower or t_raw in ["td", "rd", "sr", "cb", "xnn", "ynn", "xii", "yii", "xjj", "yjj", "xp1", "xmm", "__", "invs", "conj", "norm", "ceil", "floor", "abs", "\\'"] or "auto subscript" in n_lower or "frac" in n_lower:
        cat_math_mod.append((t, n, s))
    elif "fig" in n_lower or "tab" in n_lower or "plot" in n_lower or "tikz" in n_lower or "image" in n_lower or "asymptote" in n_lower or "graph" in n_lower or "grpb" in t_raw or "grpm" in t_raw or "img" in t_raw:
        cat_fig_tab.append((t, n, s))
    elif t_raw in ["=>", "=<", "==", "!=", "<->", "...", "xx", "+-", "OO", "RR", "QQ", "ZZ", "NN", "CC", "UU", "II", "EE", "AA", "nabl", "nab", "ooo", "inf", "\\8", "O+", "O-", "Ox", "=>|ee", "<=>|sss", "!>", "mcal"] or "implies" in n_lower or "equals" in n_lower or "subset" in n_lower or "exists" in n_lower or "forall" in n_lower or "symb relations" in n_lower or "let omega" in n_lower or "math" in n_lower or "conjunto" in n_lower or "ecuacion" in n_lower:
        cat_math_symb.append((t, n, s))
    else:
        if "math" in s or "bwA" in s or "wA" in s:
            cat_math_symb.append((t, n, s))
        else:
            cat_latex_text.append((t, n, s))

with open("/home/userh/.config/nvim/lua/luasnippets/manual_completo.md", "w", encoding="utf-8") as f:
    f.write("# Manual Completo de Snippets (Por Categoría Temática)\n\n")
    
    sections = [
        ("1. Letras Griegas", cat_griegas),
        ("2. Entornos Matemáticos y Cálculo", cat_math_env),
        ("3. Lógica y Símbolos Matemáticos", cat_math_symb),
        ("4. Modificadores, Subíndices y Superíndices", cat_math_mod),
        ("5. Código Fuente (Python, C++, etc)", cat_codigo),
        ("6. Imágenes, Gráficos y Tablas", cat_fig_tab),
        ("7. Química", cat_quimica),
        ("8. Estructura de Documento y Texto General", cat_latex_text)
    ]
    
    for title, cat in sections:
        if not cat: continue
        f.write(f"## {title}\n\n")
        f.write("| Activador (Trigger) | Descripción (Name) | Archivo Origen |\n")
        f.write("| :--- | :--- | :--- |\n")
        for t, n, s in cat:
            f.write(f"| {t} | {n} | {s} |\n")
        f.write("\n")
