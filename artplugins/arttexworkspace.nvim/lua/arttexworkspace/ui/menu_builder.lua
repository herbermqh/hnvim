local log = require("arttexworkspace.core.log")
local M = {}

-- Estado para no reiniciar highlights múltiples veces
local initialized = false
local function setup_hls()
  if initialized then return end
  -- Colores de TokyoNight (Modo Brillante/Resaltante)
  vim.api.nvim_set_hl(0, 'ArtPromptTitle', { fg = '#7dcfff', bold = true }) 
  vim.api.nvim_set_hl(0, 'ArtPromptNormal', { fg = '#c0caf5' }) 
  initialized = true
end

-- ==========================================
-- API PÚBLICA: GENERADOR DE MENÚS (CORE)
-- ==========================================
-- Genera un dashboard interactivo unificado para cualquier plugin de ArtTeX.
function M.create_menu(opts)
  setup_hls()
  
  local title = opts.title or "ArtTeX Menu"
  local prompt_lines = type(opts.prompt) == "table" and opts.prompt or { opts.prompt }
  local options = opts.options or {}
  
  -- 1. Calcular el ancho máximo dinámicamente
  local max_width = 38 -- Ancho mínimo
  for _, p in ipairs(prompt_lines) do
    local w = vim.fn.strdisplaywidth("    " .. p)
    if w > max_width then max_width = w end
  end
  for _, opt in ipairs(options) do
    local w = vim.fn.strdisplaywidth("      " .. opt.text)
    if w > max_width then max_width = w end
  end
  
  local width = max_width + 6 -- Padding extra para que respire
  
  -- 2. Construir las líneas dinámicamente
  local lines = { "" }
  for _, p in ipairs(prompt_lines) do
    table.insert(lines, "    " .. p)
  end
  table.insert(lines, "")
  
  local option_start_idx = #lines + 1
  for _, opt in ipairs(options) do
    -- Agregar padding dinámico para asegurar que el pill-highlighter ponga bordes correctamente
    local text = "      " .. opt.text
    while vim.fn.strdisplaywidth(text) < (width - 4) do
      text = text .. " "
    end
    table.insert(lines, text)
  end
  table.insert(lines, "")

  -- 2. Crear Buffer
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "arttex_dashboard"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  
  -- 3. Inyectar Highlights estáticos
  for i = 1, #prompt_lines do
    vim.api.nvim_buf_add_highlight(buf, -1, "ArtPromptTitle", i, 0, -1)
  end
  for i = 1, #options do
    vim.api.nvim_buf_add_highlight(buf, -1, "ArtPromptNormal", option_start_idx + i - 2, 0, -1)
  end
  
  vim.bo[buf].modifiable = false
  
  -- 4. Crear Ventana Flotante Centrada (Dimensiones Dinámicas)
  local height = #lines
  local ui = vim.api.nvim_list_uis()[1] or { width = 80, height = 24 }
  
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    anchor = "NW",
    style = "minimal",
    border = "rounded",
    title = " 󰙅 " .. title .. " ",
    title_pos = "center"
  }
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].winblend = 0 -- 0 opacidad para igualar los fondos del pill-highlighter
  
  -- Sincronizar el fondo de la ventana flotante con el fondo del editor
  -- Esto hace que las esquinas cuadradas del terminal se vuelvan invisibles y
  -- el borde redondeado ("╭", "╮") luzca como una curva perfecta y limpia.
  -- Además, pintamos el borde con el Cyan brillante de TokyoNight.
  vim.wo[win].winhl = "Normal:Normal,FloatBorder:ArtPromptTitle"
  
  -- 5. Conexión con tu plugin maestro `pill-highlighter`
  local pill_ok, pill = pcall(require, "pill-highlighter")
  if pill_ok then
    pill.setup({
      hl_group = "ArtTexPillSelected",
      bg_color = "#2e3c64", -- TokyoNight Visual Selection
      fg_color = "#7aa2f7", -- TokyoNight Blue
      hide_cursor = true,
      rounded = true
    })
    -- Posicionar el cursor sobre la primera opción antes de adjuntar el plugin
    vim.api.nvim_win_set_cursor(win, {option_start_idx, 6})
    pill.attach()
  else
    vim.api.nvim_win_set_cursor(win, {option_start_idx, 6})
  end
  
  -- 6. Sistema de Navegación Universal
  local function get_current_idx()
    local r = vim.api.nvim_win_get_cursor(win)[1]
    local idx = r - option_start_idx + 1
    if idx < 1 then return 1 end
    if idx > #options then return #options end
    return idx
  end
  
  local function close_and_call()
    local idx = get_current_idx()
    vim.api.nvim_win_close(win, true)
    if options[idx] and options[idx].action then
      options[idx].action()
    end
  end
  
  local function move_down()
    local r = vim.api.nvim_win_get_cursor(win)[1]
    if r < option_start_idx then
      vim.api.nvim_win_set_cursor(win, {option_start_idx, 6})
    elseif r < option_start_idx + #options - 1 then 
      vim.api.nvim_win_set_cursor(win, {r + 1, 6}) 
    end
  end
  
  local function move_up()
    local r = vim.api.nvim_win_get_cursor(win)[1]
    if r > option_start_idx then 
      vim.api.nvim_win_set_cursor(win, {r - 1, 6}) 
    else
      vim.api.nvim_win_set_cursor(win, {option_start_idx, 6})
    end
  end
  
  -- Mapeos
  vim.keymap.set("n", "j", move_down, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Down>", move_down, { buffer = buf, nowait = true })
  vim.keymap.set("n", "k", move_up, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Up>", move_up, { buffer = buf, nowait = true })
  
  vim.keymap.set("n", "<CR>", close_and_call, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<kEnter>", close_and_call, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<2-LeftMouse>", close_and_call, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<LeftRelease>", function()
    -- Click simple solo mueve el cursor y lo fuerza a estar en las opciones
    local r = vim.api.nvim_win_get_cursor(win)[1]
    if r < option_start_idx then vim.api.nvim_win_set_cursor(win, {option_start_idx, 6}) end
    if r > option_start_idx + #options - 1 then vim.api.nvim_win_set_cursor(win, {option_start_idx + #options - 1, 6}) end
  end, { buffer = buf, nowait = true })
  
  vim.keymap.set("n", "q", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, nowait = true })
  vim.keymap.set("n", "<Esc>", function() vim.api.nvim_win_close(win, true) end, { buffer = buf, nowait = true })
end

-- ==========================================
-- API PÚBLICA: GENERADOR DE INPUTS FLOTANTES
-- ==========================================
-- Genera una ventana de texto para reemplazar vim.ui.input y mantener la estética
function M.create_input(opts, on_submit)
  setup_hls()
  local title = opts.title or "ArtTeX Input"
  local prompt_text = opts.prompt or "Ingresa valor:"
  local default_text = opts.default or ""
  
  local max_width = math.max(vim.fn.strdisplaywidth(prompt_text), 45)
  local width = max_width + 4
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].filetype = "arttex_input"
  
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt_text, default_text })
  vim.api.nvim_buf_add_highlight(buf, -1, "ArtPromptTitle", 0, 0, -1)
  
  local ui = vim.api.nvim_list_uis()[1]
  local height = 2
  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = (ui.width / 2) - (width / 2),
    row = (ui.height / 2) - (height / 2),
    anchor = "NW",
    style = "minimal",
    border = "rounded",
    title = " 󰙅 " .. title .. " ",
    title_pos = "center"
  }
  
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.wo[win].winblend = 0
  vim.wo[win].winhl = "Normal:Normal,FloatBorder:ArtPromptTitle"
  
  vim.api.nvim_win_set_cursor(win, {2, string.len(default_text)})
  vim.cmd("startinsert!")
  
  local function submit()
    local lines = vim.api.nvim_buf_get_lines(buf, 1, 2, false)
    local result = lines[1] or ""
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    on_submit(result)
  end
  
  local function cancel()
    vim.cmd("stopinsert")
    vim.api.nvim_win_close(win, true)
    on_submit(nil)
  end
  
  vim.keymap.set("i", "<CR>", submit, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<CR>", submit, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("i", "<Esc>", cancel, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "<Esc>", cancel, { buffer = buf, noremap = true, silent = true })
  vim.keymap.set("n", "q", cancel, { buffer = buf, noremap = true, silent = true })
end

-- ==========================================
-- WRAPPERS ESPECÍFICOS DE NEGOCIO
-- ==========================================

function M.select_main_tex(current_filepath)
  local has_telescope, telescope = pcall(require, "telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  if has_telescope then
    telescope.find_files({
      prompt_title = " 󰙅 Selecciona tu main.tex para anclar TexLab ",
      find_command = { "rg", "--files", "--glob", "*.tex" },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            local absolute_path = vim.fn.fnamemodify(selection.path or selection[1], ":p")
            M.create_texlabroot(absolute_path, current_filepath)
          end
        end)
        return true
      end,
    })
  else
    M.create_input({
      title = "Buscar Root Manual",
      prompt = 'Ruta hacia tu archivo principal (main.tex):',
      default = vim.fn.expand('%:p:h') .. '/'
    }, function(input)
      if input and input ~= "" then
        M.create_texlabroot(input, current_filepath)
      end
    end)
  end
end

function M.create_texlabroot(filepath, current_filepath)
  local target_dir = vim.fn.fnamemodify(filepath, ":p:h")
  local root_marker = target_dir .. "/.texlabroot"
  
  -- Anclar TexLab y Memoria Fotográfica para ArtTeX (Todo en un solo archivo)
  local f = io.open(root_marker, "w")
  if f then
    f:write(filepath .. "\n")
    f:close()
    
    -- Si el usuario seleccionó esto manualmente, inyectar el archivo actual en el Grafo (Aprendizaje forzado)
    if current_filepath then
      local basename = vim.fn.fnamemodify(filepath, ":t:r")
      local config_path = target_dir .. "/." .. basename .. ".arttex.json"
      local uv = vim.uv or vim.loop
      local abs_current = uv.fs_realpath(current_filepath) or current_filepath
      
      if vim.fn.filereadable(config_path) == 1 then
        local f_in = io.open(config_path, "r")
        if f_in then
          local content = f_in:read("*all")
          f_in:close()
          local ok, parsed = pcall(vim.fn.json_decode, content)
          if ok and type(parsed) == "table" then
            parsed.project_tree = parsed.project_tree or {}
            local exists = false
            for _, dep in ipairs(parsed.project_tree) do
              if (uv.fs_realpath(dep) or dep) == abs_current then exists = true break end
            end
            if not exists then
              table.insert(parsed.project_tree, abs_current)
              local f_out = io.open(config_path, "w")
              if f_out then
                f_out:write(require("arttexworkspace.core.json").encode(parsed))
                f_out:close()
              end
            end
          end
        end
      end
    end

    local ok, err = pcall(vim.cmd, "edit!")
    if ok then
      vim.notify("ArtTeX: Conectado con main de forma permanente", vim.log.levels.INFO)
    else
      vim.notify("ArtTeX: Falló al recargar el buffer. " .. tostring(err), vim.log.levels.WARN)
    end
  else
    vim.notify("ArtTeX: Falló al crear el archivo .texlabroot en " .. target_dir, vim.log.levels.ERROR)
  end
end

return M
