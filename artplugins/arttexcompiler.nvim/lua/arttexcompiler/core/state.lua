--- Módulo de Gestión de Estado.
--- Registra en memoria (RAM) el estado de todos los procesos de compilación activos a nivel global.
--- Útil para evitar compilaciones paralelas accidentales del mismo documento y para interconectar APIs UI.
--- @class arttexcompiler.core.state
local M = {}

--- Singleton para rastrear compiladores activos y su estado.
--- Estructura: `{ ["/ruta/al/main.tex"] = { job_id = 123, status = "running"|"success"|"error"|"stopped", cmd_string = "...", output = {...} } }`
--- @type table<string, table>
M.jobs = {}

--- Inicializa un proceso de compilación marcándolo como 'starting'. Bloquea nuevas solicitudes inmediatas.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.set_starting(main_path)
  M.jobs[main_path] = { status = "starting" }
end

--- Registra un trabajo real del sistema operativo (jobstart).
--- @param main_path string Ruta absoluta del archivo raíz.
--- @param job_id number PID / ID interno de Neovim del proceso activo.
--- @param cmd_string string El comando completo en formato string (para depuración).
function M.register_job(main_path, job_id, cmd_string)
  M.jobs[main_path] = { job_id = job_id, status = "running", cmd_string = cmd_string }
end

--- Actualiza el estado visual del trabajo (ej: "success", "error", "running").
--- @param main_path string Ruta absoluta del archivo raíz.
--- @param status string Estado actual del proceso.
function M.update_status(main_path, status)
  if M.jobs[main_path] then
    M.jobs[main_path].status = status
  end
end

--- Marca un trabajo como detenido por el usuario o por error crítico y limpia su `job_id` para permitir recomenzar.
--- @param main_path string Ruta absoluta del archivo raíz.
function M.unregister_job(main_path)
  if M.jobs[main_path] then
    M.jobs[main_path].status = "stopped"
    M.jobs[main_path].job_id = nil
  end
end

--- Devuelve toda la información almacenada para un proyecto específico.
--- @param main_path string Ruta absoluta del archivo raíz.
--- @return table|nil # Información del job o nil si nunca se ha compilado en esta sesión.
function M.get_job_info(main_path)
  return M.jobs[main_path]
end

--- Comprueba si un proyecto está compilándose actualmente (evitando colisiones).
--- @param main_path string Ruta absoluta del archivo raíz.
--- @return boolean # true si el proceso está activo o iniciando.
function M.is_running(main_path)
  local info = M.jobs[main_path]
  return info ~= nil and (info.job_id ~= nil or info.status == "starting" or info.status == "running")
end

--- Devuelve un clon o referencia del diccionario completo de jobs de la sesión.
--- @return table<string, table>
function M.get_all_jobs()
  return M.jobs
end

return M
