# Documentación para Desarrolladores (`arttexcmp.nvim`)

El plugin `arttexcmp` funciona estrictamente como un "source" personalizado para la API de `nvim-cmp`. Fue diseñado bajo las premisas de acoplamiento mínimo, extrema velocidad de respuesta y abstracción del ruteo. A continuación, se detalla la arquitectura interna y la funcionalidad de cada archivo y función.

---

## 1. `init.lua` (Punto de Entrada)
Este archivo se encarga de arrancar el módulo y conectar `arttexcmp` al motor del autocompletador principal.

- **`M.setup(opts)`**:
  1. Ejecuta `require("arttexcmp.config").setup(opts)` para inyectar preferencias o restaurar el estado desde el JSON persistente.
  2. Verifica si el plugin de terceros `cmp` está cargado usando un entorno `pcall`. Si no está, se aborta silenciosamente emitiendo un Warning.
  3. Ejecuta `cmp.register_source("arttex", source.new())`, enlazando nuestra tabla de objetos definida en `source.lua` a `nvim-cmp`.
  4. Levanta y expone el comando `:ArtCmpConfig` mapeándolo a la UI visual del ecosistema.

---

## 2. `config.lua` (Gestión de Configuración y Sets O(1))
Este archivo mantiene los valores por defecto configurables por el usuario y crea los esquemas de búsqueda. 

- **`M.load_json()`**: Lee el archivo en `~/.config/nvim/arttexcmp_config.json`, lo parsea con `vim.fn.json_decode` y retorna la tabla lua.
- **`M.save_json(opts)`**: Toma un argumento tipo tabla (las opciones modificadas), lo codifica en JSON (`vim.fn.json_encode`) y lo sobreescribe en el disco persistiendo los cambios de manera asíncrona (es decir, en el próximo reinicio de Neovim estarán ahí).
- **`M.setup(opts)`**: Actúa como un *deep-merge* iterativo. Primero sobreescribe las variables locales (defaults) con los valores leídos en `M.load_json()`. Luego hace una segunda pasada priorizando opciones que pudiesen llegar pasadas vía argumento a `setup(opts)` durante el tiempo de inicialización de la configuración (desde `lazy.nvim`).
- **`M.rebuild_sets()`**: Esta función es la clave del rendimiento del autocompletador. Toma las tablas arrays (como `{"cite", "parencite"}`) y las transforma en Hash Sets (tablas con llaves/valores hash booleanos, por ej: `{ cite = true, parencite = true }`). Esto permite a `core.lua` comprobar si un comando disparó autocompletado en complejidad de tiempo `O(1)`, destruyendo la necesidad de lentos motores Regex.

---

## 3. `ui.lua` (Dashboard Interactivo)
Levanta un menú visual.

- **`M.open_menu()`**: Configura la tabla de arreglos con acciones (callbacks) para cada una de las 4 opciones de personalización (citas, referencias, includes, gráficos). Envía este array y renderiza utilizando el objeto importado `menu_builder.create_menu()` proveniente del núcleo compartido del ecosistema ArtTeX.
- **`M.edit_list(key, title)`**: Desencadenado como "callback" desde `open_menu()`. Toma la llave de estado requerida (`key` ej: `citation_commands`), la aplana a un string de palabras separadas por comas (`table.concat`) e invoca `menu_builder.create_input()`. Al pulsar Enter, este parsea de regreso el string usando `gmatch`, guarda la nueva tabla en disco vía `config.save_json()` y gatilla obligatoriamente `config.rebuild_sets()` para refrescar en caliente el Hash Set en la memoria del core del plugin, de esta manera el usuario no requiere reiniciar su editor para ver los cambios efectivos.

---

## 4. `source.lua` (Interfaz con `nvim-cmp`)
Este archivo sirve como el puente obligatorio orientado a objetos (clase) requerido explícitamente por el autor de `nvim-cmp`.

- **`source.new()`**: Constructor metatable para instanciar la fuente de autocompletado de la API global.
- **`source:get_trigger_characters()`**: Devuelve la tabla `{ "\\", "{", "[", ",", "@" }`. Esto es un listener; cada vez que el usuario presione esas teclas, Neovim solicitará un cálculo de completado.
- **`source:get_keyword_pattern()`**: Devuelve `[[\%(\\\|[a-zA-Z0-9_:-]\)\+]]`. Establece el límite en la palabra que se escriba, indicándole a `cmp` qué es lo que el usuario quiere autocompletar. Importante: Incluye la contrabarra `\` como un carácter válido dentro de un keyword de completado, afectando directamente al cómo definimos el campo `insertText`.
- **`source:is_available()`**: Pre-filtrado pasivo. Retorna `true` solo si estamos en `tex` o `plaintex`.
- **`source:complete(request, callback)`**: Extrae el contexto (`cursor_before_line` y `cursor.col`) y empaqueta la ejecución, trasladando el control a la función de enrutamiento `core.get_completions`.
- **`source:resolve` y `source:execute`**: Funciones vacías requeridas por compatibilidad de la API de Language Server; no realizan alteraciones en esta versión.

---

## 5. `core.lua` (Router Principal)
Realiza el enrutamiento Regex superficial para detectar en qué parte de un macro el cursor está atrapado.

- **`M.get_completions(line_before, cursor_col, callback)`**: 
  - Procesa strings en formato "linea-antes-del-cursor" (`line_before`).
  - Realiza un barrido heurístico y ejecuta patrones `match()` muy rápidos en Lua puro buscando casos específicos como `\\begin%s*%{([^}]*)$`.
  - Si encuentra un macro general (`\comando[opciones]{...`), extrae el root y verifica consultando el Set (`O(1)`) de `config_module.sets`. Dependiendo de a qué familia corresponda (cites, refs, includes, graphics), despacha la ejecución del callback a uno de los providers paralelos situados en `providers/*.lua`.
  - Como "Fallback" a Macros propios o IA: Consulta mediante `workspace.api.get_project_config(bufnr)` si el macro matcheado pertenece a `estructura_aprendida_ia` (usado ampliamente para proyectos multi-carpetas como los exámenes UMSA) y, de ser así, lo trata como un macro de inclusión para inyectar directorios dinámicamente. 

---

## 6. Los Proveedores (`providers/`)
Contiene los módulos encargados de generar los ítems `CompletionItem` formateados.

### `workspace.lua` (Proveedores del Entorno General)
- **`M.get_environments(bufnr, callback)`**: Consulta a `arttexworkspace` por la lista pre-compilada de entornos y los concatena con entornos bases definidos localmente (e.g., `align`, `itemize`). Retorna los ítems con el tag visual de "Struct".
- **`M.get_packages(bufnr, callback)`**: Consulta al workspace por los paquetes y retorna los ítems etiquetados como "Module".
- **`M.get_commands(bufnr, callback)`**: Añade dinámicamente un `\` antes del nombre de comando de los macros que lee desde el workspace JSON, retornándolos como "Function". (Se ajusta `insertText` a `\` ya que el patrón Regex original incluye el slash).

### `labels.lua` (Motor de Referencias Cruzadas)
- **`M.get_labels(bufnr, callback)`**: Escanea todos los archivos mapeados en `config.project_tree`.
  - **Sistema de Caché (mtime)**: Extrae iterativamente el objeto `uv.fs_stat` (libuv asíncrono) para conseguir `mtime.sec` de un archivo del disco de tu ordenador. Si el `mtime` del archivo local coincide perfectamente con nuestro `mtime` cacheado global, no hace NADA más y se salta su procesamiento.
  - De no coincidir o ser nulo, abre el archivo con la API en memoria C (`io.open`), realiza un barrido por patrón buscando `\\label%{([^}]+)%}`, extrae su contenido y lo actualiza, salvando el nuevo `mtime.sec` global.

### `citations.lua` (Motor de Bibliografías)
- **`M.get_citations(bufnr, callback)`**: Ejecuta un escaneo análogo a `labels.lua`, iterando `project_tree` y aplicando caché granular (mtime), pero filtrando únicamente aquellos archivos que tengan terminación `.bib`. Si detecta un archivo alterado, localiza strings bajo el formato `@tipo{clave,` y propaga los ítems con un tag "Reference".

### `files.lua` (Rutas e Includes)
- **`M.get_files(bufnr, ext, callback)`**: Iteración que extrae un path listado en `project_tree`.
  - Aísla la ruta inicial local del `root_dir` para truncarla y mostrarla de forma presentable y "relativa".
  - Si el formato exigido es `.tex`, descarta silenciosamente la extensión para adaptarse a comportamientos ortodoxos de inclusión macro (`\input{file}`). Si es PNG o JPG/PDF (Gráficos), mantiene la extensión. Retorna objetos marcados con tag "File".
