if vim.g.loaded_arttexvisuals == 1 then
  return
end
vim.g.loaded_arttexvisuals = 1

-- Comandos base para la futura integración interactiva (C++/UI Local)

vim.api.nvim_create_user_command("ArtTexVisualTable", function()
  require("arttexvisuals.tables").open_grid()
end, { desc = "Abre el editor visual de tablas (Hoja de cálculo en Neovim)" })

vim.api.nvim_create_user_command("ArtTexVisualMath", function()
  require("arttexvisuals.math").open_editor()
end, { desc = "Abre el editor de ecuaciones matemáticas externo (RPC a C++)" })

vim.api.nvim_create_user_command("ArtTexVisualGraph", function()
  require("arttexvisuals.graphs").open_editor()
end, { desc = "Abre el editor visual de gráficas TikZ/PGFPlots" })
