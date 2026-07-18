local M = {}

M.log_file = vim.fn.stdpath("cache") .. "/arttexconceal.log"
M.level = "error" -- Nivel por defecto, puede ser 'debug', 'info', 'warn', 'error'

local levels = {
    debug = 1,
    info = 2,
    warn = 3,
    error = 4
}

--- Escribe un mensaje en el archivo de logs
---@param msg string El mensaje a registrar
---@param level string|nil Nivel del mensaje ('debug', 'info', 'warn', 'error')
local notified_msgs = {}

function M.log(msg, level)
    level = level or "info"
    if levels[level] < levels[M.level] then return end
    
    local f = io.open(M.log_file, "a")
    if f then
        local time = os.date("%Y-%m-%d %H:%M:%S")
        f:write(string.format("[%s] [%s] %s\n", time, string.upper(level), msg))
        f:close()
    end
    
    -- Noice.nvim integration (debounced to avoid spamming the UI during rapid redraws)
    -- Remover números de línea para deduplicar el error subyacente independientemente de la línea
    local dedup_key = string.gsub(msg, "on line %d+:", "on line X:")
    if not notified_msgs[dedup_key] then
        notified_msgs[dedup_key] = true
        vim.schedule(function()
            local log_level = vim.log.levels.INFO
            if level == "error" then log_level = vim.log.levels.ERROR
            elseif level == "warn" then log_level = vim.log.levels.WARN
            elseif level == "debug" then log_level = vim.log.levels.DEBUG end
            
            -- Usa pcall por seguridad, en caso de que notify no esté listo
            pcall(vim.notify, "[ArtTexConceal] " .. msg, log_level)
        end)
    end
end

--- Registra un error
---@param msg string
function M.error(msg)
    M.log(msg, "error")
end

--- Registra información de depuración
---@param msg string
function M.debug(msg)
    M.log(msg, "debug")
end

--- Limpia el archivo de logs actual
function M.clear()
    local f = io.open(M.log_file, "w")
    if f then
        f:write("")
        f:close()
    end
end


return M
