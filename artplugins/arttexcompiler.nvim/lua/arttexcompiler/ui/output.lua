--- Módulo UI para el volcado de consola.
--- Administra los buffers y ventanas flotantes que muestran el output (stdout/stderr) en tiempo real de los procesos.
--- @class arttexcompiler.ui.output
local M = {}
M.buffers = {}
M.windows = {}
M.is_visible = {}

--- Borra todo el texto del buffer de salida para un proyecto determinado (usado al iniciar una nueva compilación).
--- @param main_path string Ruta absoluta del archivo raíz.
function M.clear_output(main_path)
  local buf = M.buffers[main_path]
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
  end
end

--- Agrega nuevas líneas al buffer en tiempo real.
--- Crea el buffer si no existe y define atajos de teclado para matar el proceso (C-c, C-z).
--- @param main_path string Ruta absoluta del archivo raíz.
--- @param data string[] Tabla con las líneas escupidas por stdout o stderr.
function M.append_output(main_path, data)
  if not M.buffers[main_path] or not vim.api.nvim_buf_is_valid(M.buffers[main_path]) then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'filetype', 'arttex_output')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    
    -- Mapeos para emular el comportamiento de una terminal interactiva (matar el proceso con Ctrl+C o Ctrl+Z)
    local kill_cmd = string.format("<Cmd>lua require('arttexcompiler.core.job').stop_compilation('%s')<CR>", main_path:gsub("'", "\\'"))
    vim.api.nvim_buf_set_keymap(buf, "n", "x", kill_cmd, { noremap = true, silent = true, desc = "Detener compilación agresivamente" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-c>", kill_cmd, { noremap = true, silent = true, desc = "Detener compilación" })
    vim.api.nvim_buf_set_keymap(buf, "i", "<C-c>", kill_cmd, { noremap = true, silent = true, desc = "Detener compilación" })
    vim.api.nvim_buf_set_keymap(buf, "n", "<C-z>", kill_cmd, { noremap = true, silent = true, desc = "Detener compilación" })
    vim.api.nvim_buf_set_keymap(buf, "i", "<C-z>", kill_cmd, { noremap = true, silent = true, desc = "Detener compilación" })
    
    M.buffers[main_path] = buf
  end
  local buf = M.buffers[main_path]
  
  -- Filtrar líneas vacías o nulas
  local clean_data = {}
  for _, line in ipairs(data) do
    if type(line) == "string" and line ~= "" then 
      table.insert(clean_data, line) 
    end
  end
  if #clean_data == 0 then return end
  
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(buf) then
      local line_count = vim.api.nvim_buf_line_count(buf)
      -- Si el buffer está vacío, reemplazar la primera línea
      if line_count == 1 and vim.api.nvim_buf_get_lines(buf, 0, -1, false)[1] == "" then
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, clean_data)
      else
        vim.api.nvim_buf_set_lines(buf, line_count, line_count, false, clean_data)
      end
      
      -- Auto-scroll hacia abajo si la ventana está abierta
      local win = M.windows[main_path]
      if win and vim.api.nvim_win_is_valid(win) then
        local new_count = vim.api.nvim_buf_line_count(buf)
        pcall(vim.api.nvim_win_set_cursor, win, {new_count, 0})
      end
    end
  end)
end

--- Abre la ventana flotante (ui modal) para ver el buffer de output.
--- Centra la ventana en la pantalla y hace auto-scroll hasta el final.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.open_window(main_path)
  if M.windows[main_path] and vim.api.nvim_win_is_valid(M.windows[main_path]) then
    return -- Ya está abierta
  end
  
  local buf = M.buffers[main_path]
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  
  local width = math.floor(vim.o.columns * 0.8)
  local height = math.floor(vim.o.lines * 0.8)
  
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = 'minimal',
    border = 'rounded',
    title = ' Terminal de Compilación: ' .. vim.fn.fnamemodify(main_path, ":t") .. ' ',
    title_pos = 'center',
  })
  
  vim.api.nvim_win_set_option(win, 'winhl', 'NormalFloat:Normal,FloatBorder:TelescopeBorder')
  
  -- Mapeos para salir rápido
  vim.keymap.set('n', 'q', function() M.close_window(main_path) end, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set('n', '<Esc>', function() M.close_window(main_path) end, { buffer = buf, noremap = true, silent = true })
  
  M.windows[main_path] = win
  M.is_visible[main_path] = true
  
  local new_count = vim.api.nvim_buf_line_count(buf)
  pcall(vim.api.nvim_win_set_cursor, win, {new_count, 0})
end

--- Cierra la ventana flotante actual si existe, pero no destruye el buffer ni los logs internos.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.close_window(main_path)
  M.is_visible[main_path] = false
  if M.windows[main_path] and vim.api.nvim_win_is_valid(M.windows[main_path]) then
    vim.api.nvim_win_close(M.windows[main_path], true)
    M.windows[main_path] = nil
  end
end

--- Intercambia el estado de visibilidad de la ventana de salida.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.toggle_window(main_path)
  if M.is_visible[main_path] and M.windows[main_path] and vim.api.nvim_win_is_valid(M.windows[main_path]) then
    M.close_window(main_path)
  else
    M.open_window(main_path)
  end
end

--- Cierra absolutamente todas las ventanas de salida gráficas activas.
function M.close_all()
  local count = 0
  for main_path, win in pairs(M.windows) do
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
    M.windows[main_path] = nil
    M.is_visible[main_path] = false
    count = count + 1
  end
  if count > 0 then
    vim.notify("ArtTeX: Todas las ventanas de salida han sido cerradas.", vim.log.levels.INFO)
  end
end

--- Configura comandos automáticos para auto-ocultar las ventanas flotantes si el usuario cambia a un buffer que no pertenece al proyecto.
function M.setup_autocmds()
  -- Evento para ocultar/mostrar la ventana dependiendo de si estamos en el main.tex
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      local current_file = vim.api.nvim_buf_get_name(0)
      for main_path, win in pairs(M.windows) do
        local output_buf = M.buffers[main_path]
        local output_buf_name = output_buf and vim.api.nvim_buf_get_name(output_buf) or ""
        
        if current_file == main_path or current_file == output_buf_name then
          -- Si volvimos al main.tex y debería estar visible, la reabrimos.
          -- Si entramos a la propia ventana de logs (output_buf_name), la dejamos abierta.
          if current_file == main_path and M.is_visible[main_path] and (not M.windows[main_path] or not vim.api.nvim_win_is_valid(M.windows[main_path])) then
            M.is_visible[main_path] = false 
            M.open_window(main_path)
          end
        else
          -- Si el usuario cambió a cualquier otra pestaña (ej. capitulo1.tex), la cerramos en la sombra.
          if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
            M.windows[main_path] = nil
          end
        end
      end
    end
  })
end

return M
