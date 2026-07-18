local M = {}

local log_file = vim.fn.stdpath("cache") .. "/arttex.log"
local levels = { TRACE = 1, DEBUG = 2, INFO = 3, WARN = 4, ERROR = 5 }

-- Por defecto, registra desde DEBUG en adelante. 
-- El usuario puede cambiarlo luego en la configuración.
M.current_level = levels.DEBUG

local function write_log(level_name, msg)
  if levels[level_name] < M.current_level then return end
  local f = io.open(log_file, "a")
  if f then
    local time = os.date("%Y-%m-%d %H:%M:%S")
    f:write(string.format("[%s] [%s] %s\n", time, level_name, msg))
    f:close()
  end
end

function M.trace(msg) write_log("TRACE", msg) end
function M.debug(msg) write_log("DEBUG", msg) end
function M.info(msg)  write_log("INFO",  msg) end
function M.warn(msg)  
  write_log("WARN",  msg) 
end
function M.error(msg) 
  write_log("ERROR", msg) 
end

function M.notify(msg, level, opts)
  if type(msg) ~= "string" then msg = vim.inspect(msg) end
  level = level or vim.log.levels.INFO
  opts = opts or {}
  if opts.timeout == nil then opts.timeout = 8000 end -- 8 segundos de duración por defecto
  vim.schedule(function()
    local id = vim.notify(msg, level, opts)
    if opts.on_id then opts.on_id(id) end
  end)
end

-- Comando útil para limpiar el log si crece mucho
vim.api.nvim_create_user_command("ArtTexClearLog", function()
  local f = io.open(log_file, "w")
  if f then f:close() end
  vim.notify("ArtTeX: Log limpiado", vim.log.levels.INFO)
end, {})

return M
