# Documentación Privada del Desarrollador - ArtTex Conceal

Esta documentación explica exhaustivamente el diseño, la estructura interna y la arquitectura del plugin `arttexconceal`, orientada exclusivamente para mantenimiento del desarrollador o del sistema de inteligencia artificial que asista en futuras mejoras.

## 1. Arquitectura General
El plugin se divide en tres componentes clave, cada uno con una responsabilidad única, garantizando la filosofía modular:

- `init.lua`: Actúa como punto de entrada público, expone la API y registra los comandos de usuario.
- `core.lua`: Contiene la lógica interna de la API de Neovim y el *Render Cycle* (el motor de `decoration_provider`).
- `symbols.lua`: Archivo de base de datos estática que mapea notaciones LaTeX a caracteres Unicode y grupos de resaltado.

---

## 2. Descripción de Componentes Internos (`core.lua`)

El módulo `core` es el corazón del plugin. Sus principales variables y funciones se describen a continuación:

### Variables de Estado (Privadas/Internas)
- `M.namespace` (entero): El ID del *namespace* generado mediante `vim.api.nvim_create_namespace("arttexconceal")`. Todo extmark virtual que creamos pertenece a este ID, lo que permite control granular sin afectar otros plugins.
- `M.active` (booleano): Indicador del estado del plugin. Si es `false`, las rutinas del decoration provider saldrán prematuramente, evitando consumo inútil de recursos.

### `M.setup_highlights()`
Rutina encargada de proveer estilos fallback si el usuario final no configuró en su tema de color (como Tokyonight o Catppuccin) los highlights custom. Comprueba de forma segura (con `pcall`) si un grupo está vacío y aplica colores base predeterminados.

### Funciones de Ciclo de Vida del Decoration Provider
La optimización más fuerte de este plugin radica en utilizar el API `nvim_set_decoration_provider`. Esto engancha lógica directamente en el ciclo de dibujado (`redraw`) de Neovim, procesando sólo lo que es visible en pantalla.

#### `local function on_win(win, buf, topline, botline)`
Es invocada por Neovim justo antes de renderizar una ventana.
- **Retorno:** Si devuelve `false`, aborta el callback para esa ventana.
- **Validación:** Verifica que `M.active == true` y que el tipo de archivo del buffer es `tex`. De esta forma, evitamos iteraciones innecesarias sobre otras ventanas o paneles.

#### `local function on_line(win, buf, row)`
Es invocada línea por línea sobre el código visible.
- **Optimizaciones Clave:**
  1. Utiliza `string.find(line, "[\\%^_]")` como *fail-fast*. Si la línea no tiene caracteres típicos de inicio de macros o matemáticos, salta el parseo complejo instantáneamente.
  2. Búsqueda *Fast-Path*: Para patrones literales (`symbols.literals`), utiliza `string.find` con el parámetro `plain=true`, lo que desactiva el parseo de regex.
  3. Extmarks Efímeras: Utiliza `ephemeral = true` en `nvim_buf_set_extmark`. Los *extmarks* efímeros se eliminan de memoria automáticamente tras finalizar el cuadro de render, eliminando cualquier tipo de _memory leak_ provocado por crear decoraciones persistentes.
- **Validación Semántica:** Invoca a `utils.in_mathzone(buf, row, col)` del plugin hermano `arttexworkspace`.

---

## 3. Descripción de la API Pública (`init.lua`)

El objeto retornado por `init.lua` exporta un objeto `M.api` de manera explícita (para interoperabilidad con otros plugins) y la función estándar de configuración `setup()`.

### `M.setup(opts)`
- **`opts`** (tabla): Parámetros de configuración inicial. Actualmente soporta `enable_on_startup` (por defecto `true`).
- **Comandos Creados:** Registra `ArtTexConcealEnable`, `ArtTexConcealDisable` y `ArtTexConcealToggle`.

### `M.api`
Expone punteros hacia el `core.lua` para que desarrolladores u otros plugins (ej. scripts Lua de automatización) puedan controlar la visibilidad del conceal programáticamente:
- `M.api.enable()`: Activa el booleano de estado e instancia el `decoration_provider`.
- `M.api.disable()`: Desactiva el booleano de estado y fuerza un `redraw!` en todas las ventanas con bufers `.tex` visibles para limpiar la interfaz.
- `M.api.toggle()`: Función puente para alternar.
- `M.api.is_active()`: Retorna el estado interno (`true`/`false`).

---

## 4. Estructura de la Base de Datos (`symbols.lua`)

La división de los mapeos permite priorizar la eficiencia de CPU:
- **`M.literals`**: Arreglo de tablas `{ pattern = "string", char = "X", hl = "Group" }`. Representan comandos directos como `\frac12` o `\alpha` donde la búsqueda de strings (plain text) es óptima.
- **`M.patterns`**: Arreglo que soporta Regex de Lua (ej. `%^{%s*x%s*}`). Ideal para atrapar agrupaciones dinámicas (superíndices con espacios). La rutina compila y evalúa éstos con la máquina regex normal.
