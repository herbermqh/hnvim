local M = {}

local utils = require("arttexsnippets.util.utils")
local pipe = utils.pipe

local _snippets = function(is_math, not_math, opts)
  local autosnippets = {}
  local normalsnippets = {}
  opts.disabled_modules = opts.disabled_modules or {}

  -- 1. Cargar el motor matemático core (Solo Autosnippets)
  if opts.load_core_math then
    for _, s in ipairs({
      "math_wRA_no_backslash",
      "math_rA_no_backslash",
      "math_wA_no_backslash",
      "math_iA_no_backslash",
      "math_iA",
      "math_wrA",
    }) do
      if not opts.disabled_modules[s] then
        vim.list_extend(autosnippets, require(("arttexsnippets.math.%s"):format(s)).retrieve(is_math))
      end
    end

    for _, s in ipairs({
      "wA",
      "bwA",
    }) do
      if not opts.disabled_modules[s] then
        vim.list_extend(autosnippets, require(("arttexsnippets.math.%s"):format(s)).retrieve(not_math))
      end
    end
  end

  -- 2. Cargar Snippets del Usuario / Extendidos (Lectura Dinámica)
  if opts.load_custom then
    local script_path = debug.getinfo(1, "S").source:sub(2)
    local custom_path = vim.fn.fnamemodify(script_path, ":h:h") .. "/custom"
    
    if vim.fn.isdirectory(custom_path) == 1 then
      for name, item_type in vim.fs.dir(custom_path) do
        if item_type == "file" and name:match("%.lua$") then
          local module_name = name:gsub("%.lua$", "")
          if not opts.disabled_modules[module_name] then
            local ok, q = pcall(require, "arttexsnippets.custom." .. module_name)
            if ok and type(q) == "table" and q.retrieve then
              local data = q.retrieve(is_math, not_math)
              if data and data.autosnippets then vim.list_extend(autosnippets, data.autosnippets) end
              if data and data.normalsnippets then vim.list_extend(normalsnippets, data.normalsnippets) end
            end
          end
        end
      end
    end
  end

  -- 3. Cargar Snippets por Proyecto
  if opts.load_project_local then
    local cwd = vim.fn.getcwd()
    local local_dir = cwd .. "/.arttex/snippets"
    if vim.fn.isdirectory(local_dir) == 1 then
      for name, item_type in vim.fs.dir(local_dir) do
        if item_type == "file" and name:match("%.lua$") then
          local module_name = name:gsub("%.lua$", "")
          if not opts.disabled_modules[module_name] then
            local filepath = local_dir .. "/" .. name
            local ok, chunk = pcall(loadfile, filepath)
            if ok and chunk then
              local module = chunk()
              if type(module) == "table" and module.retrieve then
                local data = module.retrieve(is_math, not_math)
                if data and data.autosnippets then vim.list_extend(autosnippets, data.autosnippets) end
                if data and data.normalsnippets then vim.list_extend(normalsnippets, data.normalsnippets) end
              end
            end
          end
        end
      end
    end
  end

  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end

M.setup_tex = function(is_math, not_math, opts)
  local ls = require("luasnip")
  
  local snips = _snippets(is_math, not_math, opts)
  
  if opts.load_core_math then
    local math_i = require("arttexsnippets.math.math_i").retrieve(is_math)
    vim.list_extend(snips.normalsnippets, math_i)
  end

  ls.add_snippets("tex", snips.normalsnippets, { default_priority = 0, key = "arttex_normal" })
  ls.add_snippets("tex", snips.autosnippets, { type = "autosnippets", default_priority = 0, key = "arttex_auto" })
end

M.setup_markdown = function(is_math, not_math, opts)
  local ls = require("luasnip")
  local snips = _snippets(is_math, not_math, opts)
  local autosnippets = snips.autosnippets
  
  if opts.load_core_math then
    local math_i = require("arttexsnippets.math.math_i").retrieve(is_math)
    vim.list_extend(snips.normalsnippets, math_i)
  end
  
  ls.add_snippets("markdown", snips.normalsnippets, { default_priority = 0, key = "arttex_md_normal" })

  local trigger_of_snip = function(s) return s.trigger end

  local to_filter = {}
  if opts.load_core_math then
    for _, str in ipairs({ "wA", "bwA" }) do
      local t = require(("arttexsnippets.math.%s"):format(str)).retrieve(not_math)
      vim.list_extend(to_filter, vim.tbl_map(trigger_of_snip, t))
    end
  end

  local filtered = vim.tbl_filter(function(s)
    return not vim.tbl_contains(to_filter, s.trigger)
  end, autosnippets)

  local parse_snippet = ls.extend_decorator.apply(ls.parser.parse_snippet, {
    condition = pipe({ not_math }),
  }) --[[@as function]]

  local normal_wA_tex = {
    parse_snippet({ trig = "mk", name = "Math" }, "$${1:${TM_SELECTED_TEXT}}$"),
    parse_snippet({ trig = "dm", name = "Block Math" }, "$$\n\t${1:${TM_SELECTED_TEXT}}\n$$"),
  }
  vim.list_extend(filtered, normal_wA_tex)

  ls.add_snippets("markdown", filtered, {
    type = "autosnippets",
    default_priority = 0,
    key = "arttex_md_auto"
  })
end

M.reload = function()
  for k, _ in pairs(package.loaded) do
    if k:match("^arttexsnippets%.math") or k:match("^arttexsnippets%.custom") then
      package.loaded[k] = nil
    end
  end
  
  local opts = require("arttexsnippets").opts
  local utils = require("arttexsnippets.util.utils")
  local is_math = utils.with_opts(utils.is_math, opts.use_treesitter)
  local not_math = utils.with_opts(utils.not_math, opts.use_treesitter)
  
  M.setup_tex(is_math, not_math, opts)
  if opts.allow_on_markdown then
    M.setup_markdown(is_math, not_math, opts)
  end
  vim.notify("ArtTex snippets reloaded!", vim.log.levels.INFO)
end

return M
