local M = {}

function M.strip_verbatim(content, envs)
  if not content or content == "" then
    return content
  end

  local result = content

  -- 1. Strip custom delimiters for \verb and \mintinline
  -- (e.g. \verb|...|, \verb+...+ \mintinline{tex}|...|)
  -- We replace them with spaces so line numbers don't change
  result = result:gsub("\\verb%s*([^a-zA-Z0-9%s{])(.-)%1", function(delim, inner)
    return "\\verb" .. delim .. string.rep(" ", #inner) .. delim
  end)
  result = result:gsub("\\verb%b{}", "") -- if they use \verb{...}
  
  result = result:gsub("\\mintinline%b{}%s*([^a-zA-Z0-9%s{])(.-)%1", function(delim, inner)
    return "" -- mintinline is usually ignored anyway
  end)
  result = result:gsub("\\mintinline%b{}%b{}", "")

  if not envs or #envs == 0 then
    return result
  end

  -- 2. Strip multiline verbatim environments
  for _, env in ipairs(envs) do
    -- Normal version: \begin{env} ... \end{env}
    local pattern = "\\begin%{" .. env .. "%}(.-)\\end%{" .. env .. "%}"
    result = result:gsub(pattern, function(inner)
      local newlines = ""
      for _ in inner:gmatch("\n") do
        newlines = newlines .. "\n"
      end
      return "\\begin{" .. env .. "}" .. newlines .. "\\end{" .. env .. "}"
    end)
    
    -- Starred version: \begin{env*} ... \end{env*}
    local pattern_star = "\\begin%{" .. env .. "%*%}(.-)\\end%{" .. env .. "%*%}"
    result = result:gsub(pattern_star, function(inner)
      local newlines = ""
      for _ in inner:gmatch("\n") do
        newlines = newlines .. "\n"
      end
      return "\\begin{" .. env .. "*}" .. newlines .. "\\end{" .. env .. "*}"
    end)
  end

  return result
end

return M
