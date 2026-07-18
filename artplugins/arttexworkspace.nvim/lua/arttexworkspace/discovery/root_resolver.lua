local log = require("arttexworkspace.core.log")

local M = {}

local uv = vim.uv or vim.loop
local function fast_resolve(path)
  return uv.fs_realpath(path) or path
end

local function file_exists(name)
  local stat = (vim.uv or vim.loop).fs_stat(name)
  return stat ~= nil and stat.type == "file"
end

local function file_has_documentclass(filepath)
  local f = io.open(filepath, "r")
  if not f then return false end
  local content = f:read("*all")
  f:close()
  
  if not content or content == "" then return false end
  
  -- Extraer config para obtener verbatim_envs
  local config = require("arttexworkspace.core.config").options
  local verbatim_envs = config.verbatim_envs or {}
  
  local parser = require("arttexworkspace.parsers.verbatim")
  local clean_content = parser.strip_verbatim(content, verbatim_envs)
  
  -- Buscar documentclass ignorando las líneas que son comentarios
  local prefix = clean_content:sub(1, 8000) -- Expandimos un poco por si hay muchos comentarios
  for line in prefix:gmatch("([^\n]*)\n?") do
    local clean_line = line:gsub("%%.*$", "") -- Eliminar comentario hasta el final de la línea
    if clean_line:match("\\documentclass") then
      return true
    end
  end
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
        -- VERIFICACIÓN ESTRICTA: El hecho de que un directorio padre tenga .texlabroot
        -- no significa que este archivo pertenezca a ese main (Ej: subproyectos independientes).
        local project_root = vim.fn.fnamemodify(exact_path, ":p:h")
        local basename = vim.fn.fnamemodify(exact_path, ":t:r")
        local config_path = project_root .. "/." .. basename .. ".arttex.json"
        
        local belongs_to_root = true -- Asumimos true por defecto si no hay caché
        if file_exists(config_path) then
          local f_in = io.open(config_path, "r")
          if f_in then
            local content = f_in:read("*all")
            f_in:close()
            local ok, parsed = pcall(vim.fn.json_decode, content)
            if ok and type(parsed) == "table" and parsed.project_tree then
              belongs_to_root = false
              local abs_target = fast_resolve(filepath)
              for _, dep in ipairs(parsed.project_tree) do
                if fast_resolve(dep) == abs_target then
                  belongs_to_root = true
                  break
                end
              end
            end
          end
        end
        
        if belongs_to_root then
          log.trace("Heurística de Memoria (.texlabroot): Encontrado y verificado -> " .. exact_path)
          return exact_path
        end
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
  log.trace("Ejecutando Resolver para: " .. filepath)
  if vim.b.arttex_main and file_exists(vim.b.arttex_main) then 
    log.trace("Usando vim.b.arttex_main: " .. vim.b.arttex_main)
    return fast_resolve(vim.b.arttex_main) 
  end
  
  -- 1. Búsqueda instantánea en Memoria Fotográfica o TexLab
  local root_third = check_memory_or_lsp(filepath)
  if root_third then 
    log.trace("Root encontrado por check_memory_or_lsp: " .. root_third)
    return root_third 
  end
  
  -- Si llegamos aquí, no hay memoria y TexLab falló/no está activo. Activamos el Asistente Interactivo.
  log.debug("Memoria vacía y LSP TexLab falló o no está activo en este buffer.")
  
  -- 2.5 Verificar library_paths
  local config = require("arttexworkspace.core.config").options
  if config and config.library_paths then
    local abs_filepath = vim.fn.fnamemodify(filepath, ":p")
    for _, lib_path in ipairs(config.library_paths) do
      local expanded_lib = vim.fn.expand(lib_path)
      if vim.startswith(abs_filepath, expanded_lib) then
        log.debug("El archivo pertenece a library_paths, cancelando búsqueda de raíz.")
        return nil
      end
    end
  end

  -- Para evitar múltiples pop-ups si se abren varios archivos de golpe en la misma carpeta
  local prompted_dirs = vim.g.arttex_prompted_dirs or {}
  local current_dir_for_prompt = vim.fn.fnamemodify(filepath, ":p:h")
  
  if not prompted_dirs[current_dir_for_prompt] then
    prompted_dirs[current_dir_for_prompt] = true
    vim.g.arttex_prompted_dirs = prompted_dirs
    vim.schedule(function()
      -- BÚSQUEDA HACIA ARRIBA (Upward Search)
      local current_dir = vim.fn.fnamemodify(filepath, ":p:h")
      local home_dir = vim.fn.expand("~")
      local max_levels = 2
      local possible_mains = {}
      local project_tree = require("arttexworkspace.discovery.project_tree")
      
      local abs_filepath = fast_resolve(filepath)
      for i = 1, max_levels do
        -- Buscar .tex en current_dir
        local tex_files = vim.fn.glob(current_dir .. "/*.tex", false, true)
        for _, tex_file in ipairs(tex_files) do
          if file_has_documentclass(tex_file) then
            table.insert(possible_mains, tex_file)
            
            -- Verificar inmediatamente si el archivo actual pertenece a este main
            local deps = project_tree.get_dependencies(tex_file)
            if deps then
              for _, dep in ipairs(deps) do
                if fast_resolve(dep) == abs_filepath then
                  -- ¡Encontrado! Es nuestro main definitivo.
                  require("arttexworkspace.ui.menu_builder").create_texlabroot(tex_file, filepath)
                  return
                end
              end
            end
            -- Si no pertenece, seguimos buscando (Regla 3)
          end
        end
        
        -- Subir un nivel
        local parent_dir = vim.fn.fnamemodify(current_dir, ":h")
        if parent_dir == current_dir or parent_dir == home_dir then
          break
        end
        current_dir = parent_dir
      end
      
      -- Si solo hay 1 candidato posible en todo el directorio, asumirlo automáticamente
      -- Esto soluciona módulos incluidos dinámicamente (\IfFileExists) en clases/paquetes 
      -- que el parser semántico o FLS (aún no compilado) no detecta.
      if #possible_mains == 0 then
        -- Archivo global (ej: CTAN, texlive) o muy profundo.
        -- Abortamos silenciosamente para no molestar al usuario con un menú inútil.
        return
      end
      
      if #possible_mains == 1 then
        log.info("ArtTeX: Asumiendo raíz única automáticamente -> " .. possible_mains[1])
        require("arttexworkspace.ui.menu_builder").create_texlabroot(possible_mains[1], filepath)
        return
      end
      
      -- Si hay más de 1 candidato, mostrar menú con las sugerencias
      local options = {}
      for _, main_file in ipairs(possible_mains) do
        table.insert(options, {
          text = "󰈙 " .. vim.fn.fnamemodify(main_file, ":t") .. " (" .. main_file .. ")",
          action = function()
            require("arttexworkspace.ui.menu_builder").create_texlabroot(main_file, filepath)
          end
        })
      end
      
      table.insert(options, { text = "󰈔  Seleccionar main manualmente", action = function() require("arttexworkspace.ui.menu_builder").select_main_tex(filepath) end })
      table.insert(options, { text = "󰅖  Ignorar por ahora", action = function() end })

      require("arttexworkspace.ui.menu_builder").create_menu({
        title = "ArtTeX Root Resolver (Conflictos)",
        prompt = {
          "Se detectaron múltiples archivos main.",
          "¿A cuál pertenece este archivo?"
        },
        options = options
      })
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
