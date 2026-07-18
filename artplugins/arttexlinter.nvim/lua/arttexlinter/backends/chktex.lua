local M = {}
local config = require("arttexlinter.config")

local namespace = vim.api.nvim_create_namespace("arttexlinter_chktex")

function M.lint(bufnr, filepath)
  if not vim.fn.executable("chktex") then
    vim.notify_once("ArtTex Linter: chktex no está instalado en el sistema.", vim.log.levels.WARN)
    return
  end

  local args = vim.deepcopy(config.options.chktex_args)
  -- Formato especial para facilitar el parseo: "linea:columna:tipo:mensaje"
  -- chktex format syntax: %l=line, %c=col, %k=type(w/e), %m=message
  table.insert(args, "-f")
  table.insert(args, "%l:%c:%k:%m\n")
  table.insert(args, filepath)

  local stdout = vim.uv.new_pipe(false)
  local stderr = vim.uv.new_pipe(false)
  
  local output = ""
  
  local handle, pid
  handle, pid = vim.uv.spawn("chktex", {
    args = args,
    stdio = { nil, stdout, stderr }
  }, function(code, signal)
    stdout:read_stop()
    stdout:close()
    stderr:read_stop()
    stderr:close()
    handle:close()

    if code ~= 0 and code ~= 1 then
      -- chktex returns 1 if warnings are found, which is normal. Other codes might be errors.
      return
    end

    -- Procesar asincrónicamente usando vim.schedule
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then return end
      
      local diagnostics = {}
      for line in output:gmatch("[^\r\n]+") do
        local lnum, col, type, msg = line:match("^(%d+):(%d+):(%a):(.+)$")
        if lnum and col and type and msg then
          local severity = vim.diagnostic.severity.WARNING
          if type:lower() == "e" then
            severity = vim.diagnostic.severity.ERROR
          elseif type:lower() == "i" then
            severity = vim.diagnostic.severity.INFO
          end
          
          table.insert(diagnostics, {
            lnum = tonumber(lnum) - 1, -- 0-indexed
            col = tonumber(col) - 1,
            message = vim.trim(msg),
            severity = severity,
            source = "chktex"
          })
        end
      end
      
      if not config.options.enabled then
        return
      end
      vim.diagnostic.set(namespace, bufnr, diagnostics)
    end)
  end)

  -- Leer salida estándar
  vim.uv.read_start(stdout, function(err, data)
    assert(not err, err)
    if data then
      output = output .. data
    end
  end)
end

function M.clear(bufnr)
  vim.diagnostic.set(namespace, bufnr, {})
end

return M
