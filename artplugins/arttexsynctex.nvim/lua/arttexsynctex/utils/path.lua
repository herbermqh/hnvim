local M = {}

function M.to_windows(path)
  if vim.fn.has("wsl") == 1 then
    local wsl_path = vim.fn.system({"wslpath", "-m", path})
    return wsl_path:gsub("[\n\r]", "")
  end
  return path
end

function M.to_unix(path)
  if vim.fn.has("wsl") == 1 and path:match("^[A-Z]:\\") then
    local unix_path = vim.fn.system({"wslpath", "-u", path})
    return unix_path:gsub("[\n\r]", "")
  end
  return path
end

return M
