# ArtTexConceal 🎭

ArtTexConceal es un plugin ultra-optimizado para Neovim diseñado para proporcionar una capa visual (Conceal) impecable sobre tus documentos de LaTeX usando Treesitter. Transforma un código fuente abarrotado de comandos complejos en un texto limpio, legible y hermoso, similar al documento final compilado, todo esto en tiempo real.

## 🚀 Características Principales

- **Velocidad Extrema (O(N)):** Escrito desde cero priorizando la eficiencia, con caché de consultas y caché de cálculo estructural para garantizar latencia cero y consumo mínimo de CPU, incluso en documentos inmensos.
- **Soporte Completo de Símbolos:** Oculta cientos de símbolos matemáticos (`\alpha`, `\beta`, `\sum`, `\int`) convirtiéndolos en sus equivalentes reales unicode (α, β, ∑, ∫).
- **Paréntesis y Fracciones Arcoíris (Rainbow Brackets):** Colorea de forma dinámica pares de delimitadores (corchetes, llaves, paréntesis, y fracciones) basándose en su nivel de anidamiento dentro de los entornos matemáticos.
- **Formateo Estilizado de Texto:** Los comandos de formato como `\textbf{}`, `\textit{}`, y `\textsf{}` se ocultan visualmente heredando y respetando los colores dinámicos del documento para prevenir problemas de "sangrado" de color de las secciones.
- **Soporte Estructural:** Ocultamiento de comandos estructurales (ej. `\chapter`, `\section`) y utilidades como `\note`, `\caption` e `\image` decorados con íconos modernos 󰦨, ¶, §.
- **Menú Visual Interactivo:** Integración nativa con `arttexworkspace` para activar y desactivar opciones instantáneamente con propagación en vivo a todos tus documentos abiertos.

## ⚙️ Uso y Configuración

El plugin está pensado para funcionar sin necesidad de configuración exhaustiva (Plug & Play).
Usa la interfaz gráfica visual para controlar sus opciones al instante.

**Comandos disponibles:**
* `:ArtTexConcealToggle` - Activa o desactiva de manera global el ocultamiento.

### Menú Interactivo
Si usas `arttexworkspace`, el plugin expone un menú interactivo. Aquí puedes configurar:
- Cambiar el Tema de colores (Tokyonight, Catppuccin, etc).
- Activar/Desactivar el ocultamiento matemático.
- Activar/Desactivar negrillas, cursivas o fuentes monoespaciadas.

Todos los cambios hechos en el menú persisten automáticamente en `~/.gemini/config` (o la ruta de configuración predeterminada) mediante un archivo JSON, y aplican sus cambios en vivo a todas las pestañas y *splits* de Neovim abiertos.

---

*Para detalles de arquitectura y cómo modificar o expandir este código, por favor consulta el archivo [DEVELOPER.md](./DEVELOPER.md).*
