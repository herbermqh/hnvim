--- @module arttexsourcecolor.workspace_bridge
--- @description Puente de comunicación asíncrono con el Workspace.
--- Usa Inotify (libuv) para reaccionar a cambios en la BD del workspace consumiendo 0% de CPU.
local M = {}
local injector = require("arttexsourcecolor.treesitter_injector")

local fs_event = nil
local last_json_path = nil

local function parse_and_inject(json_path)
  local f = io.open(json_path, "r")
  if not f then return end
  local content = f:read("*a")
  f:close()

  local ok, data = pcall(vim.json.decode, content)
  if ok and type(data) == "table" then
    injector.inject(data.commands, data.environments)
    
    _G.arttex_preamble_files = {}
    _G.arttex_body_files = {}
    if data.preamble_files then
      for _, f in ipairs(data.preamble_files) do _G.arttex_preamble_files[f] = true end
    end
    if data.body_files then
      for _, f in ipairs(data.body_files) do _G.arttex_body_files[f] = true end
    end
  end
end

function M.sync_with_workspace(bufnr)
  -- Intentar resolver el root via arttexworkspace
  local ok, resolver = pcall(require, "arttexworkspace.discovery.root_resolver")
  if not ok then return end
  
  local filepath = vim.api.nvim_buf_get_name(bufnr or 0)
  if filepath == "" then return end

  local main_file = resolver.find_root(filepath)
  if not main_file then return end

  local root_dir = vim.fn.fnamemodify(main_file, ":h")
  local basename = vim.fn.fnamemodify(main_file, ":t:r")

  local json_path = root_dir .. "/." .. basename .. ".arttex.json"

  -- Si es el mismo proyecto, no rehacer watcher
  if json_path == last_json_path then
    return
  end
  last_json_path = json_path

  -- 1. Leer e inyectar estado inicial
  if vim.fn.filereadable(json_path) == 1 then
    parse_and_inject(json_path)
  end

  -- 2. Configurar FS Event Watcher (0% CPU)
  if fs_event then
    fs_event:stop()
    fs_event:close()
  end

  fs_event = vim.uv.new_fs_event()
  fs_event:start(json_path, {}, vim.schedule_wrap(function(err, filename, events)
    if err then return end
    if events.change or events.rename then
      -- Pequeño delay para asegurar que la escritura del JSON terminó
      vim.defer_fn(function()
        if vim.fn.filereadable(json_path) == 1 then
          parse_and_inject(json_path)
        end
      end, 100)
    end
  end))
end

function M.stop_sync()
  if fs_event then
    fs_event:stop()
    fs_event:close()
    fs_event = nil
  end
  last_json_path = nil
end

return M
