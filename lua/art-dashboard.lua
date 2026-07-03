local M = {}
local api = vim.api

function M.setup(opts)
  opts = opts or {}
  
  -- Comando para abrir el dashboard manualmente
  api.nvim_create_user_command('ArtDashboard', function()
    M.open()
  end, {})

  -- Autocomando para abrir al iniciar si no se especificó un archivo
  api.nvim_create_autocmd("VimEnter", {
    callback = function()
      if vim.fn.argc() == 0 and vim.fn.line2byte(vim.fn.line("$")) == -1 then
        M.open()
      end
    end,
  })
end

function M.open()
  -- Crear un buffer "scratch" (desechable)
  local buf = api.nvim_create_buf(false, true)
  
  -- Configuración básica del buffer
  api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(buf, 'filetype', 'artdashboard')
  
  -- Poner el buffer en la ventana actual
  local win = api.nvim_get_current_win()
  api.nvim_win_set_buf(win, buf)
  
  -- Limpiar la ventana (quitar números, líneas, etc.)
  api.nvim_win_set_option(win, 'number', false)
  api.nvim_win_set_option(win, 'relativenumber', false)
  api.nvim_win_set_option(win, 'cursorline', false)
  api.nvim_win_set_option(win, 'cursorcolumn', false)
  api.nvim_win_set_option(win, 'foldcolumn', '0')
  api.nvim_win_set_option(win, 'signcolumn', 'no')
  api.nvim_win_set_option(win, 'list', false)
  
  local lines = {
    "", "", "", "", "", "",
    "          █████  ██████  ████████     ███    ██ ██    ██ ██ ███    ███",
    "         ██   ██ ██   ██    ██        ████   ██ ██    ██ ██ ████  ████",
    "         ███████ ██████     ██        ██ ██  ██ ██    ██ ██ ██ ████ ██",
    "         ██   ██ ██   ██    ██        ██  ██ ██  ██  ██  ██ ██  ██  ██",
    "         ██   ██ ██   ██    ██        ██   ████   ████   ██ ██      ██",
    "",
    "                               VIRTUAL SYSTEM ONLINE",
    "", "", "",
    "                               [ f ] Buscar Archivo",
    "                               [ r ] Archivos Recientes",
    "                               [ b ] Explorador de Archivos",
    "                               [ w ] Buscar Palabra",
    "                               [ q ] Salir",
  }
  
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  api.nvim_buf_set_option(buf, 'modifiable', false)

  -- ==========================================
  -- INYECCIÓN DE COLORES NEÓN (HIGHLIGHTS)
  -- ==========================================
  local ns_id = api.nvim_create_namespace('ArtDashboardColors')
  
  -- Definir colores cyberpunk
  api.nvim_set_hl(0, 'ArtLogo', { fg = '#00f0ff', bold = true })       -- Cyan Neón
  api.nvim_set_hl(0, 'ArtSubtitle', { fg = '#ff003c', italic = true }) -- Rosa/Rojo Neón
  api.nvim_set_hl(0, 'ArtKey', { fg = '#fcee0a', bold = true })        -- Amarillo brillante
  api.nvim_set_hl(0, 'ArtText', { fg = '#00ffcc' })                    -- Verde agua suave

  -- Pintar el logo (líneas 6 a 10)
  for i = 6, 10 do
    api.nvim_buf_add_highlight(buf, ns_id, 'ArtLogo', i, 0, -1)
  end
  
  -- Pintar el subtitulo (línea 12)
  api.nvim_buf_add_highlight(buf, ns_id, 'ArtSubtitle', 12, 0, -1)
  
  -- Pintar los botones (líneas 15 a 19)
  for i = 15, 19 do
    -- Toda la línea en texto verde agua
    api.nvim_buf_add_highlight(buf, ns_id, 'ArtText', i, 0, -1)
    
    -- Pero resaltamos la tecla (el corchete y la letra)
    -- Encontramos la posición de '[' y ']' para pintar lo de en medio
    local line_str = lines[i+1]
    local start_idx = string.find(line_str, "%[")
    local end_idx = string.find(line_str, "%]")
    if start_idx and end_idx then
      api.nvim_buf_add_highlight(buf, ns_id, 'ArtKey', i, start_idx - 1, end_idx)
    end
  end

  -- Mapeo de teclas: Al presionar la letra, ejecuta el comando al instante
  local function map(key, cmd)
    api.nvim_buf_set_keymap(buf, 'n', key, cmd, { noremap = true, silent = true })
  end

  map('f', '<cmd>Telescope find_files<CR>')
  map('r', '<cmd>Telescope oldfiles<CR>')
  map('b', '<cmd>Telescope file_browser<CR>')
  map('w', '<cmd>Telescope live_grep<CR>')
  map('q', '<cmd>qa<CR>')
end

return M
