if vim.g.loaded_arttextoc == 1 then
  return
end
vim.g.loaded_arttextoc = 1

vim.api.nvim_create_user_command("ArtTexTOCToggle", function()
  require("arttextoc.ui").toggle()
end, { desc = "Abre/Cierra la Tabla de Contenidos interactiva de ArtTeX" })
