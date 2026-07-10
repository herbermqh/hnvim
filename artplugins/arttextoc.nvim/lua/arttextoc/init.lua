local M = {}

-- API pública para comunicación cruzada entre plugins
M.api = {}

M.default_opts = {
  custom_levels = {
    -- Ejemplo:
    -- ["mychapter"] = 1,
    -- ["mysection"] = 2,
  }
}

M.opts = {}

M.get_json_path = function()
  return vim.fn.stdpath("config") .. "/artplugins/arttextoc.nvim/config.json"
end

M.load_json_config = function()
  local path = M.get_json_path()
  if vim.fn.filereadable(path) == 1 then
    local content = vim.fn.readfile(path)
    if #content > 0 then
      local ok, json = pcall(vim.fn.json_decode, content)
      if ok and type(json) == "table" and type(json.custom_levels) == "table" then
        return json.custom_levels
      end
    end
  end
  return {}
end

M.save_json_config = function(custom_levels)
  local path = M.get_json_path()
  local json = vim.fn.json_encode({ custom_levels = custom_levels })
  vim.fn.writefile({json}, path)
  -- Hot reload immediately
  M.opts.custom_levels = custom_levels
end

M.setup = function(opts)
  M.opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})
  local json_levels = M.load_json_config()
  M.opts.custom_levels = vim.tbl_deep_extend("force", M.opts.custom_levels, json_levels)
  
  vim.api.nvim_create_user_command("ArtTexTOCConfig", function()
    require("arttextoc.config_ui").open()
  end, { desc = "Abre la configuración de Tabla de Contenidos" })
end

return M
