local M = {}

M.options = {
  -- Toggle global para auto-hover en CursorHold
  auto_hover = true,

  citation_commands = { "cite", "parencite", "footcite", "textcite", "smartcite", "autocite" },
  reference_commands = { "ref", "eqref", "autoref", "nameref", "pageref", "cref", "Cref" },
  package_commands = { "usepackage", "RequirePackage" },
  
  -- Apariencia del popup
  border = "rounded",
  max_width = 80,
  max_height = 20,
}

M.config_file = vim.fn.stdpath("config") .. "/arttexhover_config.json"
M.sets = { cites = {}, refs = {}, pkgs = {} }

function M.load_json()
  local f = io.open(M.config_file, "r")
  if f then
    local content = f:read("*all")
    f:close()
    local ok, json = pcall(vim.fn.json_decode, content)
    if ok and type(json) == "table" then return json end
  end
  return nil
end

function M.save_json(opts)
  local f = io.open(M.config_file, "w")
  if f then
    f:write(vim.fn.json_encode(opts))
    f:close()
  end
end

function M.setup(opts)
  local saved_opts = M.load_json()
  if saved_opts then
    for k, v in pairs(saved_opts) do M.options[k] = v end
  end
  if opts then
    for k, v in pairs(opts) do M.options[k] = v end
  end
  M.rebuild_sets()
end

function M.rebuild_sets()
  M.sets.cites = {}
  M.sets.refs = {}
  M.sets.pkgs = {}
  for _, cmd in ipairs(M.options.citation_commands) do M.sets.cites[cmd] = true end
  for _, cmd in ipairs(M.options.reference_commands) do M.sets.refs[cmd] = true end
  for _, cmd in ipairs(M.options.package_commands) do M.sets.pkgs[cmd] = true end
end

return M
