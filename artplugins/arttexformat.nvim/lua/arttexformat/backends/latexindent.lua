local M = {}
local config = require("arttexformat.config")

function M.format(bufnr, is_manual)
  if not vim.fn.executable("latexindent") then
    vim.notify("ArtTex Format: latexindent no está instalado en el sistema.", vim.log.levels.ERROR)
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local content = table.concat(lines, "\n")
  local changedtick_before = vim.api.nvim_buf_get_changedtick(bufnr)
  if is_manual then vim.notify("ArtTex: Iniciando latexindent...", vim.log.levels.INFO) end

  -- Construcción dinámica de argumentos
  local args = {}
  local config_dir = config.options.latexindent_config_dir
  if config_dir and config_dir ~= "" then
    if config_dir:match("%.yaml$") then
      table.insert(args, "-l=" .. config_dir)
    else
      table.insert(args, "-l=" .. config_dir .. "/setting_latexindent.yaml")
    end
  end
  
  -- Integración con arttexworkspace: Ignorar entornos verbatim personalizados
  local verbatim_args = ""
  pcall(function()
    local ok, workspace_config = pcall(require, "arttexworkspace.core.config")
    if ok and workspace_config and workspace_config.options.verbatim_envs then
      local envs = workspace_config.options.verbatim_envs
      if #envs > 0 then
        local yaml_path = vim.fn.stdpath("cache") .. "/arttex_verbatim.yaml"
        local f = io.open(yaml_path, "w")
        if f then
          f:write("verbatimEnvironments:\n")
          for _, env in ipairs(envs) do
            f:write("  " .. env .. ": 1\n")
          end
          f:close()
          -- latexindent soporta múltiples archivos locales separados por comas
          if #args > 0 and args[#args]:match("^-l=") then
            args[#args] = args[#args] .. "," .. yaml_path
          else
            table.insert(args, "-l=" .. yaml_path)
          end
        end
      end
    end
  end)
  
  -- INDICADOR VITAL: '-' le dice a latexindent que lea desde STDIN
  table.insert(args, "-")

  local full_args = { "latexindent" }
  for _, a in ipairs(args) do table.insert(full_args, a) end
  
  vim.system(full_args, {
    stdin = content,
    text = true,
  }, function(obj)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(bufnr) then
        if is_manual then vim.notify("ArtTex: Buffer ya no es válido.", vim.log.levels.WARN) end
        return
      end
      
      if obj.code ~= 0 then
        if is_manual then
          vim.notify("ArtTex Format falló:\n" .. (obj.stderr or "Error desconocido"), vim.log.levels.ERROR)
        end
        return
      end

      -- Verificar si el usuario ha modificado el buffer mientras se formateaba
      local current_tick = vim.api.nvim_buf_get_changedtick(bufnr)
      if current_tick ~= changedtick_before then
        if is_manual then
          vim.notify("Formateo abortado: El archivo fue modificado durante el proceso.", vim.log.levels.WARN)
        end
        return
      end

      -- Procesar salida y reemplazar líneas conservando el cursor
      local result_str = obj.stdout or ""
      if result_str == "" then
        if is_manual then vim.notify("ArtTex: stdout devuelto por latexindent está vacío.", vim.log.levels.WARN) end
        return
      end
      
      local result_lines = vim.split(result_str, "\n")
      
      -- Eliminar línea vacía final si la hay por split
      if #result_lines > 0 and result_lines[#result_lines] == "" then
        table.remove(result_lines)
      end

      local winid = vim.fn.bufwinid(bufnr)
      local cursor = nil
      if winid ~= -1 then
        cursor = vim.api.nvim_win_get_cursor(winid)
      end

      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, result_lines)
      
      -- Restaurar cursor de forma segura
      if winid ~= -1 and cursor then
        local max_lines = vim.api.nvim_buf_line_count(bufnr)
        if cursor[1] > max_lines then cursor[1] = max_lines end
        pcall(vim.api.nvim_win_set_cursor, winid, cursor)
      end

      if is_manual then
        vim.notify("Archivo formateado correctamente.", vim.log.levels.INFO)
      else
        -- Es un auto-formato al guardar. Guardamos silenciosamente en disco
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("noautocmd silent! write")
        end)
      end
    end)
  end)
end

return M
