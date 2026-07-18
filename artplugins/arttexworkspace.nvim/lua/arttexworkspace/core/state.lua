local log = require("arttexworkspace.core.log")

local M = {}

-- Singleton: State Manager (Emulando gestión de memoria del SO)
-- Memoria Global (Proyectos)
M.projects = {}
-- Memoria Virtual / Mapeo Rápido (Buffers locales -> Main)
M.buffer_roots = {}
-- Caché Reactiva de Archivos (Para el árbol semántico)
M.file_nodes = {}

-- dynamic_macros[root_path] = { ["macro_name"] = { "%s/file.tex" } }
local dynamic_macros = {}

function M.set_dynamic_macros(root_path, macros)
  dynamic_macros[root_path] = macros
end

function M.get_dynamic_macros(root_path)
  return dynamic_macros[root_path] or {}
end

function M.get_project(main_path)
  return M.projects[main_path]
end

function M.register_project(main_path)
  if not M.projects[main_path] then
    M.projects[main_path] = {
      main_path = main_path,
      root_dir = vim.fn.fnamemodify(main_path, ":p:h"),
      engine = "pdflatex", -- default
      document_class = nil,
      packages = {},
      graphicspath = {},
      ready = false,
    }
    log.info("Nuevo proyecto registrado en el estado: " .. main_path)
  end
  return M.projects[main_path]
end

function M.map_buffer(buffer_path, main_path)
  M.buffer_roots[buffer_path] = main_path
  vim.b.arttex_main = main_path
  if main_path then
    log.debug("Buffer " .. buffer_path .. " mapeado a la raíz: " .. main_path)
  else
    log.debug("Buffer " .. buffer_path .. " abierto en modo huérfano (esperando asignación de raíz).")
  end
end

function M.get_main_from_buffer(buf_path)
  return M.buffer_roots[buf_path]
end

return M
