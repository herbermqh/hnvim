local M = {}

local workspace = require("arttexworkspace")
local config_module = require("arttexcmp.config")

local p_labels = require("arttexcmp.providers.labels")
local p_cites = require("arttexcmp.providers.citations")
local p_workspace = require("arttexcmp.providers.workspace")
local p_files = require("arttexcmp.providers.files")

function M.get_completions(line_before, cursor_col, callback)
  local bufnr = vim.api.nvim_get_current_buf()
  local sets = config_module.sets
  
  -- Verificar si estamos dentro de \begin{...} o \end{...}
  if line_before:match("\\begin%s*%{([^}]*)$") or line_before:match("\\end%s*%{([^}]*)$") then
    p_workspace.get_environments(bufnr, callback)
    return
  end
  
  -- Verificar si estamos dentro de \usepackage{...} o \RequirePackage{...}
  if line_before:match("\\usepackage%s*%[?[^%]]*%]?%s*%{([^}]*)$") or line_before:match("\\RequirePackage%s*%[?[^%]]*%]?%s*%{([^}]*)$") then
    p_workspace.get_packages(bufnr, callback)
    return
  end
  
  -- Capturar cualquier macro LaTeX genérico de la forma \comando[opciones]{...
  -- y verificar si es de citas, referencias, includes, gráficos o personalizadas
  local cmd_match = line_before:match("\\([%a@_]+)%*?%s*%[?[^%]]*%]?%s*%{([^}]*)$")
  
  if cmd_match then
    -- 1. Citas bibliográficas (ej: \cite, \artcite)
    if sets.cites[cmd_match] then
      p_cites.get_citations(bufnr, callback)
      return
    end
    
    -- 2. Referencias cruzadas (ej: \ref, \artref)
    if sets.refs[cmd_match] then
      p_labels.get_labels(bufnr, callback)
      return
    end
    
    -- 3. Archivos incluidos (ej: \input, \include)
    if sets.includes[cmd_match] then
      p_files.get_files(bufnr, "tex", callback)
      return
    end
    
    -- 4. Gráficos e imágenes (ej: \includegraphics)
    if sets.graphics[cmd_match] then
      p_files.get_files(bufnr, "png", function(pngs)
        p_files.get_files(bufnr, "jpg", function(jpgs)
          p_files.get_files(bufnr, "pdf", function(pdfs)
            local all = {}
            for _, v in ipairs(pngs) do table.insert(all, v) end
            for _, v in ipairs(jpgs) do table.insert(all, v) end
            for _, v in ipairs(pdfs) do table.insert(all, v) end
            callback(all)
          end)
        end)
      end)
      return
    end
    
    -- 5. Macros personalizados y/o aprendidos por IA que actúan como "includes" dinámicos
    local config = workspace.api.get_project_config(bufnr)
    if config then
      local is_include = false
      if config.estructura_aprendida_ia and config.estructura_aprendida_ia[cmd_match] then
        is_include = true
      elseif config.estructura_manual_usuario and config.estructura_manual_usuario[cmd_match] then
        is_include = true
      end
      
      if is_include then
        p_files.get_files(bufnr, "tex", callback)
        return
      end
    end
  end
  
  -- Si no encaja en lo anterior, pero termina en un slash invertido \ completamos macros disponibles
  if line_before:match("\\[%a@]*$") then
    p_workspace.get_commands(bufnr, callback)
    return
  end
  
  -- Por defecto devolver vacío si no es un contexto conocido
  callback({})
end

return M
