-- Configuraciones de Auto-comandos Globales

-- Forzar el cierre de todos los procesos en terminales al salir de Neovim
-- Esto evita procesos huérfanos (como compilaciones de LaTeX) que consuman CPU en el fondo
vim.api.nvim_create_autocmd("VimLeavePre", {
  pattern = "*",
  callback = function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" then
        local job_id = vim.b[buf].terminal_job_id
        if job_id then
          -- Ignorar errores si el proceso ya murió
          pcall(vim.fn.jobstop, job_id)
        end
      end
    end
  end,
})
