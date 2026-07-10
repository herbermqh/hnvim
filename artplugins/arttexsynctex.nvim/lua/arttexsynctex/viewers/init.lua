local M = {}

local viewers = {
  sumatrapdf = require("arttexsynctex.viewers.sumatrapdf"),
  zathura = require("arttexsynctex.viewers.zathura"),
  sioyek = require("arttexsynctex.viewers.sioyek"),
  okular = require("arttexsynctex.viewers.okular"),
  skim = require("arttexsynctex.viewers.skim"),
  termpdf = require("arttexsynctex.viewers.termpdf"),
}

--- Obtiene el módulo del visor configurado
--- @param name string El nombre del visor (ej: "sumatrapdf")
--- @return table|nil Módulo del visor con la función build_forward_search
function M.get_viewer(name)
  return viewers[name]
end

--- Obtiene la lista de todos los visores registrados
--- @return table Tabla con todos los visores
function M.get_all_viewers()
  return viewers
end

return M
