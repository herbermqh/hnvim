local M = {}

M.setup = function(opts)
  opts = opts or {}
  M.hl_group = opts.hl_group or "PillHighlighterSelect"
  M.bg_color = opts.bg_color or "#292e42"
  M.fg_color = opts.fg_color or "NONE"
  M.hide_cursor = opts.hide_cursor == nil and true or opts.hide_cursor
  M.rounded = opts.rounded or false
  M.blend = opts.blend or 0

  -- Definir colores globales para el plugin
  vim.api.nvim_set_hl(0, M.hl_group, { bg = M.bg_color, fg = M.fg_color, bold = true, blend = M.blend, default = false })
  
  if M.rounded then
    vim.api.nvim_set_hl(0, M.hl_group .. "Rounded", { fg = M.bg_color, bg = "NONE", blend = M.blend, default = false })
  end
  
  if M.hide_cursor then
    vim.api.nvim_set_hl(0, "PillHiddenCursor", { blend = 100, nocombine = true, default = false })
  end
end

-- API pública para adjuntar el efecto de píldora a cualquier buffer actual
M.attach = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ns = vim.api.nvim_create_namespace("pill_highlighter_" .. bufnr)
  
  -- Desactivar el cursorline nativo para que no interfiera
  vim.wo.cursorline = false

  -- Ocultar el cursor rosado de hardware si se configuró así
  if M.hide_cursor then
    local current_gui = vim.opt.guicursor:get()
    if type(current_gui) == "table" and current_gui[1] ~= "n-v-c:ver1-PillHiddenCursor" then
      vim.b[bufnr].old_guicursor = current_gui
      vim.opt.guicursor = "n-v-c:ver1-PillHiddenCursor"
    end
  end

  -- Dibujar el extmark dinámicamente cuando el cursor se mueve
  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = bufnr,
    callback = function()
      -- vim.schedule garantiza que se dibuje DESPUÉS de que los otros plugins hagan sus cambios
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(bufnr) then return end
        
        vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local line_text = vim.api.nvim_buf_get_lines(bufnr, line, line + 1, false)[1]
        
        if line_text and line_text:match("%S") then
          local start_col = line_text:find("%S") - 1
          local end_col = string.len(line_text) - string.len(line_text:match("%s*$"))
          
          -- Fondo de la píldora
          pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, start_col, {
            end_col = end_col,
            hl_group = M.hl_group,
            priority = 100,
          })
          
          -- Extremos redondeados
          if M.rounded then
            -- Borde izquierdo 
            if start_col > 0 then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, start_col - 1, {
                virt_text = {{"", M.hl_group .. "Rounded"}},
                virt_text_pos = "overlay",
                priority = 101,
              })
            else
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, 0, {
                virt_text = {{"", M.hl_group .. "Rounded"}},
                virt_text_pos = "inline",
                priority = 101,
              })
            end
            
            -- Borde derecho 
            if end_col < string.len(line_text) then
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, end_col, {
                virt_text = {{"", M.hl_group .. "Rounded"}},
                virt_text_pos = "overlay",
                priority = 101,
              })
            else
              pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, line, end_col, {
                virt_text = {{"", M.hl_group .. "Rounded"}},
                virt_text_pos = "eol",
                priority = 101,
              })
            end
          end
        end
      end)
    end,
  })
  
  -- Restaurar el cursor normal al salir del buffer
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = bufnr,
    callback = function()
      if vim.b[bufnr].old_guicursor then
        vim.opt.guicursor = vim.b[bufnr].old_guicursor
      else
        vim.cmd("set guicursor&")
      end
      pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns, 0, -1)
    end,
  })
  
  -- Volver a ocultar el cursor si se regresa al buffer
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = bufnr,
    callback = function()
      if M.hide_cursor then
        local gui = vim.opt.guicursor:get()
        if type(gui) == "table" and gui[1] ~= "n-v-c:ver1-PillHiddenCursor" then
          vim.b[bufnr].old_guicursor = gui
          vim.opt.guicursor = "n-v-c:ver1-PillHiddenCursor"
        end
      end
    end,
  })
end

return M
