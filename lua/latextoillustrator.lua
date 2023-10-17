--Es archivo plugin crear una ventana flotante para editar el archivo latex que al guardar se ejecuta un script que exporta la figura y luego integra en adobe illustrator

-- Variables
local buf, win
local filetex = "/home/userh/Documents/texout2illustrator/main.tex"

-- Función para configurar las opciones del buffer
local function set_buffer_options()
    if not buf then
        buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_name(buf, filetex)
        vim.api.nvim_buf_set_option(buf, "buftype", "")
        vim.api.nvim_buf_set_option(buf, "filetype", "tex")
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
        vim.api.nvim_buf_set_option(buf, "modifiable", true)
        vim.api.nvim_buf_set_option(buf, "buflisted", false)
    end
end

-- Función para configurar las opciones de la ventana
local function set_window_options()
    local width, height = vim.api.nvim_get_option("columns"), vim.api.nvim_get_option("lines")
    local win_height, win_width = math.ceil(height * 0.8 - 4), math.ceil(width * 0.8)
    local row, col = math.ceil((height - win_height) / 2 - 1), math.ceil((width - win_width) / 2)


    -- Crear buffer para el título
    -- title_buf = vim.api.nvim_create_buf(false, true)
    -- vim.api.nvim_buf_set_lines(title_buf, 0, -1, false, {"TeX to Illustrator"})

    -- Opciones para la ventana del título
    -- local title_opts = {
    --     style = "minimal",
    --     relative = "editor",
    --     width = win_width,
    --     height = 1, -- Altura de la ventana del título
    --     row = row - 1, -- Posición ajustada para que esté encima de la ventana principal
    --     col = col,
    --     border = "none"
    -- }

    -- title_win = vim.api.nvim_open_win(title_buf, true, title_opts)


    -- Opciones para la ventana principal
    local opts = {
        style = "minimal",
        relative = "editor",
        width = win_width,
        height = win_height,
        row = row,
        col = col,
        border = "rounded",
    }

    win = vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_win_set_option(win, "cursorline", true)
end


-- Función para cerrar la ventana y eliminar el buffer
_G.close_and_delete = function()
    if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
        buf = nil
    end
end

-- Función para abrir la ventana
local function open_win()
    set_buffer_options()
    set_window_options()

  -- Mapeo para cerrar la ventana y eliminar el buffer con la tecla 'q'
    vim.api.nvim_buf_set_keymap(buf, 'n', 'q', ':lua _G.close_and_delete()<CR>', { noremap = true, silent = true })
end

-- Función para ocultar la ventana
local function hide_window()
    if win then
        vim.api.nvim_win_close(win, true)
        win = nil
    end
end

-- Función para mostrar la ventana
local function show_window()
    if buf then
        set_window_options()
    end
end

-- Función principal para editar el archivo
function edit_file()
    open_win()
    vim.api.nvim_command("edit " .. filetex)
end


function toggle_file()
    if buf and vim.api.nvim_buf_is_valid(buf) then
        -- Verificar si la ventana asociada con el buffer todavía está abierta
        local win_exists = false
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
            if vim.api.nvim_win_get_buf(win_id) == buf then
                win_exists = true
                break
            end
        end

        if win_exists then
            hide_window()
        else
            show_window()
        end
    else
        edit_file()
    end
end


_G.toggle_file_tex_illustrator = toggle_file
vim.cmd("command! ToggleFileTexIllustrator lua _G.toggle_file_tex_illustrator()")

vim.cmd([[
  augroup Tex2Illustrator
      autocmd!
      autocmd BufWritePost /home/userh/Documents/texout2illustrator/main.tex silent! !/home/userh/Documents/texout2illustrator/tex2illustrator.sh
  augroup END
]])

vim.cmd([[nnoremap <F4> :ToggleFileTexIllustrator<CR>]])


