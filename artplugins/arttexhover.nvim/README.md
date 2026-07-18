# ArtTeX Hover

ArtTeX Hover es un plugin ultraligero y de alto rendimiento para Neovim diseñado específicamente para el ecosistema LaTeX. Proporciona ventanas flotantes emergentes (hovers) inteligentes que previsualizan instantáneamente el contenido de tus citas bibliográficas, referencias cruzadas y paquetes, garantizando un consumo mínimo de recursos (0% impacto de CPU y RAM).

## 🚀 Características Principales

- **Auto-Hover Inteligente**: Simplemente posiciona el cursor sobre comandos como `\cite{}` o `\ref{}` y aparecerá automáticamente una ventana flotante con el contenido original de la referencia o cita.
- **Optimización Extrema**: Utiliza la librería C nativa de Neovim (`libuv`) para un sistema de caché basado en marcas de tiempo (`mtime`). Solo escanea archivos de disco si han sido modificados; en caso contrario, los sirve instantáneamente desde la memoria.
- **Independiente de Treesitter y Markdown**: Renderiza tu código utilizando el motor de resaltado clásico (Regex C-core) nativo de Neovim (`syntax=tex`). Esto elimina los costosos parseos en vivo y los posibles fallos (crashes) asociados con gramáticas de Treesitter desincronizadas.
- **Agnóstico al Proyecto**: Se integra nativamente con `arttexworkspace` para entender la arquitectura de tu proyecto (sea un documento plano, o una tesis anidada compleja).
- **Personalización Visual**: Incluye un menú interactivo visual (`ArtHoverConfig`) construido bajo la misma interfaz limpia y homogénea del ecosistema ArtTeX.

## 📦 Dependencias

- **[arttexworkspace.nvim]**: Motor base que provee la topología del proyecto y la API para menús de UI.
- **Neovim >= 0.9.0**

## ⌨️ Comandos y Atajos

El plugin ya se encuentra integrado globalmente en el sistema de atajos (Which-Key) del ecosistema bajo la letra "l" (LaTeX):

| Atajo | Comando Neovim | Acción |
| --- | --- | --- |
| `<leader>lH` | `:ArtHoverConfig` | Abre el menú visual interactivo de configuración (Permite activar/desactivar el Auto-Hover globalmente y gestionar los triggers). |

Además, tienes el comando manual `:ArtTexHover` disponible por si en algún momento deseas desactivar el comportamiento automático (CursorHold) y mapear el hover de forma manual en tus atajos personales.

## 🛠 Configuración (UI y Archivo JSON)

El plugin funciona *Out of the Box*. Sin embargo, puedes personalizar qué comandos activan las previsualizaciones de Citas o Referencias presionando `<leader>lH`. 

Todas las configuraciones (incluyendo el estado global del Auto-Hover y tus listas de macros personalizadas) se guardan automáticamente y de forma persistente en:
`~/.config/nvim/arttexhover_config.json`

## ⚙️ Macros soportadas por defecto

- **Citas**: `\cite`, `\parencite`, `\footcite`, `\textcite`, `\smartcite`, `\autocite`
- **Referencias**: `\ref`, `\eqref`, `\autoref`, `\nameref`, `\pageref`, `\cref`, `\Cref`
- **Paquetes**: `\usepackage`, `\RequirePackage`

Si usas un comando personalizado en tu preámbulo (ej. `\micitapersonalizada{}`), solo tienes que agregarlo desde el menú visual de configuración.
