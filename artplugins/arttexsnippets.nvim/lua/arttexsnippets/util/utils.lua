local M = {}

-- local s = ls.snippet
-- local sn = ls.snippet_node
-- local isn = ls.indent_snippet_node
-- local t = ls.text_node
-- local i = ls.insert_node
-- local f = ls.function_node
-- local c = ls.choice_node
-- local d = ls.dynamic_node
-- local events = require("luasnip.util.events")
-- local r = require("luasnip.extras").rep
-- local fmt = require("luasnip.extras.fmt").fmt
-- local fmta = require("luasnip.extras.fmt").fmta

M.pipe = function(fns)
  return function(...)
    for _, fn in ipairs(fns) do
      if not fn(...) then
        return false
      end
    end

    return true
  end
end

M.no_backslash = function(line_to_cursor, matched_trigger)
  return not line_to_cursor:find("\\%a+$", -#line_to_cursor)
end

local ts_utils = require("arttexsnippets.util.ts_utils")

-- Sistema de Caché Extrema (Memoización por Tick y Posición)
-- LuaSnip evalúa las condiciones (is_math) por CADA snippet en CADA pulsación de tecla.
-- Si hay 200 snippets, buscar el AST o correr regex 200 veces por milisegundo quema la CPU.
-- Este caché asegura que el cómputo pesado se haga exactamente UNA VEZ por tecla presionada.
local _cache = { key = nil, results = {} }

local function memoize(cache_id, fn)
  local bufnr = vim.api.nvim_get_current_buf()
  local tick = vim.api.nvim_buf_get_changedtick(bufnr)
  local win = vim.api.nvim_get_current_win()
  local pos = vim.api.nvim_win_get_cursor(win)
  local current_key = string.format("%d:%d:%d:%d", bufnr, tick, pos[1], pos[2])

  if _cache.key ~= current_key then
    _cache.key = current_key
    _cache.results = {}
  end

  if _cache.results[cache_id] ~= nil then
    return _cache.results[cache_id]
  end

  local res = fn()
  _cache.results[cache_id] = res
  return res
end

M.is_math = function(treesitter)
  return memoize("is_math_" .. tostring(treesitter), function()
    if treesitter then
      return ts_utils.in_mathzone()
    end
    
    local syn_id = vim.fn.synID(vim.fn.line("."), vim.fn.col(".") - 1, 1)
    local syn_name = vim.fn.synIDattr(syn_id, "name")
    return string.match(syn_name, "Math") ~= nil
  end)
end

M.not_math = function(treesitter)
  return memoize("not_math_" .. tostring(treesitter), function()
    if treesitter then
      return ts_utils.in_text(true)
    end
    return not M.is_math()
  end)
end

M.comment = function()
  return memoize("comment", function()
    if pcall(require, "nvim-treesitter") then
      return ts_utils.in_comment()
    end
    local syn_id = vim.fn.synID(vim.fn.line("."), vim.fn.col(".") - 1, 1)
    local syn_name = vim.fn.synIDattr(syn_id, "name")
    return string.match(syn_name, "Comment") ~= nil
  end)
end

M.env = function(name)
  return memoize("env_" .. name, function()
    local is_inside = vim.fn.searchpair('\\begin{' .. name .. '}', '', '\\end{' .. name .. '}', 'bW')
    return is_inside > 0
  end)
end

M.with_priority = function(snip, priority)
  snip.priority = priority
  return snip
end

M.with_opts = function(fn, opts)
  return function()
    return fn(opts)
  end
end

return M
