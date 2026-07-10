# 📚 Guía de Creación de Snippets (ArtTeX)

Este documento te guiará paso a paso sobre cómo estructurar, entender y crear tus propios snippets personalizados para el ecosistema **ArtTeX Snippets**.

## 1. La Interfaz de Creación
Para crear un nuevo archivo de snippets, la forma más rápida y recomendada es utilizar el gestor gráfico incorporado.
Estando en Neovim, ejecuta el comando:
```vim
:ArtTexSnippetsEdit
```
Selecciona `󰐕 Crear Nuevo Módulo` y dale un nombre (por ejemplo: `fisica`). El plugin generará un archivo pre-configurado dentro de `lua/arttexsnippets/custom/fisica.lua`.

## 2. Anatomía de un Archivo de Snippets
Todo archivo de snippets en ArtTeX devuelve una tabla con una función `retrieve(is_math, not_math)`. El motor del plugin llama a esta función y le proporciona las condiciones necesarias para inyectarlos en LuaSnip.

```lua
local ls = require('luasnip')
local parse_snippet = ls.parser.parse_snippet
local utils = require('arttexsnippets.util.utils')
local is_math = utils.with_opts(utils.is_math, true)
local not_math = utils.with_opts(utils.not_math, true)
local line_begin = require('luasnip.extras.conditions.expand').line_begin
local pipe = utils.pipe

-- Utilidad para verificar entornos LaTeX
local function env(name)
  return function() return utils.env(name) end
end

local M = {}

M.retrieve = function(is_math, not_math)
  local autosnippets = {}
  local normalsnippets = {}

  -- AQUÍ VAN TUS SNIPPETS --

  return { autosnippets = autosnippets, normalsnippets = normalsnippets }
end

return M
```

## 3. Tipos de Snippets

Hay dos tablas donde puedes inyectar tus snippets usando `table.insert(tabla, snippet)`.

### A. Normalsnippets (Snippets Manuales)
Requieren que el usuario presione `<Tab>` (o su tecla de confirmación en `nvim-cmp`) para expandirse.
Se guardan en la tabla `normalsnippets`.

**Ejemplo de creación rápida usando `parse_snippet`:**
```lua
table.insert(normalsnippets, parse_snippet(
  { trig = "ali", name = "Entorno Align" },
  [=[\begin{align*}
  $1
\end{align*}$0]=]
))
```

### B. Autosnippets (Expansión Automática)
Se expanden instantáneamente en el momento en el que el usuario teclea el disparador (`trig`). No requieren presionar `<Tab>`.
Se guardan en la tabla `autosnippets`.

**Ejemplo (Fracción automática al escribir `//`):**
```lua
table.insert(autosnippets, parse_snippet(
  { trig = "//", name = "Fraccion", wordTrig = false, condition = is_math },
  [=[\frac{$1}{$2}$0]=]
))
```

## 4. Opciones Especiales (Options / Opts)
Cuando defines un snippet dentro de `parse_snippet({ ... }, "texto")`, puedes pasar ciertas opciones cruciales:

- `trig` (String): El texto que disparará el snippet.
- `name` (String): El nombre que aparecerá en el menú de autocompletado.
- `priority` (Number): Prioridad. Si dos snippets comparten letras, el de mayor prioridad gana. (Por defecto es 0. Puedes usar 1000 para forzarlo, o -50 para bajarle importancia).
- `wordTrig` (Boolean): Si es `true`, el snippet solo se activa si la palabra anterior está separada por un espacio. Si es `false`, puede expandirse pegado a otras letras (Ej: útil para sufijos).
- `trigEngine` (String): Usualmente `"ecma"` o `"vim"` si quieres que el `trig` sea interpretado como una **Expresión Regular (Regex)**.
- `condition` (Function): El snippet solo se expandirá si esta función retorna `true`.

## 5. Condiciones Comunes de ArtTeX
Para que tus snippets no se expandan en los lugares equivocados, `arttexsnippets` provee funciones de validación nativas muy veloces:

* `is_math`: Se expande SOLO si el cursor está dentro de `$ ... $` o entornos como `\begin{equation}`.
* `not_math`: Se expande SOLO si el cursor es texto normal (fuera del modo matemático).
* `env("matrix")`: Se expande SOLO si estás dentro de un `\begin{matrix} ... \end{matrix}`.
* `line_begin`: Se expande SOLO si eres el primer texto en la línea actual.

### Ejemplo de uso de Condición Combinada:
Si quieres que algo solo ocurra al inicio de línea Y en modo matemático, usas la función `pipe`:
```lua
table.insert(autosnippets, parse_snippet(
  { trig = "M", condition = pipe({ line_begin, is_math }) },
  "Snippets mágicos"
))
```

## 6. Hot Reloading (Recarga Mágica)
No necesitas reiniciar Neovim al crear snippets. El plugin incluye un watcher nativo. 
Simplemente crea tu snippet, presiona `:w` para guardar tu archivo `custom/fisica.lua`, ¡y vuelve a tu documento `.tex`! El snippet ya estará funcionando en memoria.
