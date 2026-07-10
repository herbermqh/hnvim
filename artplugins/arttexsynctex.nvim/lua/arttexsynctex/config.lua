local M = {}

M.defaults = {
  viewer = "sumatrapdf", -- Opciones: "sumatrapdf", "zathura", "sioyek"
  server_port = 0,       -- 0 asigna un puerto TCP aleatorio y seguro
  registry_file = vim.fn.stdpath("cache") .. "/arttex_sockets.json",
}

M.options = vim.deepcopy(M.defaults)

function M.setup(user_opts)
  M.options = vim.tbl_deep_extend("force", M.options, user_opts or {})
end

return M
