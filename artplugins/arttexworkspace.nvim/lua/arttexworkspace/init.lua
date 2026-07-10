local log = require("arttexworkspace.core.log")
local state = require("arttexworkspace.core.state")
local resolver = require("arttexworkspace.discovery.root_resolver")
local parser = require("arttexworkspace.parsers.preamble")
local macro_analyzer = require("arttexworkspace.parsers.macro_analyzer")
local goto_file = require("arttexworkspace.ui.goto_file")

local M = {}
M.api = {}
M.log = log

-- ================================
-- API PÚBLICA PARA OTROS PLUGINS
-- ================================
M.api.get_root_file = function(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  return state.get_main_from_buffer(filepath)
end

M.api.get_root_dir = function(bufnr)
  local root = M.api.get_root_file(bufnr)
  if root then return vim.fn.fnamemodify(root, ":p:h") end
  return nil
end

M.api.is_ready = function(bufnr)
  return M.api.get_root_file(bufnr) ~= nil
end

M.api.get_project_state = function(bufnr)
  local root = M.api.get_root_file(bufnr)
  if root then return state.get_project(root) end
  return nil
end

M.api.get_project_tree = function(bufnr)
  local root = M.api.get_root_file(bufnr)
  if root then
    local structure = require("arttexworkspace.discovery.project_tree")
    local deps, method = structure.get_dependencies(root)
    return deps, method
  end
  return nil, nil
end

M.api.get_project_config = function(bufnr)
  local root = M.api.get_root_file(bufnr)
  local config = { estructura_manual_usuario = {}, estructura_aprendida_ia = {}, custom_includes = { "chapterfile", "subfile", "import" } }
  if root then
    local project_root = vim.fn.fnamemodify(root, ":p:h")
    local basename = vim.fn.fnamemodify(root, ":t:r")
    local config_path = project_root .. "/." .. basename .. ".arttex.json"
    local f_in = io.open(config_path, "r")
    if f_in then
      local content = f_in:read("*all")
      f_in:close()
      local ok, parsed = pcall(vim.fn.json_decode, content)
      if ok and type(parsed) == "table" then
        for k, v in pairs(parsed) do config[k] = v end
      end
    end
  end
  return config
end

M.api.open_tree = function(bufnr)
  local root = M.api.get_root_file(bufnr)
  if root then
    require("arttexworkspace.ui.tree_viewer").open_tree(root)
  end
end

local function init_buffer()
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" or not filepath:match("%.tex$") then return end
  if state.get_main_from_buffer(filepath) then return end
  
  log.info("Inicializando motor de estado para: " .. filepath)
  local root = resolver.find_root(filepath)
  state.map_buffer(filepath, root)
  
  if root then
    if not state.get_project(root) then
      state.register_project(root)
      -- Dispara el parser y el analizador de macros en background
      vim.schedule(function()
        local root_dir = vim.fn.fnamemodify(root, ":p:h")
        local basename = vim.fn.fnamemodify(root, ":t:r")
        local config_path = root_dir .. "/." .. basename .. ".arttex.json"
        
        -- El usuario especificó que la actualización del JSON debe iniciar
        -- inmediatamente al abrir el proyecto para mantener la base de datos sincronizada
        -- (Especialmente si hubo cambios externos o una nueva compilación de FLS)
        macro_analyzer.auto_generate_config(root)
        
        parser.parse_project(root)
      end)
    end
  end
end

M.setup = function(opts)
  require("arttexworkspace.core.config").options = vim.tbl_deep_extend("force", require("arttexworkspace.core.config").options, opts or {})
  log.info("ArtTeX Workspace Kernel (Microkernel Arch) inicializado.")
  vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = { "tex", "plaintex" },
    callback = init_buffer,
  })

  -- Monitor en vivo (File Watcher / State Tracker)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = { "*.tex", "*.sty", "*.cls" },
    callback = function()
      local filepath = vim.api.nvim_buf_get_name(0)
      local main = state.get_main_from_buffer(filepath)
      if main then
        -- Actualizar el estado asíncronamente
        vim.schedule(function()
          macro_analyzer.auto_generate_config(main)
          parser.parse_project(main)
          
          -- Actualizar silenciosamente las dependencias y el FLS
          require("arttexworkspace.discovery.project_tree").get_dependencies(main)
        end)
      end
    end,
  })

  -- Secuestrar el atajo `gf` para macros inteligentes
  goto_file.setup()

  -- Comando para inspeccionar la memoria y el sistema de archivos (Árbol del Proyecto)
  vim.api.nvim_create_user_command("ArtTexWorkspaceTree", function()
    local root = M.api.get_root_file()
    if not root then
      vim.notify("ArtTeX Workspace: No hay ningún proyecto activo.", vim.log.levels.WARN)
      return
    end
    require("arttexworkspace.ui.tree_viewer").open_tree(root)
  end, {})
end

return M
