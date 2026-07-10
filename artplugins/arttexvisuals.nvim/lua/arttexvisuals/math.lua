local M = {}

-- Configuración del puente RPC (Remote Procedure Call)
M.config = {
  executable_path = "arttexmath_gui", -- Nombre futuro del binario C++
  port = 0,
}

function M.open_editor()
  vim.notify("[ArtTex Visuals] Inicializando puente RPC... El editor C++ de matemáticas se implementará en el futuro.", vim.log.levels.INFO)
  -- Aquí irá la lógica de vim.fn.jobstart() para abrir el programa externo C++
end

return M
