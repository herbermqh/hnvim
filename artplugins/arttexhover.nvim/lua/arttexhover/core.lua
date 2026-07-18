local M = {}

local config = require("arttexhover.config")
local parser = require("arttexhover.utils.parser")
local p_cites = require("arttexhover.providers.citations")
local p_labels = require("arttexhover.providers.labels")
local win = require("arttexhover.window")

--- Función principal de hover
--- @param is_manual boolean Si es true, proviene de un comando directo y recaerá en LSP si falla
function M.hover(is_manual)
  local macro, key = parser.get_context_under_cursor()
  
  if not macro or not key or key == "" then
    -- Fallback: delegar al LSP nativo solo si el hover fue manual
    if is_manual then
      local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
      if has_lsp then
        vim.lsp.buf.hover()
      end
    end
    return
  end
  
  local sets = config.sets
  local bufnr = vim.api.nvim_get_current_buf()
  
  -- Enrutamiento a Proveedores basado en Hash Sets O(1)
  if sets.cites[macro] then
    p_cites.get_hover_info(bufnr, key, function(lines, filetype)
      if lines then win.show(lines, "Cita: " .. key, filetype)
      elseif is_manual then vim.notify("ArtTex Hover: Cita no encontrada.", vim.log.levels.WARN) end
    end)
    return
  end
  
  if sets.refs[macro] then
    p_labels.get_hover_info(bufnr, key, function(lines, filetype)
      if lines then win.show(lines, "Referencia: " .. key, filetype)
      elseif is_manual then vim.notify("ArtTex Hover: Referencia no encontrada.", vim.log.levels.WARN) end
    end)
    return
  end
  
  if sets.pkgs[macro] then
    local lines = {
      "% Paquete: " .. key,
      "% Presiona <leader>ld o ejecuta `:ArtTexDocCTAN`",
      "% para abrir la documentación en CTAN."
    }
    win.show(lines, "Paquete", "tex")
    return
  end
  
  -- Fallback si el macro capturado no encaja en las configuraciones
  if is_manual then
    local has_lsp = #vim.lsp.get_clients({ bufnr = 0 }) > 0
    if has_lsp then
      vim.lsp.buf.hover()
    end
  end
end

--- Función para abrir la documentación del paquete en CTAN
function M.open_ctan()
  local macro, key = parser.get_context_under_cursor()
  local package_name = nil

  if macro and config.sets.pkgs[macro] and key and key ~= "" then
    package_name = key
  else
    -- Si no está sobre \usepackage{...}, tomamos la palabra bajo el cursor como nombre del paquete
    package_name = vim.fn.expand("<cword>")
  end

  if package_name and package_name ~= "" then
    local url = "https://ctan.org/pkg/" .. package_name
    vim.notify("Abriendo documentación en CTAN: " .. package_name, vim.log.levels.INFO)
    vim.ui.open(url)
  else
    vim.notify("ArtTex Hover: No se detectó un nombre de paquete válido.", vim.log.levels.WARN)
  end
end

return M
