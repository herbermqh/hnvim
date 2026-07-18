local M = {}

-- Map for simple text commands: \command -> {char, hl}
M.text_words = {
    ["\\ldots"] = { char = "…", hl = "ArtTexConcealSpecial" },
    ["\\quad"]  = { char = "  ", hl = "ArtTexConcealSpecial" },
    ["\\qquad"] = { char = "    ", hl = "ArtTexConcealSpecial" },
}

-- Map for simple math commands: \command -> {char, hl}
M.math_words = {
    -- Greek letters
    ["\\alpha"] = { char = "α", hl = "ArtTexConcealGreek" }, ["\\beta"] = { char = "β", hl = "ArtTexConcealGreek" },
    ["\\gamma"] = { char = "γ", hl = "ArtTexConcealGreek" }, ["\\delta"] = { char = "δ", hl = "ArtTexConcealGreek" },
    ["\\epsilon"] = { char = "ε", hl = "ArtTexConcealGreek" }, ["\\varepsilon"] = { char = "ε", hl = "ArtTexConcealGreek" },
    ["\\zeta"] = { char = "ζ", hl = "ArtTexConcealGreek" }, ["\\eta"] = { char = "η", hl = "ArtTexConcealGreek" },
    ["\\theta"] = { char = "θ", hl = "ArtTexConcealGreek" }, ["\\vartheta"] = { char = "ϑ", hl = "ArtTexConcealGreek" },
    ["\\iota"] = { char = "ι", hl = "ArtTexConcealGreek" }, ["\\kappa"] = { char = "κ", hl = "ArtTexConcealGreek" },
    ["\\lambda"] = { char = "λ", hl = "ArtTexConcealGreek" }, ["\\mu"] = { char = "μ", hl = "ArtTexConcealGreek" },
    ["\\nu"] = { char = "ν", hl = "ArtTexConcealGreek" }, ["\\xi"] = { char = "ξ", hl = "ArtTexConcealGreek" },
    ["\\pi"] = { char = "π", hl = "ArtTexConcealGreek" }, ["\\varpi"] = { char = "ϖ", hl = "ArtTexConcealGreek" },
    ["\\rho"] = { char = "ρ", hl = "ArtTexConcealGreek" }, ["\\varrho"] = { char = "ϱ", hl = "ArtTexConcealGreek" },
    ["\\sigma"] = { char = "σ", hl = "ArtTexConcealGreek" }, ["\\varsigma"] = { char = "ς", hl = "ArtTexConcealGreek" },
    ["\\tau"] = { char = "τ", hl = "ArtTexConcealGreek" }, ["\\upsilon"] = { char = "υ", hl = "ArtTexConcealGreek" },
    ["\\phi"] = { char = "ϕ", hl = "ArtTexConcealGreek" }, ["\\varphi"] = { char = "φ", hl = "ArtTexConcealGreek" },
    ["\\chi"] = { char = "χ", hl = "ArtTexConcealGreek" }, ["\\psi"] = { char = "ψ", hl = "ArtTexConcealGreek" },
    ["\\omega"] = { char = "ω", hl = "ArtTexConcealGreek" }, ["\\Gamma"] = { char = "Γ", hl = "ArtTexConcealGreek" },
    ["\\Delta"] = { char = "Δ", hl = "ArtTexConcealGreek" }, ["\\Theta"] = { char = "Θ", hl = "ArtTexConcealGreek" },
    ["\\Lambda"] = { char = "Λ", hl = "ArtTexConcealGreek" }, ["\\Xi"] = { char = "Ξ", hl = "ArtTexConcealGreek" },
    ["\\Pi"] = { char = "Π", hl = "ArtTexConcealGreek" }, ["\\Sigma"] = { char = "Σ", hl = "ArtTexConcealGreek" },
    ["\\Upsilon"] = { char = "Υ", hl = "ArtTexConcealGreek" }, ["\\Phi"] = { char = "Φ", hl = "ArtTexConcealGreek" },
    ["\\Psi"] = { char = "Ψ", hl = "ArtTexConcealGreek" }, ["\\Omega"] = { char = "Ω", hl = "ArtTexConcealGreek" },
    
    -- Operators
    ["\\infty"] = { char = "∞", hl = "ArtTexConcealOperator" }, ["\\sum"] = { char = "∑", hl = "ArtTexConcealOperator" },
    ["\\prod"] = { char = "∏", hl = "ArtTexConcealOperator" }, ["\\coprod"] = { char = "∐", hl = "ArtTexConcealOperator" },
    ["\\int"] = { char = "∫", hl = "ArtTexConcealOperator" }, ["\\iint"] = { char = "∬", hl = "ArtTexConcealOperator" },
    ["\\iiint"] = { char = "∭", hl = "ArtTexConcealOperator" }, ["\\oint"] = { char = "∮", hl = "ArtTexConcealOperator" },
    ["\\times"] = { char = "×", hl = "ArtTexConcealOperator" }, ["\\div"] = { char = "÷", hl = "ArtTexConcealOperator" },
    ["\\pm"] = { char = "±", hl = "ArtTexConcealOperator" }, ["\\mp"] = { char = "∓", hl = "ArtTexConcealOperator" },
    ["\\cdot"] = { char = "⋅", hl = "ArtTexConcealOperator" }, ["\\circ"] = { char = "∘", hl = "ArtTexConcealOperator" },
    ["\\bullet"] = { char = "∙", hl = "ArtTexConcealOperator" }, ["\\nabla"] = { char = "∇", hl = "ArtTexConcealOperator" },
    ["\\partial"] = { char = "∂", hl = "ArtTexConcealOperator" }, ["\\forall"] = { char = "∀", hl = "ArtTexConcealOperator" },
    ["\\exists"] = { char = "∃", hl = "ArtTexConcealOperator" }, ["\\nexists"] = { char = "∄", hl = "ArtTexConcealOperator" },
    ["\\emptyset"] = { char = "∅", hl = "ArtTexConcealOperator" }, ["\\oplus"] = { char = "⊕", hl = "ArtTexConcealOperator" },
    ["\\otimes"] = { char = "⊗", hl = "ArtTexConcealOperator" }, ["\\odot"] = { char = "⊙", hl = "ArtTexConcealOperator" },
    ["\\setminus"] = { char = "\\", hl = "ArtTexConcealOperator" }, ["\\sqrt"] = { char = "√", hl = "ArtTexConcealRoot" },
    ["\\intop"] = { char = "∫", hl = "ArtTexConcealOperator" }, ["\\smallint"] = { char = "∫", hl = "ArtTexConcealOperator" },
    ["\\bigcap"] = { char = "⋂", hl = "ArtTexConcealOperator" }, ["\\bigcup"] = { char = "⋃", hl = "ArtTexConcealOperator" },
    ["\\bigsqcup"] = { char = "⨆", hl = "ArtTexConcealOperator" }, ["\\bigwedge"] = { char = "⋀", hl = "ArtTexConcealOperator" },
    ["\\bigvee"] = { char = "⋁", hl = "ArtTexConcealOperator" }, ["\\bigoplus"] = { char = "⨁", hl = "ArtTexConcealOperator" },
    ["\\bigotimes"] = { char = "⨂", hl = "ArtTexConcealOperator" }, ["\\bigodot"] = { char = "⨀", hl = "ArtTexConcealOperator" },
    ["\\biguplus"] = { char = "⨄", hl = "ArtTexConcealOperator" }, ["\\bigcirc"] = { char = "◯", hl = "ArtTexConcealOperator" },
    ["\\bigtriangleup"] = { char = "△", hl = "ArtTexConcealOperator" }, ["\\iiiint"] = { char = "⨌", hl = "ArtTexConcealOperator" },
    ["\\idotsint"] = { char = "∫", hl = "ArtTexConcealOperator" },

    -- Relations
    ["\\approx"] = { char = "≈", hl = "ArtTexConcealRelation" }, ["\\neq"] = { char = "≠", hl = "ArtTexConcealRelation" },
    ["\\equiv"] = { char = "≡", hl = "ArtTexConcealRelation" }, ["\\propto"] = { char = "∝", hl = "ArtTexConcealRelation" },
    ["\\leq"] = { char = "≤", hl = "ArtTexConcealRelation" }, ["\\geq"] = { char = "≥", hl = "ArtTexConcealRelation" },
    ["\\in"] = { char = "∈", hl = "ArtTexConcealRelation" }, ["\\notin"] = { char = "∉", hl = "ArtTexConcealRelation" },
    ["\\subset"] = { char = "⊂", hl = "ArtTexConcealRelation" }, ["\\supset"] = { char = "⊃", hl = "ArtTexConcealRelation" },
    ["\\subseteq"] = { char = "⊆", hl = "ArtTexConcealRelation" }, ["\\supseteq"] = { char = "⊇", hl = "ArtTexConcealRelation" },
    ["\\cup"] = { char = "∪", hl = "ArtTexConcealRelation" }, ["\\cap"] = { char = "∩", hl = "ArtTexConcealRelation" },
    ["\\vee"] = { char = "∨", hl = "ArtTexConcealRelation" }, ["\\wedge"] = { char = "∧", hl = "ArtTexConcealRelation" },
    ["\\lor"] = { char = "∨", hl = "ArtTexConcealRelation" }, ["\\land"] = { char = "∧", hl = "ArtTexConcealRelation" },
    ["\\lnot"] = { char = "¬", hl = "ArtTexConcealRelation" }, ["\\implies"] = { char = "⇒", hl = "ArtTexConcealRelation" },
    ["\\geqslant"] = { char = "⩾", hl = "ArtTexConcealRelation" }, ["\\leqslant"] = { char = "⩽", hl = "ArtTexConcealRelation" },
    ["\\coloneqq"] = { char = "≔", hl = "ArtTexConcealRelation" }, ["\\colon"] = { char = ":", hl = "ArtTexConcealRelation" },
    ["\\therefore"] = { char = "∴", hl = "ArtTexConcealRelation" }, ["\\because"] = { char = "∵", hl = "ArtTexConcealRelation" },

    -- Arrows
    ["\\leftarrow"] = { char = "←", hl = "ArtTexConcealArrow" }, ["\\rightarrow"] = { char = "→", hl = "ArtTexConcealArrow" },
    ["\\uparrow"] = { char = "↑", hl = "ArtTexConcealArrow" }, ["\\downarrow"] = { char = "↓", hl = "ArtTexConcealArrow" },
    ["\\leftrightarrow"] = { char = "↔", hl = "ArtTexConcealArrow" }, ["\\Leftarrow"] = { char = "⇐", hl = "ArtTexConcealArrow" },
    ["\\Rightarrow"] = { char = "⇒", hl = "ArtTexConcealArrow" }, ["\\Uparrow"] = { char = "⇑", hl = "ArtTexConcealArrow" },
    ["\\Downarrow"] = { char = "⇓", hl = "ArtTexConcealArrow" }, ["\\Leftrightarrow"] = { char = "⇔", hl = "ArtTexConcealArrow" },
    ["\\mapsto"] = { char = "↦", hl = "ArtTexConcealArrow" }, ["\\to"] = { char = "→", hl = "ArtTexConcealArrow" },
    ["\\gets"] = { char = "←", hl = "ArtTexConcealArrow" }, ["\\updownarrow"] = { char = "↕", hl = "ArtTexConcealArrow" },
    ["\\Updownarrow"] = { char = "⇕", hl = "ArtTexConcealArrow" }, ["\\nwarrow"] = { char = "↖", hl = "ArtTexConcealArrow" },
    ["\\nearrow"] = { char = "↗", hl = "ArtTexConcealArrow" }, ["\\swarrow"] = { char = "↙", hl = "ArtTexConcealArrow" },
    ["\\searrow"] = { char = "↘", hl = "ArtTexConcealArrow" }, ["\\nleftarrow"] = { char = "↚", hl = "ArtTexConcealArrow" },
    ["\\nLeftarrow"] = { char = "⇍", hl = "ArtTexConcealArrow" }, ["\\nrightarrow"] = { char = "↛", hl = "ArtTexConcealArrow" },
    ["\\nRightarrow"] = { char = "⇏", hl = "ArtTexConcealArrow" }, ["\\longleftarrow"] = { char = "⟵", hl = "ArtTexConcealArrow" },
    ["\\Longleftarrow"] = { char = "⟸", hl = "ArtTexConcealArrow" }, ["\\longrightarrow"] = { char = "⟶", hl = "ArtTexConcealArrow" },
    ["\\Longrightarrow"] = { char = "⟹", hl = "ArtTexConcealArrow" }, ["\\longleftrightarrow"] = { char = "⟷", hl = "ArtTexConcealArrow" },
    ["\\Longleftrightarrow"] = { char = "⟺", hl = "ArtTexConcealArrow" }, ["\\longmapsto"] = { char = "⟼", hl = "ArtTexConcealArrow" },

    -- Functions and text operators
    ["\\log"] = { char = "log", hl = "ArtTexConcealMath" }, ["\\lim"] = { char = "lim", hl = "ArtTexConcealMath" },
    ["\\sin"] = { char = "sin", hl = "ArtTexConcealMath" }, ["\\cos"] = { char = "cos", hl = "ArtTexConcealMath" },
    ["\\tan"] = { char = "tan", hl = "ArtTexConcealMath" }, ["\\cot"] = { char = "cot", hl = "ArtTexConcealMath" },
    ["\\csc"] = { char = "csc", hl = "ArtTexConcealMath" }, ["\\sec"] = { char = "sec", hl = "ArtTexConcealMath" },
    ["\\sup"] = { char = "sup", hl = "ArtTexConcealMath" }, ["\\inf"] = { char = "inf", hl = "ArtTexConcealMath" },
    ["\\ker"] = { char = "ker", hl = "ArtTexConcealMath" }, ["\\det"] = { char = "det", hl = "ArtTexConcealMath" },
    ["\\gcd"] = { char = "gcd", hl = "ArtTexConcealMath" }, ["\\lg"] = { char = "lg", hl = "ArtTexConcealMath" },
    ["\\limsup"] = { char = "limsup", hl = "ArtTexConcealMath" }, ["\\liminf"] = { char = "liminf", hl = "ArtTexConcealMath" },
    ["\\arcsin"] = { char = "arcsin", hl = "ArtTexConcealMath" }, ["\\arccos"] = { char = "arccos", hl = "ArtTexConcealMath" },
    ["\\arctan"] = { char = "arctan", hl = "ArtTexConcealMath" }, ["\\coth"] = { char = "coth", hl = "ArtTexConcealMath" },
    ["\\sinh"] = { char = "sinh", hl = "ArtTexConcealMath" }, ["\\cosh"] = { char = "cosh", hl = "ArtTexConcealMath" },
    ["\\tanh"] = { char = "tanh", hl = "ArtTexConcealMath" }, ["\\max"] = { char = "max", hl = "ArtTexConcealMath" },
    ["\\min"] = { char = "min", hl = "ArtTexConcealMath" }, ["\\dim"] = { char = "dim", hl = "ArtTexConcealMath" },
    ["\\exp"] = { char = "exp", hl = "ArtTexConcealMath" }, ["\\deg"] = { char = "deg", hl = "ArtTexConcealMath" },
    ["\\ln"] = { char = "ln", hl = "ArtTexConcealMath" }, ["\\arg"] = { char = "arg", hl = "ArtTexConcealMath" },
    ["\\hom"] = { char = "hom", hl = "ArtTexConcealMath" }, ["\\Pr"] = { char = "Pr", hl = "ArtTexConcealMath" },
    ["\\bmod"] = { char = "mod", hl = "ArtTexConcealMath" },

    -- Dots, Hats and Accents
    ["\\dots"] = { char = "…", hl = "ArtTexConcealSpecial" }, ["\\cdots"] = { char = "⋯", hl = "ArtTexConcealSpecial" },
    ["\\vdots"] = { char = "⋮", hl = "ArtTexConcealSpecial" }, ["\\ddots"] = { char = "⋱", hl = "ArtTexConcealSpecial" },
    ["\\dotsc"] = { char = "…", hl = "ArtTexConcealSpecial" }, ["\\dotsb"] = { char = "⋯", hl = "ArtTexConcealSpecial" },
    ["\\dotsm"] = { char = "⋯", hl = "ArtTexConcealSpecial" }, ["\\dotsi"] = { char = "⋯", hl = "ArtTexConcealSpecial" },
    ["\\dotso"] = { char = "…", hl = "ArtTexConcealSpecial" }, ["\\acute"] = { char = "´", hl = "ArtTexConcealSpecial" },
    ["\\bar"] = { char = "¯", hl = "ArtTexConcealSpecial" }, ["\\vv"] = { char = "→", hl = "ArtTexConcealSpecial" },
    ["\\vec"] = { char = "→", hl = "ArtTexConcealSpecial" }, ["\\overline"] = { char = "‾", hl = "ArtTexConcealSpecial" },
    ["\\underline"] = { char = "_", hl = "ArtTexConcealSpecial" }, ["\\underbrace"] = { char = "⏟", hl = "ArtTexConcealSpecial" },
    ["\\overbrace"] = { char = "⏞", hl = "ArtTexConcealSpecial" }, ["\\hat"] = { char = "^", hl = "ArtTexConcealSpecial" },
}

-- Exact string literals that require `string.find(line, pattern, col, true)`
-- 'env' dictates whether it is active in "math", "text", or "both"
M.literals = {
    { pattern = "\\#", char = "#", hl = "ArtTexConcealSpecial", env = "both" },
    { pattern = "``", char = "“", hl = "ArtTexConcealSpecial", env = "both" },
    { pattern = "''", char = "”", hl = "ArtTexConcealSpecial", env = "both" },
    { pattern = "\\\\", char = "⏎", hl = "ArtTexConcealSpecial", env = "both" },
}

-- Maps for Fractions: format "numerator/denominator" -> char
M.fractions = {
    ["1/2"] = "½", ["1/3"] = "⅓", ["2/3"] = "⅔", ["1/4"] = "¼",
    ["1/5"] = "⅕", ["2/5"] = "⅖", ["3/5"] = "⅗", ["4/5"] = "⅘",
    ["1/6"] = "⅙", ["5/6"] = "⅚", ["1/8"] = "⅛", ["3/8"] = "⅜", ["3/4"] = "¾",
    ["5/8"] = "⅝", ["7/8"] = "⅞",
}

-- Super/Subscripts maps
M.superscripts = {
    ["0"]="⁰", ["1"]="¹", ["2"]="²", ["3"]="³", ["4"]="⁴", ["5"]="⁵", ["6"]="⁶", ["7"]="⁷", ["8"]="⁸", ["9"]="⁹",
    ["a"]="ᵃ", ["b"]="ᵇ", ["c"]="ᶜ", ["d"]="ᵈ", ["e"]="ᵉ", ["f"]="ᶠ", ["g"]="ᵍ", ["h"]="ʰ", ["i"]="ⁱ", ["j"]="ʲ",
    ["k"]="ᵏ", ["l"]="ˡ", ["m"]="ᵐ", ["n"]="ⁿ", ["o"]="ᵒ", ["p"]="ᵖ", ["r"]="ʳ", ["s"]="ˢ", ["t"]="ᵗ", ["u"]="ᵘ",
    ["v"]="ᵛ", ["w"]="ʷ", ["x"]="ˣ", ["y"]="ʸ", ["z"]="ᶻ",
    ["A"]="ᴬ", ["B"]="ᴮ", ["D"]="ᴰ", ["E"]="ᴱ", ["G"]="ᴳ", ["H"]="ᴴ", ["I"]="ᴵ", ["J"]="ᴶ", ["K"]="ᴷ", ["L"]="ᴸ",
    ["M"]="ᴹ", ["N"]="ᴺ", ["O"]="ᴼ", ["P"]="ᴾ", ["R"]="ᴿ", ["T"]="ᵀ", ["U"]="ᵁ", ["W"]="ᵂ",
    ["+"]="⁺", ["-"]="⁻", ["<"]="˂", [">"]="˃", ["/"]="ˊ", ["("]="⁽", [")"]="⁾", ["."]="˙", ["="]="˭",
    ["\\alpha"]="ᵅ", ["\\beta"]="ᵝ", ["\\gamma"]="ᵞ", ["\\delta"]="ᵟ", ["\\epsilon"]="ᵋ", ["\\theta"]="ᶿ",
    ["\\iota"]="ᶥ", ["\\Phi"]="ᶲ", ["\\varphi"]="ᵠ", ["\\chi"]="ᵡ", ["*"]="˟", ["\\ast"]="˟", ["\\star"]="˟"
}

M.subscripts = {
    ["0"]="₀", ["1"]="₁", ["2"]="₂", ["3"]="₃", ["4"]="₄", ["5"]="₅", ["6"]="₆", ["7"]="₇", ["8"]="₈", ["9"]="₉",
    ["a"]="ₐ", ["e"]="ₑ", ["h"]="ₕ", ["i"]="ᵢ", ["j"]="ⱼ", ["k"]="ₖ", ["l"]="ₗ", ["m"]="ₘ", ["n"]="ₙ", ["o"]="ₒ",
    ["p"]="ₚ", ["r"]="ᵣ", ["s"]="ₛ", ["t"]="ₜ", ["u"]="ᵤ", ["v"]="ᵥ", ["x"]="ₓ",
    ["+"]="₊", ["-"]="₋", ["/"]="ˏ", ["("]="₍", [")"]="₎",
    ["\\beta"]="ᵦ", ["\\rho"]="ᵨ", ["\\phi"]="ᵩ", ["\\gamma"]="ᵧ", ["\\chi"]="ᵪ"
}

-- Alphabet blocks
M.alphabets = {
    mathbb = {
        A="𝔸", B="𝔹", C="ℂ", D="𝔻", E="𝔼", F="𝔽", G="𝔾", H="ℍ", I="𝕀", J="𝕁", K="𝕂", L="𝕃", M="𝕄",
        N="ℕ", O="𝕆", P="ℙ", Q="ℚ", R="ℝ", S="𝕊", T="𝕋", U="𝕌", V="𝕍", W="𝕎", X="𝕏", Y="𝕐", Z="ℤ",
    },
    mathsf = {
        a="𝖺", b="𝖻", c="𝖼", d="𝖽", e="𝖾", f="𝖿", g="𝗀", h="𝗁", i="𝗂", j="𝗃", k="𝗄", l="𝗅", m="𝗆",
        n="𝗇", o="𝗈", p="𝗉", q="𝗊", r="𝗋", s="𝗌", t="𝗍", u="𝗎", v="𝗏", w="𝗐", x="𝗑", y="𝗒", z="𝗓",
        A="𝖠", B="𝖡", C="𝖢", D="𝖣", E="𝖤", F="𝖥", G="𝖦", H="𝖧", I="𝖨", J="𝖩", K="𝖪", L="𝖫", M="𝖬",
        N="𝖭", O="𝖮", P="𝖯", Q="𝖰", R="𝖱", S="𝖲", T="𝖳", U="𝖴", V="𝖵", W="𝖶", X="𝖷", Y="𝖸", Z="𝖹",
    },
    mathfrak = {
        a="𝔞", b="𝔟", c="𝔠", d="𝔡", e="𝔢", f="𝔣", g="𝔤", h="𝔥", i="𝔦", j="𝔧", k="𝔨", l="𝔩", m="𝔪",
        n="𝔫", o="𝔬", p="𝔭", q="𝔮", r="𝔯", s="𝔰", t="𝔱", u="𝔲", v="𝔳", w="𝔴", x="𝔵", y="𝔶", z="𝔷",
        A="𝔄", B="𝔅", C="ℭ", D="𝔇", E="𝔈", F="𝔉", G="𝔊", H="ℌ", I="ℑ", J="𝔍", K="𝔎", L="𝔏", M="𝔐",
        N="𝔑", O="𝔒", P="𝔓", Q="𝔔", R="ℜ", S="𝔖", T="𝔗", U="𝔘", V="𝔙", W="𝔚", X="𝔛", Y="𝔜", Z="ℨ",
    },
    mathcal = {
        A="𝓐", B="𝓑", C="𝓒", D="𝓓", E="𝓔", F="𝓕", G="𝓖", H="𝓗", I="𝓘", J="𝓙", K="𝓚", L="𝓛", M="𝓜",
        N="𝓝", O="𝓞", P="𝓟", Q="𝓠", R="𝓡", S="𝓢", T="𝓣", U="𝓤", V="𝓥", W="𝓦", X="𝓧", Y="𝓨", Z="𝓩",
    }
}
M.alphabets.mathscr = M.alphabets.mathcal

function M.load_custom_symbols()
    local config = require("arttexconceal.config")
    if config.options.custom_symbols then
        for _, custom in ipairs(config.options.custom_symbols) do
            table.insert(M.literals, custom)
        end
    end
end

return M