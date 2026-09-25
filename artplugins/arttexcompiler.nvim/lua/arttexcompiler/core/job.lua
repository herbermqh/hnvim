local state = require("arttexcompiler.core.state")
local workspace = require("arttexworkspace")
local output = require("arttexcompiler.ui.output")
local log = workspace.log

--- Módulo de Gestión de Trabajos (Jobs) del Sistema Operativo.
--- Construye los comandos (args) y lanza los procesos de latexmk o motores crudos de manera asíncrona usando la API de Neovim (`jobstart`).
--- @class arttexcompiler.core.job
local M = {}

--- Rutina de limpieza extrema. Busca y destruye procesos huérfanos de `latexmk` que hayan quedado corriendo en el background de manera infinita.
--- @param main_path string Ruta absoluta del archivo raíz (usada para identificar al proceso zombie).
local function kill_zombies(main_path)
  if vim.fn.has("win32") == 1 then return end
  local safe_path = main_path:gsub("'", "'\\''")
  local sweep_cmd = string.format('for pid in $(pgrep -f "(latexmk|xelatex|pdflatex|lualatex|pdftex|luatex|xetex|tectonic).*%s"); do pkill -9 -P $pid 2>/dev/null; kill -9 $pid 2>/dev/null; done', safe_path)
  os.execute(sweep_cmd)
end

--- Punto de entrada para lanzar una compilación.
--- Parsea la configuración, inyecta las banderas vitales (`-file-line-error`, carpetas de salida) y ejecuta el proceso.
--- @param main_path string Ruta absoluta del archivo raíz del proyecto.
--- @param engine string Motor de compilación a usar (ej: "pdflatex", "latexmk", "plaintex").
function M.start_compilation(main_path, engine)
  if state.is_running(main_path) then
    log.warn("Compiler: El proceso ya está corriendo para " .. main_path)
    log.notify("ArtTeX: Ya compilando.", vim.log.levels.WARN)
    return
  end
  
  -- Pre-boot Zombie Sweeper: Limpiar procesos latexmk huérfanos antes de iniciar
  kill_zombies(main_path)
  
  state.set_starting(main_path)

  local config = require("arttexcompiler.config").get_options(main_path)
  local root_dir = vim.fn.fnamemodify(main_path, ":h")

  local cmd = {}
  
  if engine == "plaintex" then
    local plain_eng = config.plain_engine or "pdftex"
    local plain_cmd_str = config.plain_cmds and config.plain_cmds[plain_eng] or ('pdftex --shell-escape -file-line-error -interaction=nonstopmode -synctex=1 %S')
    
    -- INYECTAR OPCIONES DE CARPETA DE SALIDA PARA PLAIN TEX
    if config.use_out_dir and config.out_dir_name and config.out_dir_name ~= "" then
      local out_dir_opt = "-output-directory=" .. config.out_dir_name
      if not plain_cmd_str:match("%-output%-directory") then
        plain_cmd_str = plain_cmd_str:gsub(plain_eng, plain_eng .. " " .. out_dir_opt)
      end
      vim.fn.mkdir(root_dir .. "/" .. config.out_dir_name, "p")
    end

    -- Inyectar -file-line-error si el usuario lo borró accidentalmente (vital para quickfix)
    if not plain_cmd_str:match("%-file%-line%-error") then
      plain_cmd_str = plain_cmd_str:gsub(plain_eng, plain_eng .. " -file-line-error")
    end
    
    -- Inyectar -interaction=nonstopmode para evitar que el compilador se congele esperando input
    if not plain_cmd_str:match("%-interaction=") then
      plain_cmd_str = plain_cmd_str:gsub(plain_eng, plain_eng .. " -interaction=nonstopmode")
    end

    local final_cmd = plain_cmd_str:gsub("%%S", main_path)
    for w in final_cmd:gmatch("%S+") do table.insert(cmd, w) end
  else
    if config.use_latexmk then
      cmd = { "latexmk" }
      if engine == "pdflatex" then
        table.insert(cmd, "-pdflatex")
      elseif engine == "lualatex" then
        table.insert(cmd, "-lualatex")
      elseif engine == "xelatex" then
        table.insert(cmd, "-xelatex")
      end
      
      local lmk_opts = config.latexmk_options or ""
      
      -- INYECTAR OPCIONES DE CARPETA DE SALIDA PARA LATEXMK
      if config.use_out_dir and config.out_dir_name and config.out_dir_name ~= "" then
        local out_dir_opt = "-outdir=" .. config.out_dir_name
        if not lmk_opts:match("%-outdir=") then
          lmk_opts = out_dir_opt .. " " .. lmk_opts
        end
        vim.fn.mkdir(root_dir .. "/" .. config.out_dir_name, "p")
      end
      
      -- INYECTAR OPCIONES FUNDAMENTALES PARA EL MOTOR SUBYACENTE
      if not lmk_opts:match("%-file%-line%-error") then
        lmk_opts = "-file-line-error " .. lmk_opts
      end
      if not lmk_opts:match("%-interaction=") then
        lmk_opts = "-interaction=nonstopmode " .. lmk_opts
      end
      
      if lmk_opts ~= "" then
        for w in lmk_opts:gmatch("%S+") do table.insert(cmd, w) end
      end

      if config.continuous then
        table.insert(cmd, "-pvc")
        table.insert(cmd, "-e")
        table.insert(cmd, "$success_cmd='echo arttex_success'; $failure_cmd='echo arttex_failure'")
      end
      table.insert(cmd, main_path)
    else
      cmd = { engine }
      local raw_opt_str = config.raw_cmds and config.raw_cmds[engine] or ""
      
      -- INYECTAR OPCIONES DE CARPETA DE SALIDA PARA RAW COMMANDS
      if config.use_out_dir and config.out_dir_name and config.out_dir_name ~= "" then
        local out_dir_opt = "-output-directory=" .. config.out_dir_name
        if not raw_opt_str:match("%-output%-directory") then
          raw_opt_str = out_dir_opt .. " " .. raw_opt_str
        end
        vim.fn.mkdir(root_dir .. "/" .. config.out_dir_name, "p")
      end
      
      if not raw_opt_str:match("%-file%-line%-error") and (engine == "pdflatex" or engine == "lualatex" or engine == "xelatex") then
        raw_opt_str = "-file-line-error " .. raw_opt_str
      end
      
      if not raw_opt_str:match("%-interaction=") and (engine == "pdflatex" or engine == "lualatex" or engine == "xelatex") then
        raw_opt_str = "-interaction=nonstopmode " .. raw_opt_str
      end

      if raw_opt_str ~= "" then
        for w in raw_opt_str:gmatch("%S+") do table.insert(cmd, w) end
      end
      table.insert(cmd, main_path)
    end
  end

  log.info("Compiler: Iniciando latexmk para " .. main_path)
  log.info("Compiler CMD: " .. table.concat(cmd, " "))
  state.update_status(main_path, "running")
  
  -- Añadimos separadores en vez de limpiar, para mantener el historial vivo siempre
  output.append_output(main_path, { "", "================================================" })
  output.append_output(main_path, { "=== Iniciando Compilación (" .. engine .. ") ===" })
  output.append_output(main_path, { "Comando Exacto (Incluyendo inyecciones automáticas y personalizadas):" })
  output.append_output(main_path, { "$ " .. table.concat(cmd, " "), "" })

  local filename = vim.fn.fnamemodify(main_path, ":t")

  local job_id = vim.fn.jobstart(cmd, {
    cwd = root_dir,
    on_stdout = function(jid, data)
      local current_info = state.get_job_info(main_path)
      if current_info and current_info.job_id ~= nil and current_info.job_id ~= jid then return end
      if data then
        output.append_output(main_path, data)
        for _, line in ipairs(data) do
          if line:match("Latexmk: applying rule") or line:match("Latexmk: File changed") then
            state.update_status(main_path, "running")
            log.info("Compiler: Detectados cambios, iniciando recompilación...")
          elseif line:match("arttex_success") then
            if state.get_job_info(main_path).status ~= "success" then
              log.info("Compiler: Éxito reportado por latexmk.")
              state.update_status(main_path, "success")
              require("arttexcompiler.ui.quickfix").clear_errors()
            end
          elseif line:match("arttex_failure") then
            if state.get_job_info(main_path).status ~= "failed" then
              log.error("Compiler: Fallo reportado por latexmk.")
              state.update_status(main_path, "failed")
              log.notify("Error", vim.log.levels.ERROR, { title = filename, icon = "❌", timeout = 5000 })
              require("arttexcompiler.ui.quickfix").parse_log(main_path)
            end
          end
        end
      end
    end,
    on_stderr = function(jid, data)
      local current_info = state.get_job_info(main_path)
      if current_info and current_info.job_id ~= nil and current_info.job_id ~= jid then return end
      if data then
        output.append_output(main_path, data)
      end
    end,
    on_exit = function(jid, code)
      local current_info = state.get_job_info(main_path)
      local was_stopped = current_info and current_info.status == "stopped"

      if current_info and current_info.job_id == jid then
        state.unregister_job(main_path)
      end
      
      if code == 0 then
        output.append_output(main_path, { "", "=== Compilación Finalizada con Éxito ===" })
        log.info("Compiler: Proceso terminado exitosamente.")
        state.update_status(main_path, "success")
        log.notify("Éxito", vim.log.levels.INFO, { title = filename, icon = "󰄴", timeout = 3000 })
        require("arttexcompiler.ui.quickfix").clear_errors()
      elseif was_stopped then
        output.append_output(main_path, { "", "=== Compilación Cancelada ===" })
        log.info("Compiler: El compilador fue detenido por el usuario.")
      else
        output.append_output(main_path, { "", "=== Falló la compilación (Code: " .. code .. ") ===" })
        log.error("Compiler: El compilador terminó con error. Code: " .. tostring(code))
        state.update_status(main_path, "error")
        -- DUMP THE OUTPUT TO A FILE FOR DEBUGGING
        local job_info = state.get_job_info(main_path)
        if job_info and job_info.output then
          local dump_f = io.open("/home/userh/.cache/nvim/arttex_last_error.log", "w")
          if dump_f then
            for _, line in ipairs(job_info.output) do
              dump_f:write(line .. "\n")
            end
            dump_f:close()
          end
        end
        log.notify("Error", vim.log.levels.ERROR, { title = filename, icon = "󰅙", timeout = 5000 })
        require("arttexcompiler.ui.quickfix").parse_log(main_path)
      end
    end
  })

  if job_id > 0 then
    state.register_job(main_path, job_id, table.concat(cmd, " "))
    log.info("Compiler: Job registrado exitosamente con PID/JobID: " .. job_id)
  else
    state.unregister_job(main_path)
    log.error("Compiler: Fallo fatal al intentar iniciar el job de latexmk")
    log.notify("ArtTeX: Fallo arranque " .. filename, vim.log.levels.ERROR)
  end
end

--- Detiene inmediatamente la compilación en curso de un proyecto específico cerrando su PID interno en Neovim.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.stop_compilation(main_path)
  local info = state.get_job_info(main_path)
  if info and info.job_id then
    state.update_status(main_path, "stopped")
    local pid = vim.fn.jobpid(info.job_id)
    if pid and pid > 0 then
      -- Matar agresivamente el proceso y todos sus hijos (latexmk + pdflatex)
      vim.fn.system("pkill -9 -P " .. pid)
      vim.fn.system("kill -9 " .. pid)
    end
    pcall(vim.fn.jobstop, info.job_id)
    
    log.info("Compiler: Comando KILL agresivo enviado al JobID: " .. info.job_id)
    local output = require("arttexcompiler.ui.output")
    output.append_output(main_path, { "", "=== PROCESO ABORTADO POR EL USUARIO ===" })
  else
    log.warn("Compiler: Comando de parada ignorado. No hay compilador activo para " .. main_path)
    log.notify("ArtTeX: Ya detenido.", vim.log.levels.WARN)
  end
end

--- Recorre todos los procesos de compilación activos a nivel global y los detiene simultáneamente.
function M.stop_all()
  local jobs = state.get_all_jobs()
  local count = 0
  for path, info in pairs(jobs) do
    if info.job_id then
      state.update_status(path, "stopped")
      if vim.fn.has("win32") == 0 then
        local pid = vim.fn.jobpid(info.job_id)
        if pid and pid > 0 then
          os.execute("pkill -9 -P " .. tostring(pid) .. " 2>/dev/null")
          os.execute("kill -9 " .. tostring(pid) .. " 2>/dev/null")
        end
      end
      vim.fn.jobstop(info.job_id)
      count = count + 1
      log.info("Compiler: Deteniendo job globalmente para: " .. path)
    end
  end
  if count > 0 then
    log.notify("ArtTeX: Stop All (" .. tostring(count) .. ")", vim.log.levels.INFO)
  else
    log.notify("ArtTeX: Sin procesos.", vim.log.levels.INFO)
  end
end

vim.api.nvim_create_autocmd("VimLeavePre", {
  desc = "Stop all arttexcompiler jobs when Neovim exits",
  callback = function()
    M.stop_all()
  end,
})

return M
