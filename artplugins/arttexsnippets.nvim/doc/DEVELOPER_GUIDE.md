# 🛠️ Documentación de Desarrollador (ArtTeX Snippets)

Este documento detalla la arquitectura interna y el funcionamiento de cada módulo crítico del plugin `arttexsnippets.nvim`. Está pensado para mantenedores o si deseas realizar modificaciones profundas al comportamiento del plugin.

---

## 1. Arquitectura de Carpetas

```text
lua/arttexsnippets/
├── core/
│   └── engine.lua       # Motor que fusiona los módulos matemáticos y personalizados.
├── custom/              # Carpeta de carga dinámica para archivos creados por el usuario (general, algebra...).
├── math/                # Módulos core de matemáticas (basados en Gilles Castel). Son inmutables.
├── util/
│   ├── ts_utils.lua     # Detección de Treesitter.
│   └── utils.lua        # API de validación nativa (Neovim synID, regex).
├── ui.lua               # Gestor gráfico (Ventanas flotantes) que vincula con arttexworkspace.
└── init.lua             # API pública de setup (35 líneas).
plugin/
└── arttexsnippets.lua   # Script auto-inicializador y detector de Hot-Reload (BufWritePost).
```

---

## 2. API y Módulos Internos

### A. `plugin/arttexsnippets.lua`
**Función:** Arranca el ecosistema entero "Zero-Config".
- Verifica si `luasnip` está instalado.
- Ejecuta `require("arttexsnippets").setup()`.
- Registra el comando `:ArtTexSnippetsEdit`.
- **Hot-Reload:** Mantiene un auto-comando `BufWritePost` suscrito a la carpeta `custom/`. Cuando un archivo es guardado, hace un `package.loaded["arttexsnippets.custom.NAME"] = nil` para limpiar el caché de Lua, y luego vuelve a ejecutar la carga de LuaSnip sobre-escribiendo los snippets usando `key`.

### B. `lua/arttexsnippets/init.lua`
**Función:** La puerta de entrada para Lazy.nvim o configuraciones de usuario.
- Crea el `augroup` que captura los eventos `FileType tex, markdown`.
- Expone `setup(opts)`, permitiendo al usuario inyectar la opción `use_treesitter = true`.
- Delega el trabajo pesado a `core/engine.lua`.

### C. `lua/arttexsnippets/core/engine.lua`
**Función:** El "Cerebro" de recolección de snippets.

* `_snippets(is_math, not_math)`:
  1. Recorre e invoca todos los módulos en la carpeta `math/` de forma estática.
  2. Ejecuta un `vim.fs.dir()` sobre la ruta absoluta de la carpeta `custom/`. Por cada archivo `.lua` encontrado, le hace `require()` y extrae las listas `autosnippets` y `normalsnippets`.
  3. Junta ambas tablas en una lista maestra.

* `setup_tex(is_math, not_math)`:
  Llama a `_snippets()`, inyecta el archivo `math_i` y finalmente usa la API de LuaSnip: `ls.add_snippets("tex", table, { key = "arttex_normal" })`. El atributo `key` es fundamental para que el "Hot-Reload" sobrescriba la memoria en vez de duplicar los atajos.

### D. `lua/arttexsnippets/util/utils.lua`
**Función:** Evaluadores de Contexto de Neovim (Reemplazo total de VimTeX).

* `M.is_math(treesitter)`:
  Si `treesitter` está activo, delega a `ts_utils.in_mathzone()`. 
  Como mecanismo de resiliencia total, si Treesitter falla o no está instalado, lee el identificador sintáctico nativo de Vim bajo el cursor usando `vim.fn.synID()` y evalúa si su highlight group contiene la palabra `"Math"`. Es instantáneo y no requiere dependencias.

* `M.env(name)`:
  Utiliza el motor de expresiones regulares nativas de C de Neovim mediante `vim.fn.searchpair('\\begin{' .. name .. '}', '', '\\end{' .. name .. '}', 'bW')` para detectar de manera exacta si el cursor se encuentra enclaustrado dentro del bloque específico proporcionado (ej. matrix, align).

### E. `lua/arttexsnippets/ui.lua`
**Función:** Presentación Visual del Gestor de Snippets.
- `M.open_manager()`: 
  Resuelve la ruta física del plugin usando la función de introspección de Lua: `debug.getinfo(1, "S").source`.
  Llama al módulo `arttexworkspace.ui.menu_builder` para renderizar ventanas flotantes con el diseño del usuario. Se encarga de manejar la escritura de la plantilla por defecto (`io.open`) si el usuario solicita crear un nuevo archivo de snippets.

---

## 3. Escalabilidad

Gracias a la lectura dinámica implementada en `engine.lua`, el plugin tiene escalabilidad infinita:
Si se desea añadir un nuevo soporte o archivo al sistema, no se necesita tocar el código base del plugin. Cualquier script que resida en la carpeta `custom/` y respete el contrato de retornar `M.retrieve()` será asimilado por el ecosistema de forma automática en el próximo reinicio o al ejecutar `:w`.
