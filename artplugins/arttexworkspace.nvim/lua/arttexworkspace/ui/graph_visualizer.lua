local M = {}

function M.generate_graph()
  local arttex_api = require("arttexworkspace").api
  local root_file = arttex_api.get_root_file(0)
  
  if not root_file then
    vim.notify("ArtTex Workspace: No se detectó proyecto activo para visualizar.", vim.log.levels.WARN)
    return
  end
  
  local config = arttex_api.get_project_config(0)
  if not config then return end

  local lines = {
    "# Grafo de Conocimiento del Proyecto LaTeX",
    "Este grafo generado automáticamente muestra cómo la IA de ArtTeX entendió las interacciones y expansiones de macros en tu proyecto.",
    "",
    "```mermaid",
    "graph TD;",
    "  %% Archivos",
    "  classDef file fill:#2d3f76,stroke:#7aa2f7,stroke-width:2px,color:#c0caf5;",
    "  classDef macro fill:#3d59a1,stroke:#7dcfff,stroke-width:2px,color:#c0caf5,rx:10px,ry:10px;",
    "  classDef ext fill:#1f2335,stroke:#bb9af7,stroke-width:2px,color:#a9b1d6,stroke-dasharray: 5 5;",
  }

  local node_ids = {}
  local node_count = 0
  
  local function get_node_id(name)
    if not node_ids[name] then
      node_count = node_count + 1
      node_ids[name] = "N" .. tostring(node_count)
    end
    return node_ids[name]
  end

  -- Dibujar Árbol de archivos locales
  if config.project_tree then
    for _, path in ipairs(config.project_tree) do
      local basename = vim.fn.fnamemodify(path, ":t")
      local id = get_node_id(basename)
      table.insert(lines, string.format('  %s["📄 %s"]:::file', id, basename))
    end
  end

  -- Dibujar Interacciones Estructurales (Macros -> Expansiones/Llamadas)
  if config.estructura_aprendida_ia then
    for caller, callees in pairs(config.estructura_aprendida_ia) do
      local caller_id = get_node_id(caller)
      table.insert(lines, string.format('  %s["⚙️ \\\\%s"]:::macro', caller_id, caller))
      
      for _, callee_pattern in ipairs(callees) do
        local callee_label = callee_pattern:gsub("%%s", "{arg}")
        local callee_id = get_node_id(callee_label)
        table.insert(lines, string.format('  %s["%s"]:::ext', callee_id, callee_label))
        
        -- Crear relación (Edge)
        table.insert(lines, string.format('  %s -->|expande a| %s', caller_id, callee_id))
      end
    end
  end

  table.insert(lines, "```")

  -- Crear buffer flotante o abrir en un nuevo tab
  vim.cmd("tabnew")
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.bo[bufnr].filetype = "markdown"
  vim.bo[bufnr].bufhidden = "wipe"
  vim.bo[bufnr].buftype = "nofile"
  vim.api.nvim_buf_set_name(bufnr, "ArtTex_Knowledge_Graph.md")
  
  vim.notify("Grafo generado con éxito. Si tienes un plugin de Markdown, podrás ver el diagrama Mermaid.", vim.log.levels.INFO)
end

return M
