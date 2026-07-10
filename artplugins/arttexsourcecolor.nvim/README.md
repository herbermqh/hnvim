# 🎨 ArtTexSourceColor.nvim

An advanced Neovim plugin focused purely on coloring LaTeX and TeX source code up to the kernel level using Treesitter's Abstract Syntax Tree (AST). Designed for those who write documents, packages (`.sty`), classes (`.cls`), and LaTeX3 `expl3` code.

## ✨ Features
- **Deep AST Parsing**: Unlike regex-based colorizers, this uses Neovim's native Treesitter parser to inject extmarks globally.
- **LaTeX2e & LaTeX3 Support**: Highlights structural components `\newcommand`, `\makeatletter`, `\ExplSyntaxOn`.
- **Kernel Macros**: Safely highlights `@`-macros natively without breaking your flow.
- **Expl3 Code**: Colors modern LaTeX3 variables and macros (containing `_` and `:`).
- **Virtual Text Annotations**: Instantly injects virtual signs like `📖 CHAPTER` or `📌` for visual hierarchy in books and articles.
- **Deep Bracket Coloring**: An inner rainbow engine that detects braces `{}` exceeding 3 levels of depth to help you debug complex macro definitions.

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
