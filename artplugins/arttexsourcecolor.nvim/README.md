# 🎨 ArtTexSourceColor.nvim

An advanced Neovim plugin focused purely on coloring LaTeX and TeX source code up to the kernel level using Treesitter's Abstract Syntax Tree (AST). Designed for those who write documents, packages (`.sty`), classes (`.cls`), and LaTeX3 `expl3` code.

## ✨ Features
- **Deep AST Parsing**: Uses Neovim's native Treesitter parser to inject extmarks.
- **0-Cost CPU Rendering**: Built on Neovim's `Decoration Providers` (`nvim_set_decoration_provider`), guaranteeing that CPU and RAM usage stays at literally 0% by only executing visual processing on the lines currently visible on the screen.
- **LaTeX2e & LaTeX3 Support**: Highlights structural components `\newcommand`, `\makeatletter`, `\ExplSyntaxOn`.
- **Kernel Macros**: Safely highlights `@`-macros natively.
- **Expl3 Code**: Colors modern LaTeX3 variables and macros (containing `_` and `:`).
- **Virtual Text Annotations**: Instantly injects virtual signs like `📖 CAPÍTULO` or `📌` for visual hierarchy in books and articles.
- **Native Rainbow Delimiters**: Full rainbow bracket architecture out-of-the-box (`{}`, `[]`, `\begin`, `\end`) with exact depth calculation, completely independent of other heavy rainbow plugins.

## 📦 Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "tu-usuario/arttexsourcecolor.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "tex", "sty", "cls", "dtx" },
    config = function()
        require("arttexsourcecolor").setup()
    end,
}
```

## 🚀 Setup
The plugin requires no configuration to run. Just call `setup()` and it will attach to all LaTeX-related buffers automatically!

## 📚 Documentación

Para una guía completa y en profundidad, por favor consulta los manuales en la carpeta `doc/`:

- [📖 Manual del Usuario](doc/01_Manual_Usuario.md) - Aprende a configurar temas, cambiar atajos de teclado y definir tus propios grupos personalizados de colores.
- [🛠️ Manual del Desarrollador](doc/02_Manual_Desarrollador.md) - Documentación arquitectónica, flujos de datos y diagramas de cómo el motor AST logra 0% de latencia.
