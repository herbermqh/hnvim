-- =========================================================================
-- LSP UI CONFIGURATION (Ultra Clean & Beautiful)
-- =========================================================================

-- 1. Bordes redondeados elegantes para todas las ventanas flotantes
local border = "rounded"

-- 2. Sobrescribir los manejadores globales del LSP
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = border,
})

-- Función de rescate para forzar bordes redondeados en cualquier otra ventana flotante del LSP
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or border
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- 3. Configuración principal de Diagnósticos
vim.diagnostic.config({
  virtual_text = false,        -- Texto virtual apagado (código limpio)
  signs = true,                -- Mostrar íconos en el margen izquierdo
  underline = true,            -- Subrayar el código problemático
  update_in_insert = false,    -- No actualizar mientras escribes (evita distracciones)
  severity_sort = true,        -- Mostrar errores antes que advertencias
  
  -- Configuración de la ventana flotante de diagnósticos (al dejar el cursor quieto)
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",         -- Mostrar de qué plugin/LSP viene el error
    header = "",               -- Eliminar el título por defecto "Diagnostics:" (se ve feo)
    prefix = "  ",            -- Un pequeño punto elegante antes del texto del error
    format = function(diagnostic)
      -- Formato hermoso: "Mensaje de error [Fuente]"
      return string.format("%s  [%s]", diagnostic.message, diagnostic.source)
    end,
  },
})

-- 4. Íconos premium para el margen izquierdo (Gutter)
-- Usamos íconos clásicos y limpios de NerdFonts
local signs = { 
  Error = " ", 
  Warn  = " ", 
  Hint  = " ", 
  Info  = " " 
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 5. Mostrar ventana flotante de diagnóstico automáticamente
vim.o.updatetime = 250 -- Tiempo de espera suave de un cuarto de segundo
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})]]
