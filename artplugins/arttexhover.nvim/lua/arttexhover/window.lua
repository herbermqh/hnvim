local M = {}
local config = require("arttexhover.config")

local active_win = nil
local active_buf = nil

function M.close()
  if active_win and vim.api.nvim_win_is_valid(active_win) then
    vim.api.nvim_win_close(active_win, true)
  end
  active_win = nil
  active_buf = nil
end

-- Renderizado UI ultraligero y nativo (0% Treesitter, 100% Regex C-core)
function M.show(lines, title, filetype)
  M.close()
  if not lines or #lines == 0 then return end

  -- 1. Crear Buffer Ciego (unlisted, scratch)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- 2. Calcular dimensiones exactas para no desperdiciar renderizado
  local max_w = config.options.max_width
  local max_h = config.options.max_height
  local width = 0
  for _, line in ipairs(lines) do
    local w = vim.fn.strdisplaywidth(line)
    if w > width then width = w end
  end
  if width > max_w then width = max_w end
  local height = math.min(#lines, max_h)

  -- 3. Crear Ventana Flotante
  local win_opts = {
    relative = "cursor",
    row = 1,
    col = 0,
    width = width + 2,
    height = height,
    style = "minimal",
    border = config.options.border,
    title = title and (" " .. title .. " ") or nil,
    title_pos = "center"
  }
  
  local win = vim.api.nvim_open_win(buf, false, win_opts)
  vim.wo[win].wrap = true
  vim.wo[win].winhl = "Normal:NormalFloat,FloatBorder:FloatBorder"

  -- 4. Optimización de Sintaxis (Bloquear Treesitter, Forzar Legacy Regex)
  -- Lo hacemos DESPUÉS de que la ventana está abierta, para que Neovim aplique el highlight a la ventana.
  vim.api.nvim_win_call(win, function()
    -- Aplicar Filetype
    vim.bo[buf].filetype = filetype or "tex"
    -- Detener cualquier inyección de Treesitter que consuma CPU
    pcall(vim.treesitter.stop, buf)
    -- Encender el motor clásico Regex escrito en C (súper optimizado)
    vim.bo[buf].syntax = filetype or "tex"
  end)

  active_buf = buf
  active_win = win

  -- 5. Auto-Cierre Inteligente
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "InsertEnter", "BufLeave", "WinLeave" }, {
    buffer = vim.api.nvim_get_current_buf(),
    once = true,
    callback = function()
      M.close()
    end
  })
end

return M
