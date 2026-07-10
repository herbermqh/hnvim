local log = require("arttexworkspace.core.log")
local state = require("arttexworkspace.core.state")

local M = {}

function M.parse_project(main_path)
  local project = state.get_project(main_path)
  if not project then return end

  log.info("Iniciando parseo sintáctico del preámbulo para: " .. main_path)
  local f = io.open(main_path, "r")
  if not f then 
    log.error("Fallo crítico: No se pudo abrir ni analizar el archivo raíz (" .. main_path .. "). Revisa los permisos de lectura.")
    return 
  end

  local preamble = ""
  for line in f:lines() do
    -- Detener el parseo al llegar al documento
    if line:match("\\begin{document}") then break end
    -- Extraer el motor de compilación mágico
    local engine = line:match("^%s*%%%s*!?%s*[tT][eE][xX]%s+[pP][rR][oO][gG][rR][aA][mM]%s*[=:]%s*(.+)%s*$")
    if engine then project.engine = engine end
    
    -- Limpiar comentarios para evitar falsos positivos
    local clean_line = line:gsub("%%.*$", "")
    preamble = preamble .. " " .. clean_line
  end
  f:close()

  -- Extraer clase de documento
  local class = preamble:match("\\documentclass%[?.-%]?%{([^}]+)%}")
  if class then
    project.document_class = class
    log.debug("Clase detectada: " .. class)
  end

  -- Extraer paquetes (\usepackage{a,b,c})
  for pkgs in preamble:gmatch("\\usepackage%[.-%]%{([^}]+)%}") do
    for pkg in pkgs:gmatch("[^,]+") do
      local p = pkg:match("^%s*(.-)%s*$")
      project.packages[p] = true
    end
  end
  for pkgs in preamble:gmatch("\\usepackage%{([^}]+)%}") do
    for pkg in pkgs:gmatch("[^,]+") do
      local p = pkg:match("^%s*(.-)%s*$")
      project.packages[p] = true
    end
  end
  
  -- Extraer graphicspath (\graphicspath{{img/}{figs/}})
  local paths = preamble:match("\\graphicspath%{%s*(.-)%s*%}")
  if paths then
    for path in paths:gmatch("%{([^}]+)%}") do
      table.insert(project.graphicspath, path)
    end
  end

  project.ready = true
  log.info("Parseo completado. Paquetes encontrados: " .. vim.tbl_count(project.packages))
  
  -- Solo mostrar Success si el archivo analizado es realmente una raíz válida (tiene documentclass)
  -- Esto evita mostrar Success en módulos huérfanos que el FLS/LSP no pudieron resolver.
  -- if not silent then
  --   log.info("ArtTeX Workspace: Success " .. vim.fn.fnamemodify(main_path, ":t") .. ".")
  -- end
  
  -- Emitir evento global (Pub/Sub) tipo OS Interrupt
  vim.api.nvim_exec_autocmds("User", {
    pattern = "ArtTexWorkspaceReady",
    data = { main_path = main_path }
  })
end

return M
