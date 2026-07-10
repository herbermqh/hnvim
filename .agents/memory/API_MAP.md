# Mapa de APIs y Documentación de ArtTeX

Este documento es mantenido automáticamente por la IA en base a la **Regla Inquebrantable 9**. Su propósito es rastrear todas las funciones públicas, APIs, y atajos de teclado de los 12 plugins modulares.

## 1. arttexworkspace.nvim
**Descripción:** Plugin base central que maneja el estado del proyecto y determina la raíz del documento LaTeX. Todos los demás plugins dependen de este.
**Estado:** Inicializado.

### API Pública (`require("arttexworkspace").api`)
- `get_root_file(bufnr) -> string|nil`: Devuelve la ruta absoluta al archivo raíz (ej. `main.tex`).
- `get_root_dir(bufnr) -> string|nil`: Devuelve el directorio absoluto donde reside el archivo raíz.
- `is_ready(bufnr) -> boolean`: Devuelve `true` si el workspace ha detectado una raíz.
- `get_project_state(bufnr) -> table|nil`: Retorna la tabla de estado (Singleton) del proyecto actual conteniendo `{ engine, document_class, packages, graphicspath, ready }`.

### Módulo Logger (`require("arttexworkspace").log`)
- `.trace(msg)`, `.debug(msg)`, `.info(msg)`, `.warn(msg)`, `.error(msg)`: Escribe en `~/.cache/nvim/arttex.log`.

### Eventos (Pub/Sub)
- **Emite:** `User ArtTexWorkspaceReady` cuando el parser termina de extraer los paquetes y clase del preámbulo.

---

## 2. arttexcompiler.nvim
**Descripción:** Motor asíncrono de compilación basado en `latexmk`. Funciona como un administrador de procesos multiproyecto.
**Estado:** Activo e Inicializado.

### API Pública (`require("arttexcompiler").api`)
- `start(bufnr)`: Construye y lanza el comando asíncrono `latexmk -pvc` para el proyecto actual.
- `stop(bufnr)`: Mata (`SIGTERM`) el job de compilación del documento actual.
- `stop_all()`: Mata todos los procesos de compilación globales (útil como botón de pánico).
- `clean(bufnr)`: Ejecuta `latexmk -c` en segundo plano para borrar temporales.
- `status()`: Imprime (Notifica) la lista de todos los jobs activos globalmente.
- `get_compilation_state(bufnr) -> table|nil`: Retorna `{ job_id = number, status = "running"|"success"|"failed"|"stopped" }`. API diseñada explícitamente para integrarse con **`noice.nvim`** o barras de estado.

### Comandos de Usuario (Exposed UI)
- `:ArtTexCompile`, `:ArtTexStop`, `:ArtTexStopAll`, `:ArtTexClean`, `:ArtTexStatus`.

### Autocommands
- **Se suscribe a:** `User ArtTexWorkspaceReady` (Queda a la espera de que el Workspace lea el entorno).
- **Se suscribe a:** `VimLeavePre` (Ejecuta `stop_all()` para evitar procesos `latexmk` huérfanos al cerrar el editor).

---

## 3. arttexsynctex.nvim
**Descripción:** Motor de sincronización asíncrona (Forward/Backward search) entre Neovim y el visor PDF mediante SyncTeX. Soporta Zero-lag policy y perfiles múltiples de visores.
**Estado:** Activo e Inicializado.

### API Pública (`require("arttexsynctex").api`)
- `forward_search()`: Sincroniza la posición actual del cursor en Neovim con el visor PDF configurado (ej. Zathura o Sioyek). Calcula la posición relativa a `get_root_file`.

### Comandos de Usuario (Exposed UI)
- `:ArtTexForwardSearch` (Atajo: `<leader>lv`)

### Configuración
- `setup({ viewer = "sumatrapdf" })` (soporta "sumatrapdf", "zathura" y "sioyek").
