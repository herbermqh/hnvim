# Capítulo 3: Arquitectura Core y Máquina de Estado

## 3.1 El Patrón Singleton del Estado (`state.lua`)
En entornos multihilo o asíncronos de Vim, la persistencia del estado es vital. Si dos buffers cargan simultáneamente, el plugin podría intentar parsear el proyecto dos veces, colapsando el editor. 

ArtTeX resuelve esto instanciando un **Gestor de Memoria Singleton**.

### Tabla de Memoria del Sistema
```lua
local M = {}
-- Registro de todos los proyectos activos. LLave: Ruta absoluta del Main.
M.projects = {} 

-- Mapeo Buffer->Raíz. Si el usuario abre el capitulo1.tex, aquí se registra a qué main pertenece.
M.buffer_roots = {} 

-- Caché libuv para evitar IO overhead (Lectura de disco) repetida.
M.file_nodes = {} 
```

Cuando se llama a `register_project(main_path)`, el sistema bloquea preventivamente (spinlock abstracto) marcando la estructura inicializada y configurando el flag `ready = false`. Ningún otro plugin puede operar sobre este proyecto hasta que el evento asíncrono modifique la bandera a `ready = true`.

## 3.2 Motor de Notificaciones (`log.lua`) Seguro
Neovim provee `vim.notify` para notificar al usuario. Sin embargo, llamar a `vim.notify` fuera del hilo principal a veces provoca crashes catastróficos.
ArtTeX implementa un proxy de seguridad:

```lua
function M.notify(msg, level, opts)
  if type(msg) ~= "string" then msg = vim.inspect(msg) end
  level = level or vim.log.levels.INFO
  opts = opts or {}
  vim.schedule(function()
    vim.notify(msg, level, opts)
  end)
end
```
Con este proxy, cualquier error o mensaje emitido por un job en segundo plano se "sanea" y empuja al ciclo principal de forma 100% segura.
