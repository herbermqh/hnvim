--- Archivo principal de ArtTeX Preview (Automático)
local M = {}

local extractor = require("arttexpreview.core.extractor")
local renderer = require("arttexpreview.ui.renderer")
local config = require("arttexpreview.config")
local menu = require("arttexpreview.ui.menu")

local last_rendered_content = nil

--- Intenta previsualizar el contenido bajo el cursor (si está habilitado)
local function try_auto_preview()
  -- Previsualizar Matemáticas
  if config.settings.auto_math then
    local math_code, _, _ = extractor.get_math_at_cursor()
    if math_code and math_code ~= "" then
      if math_code ~= last_rendered_content then
        renderer.show_math(math_code)
        last_rendered_content = math_code
      end
      return -- Si encontró matemáticas, no buscar imágenes
    end
  end
  
  -- Previsualizar Imágenes
  if config.settings.auto_image then
    local image_path = extractor.get_image_at_cursor()
    if image_path and image_path ~= "" then
      if image_path ~= last_rendered_content then
        renderer.show_image(image_path)
        last_rendered_content = image_path
      end
      return
    end
  end
  
  -- Si no estamos sobre nada, limpiar la previsualización si la había
  if last_rendered_content ~= nil then
    renderer.clear_preview()
    last_rendered_content = nil
  end
end

function M.setup(opts)
  opts = opts or {}
  if opts.auto_math ~= nil then config.settings.auto_math = opts.auto_math end
  if opts.auto_image ~= nil then config.settings.auto_image = opts.auto_image end

  -- Crear el comando para abrir el menú de configuración
  vim.api.nvim_create_user_command("ArtTexPreviewConfig", function()
    menu.open_menu()
  end, { desc = "Menú de Configuración de ArtTeX Preview" })
  
  -- Crear un autocomando para rastrear el movimiento del cursor en archivos tex
  local augroup = vim.api.nvim_create_augroup("ArtTexAutoPreview", { clear = true })
  
  -- Usamos un debounce (temporizador) para no saturar la CPU en CursorMoved
  local timer = nil
  vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI"}, {
    group = augroup,
    pattern = "*.tex",
    callback = function()
      local bt = vim.bo.buftype
      if bt == "nofile" or bt == "prompt" or bt == "terminal" then return end
      
      if timer then
        timer:stop()
        if not timer:is_closing() then timer:close() end
      end
      
      timer = vim.loop.new_timer()
      timer:start(50, 0, vim.schedule_wrap(function()
        try_auto_preview()
      end))
    end
  })
end

return M
