local M = {}

M.config_file = vim.fn.stdpath("config") .. "/arttexformat_config.json"

M.options = {
  auto_format_on_save = false,
  latexindent_config_dir = vim.fn.stdpath("config") .. "/artplugins/arttexformat.nvim",
  use_realtime_indent = true, -- Manejo automático de sangría al escribir
  backend = "latexindent"
}

function M.load_json()
  local f = io.open(M.config_file, "r")
  if f then
    local content = f:read("*all")
    f:close()
    local ok, json = pcall(vim.fn.json_decode, content)
    if ok and type(json) == "table" then return json end
  end
  return nil
end

function M.save_json(opts)
  local f = io.open(M.config_file, "w")
  if f then
    f:write(vim.fn.json_encode(opts))
    f:close()
  end
end

function M.setup(opts)
  local saved_opts = M.load_json()
  if saved_opts then
    for k, v in pairs(saved_opts) do M.options[k] = v end
  end
  if opts then
    for k, v in pairs(opts) do M.options[k] = v end
  end
end

return M
