--- Módulo de Configuración de ArtTeX Compiler.
--- Gestiona las opciones globales y locales por proyecto.
--- @class arttexcompiler.Config
local M = {}

M.options = {
  -- Motor por defecto ("pdflatex", "lualatex", "xelatex")
  engine = "pdflatex",
  
  -- ¿Usar latexmk como orquestador?
  use_latexmk = false,
  
  -- Opciones adicionales globales para latexmk
  latexmk_options = "",
  
  -- Destinar compilación a una carpeta específica (ej. build/)
  use_out_dir = false,
  out_dir_name = "build",
  
  -- Opciones puras para compilación sin latexmk
  raw_cmds = {
    pdflatex = "--shell-escape -file-line-error -interaction=nonstopmode -synctex=1",
    lualatex = "--shell-escape -file-line-error -interaction=nonstopmode -synctex=1",
    xelatex = "--shell-escape -file-line-error -interaction=nonstopmode -synctex=1",
    tectonic = "-X compile --synctex",
    arara = "",
    pythontex = ""
  },
  
  -- Modo continuo (-pvc) para latexmk
  continuous = false,

  -- Si es true, preguntará al usuario antes de compilar si está en un archivo incrustado (módulo)
  confirm_subfile_compilation = true,
  
  -- Opciones exclusivas para PlainTeX (No usa latexmk)
  plain_engine = "pdftex", -- Motores permitidos: "pdftex", "luatex", "xetex"
  plain_cmds = {
    pdftex = 'pdftex --shell-escape -file-line-error -interaction=nonstopmode -synctex=1 %S',
    luatex = 'luatex --shell-escape -file-line-error -interaction=nonstopmode -synctex=1 %S',
    xetex  = 'xetex --shell-escape -file-line-error -interaction=nonstopmode -synctex=1 %S'
  }
}

M.project_options = {}

--- Extrae las opciones finales fusionando globales y locales.
--- @param main_path string|nil Ruta absoluta del archivo raíz. Si es nil, devuelve globales.
--- @return table # Tabla con las opciones combinadas para este proyecto.
function M.get_options(main_path)
  if not main_path then return M.options end
  if not M.project_options[main_path] then
    M.load_from_json(main_path)
    if not M.project_options[main_path] then
      M.project_options[main_path] = {}
    end
  end
  return vim.tbl_deep_extend("force", M.options, M.project_options[main_path])
end

--- Modifica una opción específica a nivel de proyecto y la persiste en JSON.
--- @param main_path string Ruta absoluta del archivo raíz.
--- @param key string Nombre de la propiedad a modificar (ej. "engine").
--- @param value any Nuevo valor para la propiedad.
function M.set_project_option(main_path, key, value)
  if not main_path then return end
  if not M.project_options[main_path] then
    M.project_options[main_path] = {}
  end
  M.project_options[main_path][key] = value
  M.save_to_json(main_path)
end

--- Guarda las opciones locales del proyecto en un archivo JSON oculto en la raíz.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.save_to_json(main_path)
  if not main_path then return end
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  local basename = vim.fn.fnamemodify(main_path, ":t:r")
  local json_path = root_dir .. "/." .. basename .. ".arttex.json"
  
  local json_data = {}
  local f_in = io.open(json_path, "r")
  if f_in then
    local content = f_in:read("*all")
    f_in:close()
    local ok, parsed = pcall(vim.fn.json_decode, content)
    if ok and type(parsed) == "table" then json_data = parsed end
  end
  
  json_data.compiler = M.project_options[main_path] or {}
  
  local f_out = io.open(json_path, "w")
  if f_out then
    local ok_json, json_str = pcall(vim.fn.json_encode, json_data)
    if ok_json then f_out:write(json_str) end
    f_out:close()
  end
end

--- Carga las opciones locales del proyecto desde el archivo JSON si existe.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.load_from_json(main_path)
  if not main_path then return end
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  local basename = vim.fn.fnamemodify(main_path, ":t:r")
  local json_path = root_dir .. "/." .. basename .. ".arttex.json"
  
  local f_in = io.open(json_path, "r")
  if f_in then
    local content = f_in:read("*all")
    f_in:close()
    local ok, parsed = pcall(vim.fn.json_decode, content)
    if ok and type(parsed) == "table" and parsed.compiler then
      M.project_options[main_path] = parsed.compiler
    end
  end
end

return M
