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
  table.insert(autosnippets,   parse_snippet({trig = [=[sc]=], name = [=[chemin subscript]=], priority = 100, trigEngine = "ecma", wordTrig = false, condition = pipe({is_math, not_preceded_by('i$')})}, [=[_{{\ce{$1}}}$0]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[([0-9^{}\-\+])\s([a-zA-Z]+)\s([a-zA-Z0-9]+)]=], name = [=[valor unidada sustancia]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[([0-9^{}\-\+]+)\s([a-zA-Z]+)\s([\\a-zA-Z0-9]+)]=], name = [=[valor unidada macro]=], priority = -1000, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[([\+\-]?[0-9\,\.\\pi]+(?:\\times10\^\{[\+\-0-9]+\})?)\s([a-zA-Z\\\{\}\/íó\^0-9]+)]=], name = [=[valor unidada]=], priority = -1000, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[([a-zA-Z0-9^{}\\;\{\},\-\+íó]+)>([a-zA-Z0-9^{}\\;\{\},\-\+íó]+)]=], name = [=[factor conversor]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[(w+)<]=], name = [=[factor conversor]=], priority = 1000, trigEngine = "ecma", wordTrig = false, condition = is_math}, [=[]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[ce]=], name = [=[chemin]=], priority = 1000, wordTrig = false}, [=[\ce{$1}]=]))
  table.insert(normalsnippets,   parse_snippet({trig = [=[chemin]=], name = [=[Nomenclatura inorgánica]=], priority = 1000, wordTrig = false}, [=[\chemin[$1]{
  \ntra{$2}\\
  \nsto{$3}\\
  \niup{$0}
}]=]))
  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end
return M