local M = {}
local cmp = require("cmp")
local workspace = require("arttexworkspace")

function M.get_environments(bufnr, callback)
  local config = workspace.api.get_project_config(bufnr)
  local items = {}
  
  if config and config.environments then
    for _, env in ipairs(config.environments) do
      table.insert(items, {
        label = env,
        kind = cmp.lsp.CompletionItemKind.Struct,
        detail = "Entorno (ArtTeX Workspace)"
      })
    end
  end
  
  -- Añadir entornos estándar siempre
  local std_envs = { "equation", "align", "itemize", "enumerate", "figure", "table", "center", "document", "abstract" }
  for _, env in ipairs(std_envs) do
    table.insert(items, { label = env, kind = cmp.lsp.CompletionItemKind.Struct, detail = "Estándar" })
  end
  
  callback(items)
end

function M.get_packages(bufnr, callback)
  local config = workspace.api.get_project_config(bufnr)
  local items = {}
  
  if config and config.packages then
    for _, pkg in ipairs(config.packages) do
      table.insert(items, {
        label = pkg,
        kind = cmp.lsp.CompletionItemKind.Module,
        detail = "Paquete (ArtTeX Workspace)"
      })
    end
  end
  
  callback(items)
end

function M.get_commands(bufnr, callback)
  local config = workspace.api.get_project_config(bufnr)
  local items = {}
  
  if config and config.commands then
    for _, cmd in ipairs(config.commands) do
      table.insert(items, {
        label = "\\" .. cmd,
        filterText = "\\" .. cmd,
        insertText = "\\" .. cmd,
        kind = cmp.lsp.CompletionItemKind.Function,
        detail = "Comando (ArtTeX Workspace)"
      })
    end
  end
  
  if config and config.estructura_aprendida_ia then
    for cmd, _ in pairs(config.estructura_aprendida_ia) do
      table.insert(items, {
        label = "\\" .. cmd,
        filterText = "\\" .. cmd,
        insertText = "\\" .. cmd,
        kind = cmp.lsp.CompletionItemKind.Function,
        detail = "Macro Módulo (ArtTeX Workspace)"
      })
    end
  end
  
  callback(items)
end

return M
