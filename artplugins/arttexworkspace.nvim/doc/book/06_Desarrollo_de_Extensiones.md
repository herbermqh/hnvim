# Capítulo 6: Desarrollo de Extensiones y Autocompletado

## 6.1 Cómo crear un plugin satélite (Satellite Plugin)
Supongamos que deseas crear `arttex-ai`, un plugin para inyectar sugerencias heurísticas en LaTeX usando IA. No necesitas reescribir un parser. Todo está en la RAM gracias al estado global.

```lua
-- arttex-ai.lua
local workspace = require("arttexworkspace.api")
local state = require("arttexworkspace.core.state")

vim.api.nvim_create_autocmd("User", {
  pattern = "ArtTexWorkspaceReady",
  callback = function(args)
    local main_path = args.data.main_path
    local project = state.get_project(main_path)
    
    -- Inyectar comandos heurísticos para que el autocompletado (arttexcmp) los lea
    state.set_dynamic_macros(main_path, {
      estructura_ia = {
        ["\\generarGrafico"] = { definition = "Macro IA", line = 0 }
      }
    })
  end
})
```

## 6.2 Integración nativa con `nvim-cmp` (`arttexcmp.nvim`)
El motor de autocompletado propio, **arttexcmp**, se conecta a `nvim-cmp` como un "source" personalizado. 

### Flujo de sugerencias en microsegundos:
1. El usuario teclea `\`.
2. El LSP texlab demora en enviar resultados.
3. `arttexcmp` bypasses the LSP by querying `arttexworkspace.core.state` in memory.
4. Devuelve instantáneamente todas las macros y entornos encontrados en los archivos locales, *y* en los paquetes globales parcheados por ripgrep.
5. Los iconos (`kind`) se mapean automáticamente (ej. Icono 📦 para paquetes, ⚡ para comandos).

```mermaid
graph LR
    User[Teclea '\'] --> CMP[nvim-cmp core]
    CMP --> TexLab[LSP Source]
    CMP --> ArtTex[arttexcmp Source]
    ArtTex -->|Lookup O(1)| State[RAM: state.lua]
    State -->|Retorna| ArtTex
    ArtTex -->|Filtro difuso| CMP
```
