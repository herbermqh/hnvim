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
  
  local f_in = io.open(reg_file, "r")
  if f_in then
    local content = f_in:read("*all")
    f_in:close()
    local ok, decoded = pcall(vim.json.decode, content)
    if ok and type(decoded) == "table" then
      registry = decoded
    end
  end

  registry[root_file] = server_addr
  
  local f_out = io.open(reg_file, "w")
  if f_out then
    f_out:write(vim.json.encode(registry))
    f_out:close()
  end
  log.debug("Proyecto registrado en " .. vim.fn.fnamemodify(reg_file, ":t") .. " -> " .. server_addr)

  -- Limpiar el registro al salir de Neovim
  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      local f_in_clean = io.open(reg_file, "r")
      if f_in_clean then
        local content = f_in_clean:read("*all")
        f_in_clean:close()
        local ok, decoded = pcall(vim.json.decode, content)
        if ok and type(decoded) == "table" then
          decoded[root_file] = nil
          local f_out_clean = io.open(reg_file, "w")
          if f_out_clean then
            f_out_clean:write(vim.json.encode(decoded))
            f_out_clean:close()
          end
        end
      end
    end
  })
end

function M.handle_inverse_search(file, line)
  -- 1. Si es un archivo generado por minted/pyg, buscamos su origen asíncronamente
  if file:match("_minted") or file:match("%.pyg$") or file:match("%.minted$") then
    log.info("Inverse search apuntó a archivo temporal verbatim: " .. file)
    
    local f = io.open(file, "r")
    if f then
      local first_line = nil
      for l in f:lines() do
        if l:match("%S") then -- primera línea no vacía
          first_line = l
          break
        end
      end
      f:close()
      
      if first_line then
        local bufnr = vim.api.nvim_get_current_buf()
        local root_dir = workspace.api.get_root_dir(bufnr) or vim.fn.getcwd()
        
        -- Ejecutar rg para buscar esa línea exacta en archivos tex del proyecto
        vim.system({"rg", "-F", "-n", "--type", "tex", "--", first_line, root_dir}, { text = true }, function(obj)
          if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
            local result = vim.split(obj.stdout, "\n")[1]
            local matched_file, matched_line = result:match("^(.-):(%d+):")
            
            if matched_file and matched_line then
              vim.schedule(function()
                vim.cmd("drop " .. vim.fn.fnameescape(matched_file))
                pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(matched_line), 0 })
                vim.cmd("normal! zz")
                log.info("Búsqueda inversa de verbatim resuelta: " .. matched_file .. ":" .. matched_line)
              end)
              return
            end
          end
          
          vim.schedule(function()
            log.warn("No se pudo mapear el código verbatim al archivo original.")
            vim.notify("ArtTeX: Búsqueda inversa incompleta (origen verbatim no encontrado)", vim.log.levels.WARN)
          end)
        end)
        return
      end
    end
    
    log.warn("Archivo temporal verbatim ilegible o vacío.")
    vim.notify("ArtTeX: Búsqueda inversa ignorada (archivo temporal inválido)", vim.log.levels.WARN)
    return
  end
  
  -- 2. Archivos normales, realizar salto directo
  local stat = vim.uv.fs_stat(file)
  if not stat then
    log.error("Búsqueda inversa falló: archivo no encontrado " .. file)
    return
  end
  
  vim.schedule(function()
    vim.cmd("drop " .. vim.fn.fnameescape(file))
    pcall(vim.api.nvim_win_set_cursor, 0, { tonumber(line), 0 })
    vim.cmd("normal! zz")
  end)
end

return M
