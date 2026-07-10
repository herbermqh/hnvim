# 👻 ArtTexConceal.nvim

A standalone, GitHub-ready Neovim plugin designed exclusively to manage and toggle magical symbol concealment (Conceal) in LaTeX documents with a single keystroke.

## ✨ Features
- Instantly toggles between raw source code (`\alpha`) and rendered symbols (`α`).
- Upgrades the default gray, dull conceal color to a vibrant, premium purple.
- Window-local highlights, ensuring markdown files remain unaffected.

## 📦 Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "tu-usuario/arttexconceal.nvim",
    ft = { "tex", "sty", "cls", "dtx" },
    config = function()
        require("arttexconceal").setup()
    end,
}
```

## ⌨️ Keybinds
Map `require('arttexconceal').toggle()` in your which-key configuration.
