# Capítulo 8: Navegación Inteligente y Súper Heurísticas

ArtTeX no solo lee archivos y extrae macros estáticas; emplea un motor de resolución difuso (Fuzzy Fallback) extremadamente avanzado para resolver casos en los que LaTeX utiliza macros altamente dinámicos y dependientes del contexto.

## 8.1 Go to Definition (`gd`) Resiliente

La función nativa `<cword>` de Vim/Neovim para extraer la palabra bajo el cursor falla por defecto en proyectos LaTeX complejos porque símbolos especiales como `@` o `_` (comunes en archivos `.sty` o `.cls`) no se consideran parte de la palabra. 
Por ejemplo, intentar un `gd` sobre `\@section@theory` fallaría nativamente porque Vim capturaría solamente `section`.

Para solucionar esto, `arttexworkspace` secuestra temporalmente la acción y despliega el algoritmo **`get_macro_under_cursor`**:
1. Escanea bidireccionalmente la línea actual partiendo del cursor.
2. Identifica cualquier cadena conectada que contenga `[a-zA-Z@_]`.
3. Extrae la macro original evadiendo el backslash inicial y asegurando un salto de definición del 100% de precisión.

### Parsing Exhaustivo (Soporte Multi-Sintaxis)
El motor semántico ya no se limita al anticuado `\newcommand`. El Árbol Sintáctico (AST) en RAM mapea instantáneamente:
- Declaraciones dinámicas y alias: `\let\image\@imagebody\relax`
- Primitivas puras de TeX: `\def\macro{...}`
- Ecosistema moderno (`xparse`): `\NewDocumentCommand`, `\DeclareDocumentCommand`
- Comandos sin encapsulamiento: `\newcommand\mivector` (sin llaves en el target).
- Paquetes modulares gigantes: Soporte profundo para dependencias añadidas usando `\import{dir}{file}` y `\subimport`.

## 8.2 Global Ripgrep Fallback para Archivos Dinámicos (`gf`)

Uno de los mayores retos de la indexación estática es lidiar con código LaTeX cuyo path se define en **tiempo de ejecución**. 

**El Problema:**
Imagina un macro de imagen dinámica: 
```tex
\def\rootimage{../problems-book/IMAGES-TEORIA}
\let\image\@imagebody
```
Si el usuario coloca el cursor sobre `\image{71-1}` e intenta saltar a la imagen (`gf`), el sistema colapsaría porque el path `../problems-book/.../71-1.png` depende del entorno actual y no puede evaluarse estáticamente.

**La Solución de ArtTeX:**
El plugin implementa una **Búsqueda Global Extrema**:
1. El analizador intercepta `gf` sobre `\image{71-1}`. Al notar que `image` es una macro que desconoce la ruta final de `71-1`, descarta la evaluación TeX bloqueante.
2. Invoca automáticamente una heurística a nivel de Sistema Operativo usando `ripgrep`:
   ```bash
   rg --files -g '**/*71-1*' /ruta/del/proyecto
   ```
3. Ripgrep barre iterativamente la jerarquía completa del proyecto en 2 milisegundos y encuentra el objetivo escondido (ej. `IMAGES-TEORIA/71-1.pdf`).
4. Si el `basename` coincide, se asume que es el archivo de la macro y Neovim lo abre o lo despliega en el menú flotante para el usuario.
5. El sistema *aprende* el patrón (Machine Learning ligero en el archivo `.arttex.json`) asegurando que el próximo salto a `\image{...}` sea instantáneo.

## 8.3 Integración con Visores del Sistema Operativo (External Asset Viewer)

El comando nativo `gf` en Neovim intenta abrir el archivo resultante volcando su contenido crudo (texto o binario) en el buffer actual. Esto es inútil cuando la heurística logra interceptar exitosamente un archivo multimedia asociado a LaTeX (por ejemplo, gráficas vectoriales o imágenes exportadas).

Para resolver esto, ArtTeX cuenta con un interceptor nativo (`open_file` hook) implementado dentro de la lógica de resolución `gf`:
- Una vez que la Super Heurística (o el caché directo) resuelve exitosamente una ruta, el plugin evalúa su extensión.
- Si el archivo resultante tiene extensión **multimedia o de gráficos** (`.pdf`, `.png`, `.jpg`, `.jpeg`, `.eps`, `.svg`, `.gif`), se aborta la inyección binaria al buffer.
- El plugin despliega una notificación y despacha la ruta directamente al **visor predeterminado del Sistema Operativo** en segundo plano (usando `xdg-open` en Linux / `open` en macOS, soportado nativamente vía `vim.ui.open` y `vim.fn.jobstart`).
- El usuario podrá saltar desde el código fuente `\image{71-1}` a la previsualización directa del documento `71-1.pdf` en Zathura (o su visor preferido) sin congelar ni manchar su entorno Neovim.

## 8.4 Arquitectura Abierta de Manejo de Medios (Hook System)

Aunque el comportamiento universal de abrir el visor del sistema operativo es útil para el 99% de los usuarios, los proyectos LaTeX avanzados suelen tener flujos de trabajo de edición fuertemente acoplados. ArtTeX no interfiere con estos flujos, sino que ofrece una API de configuración (`media_handlers`) para inyectar flujos de trabajo personalizados (Hooks).

### Escenario 1: Flujo de Trabajo Universal (Por Defecto)
Si un usuario no configura nada, al presionar `gf` sobre `\imagebody{mi_imagen}`, la IA resuelve que `mi_imagen.pdf` es el activo correspondiente y se lanza `xdg-open` (o `open` en macOS).

### Escenario 2: Edición de código fuente en lugar de visor (Adobe Illustrator)
Si un usuario administra sus imágenes a través de un módulo de Python que compila/edita desde Adobe Illustrator, puede configurar ArtTeX para que le ceda el control de archivos `.pdf`:

```lua
-- En tu init.lua (Configuración personal de Neovim)
require("arttexworkspace").setup({
  media_handlers = {
    pdf = function(path)
      local line = vim.api.nvim_get_current_line()
      local current_file = vim.api.nvim_buf_get_name(0)
      
      -- Construye el comando hacia el módulo personalizado (Ej: illustrator-figures)
      local cmd = string.format("!python -m illustrator-figures crear-editar %s %s",
        vim.fn.shellescape(line), vim.fn.shellescape(current_file))
      
      vim.cmd("silent execute " .. vim.fn.string(cmd))
      vim.notify("Abriendo Illustrator...", vim.log.levels.INFO)
    end
  }
})
```

### Escenario 3: Edición directa de Vectores (Inkscape)
Para usuarios que generan figuras `.svg` o matemáticos usando `inkscape-figures`, el hook puede usarse para saltar directamente a la mesa de trabajo de Inkscape en lugar de abrir el visualizador de imágenes:

```lua
require("arttexworkspace").setup({
  media_handlers = {
    svg = function(path)
      vim.fn.jobstart({ "inkscape", path }, { detach = true })
    end
  }
})
```

Esta arquitectura garantiza que el núcleo de navegación (`goto_file`) siga siendo universal y agnóstico, pero se convierta en una plataforma de lanzamiento extremadamente flexible para los flujos de trabajo de cada usuario.
