local M = {}
local workspace = require("arttexworkspace")
local fs_cache = require("arttexhover.utils.fs_cache")

local function extract_label_context(content, target_key)
  local lines = {}
  for line in content:gmatch("[^\r\n]+") do
    table.insert(lines, line)
  end
  
  local target_pattern = "\\label%s*%{%s*" .. vim.pesc(target_key) .. "%s*%}"
  
  for i, line in ipairs(lines) do
    if line:match(target_pattern) then
      local result = {}
      local start_idx = math.max(1, i - 3)
      local end_idx = math.min(#lines, i + 3)
      
      for j = start_idx, end_idx do
        table.insert(result, lines[j])
      end
      return result, "tex"
    end
  end
  
  return nil
end

function M.get_hover_info(bufnr, target_key, callback)
  local config = workspace.api.get_project_config(bufnr)
  if not config or not config.project_tree then
    callback(nil)
    return
  end
  
  for _, content in fs_cache.iter_cached_files(config.project_tree, "%.tex$") do
    local context_lines, filetype = extract_label_context(content, target_key)
    if context_lines then
      callback(context_lines, filetype)
      return
    end
  end
  
  callback(nil)
end

return M
