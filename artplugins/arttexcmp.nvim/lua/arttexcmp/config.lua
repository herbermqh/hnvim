local M = {}

M.options = {
  citation_commands = { "cite", "parencite", "footcite", "textcite", "smartcite", "autocite" },
  reference_commands = { "ref", "eqref", "autoref", "nameref", "pageref", "cref", "Cref" },
  include_commands = { "input", "include", "includeonly" },
  graphics_commands = { "includegraphics" },
  ignore_patterns = { "%.git/", "build/", "out/", "%.aux$" },
  cache_ttl = 5,
}

M.config_file = vim.fn.stdpath("config") .. "/arttexcmp_config.json"

function M.load_json()
  local f = io.open(M.config_file, "r")
  if f then
    local content = f:read("*all")
    f:close()
    local ok, json = pcall(vim.fn.json_decode, content)
    if ok and type(json) == "table" then
      return json
    end
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
  -- 1. Cargar desde JSON (Configuración guardada por la UI)
  local saved_opts = M.load_json()
  if saved_opts then
    for k, v in pairs(saved_opts) do
      M.options[k] = v
    end
  end

  -- 2. Sobrescribir con opciones manuales de setup()
  if opts then
    for k, v in pairs(opts) do
      M.options[k] = v
    end
  end
  
  M.rebuild_sets()
end

function M.rebuild_sets()
  M.sets = { cites = {}, refs = {}, includes = {}, graphics = {} }
  for _, cmd in ipairs(M.options.citation_commands) do M.sets.cites[cmd] = true end
  for _, cmd in ipairs(M.options.reference_commands) do M.sets.refs[cmd] = true end
  for _, cmd in ipairs(M.options.include_commands) do M.sets.includes[cmd] = true end
  for _, cmd in ipairs(M.options.graphics_commands) do M.sets.graphics[cmd] = true end
end

return M
