# Registro Episódico de Hitos

- **Fecha:** 2026-07-04
- **Problema / Hito:** Migración e inicialización del subagente `neovim_expert` siguiendo estrictamente la arquitectura modular definida en `/home/userh/Documents/estructuraIA`.
- **Decisión Tomada:** Se copió el directorio boilerplate `.agents/` hacia `~/.config/nvim/` y se configuró la Skill `neovim_expert` con reglas para mantener la consciencia arquitectónica. Se estableció el registro de memoria en `EPISODIC.md` como mandato operativo primario.

- **Fecha:** 2026-07-04
- **Problema / Hito:** Instalación de `MeanderingProgrammer/render-markdown.nvim` para renderizado nativo de Markdown.
- **Decisión Tomada:** Se agregó el plugin a `lua/plugins/init.lua` con dependencias `nvim-treesitter/nvim-treesitter` y `nvim-tree/nvim-web-devicons`. Se invocó su función de setup, aprovechando la compatibilidad óptima con WezTerm (backend kitty) y `image.nvim`.

- **Fecha:** 2026-07-04
- **Problema / Hito:** Instalación de `stevearc/aerial.nvim` para visualizar el outline (sections) del código (soporte de LSP y Treesitter).
- **Decisión Tomada:** Se agregó el plugin a `lua/plugins/init.lua` con dependencias en treesitter y telescope. Se configuró para modo flotante (`default_direction = "float"`) y se cargó su extensión en Telescope. También se configuró el mapeo `<leader>o` en `lua/whichkey-config.lua` llamando a `Telescope aerial`.
