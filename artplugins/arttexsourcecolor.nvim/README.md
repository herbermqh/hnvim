# ArtTex SourceColor 🎨

ArtTex SourceColor es un sistema de resaltado semántico y coloreado contextual altamente dinámico para documentos de LaTeX en Neovim. Más que colorear sintaxis plana, el plugin se comunica en tiempo real con la infraestructura de tu proyecto y analiza el contexto estructural, dibujando referencias, validando variables y aplicando colores con inteligencia.

## ✨ Características Especiales

- **Resaltado Semántico Instantáneo:** Utiliza las nuevas API visuales de bajo nivel en Neovim (Decoration Providers) para aplicar colores que siguen los desplazamientos de la pantalla en tiempo real (60 FPS sin retraso).
- **Entornos y Bloques Inteligentes:** Detecta y pinta entornos de Teoremas, Cajas y Bloques matemáticos usando colores semánticos, reaccionando a la configuración de `arttexworkspace`.
- **Validación de Referencias y Texto Virtual:**
  - Si escribes `\ref{eq:inexistente}`, instantáneamente aparecerá un texto virtual tachado (❌ No hallado).
  - Los comandos como `\chapter` o `\section` se enriquecen con marcadores virtuales de colores al final de la línea.
- **Detección Efímera de Errores Sintácticos:** Errores como etiquetas no cerradas resaltarán temporalmente su línea o porción relevante para llamar tu atención, filtrando ruidos y paquetes falsos.
- **Paréntesis Arcoíris (Visual):** Acompañando a `arttexconceal`, este plugin también colorea dinámicamente entornos, delimitadores y corchetes en base a su nivel exacto de profundidad recursiva y matemática.
- **Match-Paren Semántico:** Resalta los entornos `\begin` y `\end` de manera emparejada visualmente basándose puramente en la jerarquía del AST.

## ⚙️ Uso y Configuración

Usa la interfaz gráfica visual para controlar este motor en tiempo real.

**Comandos disponibles:**
* `:ArtSourceColorConfig` - Abre un menú interactivo usando tu interfaz configurada por defecto de Neovim/ArtTex.
* `:ArtSourceColorSync` - Sincroniza explícitamente y fuerza un refresco de información visual extraída de `arttexworkspace`.

### Menú Interactivo
El menú interactivo te permite desactivar globalmente cualquier función sin recargar Neovim. Todas las desactivaciones borran instantáneamente todo su contexto visual asociado en todos los búferes abiertos simultáneamente.

---

*Para detalles de arquitectura de integración con Neovim y desarrollo interno, consulta el archivo [DEVELOPER.md](./DEVELOPER.md).*
