--- @module arttexsourcecolor.treesitter_injector
--- @description Encargado de escribir consultas AST dinámicas para macros personalizados.
--- Evita reescrituras innecesarias en disco mediante verificación de hashes/strings para cuidar el I/O.
local M = {}

function M.clear_injection()
  local query_file = vim.fn.stdpath("data") .. "/arttex_dynamic_queries/queries/latex/highlights.scm"
  if vim.fn.filereadable(query_file) == 1 then
    os.remove(query_file)
    pcall(vim.cmd, "write")
    pcall(vim.cmd, "edit")
  end
end

function M.inject(commands, environments)
  local query_file = vim.fn.stdpath("data") .. "/arttex_dynamic_queries/queries/latex/highlights.scm"
  
  -- Create dir if it doesn't exist
  local dir = vim.fn.fnamemodify(query_file, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end

  local new_content = ";; extends\n\n"
  
  if commands and #commands > 0 then
    local escaped_cmds = {}
    for _, cmd in ipairs(commands) do
      local c = cmd:gsub("^\\", "")
      table.insert(escaped_cmds, '"\\\\' .. c .. '"')
    end
    local cmd_str = table.concat(escaped_cmds, " ")
    new_content = new_content .. '((command_name) @ArtTexCustomCommand\n'
    new_content = new_content .. ' (#any-of? @ArtTexCustomCommand ' .. cmd_str .. '))\n\n'
  end
  
  if environments and #environments > 0 then
    local escaped_envs_begin = {}
    local escaped_envs_end = {}
    for _, env in ipairs(environments) do
      table.insert(escaped_envs_begin, '"\\\\begin{' .. env .. '}"')
      table.insert(escaped_envs_end, '"\\\\end{' .. env .. '}"')
    end
    local env_str_begin = table.concat(escaped_envs_begin, " ")
    local env_str_end = table.concat(escaped_envs_end, " ")
    
    new_content = new_content .. '((begin) @ArtTexCustomEnv\n'
    new_content = new_content .. ' (#any-of? @ArtTexCustomEnv ' .. env_str_begin .. '))\n\n'
    new_content = new_content .. '((end) @ArtTexCustomEnv\n'
    new_content = new_content .. ' (#any-of? @ArtTexCustomEnv ' .. env_str_end .. '))\n\n'
  end
  
  local current_content = ""
  if vim.fn.filereadable(query_file) == 1 then
    local cf = io.open(query_file, "r")
    if cf then
      current_content = cf:read("*a")
      cf:close()
    end
  end
  
  if current_content == new_content then
    return true -- No changes needed
  end

  local f = io.open(query_file, "w")
  if not f then return false end
  f:write(new_content)
  f:close()
  
  -- We deliberately DO NOT call :write or :edit here to avoid disrupting the user's workflow.
  -- Treesitter will pick up the new queries on the next buffer reload or naturally depending on Neovim version.
  
  return true
end

return M
