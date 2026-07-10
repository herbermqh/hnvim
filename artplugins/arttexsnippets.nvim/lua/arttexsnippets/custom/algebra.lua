local ls = require('luasnip')
local parse_snippet = ls.parser.parse_snippet
local utils = require('arttexsnippets.util.utils')
local is_math = utils.with_opts(utils.is_math, true)
local not_math = utils.with_opts(utils.not_math, true)
local line_begin = require('luasnip.extras.conditions.expand').line_begin
local pipe = utils.pipe
local function env(name)
  return function()
    return utils.env(name)
  end
end
local function not_preceded_by(pattern)
  return function(line_to_cursor, matched_trigger)
    local before_match = line_to_cursor:sub(1, -(#matched_trigger + 1))
    return not before_match:find(pattern)
  end
end
local function word_boundary(line_to_cursor, matched_trigger)
  local before_match = line_to_cursor:sub(1, -(#matched_trigger + 1))
  if before_match == '' then return true end
  local last_char = before_match:sub(-1)
  return last_char:match('[%w_]') == nil
end
local M = {}
M.retrieve = function()
  local autosnippets = {}
  local normalsnippets = {}
  table.insert(normalsnippets,   parse_snippet({trig = [=[matrixpy]=], name = [=[matrix python]=], wordTrig = true}, [=[matrixpy $1 matrixpy$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[matrixpy(.*)matrixpy]=], name = [=[matrix python]=], priority = 10000, trigEngine = "ecma", wordTrig = false, condition = word_boundary}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[Matrix(.*)]=], name = [=[matrix sympy]=], priority = 10000, trigEngine = "ecma", wordTrig = false, condition = word_boundary}, [=[]=]))
  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end
return M