# Manual del Desarrollador (Developer Docs) - arttexworkspace

Este documento detalla la arquitectura interna, estructura de datos, y los componentes de bajo nivel del plugin `arttexworkspace`. Está diseñado para cualquier colaborador (humano o IA) que desee escalar o integrar el plugin.

## 1. Arquitectura Base (Microkernel)
El plugin se estructura en módulos independientes que se invocan entre sí, siguiendo un patrón donde `init.lua` actúa como el Entry Point, conectando el escáner de estado, resolutor de raíces, y las interfaces gráficas.

---

## 2. Descripción Detallada por Módulo

### 2.1. `lua/arttexworkspace/init.lua`
Es el núcleo central del plugin. Define los autocommands y exporta la API pública.
**Variables y Funciones:**
- `M.api`: Tabla que contiene las funciones expuestas a otros plugins.
- `init_buffer()`: Función privada (`local`). Disparada en el evento `FileType tex`. Resuelve la raíz del archivo y lanza el parseo asíncrono en background.
- `M.setup(opts)`: Función pública. Inicia los autocommands, monitoriza escritura (`BufWritePost`), inicializa `goto_file.setup()` y crea comandos de usuario (`ArtTexWorkspaceTree`).

### 2.2. `lua/arttexworkspace/core/state.lua` (Gestor de Memoria en RAM)
Módulo Singleton que actúa como caché ultrarrápida (O(1)) para evitar reprocesar archivos de forma intensiva.
**Tipos de Dato:**
- `Project_Table`: Objeto que representa el estado del proyecto. Contiene `{ ready = boolean, engine = string, packages = table, commands = table, environments = table, file_structure = table }`.
**Variables y Funciones:**
- `M.projects`: Diccionario privado (memoria) que mapea `ruta_raiz -> Project_Table`.
- `M.buffer_roots`: Diccionario privado que mapea `ruta_archivo_hijo -> ruta_raiz`.
- `M.get_project(root_path)`: Devuelve la instancia del proyecto.
- `M.register_project(root_path)`: Inicializa la memoria para una nueva raíz.
- `M.map_buffer(buffer_path, root_path)`: Crea la relación para búsquedas inversas instantáneas.

### 2.3. `lua/arttexworkspace/discovery/root_resolver.lua`
Motor heurístico secuencial que determina cuál es el `main.tex` de cualquier fragmento abierto.
**Funciones:**
- `M.find_root(filepath)`: Función principal que recorre 7 estrategias (comentarios mágicos `!TeX root`, variables `.arttex.json`, escaneo ascendente de filesystem usando `rg` buscando `\documentclass`, etc.).

### 2.4. `lua/arttexworkspace/parsers/macro_analyzer.lua`
El "cerebro" del plugin. Un analizador léxico de dos pasadas impulsado por grafos.
**Variables Privadas Locales:**
- `local_packages_cache`: Caché O(1) de todos los archivos `.sty`, `.cls` del ecosistema del usuario en `library_paths`. Evita que `rg` busque cientos de veces.
**Funciones:**
- `M.analyze_file(filepath)`: Ejecuta una lectura en bloque buscando `\newcommand`, `\def`, etc., utilizando expresiones regulares optimizadas (`[a-zA-Z_@]+`). Soporta parámetros opcionales `[]` e ignora comentarios.
- `M.auto_generate_config(main_file)`: El motor de resolución de alias global (Segunda Pasada). Genera y actualiza iterativamente `.[basename].arttex.json`. Identifica macros que llaman internamente a sub-archivos para deducir la estructura.

### 2.5. `lua/arttexworkspace/ui/goto_file.lua`
Implementa el sistema perezoso de saltos `gf`.
**Funciones:**
- `M.setup()`: Crea mapeos dinámicos en archivos `tex` sobreescribiendo `gf`.
- `intelligent_fallback(cmd_name, arg, config_path, config, root)`: Función privada. Si el macro no está en memoria, utiliza `rg` en las rutas del usuario (`library_paths`) para encontrar su definición original, compilar su alias, inyectarlo al JSON de la IA e instantáneamente forzar el salto.

### 2.6. `lua/arttexworkspace/ui/tree_viewer.lua`
UI Semántica en tiempo real.
**Tipos de Datos Locales:**
- `line_to_node`: Mapeo de `numero_de_linea` (UI) -> Tabla `{ type = "file", path = string }`. Utilizado para abrir archivos con `<CR>`.
**Funciones:**
- `M.open_tree(root)`: Inicializa un búfer flotante, aplica la opción de `cursorline = true`, inyecta el `pill-highlighter` si existe, y ejecuta `parse_node`.
- `parse_node(filepath)`: Función recursiva que lee `.[basename].arttex.json` y arma el grafo jerárquico de archivos incluidos en el proyecto al vuelo.
- `render_node(...)`: Pinta los caracteres ASCII/NerdFonts (`├──`, `└──`) y genera iconos.

---

## 3. Integración y Extensibilidad

Este plugin expone múltiples APIs a las cuales pueden recurrir otros módulos o el ecosistema ArtTeX para consultar el estado global:

- `require("arttexworkspace").api.get_root_file(bufnr)`
- `require("arttexworkspace").api.get_project_state(bufnr)`
- `require("arttexworkspace").api.get_project_tree(bufnr)` (Para extraer un vector con todas las dependencias del proyecto).
