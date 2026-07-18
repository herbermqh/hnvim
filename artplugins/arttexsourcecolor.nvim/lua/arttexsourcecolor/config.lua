--- @module arttexsourcecolor.config
--- @description Administra la configuración persistente del plugin (estado global).
--- Su diseño de single-source-of-truth simplifica la reactividad de la UI.
local M = {}

M.config_file = vim.fn.stdpath("config") .. "/arttexsourcecolor_config.json"

M.options = {
  enabled = true,
  theme_name = "tokyonight",
  colors = {
    -- Personalizados extraídos del Workspace (.arttex.json)
    custom_command = "#ff9e64",
    custom_env = "#7aa2f7",

    -- Globales Base (Treesitter)
    macro = "#bb9af7",      -- \textbf, \section
    env_name = "#ff9e64",   -- {align*}
    env_kw = "#7dcfff",     -- \begin / \end
    math = "#86e1fc",       -- bloque matematico
    math_oper = "#f7768e",  -- $, \[, \]
    link = "#7aa2f7",       -- Referencias y Citas

    -- Kernel & Expl3
    kernel_macro = "#f7768e", -- Macros con @
    expl3_macro = "#e0af68",  -- Macros con _ y :
    struct_cmd = "#9ece6a",   -- \usepackage, \documentclass

    -- Semántica de Entornos
    env_theorem = "#bb9af7",  -- theorem, lemma, proof
    env_math_block = "#7dcfff", -- align, equation
    env_box = "#e0af68",      -- mdframed, tcolorbox

    -- Validación y Errores
    ref_valid = "#9ece6a",    -- \ref válido
    ref_invalid = "#f7768e",  -- \ref inválido
    error_color = "#f7768e",  -- Errores de sintaxis (undercurl)
    match_paren = "#3b4261",  -- Fondo de Begin/End emparejados
    resource_virt = "#565f89", -- Color para virtual text de imágenes/archivos

    -- Rainbow Brackets (Deep)
    rainbow1 = "#f7768e",
    rainbow2 = "#e0af68",
    rainbow3 = "#9ece6a",
    rainbow4 = "#7aa2f7",
    rainbow5 = "#bb9af7",
    rainbow6 = "#7dcfff",
    
    -- UI del editor
    cursor_line_nr = "#ff9e64", -- Color del número de línea actual
  },
  features = {
    rainbow_brackets = true,
    match_paren = true,
    semantic_envs = true,  -- Fondos de teoremas y cajas matemáticas
    virtual_text = {
      references = true,   -- Validación de \ref (iconos y colores)
      resources = true,    -- Iconos para \includegraphics e \input
      structs = true,      -- Texto virtual para \chapter y \section
    },
    syntax_errors = true,
  },
  env_keywords = {
    theorem = { "theorem", "lemma", "proof", "corollary", "definition", "example", "remark" },
    math_block = { "align", "align*", "equation", "equation*", "gather", "gather*", "eqnarray" },
    box = { "mdframed", "tcolorbox", "minipage" },
  },
  custom_groups = {
    -- Ejemplo:
    -- {
    --   name = "MySpecialGroup",
    --   color = "#ff00ff",
    --   bold = true,
    --   italic = false,
    --   commands = { "\\mycmd", "\\othercmd" }
    -- }
  }
}

function M.setup(user_opts)
  if user_opts then
    M.options = vim.tbl_deep_extend("force", M.options, user_opts)
  end
  M.load_json()
end

function M.load_json()
  local f = io.open(M.config_file, "r")
  if f then
    local content = f:read("*a")
    f:close()
    local ok, parsed = pcall(vim.json.decode, content)
    if ok and type(parsed) == "table" then
      M.options = vim.tbl_deep_extend("force", M.options, parsed)
    end
  end
end

function M.save_json()
  -- Solo guardar colores (theme) y features, para no engordar el archivo con env_keywords si no se modificaron desde UI
  local save_data = {
    colors = M.options.colors,
    features = M.options.features,
    theme_name = M.options.theme_name -- track selected theme
  }
  local f = io.open(M.config_file, "w")
  if f then
    f:write(vim.json.encode(save_data))
    f:close()
  end
end



return M
