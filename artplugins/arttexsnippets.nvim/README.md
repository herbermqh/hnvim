# 🌟 ArtTeX Snippets (`arttexsnippets.nvim`)

El gestor de Snippets para LaTeX más rápido, inteligente y personalizable del ecosistema Neovim. 
Construido sobre LuaSnip y Treesitter, con una **caché de evaluación extrema** que garantiza un rendimiento ultra-veloz sin importar cuántos miles de snippets tengas cargados.

## ✨ Características Principales
- **Zero Lag (Caché de Memoización):** Consume `O(1)` recursos de CPU por pulsación de tecla, sin importar si tienes 100 o 5,000 snippets matemáticos automáticos evaluando el AST de Treesitter.
- **Expansiones Automáticas (Auto-Expanding):** Escribe `//` y obtén instantáneamente `\frac{|}{}`, escribe `==` y obtén `&=`, sin presionar `Tab`.
- **Ecosistema Interactivo (UI):** Interfaces gráficas flotantes para buscar, crear, editar y configurar snippets en tiempo real sin salir de tu código ni reiniciar Neovim.

## 🚀 Instalación y Configuración Base

Si usas **Lazy.nvim**, puedes instalar el plugin con la configuración "Zero-Config" (Por defecto cargará todo tu ecosistema):

```lua
{
  "usuario/arttexsnippets.nvim",
  dependencies = { "L3MON4D3/LuaSnip" },
  config = function()
    require("arttexsnippets").setup()
  end
}
```

## ⚙️ Configuración Avanzada (Opciones Modificables por el Usuario)

El plugin fue diseñado para darte control absoluto sobre lo que se carga en tu memoria RAM. 
Al llamar al plugin (en tu `plugins-config.lua` o archivo de Lazy), puedes pasarle este bloque de opciones para sobreescribir el comportamiento predeterminado:

```lua
require("arttexsnippets").setup({
  
  -- 1. Módulos de Carga
  load_core_math = true,      -- Carga los automáticos matemáticos base (estilo Gilles Castel)
  load_custom = true,         -- Carga módulos propios (general, algebra, quimica)
  load_project_local = true,  -- Carga dinámicamente '.arttex/snippets/' del proyecto actual
  
  -- 2. Detección Sintáctica
  use_treesitter = true,      -- 'false' usa Regex/SynID (nativa). 'true' usa AST (Treesitter)
  allow_on_markdown = true,   -- Inyecta los snippets matemáticos en archivos .md y .qmd
  
  -- 3. Lista Negra (Blacklist) Ultra-específica
  -- Pon en 'true' cualquier archivo individual que NO quieras cargar en memoria.
  disabled_modules = {
    -- ["math_iA"] = true,     -- (Apaga fragmentos específicos del Core)
    -- ["quimica"] = true,     -- (Apaga fragmentos específicos tuyos)
  }
})
```
*Cualquier opción que omitas usará su valor predeterminado (Activado).*

## 🪄 Comandos Integrados (Atajos)

Puedes mapear en tu gestor favorito (como `which-key`) los siguientes comandos interactivos:
* `:ArtTexSnippetsSearch` ➔ Abre un buscador **Telescope** para previsualizar instantáneamente el código generado por cualquiera de tus cientos de snippets.
* `:ArtTexSnippetsEdit` ➔ Abre el menú flotante para **Crear / Editar** archivos de snippets, o usar el **Generador Visual Rápido** que inyecta código Lua por ti.
* `:ArtTexSnippetsConfig` ➔ Abre el panel de control avanzado para activar/desactivar las configuraciones (Core, Custom, Lista Negra) **en caliente** y limpiar LuaSnip al instante.

> Todo cambio que hagas mediante `:ArtTexSnippetsEdit` es recargado automáticamente en memoria al guardar (`Hot-Reload`), para que nunca pierdas tu flujo creativo.
