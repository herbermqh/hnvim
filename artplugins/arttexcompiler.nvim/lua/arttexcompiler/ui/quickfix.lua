--- Módulo UI para análisis (parsing) y volcado de errores en Quickfix.
--- Extrae las líneas de error de los archivos `.log` y las presenta en la lista Quickfix (o Trouble) de Neovim.
--- @class arttexcompiler.ui.quickfix
local M = {}

--- Parsea el archivo .log generado por el compilador para extraer la línea exacta del error.
--- Es VITAL que el compilador se ejecute con la bandera `-file-line-error`.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.parse_log(main_path)
  local workspace = require("arttexworkspace")
  local log = workspace.log
  local config = require("arttexcompiler.config").get_options(main_path)
  local basename = vim.fn.fnamemodify(main_path, ":t:r")
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  
  local log_root = root_dir .. "/" .. basename .. ".log"
  local log_build = root_dir .. "/build/" .. basename .. ".log"
  local log_custom = nil
  
  if config.use_out_dir and config.out_dir_name then
    log_custom = root_dir .. "/" .. config.out_dir_name .. "/" .. basename .. ".log"
  end
  
  local stat_root = vim.loop.fs_stat(log_root)
  local stat_build = vim.loop.fs_stat(log_build)
  local stat_custom = log_custom and vim.loop.fs_stat(log_custom) or nil
  
  local log_path = nil
  local latest_time = -1
  
  -- Algoritmo heurístico para encontrar el log file más reciente (en caso de limpiezas asíncronas)
  if stat_root and stat_root.mtime.sec > latest_time then
    latest_time = stat_root.mtime.sec
    log_path = log_root
  end
  if stat_build and stat_build.mtime.sec > latest_time then
    latest_time = stat_build.mtime.sec
    log_path = log_build
  end
  if stat_custom and stat_custom.mtime.sec > latest_time then
    latest_time = stat_custom.mtime.sec
    log_path = log_custom
  end
  
  local f = nil
  if log_path then
    f = io.open(log_path, "r")
  end
  
  if not f then
    log.error("Quickfix: No se encontró el archivo log en la raíz ni en build/")
    return
  end
  
  local qf_list = {}
  local root_dir = vim.fn.fnamemodify(main_path, ":p:h")
  
  for line in f:lines() do
    -- Busca el patrón de -file-line-error: "archivo.tex:linea: mensaje"
    local file, lnum, msg = line:match("^(.-):(%d+): (.*)$")
    
    -- Ignorar falsos positivos de latexmk o trazas del sistema
    if file and lnum and msg and not file:match("latexmk") then
      local abs_file = file
      -- Convertir rutas relativas a absolutas basadas en el directorio del proyecto
      if not file:match("^/") then
         abs_file = vim.fn.resolve(root_dir .. "/" .. file)
      end
      
      table.insert(qf_list, {
        filename = abs_file,
        lnum = tonumber(lnum),
        text = msg,
        type = "E" -- Error type para Neovim
      })
    end
  end
  f:close()
  
  -- Si hay errores, mandarlos al Quickfix de Neovim
  if #qf_list > 0 then
    vim.schedule(function()
      vim.fn.setqflist(qf_list, 'r')
      local has_trouble, _ = pcall(vim.cmd, "Trouble qflist open")
      if not has_trouble then
         vim.cmd("copen")
      end
      vim.notify("ArtTeX: " .. #qf_list .. " errores encontrados. Revisa el panel de Trouble.", vim.log.levels.WARN)
    end)
    log.info("Quickfix: " .. #qf_list .. " errores extraídos y cargados al panel.")
  else
    log.warn("Quickfix: Falló la compilación, pero no se hallaron errores con formato file-line-error en " .. (log_path or "ninguno"))
    vim.schedule(function()
      vim.notify("ArtTeX: error file-line-error en " .. vim.fn.fnamemodify(log_path or "", ":t"), vim.log.levels.WARN)
    end)
  end
end

--- Limpia la lista Quickfix (y cierra Trouble) automáticamente tras una compilación exitosa.
function M.clear_errors()
  vim.schedule(function()
    vim.fn.setqflist({}, 'r')
    pcall(vim.cmd, "Trouble qflist close")
    pcall(vim.cmd, "cclose")
  end)
end

return M
