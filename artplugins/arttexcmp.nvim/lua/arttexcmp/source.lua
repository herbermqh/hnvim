local cmp = require("cmp")
local core = require("arttexcmp.core")

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

-- Determinar cuándo se dispara el autocompletado
function source:get_trigger_characters()
  return { "\\", "{", "[", ",", "@" }
end

function source:get_keyword_pattern()
  -- Emparejar palabras con o sin contrabarra, y caracteres permitidos en LaTeX
  return [[\%(\\\|[a-zA-Z0-9_:-]\)\+]]
end

function source:is_available()
  return vim.bo.filetype == "tex" or vim.bo.filetype == "plaintex"
end

function source:complete(request, callback)
  local ctx = request.context
  local line = ctx.cursor_before_line
  local cursor_col = ctx.cursor.col

  -- Pasamos el contexto al motor principal que determinará qué proveer
  core.get_completions(line, cursor_col, function(items)
    callback({
      items = items,
      isIncomplete = false,
    })
  end)
end

function source:resolve(completion_item, callback)
  callback(completion_item)
end

function source:execute(completion_item, callback)
  callback(completion_item)
end

return source
