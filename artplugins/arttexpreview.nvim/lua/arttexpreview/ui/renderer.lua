--- Módulo de Renderizado en Ventana Flotante (Esquina Superior Derecha)
--- @class arttexpreview.renderer
local M = {}

local active_win = nil
local active_buf = nil
local active_image = nil

--- Cierra y limpia la previsualización actual
function M.clear_preview()
  if active_image then
    pcall(function() active_image:clear() end)
    active_image = nil
  end
  if active_win and vim.api.nvim_win_is_valid(active_win) then
    vim.api.nvim_win_close(active_win, true)
  end
  if active_buf and vim.api.nvim_buf_is_valid(active_buf) then
    vim.api.nvim_buf_delete(active_buf, { force = true })
  end
  active_win = nil
  active_buf = nil
end

--- Crea o reutiliza la ventana en la esquina superior derecha
local function setup_window(width, height, title)
  M.clear_preview()
  
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  
  -- Calcular posición superior derecha
  local columns = vim.o.columns
  local col_pos = columns - width - 2
  local row_pos = 1
  
  local win_opts = {
    relative = "editor",
    row = row_pos,
    col = col_pos,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = title,
    title_pos = "center",
    zindex = 45
  }
  
  local win = vim.api.nvim_open_win(buf, false, win_opts)
  pcall(function()
    vim.wo[win].winhl = "Normal:NormalFloat,FloatBorder:ArtPromptTitle"
    vim.wo[win].winblend = 10 
  end)
  
  active_win = win
  active_buf = buf
  return buf, win
end

--- Renderiza matemáticas usando Nabla en la esquina superior derecha
function M.show_math(math_code)
  local has_nabla, _ = pcall(require, "nabla")
  if not has_nabla then return end
  local parser_ok, parser = pcall(require, "nabla.latex")
  local ascii_ok, ascii = pcall(require, "nabla.ascii")
  if not parser_ok or not ascii_ok then return end
  
  local line = math_code:gsub("\r", ""):gsub("\n", " ")
  line = line:gsub("%$", ""):gsub("\\%[", ""):gsub("\\%]", ""):gsub("^\\%(", ""):gsub("\\%)$", "")
  line = line:gsub("\\begin%{[^}]+%}", ""):gsub("\\end%{[^}]+%}", "")
  line = vim.trim(line)
  
  if line == "" then M.clear_preview(); return end
  
  local drawing = {}
  local max_width = 20
  
  -- Soportar saltos de línea (\\) separando la ecuación
  local parts = vim.split(line, "\\\\", {plain = true})
  
  for _, part in ipairs(parts) do
    local trimmed = vim.trim(part)
    if trimmed ~= "" then
      local success, exp = pcall(parser.parse_all, trimmed)
      if success and exp then
        local succ, g = pcall(ascii.to_ascii, {exp}, 1)
        if succ and g and g ~= "" then
          for row in vim.gsplit(tostring(g), "\n") do
            table.insert(drawing, row)
            max_width = math.max(max_width, vim.fn.strdisplaywidth(row))
          end
        end
      end
    end
  end
  
  if #drawing > 0 then
    local buf, _ = setup_window(max_width + 4, #drawing, " 󰇩 Math Preview ")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, drawing)
  else
    M.clear_preview()
  end
end

--- Renderiza una imagen (Estructura preparada para el futuro)
function M.show_image(image_path)
  -- El usuario implementará la visualización de imágenes en el futuro.
  -- Por ahora, no generamos ninguna ventana gigante para evitar interrumpir la vista.
  
  -- if vim.fn.filereadable(image_path) == 0 then return end
  -- Aquí irá el código futuro para visualizar la imagen (ej: hologram, ueberzug, etc.)
  
  -- Asegurarnos de limpiar ventanas previas matemáticas si existen
  M.clear_preview()
end

return M
