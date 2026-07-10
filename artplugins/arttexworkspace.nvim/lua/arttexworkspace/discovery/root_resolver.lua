local log = require("arttexworkspace.core.log")

local M = {}

local function file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then io.close(f) return true else return false end
end

local function file_has_documentclass(filepath)
  local f = io.open(filepath, "r")
  if not f then return false end
  local count = 0
  for line in f:lines() do
    count = count + 1
    if count > 50 then break end
    if line:match("\\documentclass") then
      f:close()
      return true
    end
  end
  f:close()
  return false
end

-- ==============================================
-- MOTOR DE MEMORIA ABSOLUTA Y LSP
-- ==============================================
local function check_memory_or_lsp(filepath)
  -- 0. Heurística Directa (Fast-Path): ¿El archivo actual es el principal?
  -- Si el archivo que abriste tiene \documentclass, es 100% el archivo main.
  -- Esto soluciona que te pida la raíz en archivos simples.
  if file_has_documentclass(filepath) then
    log.trace("Heurística Fast-Path: El archivo actual tiene \\documentclass -> " .. filepath)
    return filepath
  end

  -- 1. Buscar la Memoria Fotográfica (.texlabroot unificado)
  local start_dir = vim.fn.fnamemodify(filepath, ":p:h")
  local root_marker_files = vim.fs.find(".texlabroot", { path = start_dir, upward = true, stop = vim.fn.expand("~") })
  
  if #root_marker_files > 0 then
    local f = io.open(root_marker_files[1], "r")
    if f then
      local exact_path = f:read("*l")
      f:close()
      if exact_path and file_exists(exact_path) and exact_path:match("%.tex$") then
        log.trace("Heurística de Memoria (.texlabroot): Encontrado -> " .. exact_path)
        return exact_path
      else
        -- Si el archivo existe pero está vacío (comportamiento legacy de TexLab)
        -- Trataremos la carpeta que lo contiene como la raíz, pero necesitamos un main.tex
        local root_dir = vim.fn.fnamemodify(root_marker_files[1], ":p:h")
        local main_guess = root_dir .. "/main.tex"
        if file_exists(main_guess) then return main_guess end
      end
    end
  end

  -- 2. Fallback a TexLab LSP (si la memoria no existe)
  local bufnr = vim.fn.bufnr(filepath)
  if bufnr == -1 then return nil end
  
  local get_clients = vim.lsp.get_clients or vim.lsp.get_active_clients
  local clients = get_clients({ bufnr = bufnr, name = "texlab" })
  
  if not clients or #clients == 0 then return nil end
  local root_dir = clients[1].config.root_dir
  if not root_dir then return nil end
  
  local tex_files = vim.fn.globpath(root_dir, "*.tex", false, true)
  if type(tex_files) == "string" and tex_files ~= "" then tex_files = {tex_files} end
  if type(tex_files) == "table" then
    for _, tex in ipairs(tex_files) do
      if file_has_documentclass(tex) then
        log.trace("Heurística LSP (texlab): Encontrado -> " .. tex)
        return tex
      end
    end
  end
  return nil
end

function M.find_root(filepath)
  log.debug("Ejecutando Resolver para: " .. filepath)
  if vim.b.arttex_main and file_exists(vim.b.arttex_main) then return vim.fn.resolve(vim.b.arttex_main) end
  
  -- 1. Búsqueda instantánea en Memoria Fotográfica o TexLab
  local root_third = check_memory_or_lsp(filepath)
  if root_third then return root_third end
  
  -- Si llegamos aquí, no hay memoria y TexLab falló/no está activo. Activamos el Asistente Interactivo.
  log.debug("Memoria vacía y LSP TexLab falló o no está activo en este buffer.")
  
  -- Para evitar múltiples pop-ups si se abren varios archivos de golpe
  if not vim.g.arttex_texlabroot_prompted then
    vim.g.arttex_texlabroot_prompted = true
    vim.schedule(function()
      require("arttexworkspace.ui.menu_builder").prompt_texlabroot(function(choice)
        if choice == 1 then
          require("arttexworkspace.ui.menu_builder").select_main_tex()
        end
      end)
    end)
  end
  
  -- Si llegamos aquí y el archivo actual NO tiene \documentclass, no podemos asumirlo como raíz
  -- porque es un submódulo. Devolvemos nil para no contaminar con archivos JSON falsos.
  if not file_has_documentclass(filepath) then
    return nil
  end
  
  log.warn("No se encontró la raíz del proyecto. Usando el archivo actual como fallback porque tiene \\documentclass.")
  return filepath
end

return M
