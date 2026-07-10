# ArtTeX Preview 🎨✨

**ArtTeX Preview** es un plugin altamente optimizado para Neovim diseñado específicamente para el ecosistema LaTeX. Proporciona una previsualización dinámica, en tiempo real y no intrusiva de ecuaciones matemáticas e imágenes directamente en el editor.

## ✨ Características Principales

*   **⚡ Ultra-rápido (Zero-Lag):** Construido sobre la potente API de **Treesitter**. El plugin sabe exactamente dónde estás sin necesidad de escanear el archivo entero, asegurando un consumo de CPU prácticamente nulo y cero parpadeos al mover el cursor.
*   **🧮 Previsualización Matemática Elegante:** Transforma el código LaTeX oscuro en ecuaciones hermosamente renderizadas en una ventana flotante lateral, cortesía de la integración con `nabla.nvim`.
*   **🖼️ Soporte de Imágenes Preparado:** Arquitectura lista para inyectar previsualizadores de imágenes interactivos.
*   **🎛️ Menú Interactivo de Configuración:** Cambia los ajustes al vuelo con un hermoso menú de opciones emergente.
*   **💤 Totalmente Perezoso (Lazy-Ready):** Por defecto, todas las opciones pesadas nacen apagadas para que decidas cuándo encenderlas sin ralentizar tu arranque de Neovim.

## 📦 Instalación

Recomendamos usar `lazy.nvim`. Añade este bloque a tu archivo de configuración (ej. `~/.config/nvim/lua/plugins/init.lua`):

```lua
return {
  {
    dir = vim.fn.stdpath("config") .. "/artplugins/arttexpreview.nvim", 
    ft = "tex", 
    dependencies = { 
      "jbyuki/nabla.nvim", 
      "arttexworkspace" -- Opcional: Requerido si deseas usar el menú interactivo
    },
    config = function() 
      require("arttexpreview").setup({
        auto_math = false,   -- Cambiar a true para previsualizar fórmulas automáticamente
        auto_image = false   -- Cambiar a true para imágenes
      }) 
    end 
  }
}
```

## 🚀 Uso

### El Menú Interactivo
Una vez dentro de un archivo `.tex`, puedes presionar:
`<leader>lp` (Leader + L + P)
Esto abrirá el **Menú de Configuración de ArtTeX Preview**. Desde aquí puedes alternar (encender/apagar) la previsualización de matemáticas o imágenes con solo un "Enter", sin tocar el código.

### Previsualización Matemática (Automática)
Si activaste `auto_math`, simplemente **coloca tu cursor sobre cualquier entorno matemático** (`\begin{equation}`, `\begin{align}`, `$$...$$`, `\[...\]`).
Una ventana flotante elegante y con bordes curvos aparecerá silenciosamente a tu derecha con la ecuación renderizada. Tan pronto como tu cursor salga de la fórmula, la ventana desaparecerá sola sin estorbar tu vista.

## 🛠️ Personalización Avanzada

Si prefieres sobrescribir el comportamiento por defecto directamente por código, la función `setup` acepta las siguientes variables en su diccionario de opciones:

| Opción | Tipo | Por Defecto | Descripción |
| :--- | :--- | :--- | :--- |
| `auto_math` | `boolean` | `false` | Activa el renderizado de ecuaciones matemáticas en ventana flotante al posar el cursor. |
| `auto_image` | `boolean` | `false` | (Experimental) Activa el hook para previsualizar comandos como `\includegraphics`. |
