local M = {}
local workspace = require("arttexworkspace")
local fs_cache = require("arttexhover.utils.fs_cache")

local function extract_bib_entry(content, target_key)
  local pattern = "(@%a+%s*%{%s*" .. vim.pesc(target_key) .. "%s*,.-)%n%s*@%a+{"
  local match = content:match(pattern)
  if match then return match end
  
  local fallback_pattern = "(@%a+%s*%{%s*" .. vim.pesc(target_key) .. "%s*,.*)"
  local fallback_match = content:match(fallback_pattern)
  if fallback_match then
    return fallback_match:sub(1, 1000)
  end
  return nil
end

function M.get_hover_info(bufnr, target_key, callback)
  local config = workspace.api.get_project_config(bufnr)
  if not config or not config.project_tree then
    callback(nil)
    return
  end
  
  for _, content in fs_cache.iter_cached_files(config.project_tree, "%.bib$") do
    local entry_text = extract_bib_entry(content, target_key)
    if entry_text then
      local lines = {}
      for line in entry_text:gmatch("[^\r\n]+") do
        table.insert(lines, line)
      end
      callback(lines, "bib")
      return
    end
  end
  
  callback(nil)
end

return M
