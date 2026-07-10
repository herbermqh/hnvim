local workspace = require("arttexworkspace")
local state = require("arttexcompiler.core.state")
local job = require("arttexcompiler.core.job")
local log = workspace.log

--- Módulo principal de ArtTeX Compiler.
--- Expone la API pública (comandos y funciones) para interactuar con el compilador.
--- @class arttexcompiler
local M = {}

--- Contiene la API funcional del plugin.
--- @class arttexcompiler.api
M.api = {}

--- Resuelve el archivo raíz del proyecto a compilar.
--- Analiza si el documento actual es un módulo PlainTeX (usando \bye) o si depende del Workspace.
--- @param bufnr number ID del buffer.
--- @return string|nil # Ruta absoluta del archivo raíz, o nil si no se detectó.
local function resolve_root(bufnr)
  bufnr = bufnr or 0
  local root = workspace.api.get_root_file(bufnr)
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  
  local is_plain_override = (vim.bo[bufnr].filetype == "plaintex")
  if not is_plain_override and current_file and current_file ~= "" then
    local lines = vim.fn.readfile(current_file, "", -50)
    if lines then
      for _, line in ipairs(lines) do
        if line:match("\\bye%s*$") or line:match("\\bye%s*%%") or line == "\\bye" then
          is_plain_override = true
          break
        end
      end
    end
  end
  
  if is_plain_override then
    return current_file
  end
  
  return root
end

--- Inicia el proceso de compilación para el archivo raíz correspondiente al buffer dado.
--- Muestra un prompt si el archivo actual es un submódulo y está habilitada la confirmación.
--- @param bufnr number|nil ID del buffer (0 por defecto).
M.api.start = function(bufnr)
  bufnr = bufnr or 0
  local root = resolve_root(bufnr)
  local config = require("arttexcompiler.config").options
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  
  if not root then 
    log.error("Compiler: No se puede iniciar compilador. Workspace no resuelto.")
    log.notify("ArtTeX: Proyecto no detectado.", vim.log.levels.ERROR)
    return 
  end
  
  local proceed_compilation = function()
    local proj = workspace.api.get_project_state(bufnr)
    local compiler_opts = require("arttexcompiler.config").get_options(root)
    local engine = compiler_opts.engine or "pdflatex"
    
    -- DETECCIÓN AUTOMÁTICA DE PLAINTEX
  local is_plaintex = (root == current_file) and (
    vim.bo[bufnr or 0].filetype == "plaintex" or (function()
      local lines = vim.fn.readfile(current_file, "", -50)
      if lines then
        for _, line in ipairs(lines) do
          if line:match("\\bye%s*$") or line:match("\\bye%s*%%") or line == "\\bye" then return true end
        end
      end
      return false
    end)()
  )

    if not is_plaintex then
      if proj then
        if not proj.document_class then is_plaintex = true end
      else
        local lines = vim.fn.readfile(root, "", 150)
        local has_doc = false
        if lines then
          for _, line in ipairs(lines) do
            if line:match("\\documentclass") or line:match("\\begin{document}") then 
              has_doc = true 
              break 
            end
          end
          if not has_doc then is_plaintex = true end
        end
      end
    end
    
    if is_plaintex then
      engine = "plaintex"
      log.info("Compiler: Archivo PlainTeX detectado. Sobreescribiendo motor.")
    end
    
    job.start_compilation(root, engine)
  end

  if config.confirm_subfile_compilation and current_file ~= "" and current_file ~= root then
    local root_name = vim.fn.fnamemodify(root, ":t")
    local menu_builder = require("arttexworkspace.ui.menu_builder")
    
    menu_builder.create_menu({
      title = "Módulo Detectado",
      prompt = "¿Compilar raíz: " .. root_name .. "?",
      options = {
        {
          text = "  ▶  Sí, compilar raíz",
          action = proceed_compilation
        },
        {
          text = "  ⬅  No, cancelar",
          action = function()
            log.info("Compiler: Compilación de raíz cancelada por el usuario.")
          end
        }
      }
    })
  else
    proceed_compilation()
  end
end

--- Fuerza la compilación del buffer actual asumiendo que es un archivo PlainTeX puro.
--- Ignora la detección de raíz de proyecto de latexmk.
--- @param bufnr number|nil ID del buffer (0 por defecto).
M.api.start_plain = function(bufnr)
  bufnr = bufnr or 0
  local current_file = vim.api.nvim_buf_get_name(bufnr)
  
  if not current_file or current_file == "" then
    log.error("Compiler: No se puede iniciar compilador PlainTeX en un buffer sin archivo.")
    return
  end
  
  log.info("Compiler: Compilación forzada a PlainTeX solicitada por el usuario en: " .. current_file)
  job.start_compilation(current_file, "plaintex")
end

--- Detiene la compilación en curso del proyecto asociado al buffer.
--- Termina el trabajo de latexmk o motores crudos y los detiene limpiamente.
--- @param bufnr number ID del buffer.
M.api.stop = function(bufnr)
  local root = resolve_root(bufnr)
  if not root then return end
  job.stop_compilation(root)
end

--- Detiene absolutamente todos los procesos de compilación en todos los proyectos gestionados.
M.api.stop_all = function()
  job.stop_all()
end

--- Limpia los archivos temporales de compilación (auxiliares, logs) generados por latexmk o pdflatex.
--- Restaura el archivo `.fls` generado por latexmk para no romper el AST de arttexworkspace.
--- @param bufnr number ID del buffer.
M.api.clean = function(bufnr)
  local root = resolve_root(bufnr)
  if not root then return end
  local root_dir = vim.fn.fnamemodify(root, ":p:h")
  
  -- 1. Respaldar el archivo .fls en memoria (RAM)
  local fls_path = vim.fn.fnamemodify(root, ":r") .. ".fls"
  local fls_content = nil
  local f_in = io.open(fls_path, "r")
  if f_in then
    fls_content = f_in:read("*all")
    f_in:close()
  end
  
  -- 2. Ejecutar latexmk -c
  local cmd = { "latexmk", "-c", root }
  vim.fn.jobstart(cmd, { 
    cwd = root_dir,
    on_exit = function()
      -- 3. Restaurar el archivo .fls desde la memoria al disco
      if fls_content then
        local f_out = io.open(fls_path, "w")
        if f_out then
          f_out:write(fls_content)
          f_out:close()
        end
      end
      log.notify("ArtTeX: limpiado.", vim.log.levels.INFO)
    end
  })
  
  log.info("Compiler: Limpiando archivos auxiliares de " .. root)
end

--- Imprime en la consola el estado de todos los trabajos (jobs) globales de compilación.
M.api.status = function()
  local jobs = state.get_all_jobs()
  local count = 0
  local msg = "Procesos Globales (ArtTeX):\n"
  
  for path, info in pairs(jobs) do
    if info.job_id then
      count = count + 1
      local short_path = vim.fn.fnamemodify(path, ":~") -- Ruta con ~ para mejor lectura
      msg = msg .. string.format("► [%s] PID: %d | Archivo: %s\n", string.upper(info.status), info.job_id, short_path)
    end
  end
  
  if count == 0 then
    log.notify("ArtTeX: Sin procesos.", vim.log.levels.INFO)
  else
    log.notify(msg, vim.log.levels.INFO)
  end
end

-- ==============================================
-- NUEVA API DE ESTADO (Para integración Noice.nvim)
-- ==============================================
--- Devuelve la tabla de información del estado del job actual. Útil para integraciones (e.g. Noice.nvim, Lualine).
--- @param bufnr number ID del buffer.
--- @return table|nil # Retorna: { job_id = number, status = "running"|"success"|"error"|"stopped" } o nil
M.api.get_compilation_state = function(bufnr)
  local root = resolve_root(bufnr)
  if not root then return nil end
  return state.get_job_info(root)
  -- Retorna: { job_id = number, status = "running" | "success" | "failed" | "stopped" } o nil
end

--- Fuerza el re-análisis del archivo `.log` para abrir la lista Quickfix con los errores.
--- @param bufnr number ID del buffer.
M.api.errors = function(bufnr)
  local root = resolve_root(bufnr)
  if not root then return end
  require("arttexcompiler.ui.quickfix").parse_log(root)
end

--- Retorna un string corto formateado con iconos (ideal para barras de estado como Lualine).
--- @param bufnr number ID del buffer.
--- @return string # String descriptivo del estado (ej. "󰑮 Compilando...").
M.api.get_status_string = function(bufnr)
  local info = M.api.get_compilation_state(bufnr)
  if not info then return "" end
  if info.status == "running" then return "󰑮 Compilando..." end
  if info.status == "success" then return "󰄴 Listo" end
  if info.status == "failed" then return "󰅙 Falló" end
  return ""
end

--- Abre una ventana flotante (Telescope-like) y vuelca el output de la consola en tiempo real del proceso asociado al buffer.
--- @param bufnr number ID del buffer.
M.api.debug_command = function(bufnr)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "Conectando al proceso..." })
  
  local width = math.floor(vim.o.columns * 0.8)
  local height = 5
  local col = math.floor((vim.o.columns - width) / 2)
  local row = math.floor((vim.o.lines - height) / 2)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = col,
    row = row,
    style = "minimal",
    border = "rounded",
    title = " ArtTeX Debug Comando ",
    title_pos = "center"
  })
  
  -- Cerrar fácilmente con q
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>bwipeout<CR>", { noremap = true, silent = true })
  
  -- Actualizador dinámico
  local timer = vim.loop.new_timer()
  timer:start(0, 500, vim.schedule_wrap(function()
    if not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(buf) then
      timer:stop()
      timer:close()
      return
    end
    
    local info = M.api.get_compilation_state(bufnr)
    if info and info.cmd_string then
      if info.status == "running" then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "🚀 Ejecutando ahora mismo (con inyecciones automáticas y personalizadas):", "", info.cmd_string })
      else
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "🏁 Compilación finalizada. Comando EXACTO utilizado al Sistema Operativo:", "", info.cmd_string, "", "(Presiona 'q' para cerrar)" })
      end
    else
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "No hay historial de compilación para este archivo.", "Presiona 'q' para cerrar esta ventana." })
    end
  end))
end

M.api.toggle_output = function()
  local output = require("arttexcompiler.ui.output")
  local roots = vim.tbl_keys(output.buffers)
  
  local valid_roots = {}
  for _, r in ipairs(roots) do
    if vim.api.nvim_buf_is_valid(output.buffers[r]) then
      table.insert(valid_roots, r)
    end
  end
  
  if #valid_roots == 0 then
    local current_root = workspace.api.get_root_file(0)
    if current_root then
      output.toggle_window(current_root)
    else
      log.notify("ArtTeX: No hay salidas de compilación disponibles.", vim.log.levels.WARN)
    end
    return
  end
  
  if #valid_roots == 1 then
    output.toggle_window(valid_roots[1])
    return
  end
  
  local menu_builder = require("arttexworkspace.ui.menu_builder")
  
  local menu_options = {}
  for _, r in ipairs(valid_roots) do
    table.insert(menu_options, {
      text = "  ▶  " .. vim.fn.fnamemodify(r, ":t"),
      action = function()
        output.toggle_window(r)
      end
    })
  end
  
  table.insert(menu_options, {
    text = "  ⬅  Cancelar",
    action = function() end
  })

  menu_builder.create_menu({
    title = "Proyectos Activos",
    prompt = "¿De qué proyecto deseas ver la consola?",
    options = menu_options
  })
end

M.api.close_output = function()
  require("arttexcompiler.ui.output").close_all()
end

M.api.menu = function(bufnr)
  require("arttexcompiler.ui.menu").open_menu(bufnr)
end

--- Función principal de inicialización del plugin.
--- Define opciones globales, comandos de usuario y autocommands (BufWritePost para modo continuo puro).
--- @param opts table Tabla con configuraciones proveídas por el usuario en `init.lua`.
function M.setup(opts)
  require("arttexcompiler.config").options = vim.tbl_deep_extend("force", require("arttexcompiler.config").options, opts or {})
  log.info("ArtTeX Compiler cargado en memoria.")
  
  vim.api.nvim_create_autocmd("User", {
    pattern = "ArtTexWorkspaceReady",
    callback = function(args)
      local main_path = args.data.main_path
      log.info("Compiler: Recibido evento WorkspaceReady para: " .. main_path)
    end
  })


  vim.api.nvim_create_user_command("ArtTexCompile", function() M.api.start() end, {})
  vim.api.nvim_create_user_command("ArtTexCompilePlain", function() M.api.start_plain() end, {})
  vim.api.nvim_create_user_command("ArtTexStop", function() M.api.stop() end, {})
  vim.api.nvim_create_user_command("ArtTexStopAll", function() M.api.stop_all() end, {})
  vim.api.nvim_create_user_command("ArtTexErrors", function() M.api.errors(0) end, {})
  vim.api.nvim_create_user_command("ArtTexClean", function() M.api.clean() end, {})
  vim.api.nvim_create_user_command("ArtTexOutput", function() M.api.toggle_output() end, {})
  vim.api.nvim_create_user_command("ArtTexOutputClose", function() M.api.close_output() end, {})
  vim.api.nvim_create_user_command("ArtTexDebugCommand", function() M.api.debug_command() end, {})
  vim.api.nvim_create_user_command("ArtTexViewLog", function()
    local root = resolve_root(0)
    if root then
      local log_file = vim.fn.fnamemodify(root, ":r") .. ".log"
      if vim.fn.filereadable(log_file) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(log_file))
        vim.cmd("setlocal filetype=arttex_output")
        vim.cmd("setlocal readonly nomodifiable")
      else
        vim.notify("ArtTeX: No se encontró archivo .log (" .. log_file .. ")", vim.log.levels.WARN)
      end
    end
  end, { desc = "View .log file" })
  vim.api.nvim_create_user_command("ArtTexMenuCompilatorConfig", function() M.api.menu() end, {})
  
  require("arttexcompiler.ui.output").setup_autocmds()
  
  -- Watcher nativo de Neovim para Modo Continuo en Motores Puros (Sin latexmk)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.tex", "*.sty", "*.cls" },
    callback = function(args)
      local bufnr = args.buf
      local root = resolve_root(bufnr)
      if root then
        local opts = require("arttexcompiler.config").get_options(root)
        -- Si está en continuo pero NO usa latexmk, Neovim mismo hace el re-compile al guardar
        if opts.continuous and not opts.use_latexmk then
          -- Pequeño delay para no colisionar con otros plugins
          vim.defer_fn(function()
            -- Solo iniciar si no hay ya una compilación corriendo
            local state_info = M.api.get_compilation_state(bufnr)
            if not state_info or state_info.status ~= "running" then
              M.api.start(bufnr)
            end
          end, 200)
        end
      end
    end
  })
end

return M
