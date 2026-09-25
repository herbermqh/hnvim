local ui = require("resourcemon.ui")

local M = {}

function M.setup(opts)
  vim.api.nvim_create_user_command("MonitorRecursos", function()
    ui.open()
  end, { desc = "Abre una ventana para monitorear el consumo de recursos de Neovim y sus procesos hijos" })
end

return M
