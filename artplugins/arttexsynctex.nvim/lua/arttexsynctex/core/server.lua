local M = {}
local config = require("arttexsynctex.config")
local workspace = require("arttexworkspace")
local log = workspace.log

function M.start_and_register()
  local bufnr = vim.api.nvim_get_current_buf()
  local root_file = workspace.api.get_root_file(bufnr)
  if not root_file then return end

  -- Iniciar servidor TCP si no hay uno activo
  local server_addr = vim.v.servername
  if not server_addr:match(":") then 
    -- Solicita al OS un puerto libre
    server_addr = vim.fn.serverstart("127.0.0.1:" .. config.options.server_port)
    log.info("Servidor de enrutamiento TCP iniciado en " .. server_addr)
  end

  -- Escribir en el registro JSON
  local reg_file = config.options.registry_file
  local registry = {}
  
  if vim.fn.filereadable(reg_file) == 1 then
    local content = table.concat(vim.fn.readfile(reg_file), "\n")
    local ok, decoded = pcall(vim.json.decode, content)
    if ok and type(decoded) == "table" then
      registry = decoded
    end
  end

  registry[root_file] = server_addr
  vim.fn.writefile({ vim.json.encode(registry) }, reg_file)
  log.debug("Proyecto registrado en " .. vim.fn.fnamemodify(reg_file, ":t") .. " -> " .. server_addr)
end

return M
