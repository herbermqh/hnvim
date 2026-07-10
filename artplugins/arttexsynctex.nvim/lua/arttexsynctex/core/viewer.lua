local M = {}
local config = require("arttexsynctex.config")
local workspace = require("arttexworkspace")
local path_utils = require("arttexsynctex.utils.path")
local log = workspace.log

local viewers_factory = require("arttexsynctex.viewers")

function M.forward_search()
  local bufnr = vim.api.nvim_get_current_buf()
  local tex_file = vim.api.nvim_buf_get_name(bufnr)
  local root_file = workspace.api.get_root_file(bufnr)

  if not root_file then
    log.warn("No se pudo ejecutar Forward Search: No se detectó un archivo raíz.")
    return
  end

  local pdf_file = root_file:gsub("%.tex$", ".pdf")
  if vim.fn.filereadable(pdf_file) == 0 then
    log.warn("PDF no encontrado para Forward Search: " .. pdf_file)
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local line = cursor[1]
  local col = cursor[2] + 1

  local viewer_name = config.options.viewer
  local viewer_module = viewers_factory.get_viewer(viewer_name)
  
  if not viewer_module then
    log.error("Perfil de visor desconocido: " .. tostring(viewer_name))
    return
  end

  local root_dir = vim.fn.fnamemodify(root_file, ":p:h")
  
  -- Delegamos la construcción del comando y argumentos al módulo del visor específico
  local cmd, args = viewer_module.build_forward_search(pdf_file, tex_file, line, col)

  -- Si el módulo (ej. visores de terminal) se encarga de su propia ejecución, retorna nil
  if not cmd then return end

  log.info(string.format("Ejecutando Forward Search (%s) -> %s:%d", viewer_name, tex_file, line))

  vim.system({ cmd, unpack(args) }, { text = true, cwd = root_dir, detach = true }, function(obj)
    if obj.code ~= 0 and obj.stderr and obj.stderr ~= "" then
      log.error("Fallo en Forward Search (" .. cmd .. "): " .. obj.stderr)
      vim.schedule(function()
        log.notify("ArtTeX: Error abriendo visor", vim.log.levels.ERROR)
      end)
    end
  end)
end

return M
