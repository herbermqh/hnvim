local M = {}

local builder = require("arttexworkspace.ui.menu_builder")

M.create_menu = function(opts)
  return builder.create_menu(opts)
end

return M
