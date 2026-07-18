local M = {}

M.options = {
  -- Motor LSP para resolución estructural de dependencias cruzadas.
  -- Opciones disponibles:
  -- "texlab"   : (Por Defecto) Delega la resolución al servidor LSP de terceros (TexLab) si está activo.
  -- "arttex"   : Nuestro motor nativo hiper-rápido (usa Ripgrep/Lua para buscar \documentclass)
  -- "digestif" : Delega la resolución al servidor LSP de terceros (Digestif) si está activo.
  -- "none"     : Desactiva el motor LSP y obliga a usar estrictamente el Motor FLS.
  lsp_engine = "texlab",
  
  -- Rutas donde el usuario guarda sus clases y paquetes personalizados (fuera del proyecto actual).
  -- Esto permite a la IA buscar comandos definidos en librerías privadas del usuario.
  -- Por defecto incluye la ruta estándar de TeXMF de usuario y el clásico Documents/LaTeX.
  library_paths = {
    "~/texmf",
    "~/Documents/LaTeX"
  },
  -- Manejadores personalizados para abrir tipos de archivo específicos (media_handlers)
  -- Si no se define, se usará el visor por defecto del sistema (xdg-open / open).
  media_handlers = {
    -- Ejemplo:
    -- pdf = function(filepath) vim.fn.jobstart({"zathura", filepath}) end,
  },
  
  -- Entornos que deben ser ignorados por el analizador semántico 
  -- (útil si pones código LaTeX dentro de minted o lstlisting)
  verbatim_envs = {
    "verbatim", "Verbatim", "lstlisting", "minted"
  }
}

return M
