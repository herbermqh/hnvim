local M = {}

-- Caché para el nombre de la distro (se obtiene solo una vez)
local wsl_distro = os.getenv("WSL_DISTRO_NAME")

function M.to_windows(path)
  if vim.fn.has("wsl") == 1 then
    if wsl_distro then
      -- Fast-Path 1: Rutas nativas de Linux (/home/user/...)
      if path:sub(1, 1) == "/" and not path:match("^/mnt/%a/") then
        return "\\\\wsl.localhost\\" .. wsl_distro .. path:gsub("/", "\\")
      end
      -- Fast-Path 2: Rutas montadas de Windows (/mnt/c/...)
      local drive, rest = path:match("^/mnt/(%a)/(.*)")
      if drive and rest then
        return drive:upper() .. ":\\" .. rest:gsub("/", "\\")
      end
    end
    -- Fallback si falla
    local wsl_path = vim.fn.system({"wslpath", "-w", path})
    return wsl_path:gsub("[\n\r]", "")
  end
  return path
end

function M.to_unix(path)
  if vim.fn.has("wsl") == 1 and path:match("^[A-Z]:\\") then
    if wsl_distro then
      -- Fast-Path para rutas de Windows (C:\...)
      local drive, rest = path:match("^([A-Z]):\\(.*)")
      if drive and rest then
        return "/mnt/" .. drive:lower() .. "/" .. rest:gsub("\\", "/")
      end
    end
    local unix_path = vim.fn.system({"wslpath", "-u", path})
    return unix_path:gsub("[\n\r]", "")
  end
  return path
end

return M
