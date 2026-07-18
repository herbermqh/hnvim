# ArtTex Conceal 🎨

**ArtTex Conceal** es un plugin moderno y de alto rendimiento para Neovim diseñado específicamente para el ecosistema ArtTex. Su objetivo es reemplazar de manera eficiente los comandos y notaciones matemáticas de LaTeX por símbolos Unicode atractivos y coloreados, sin impactar el rendimiento del editor.

## Características ✨

- **Alto Rendimiento:** Utiliza `nvim_set_decoration_provider`, lo que significa que el procesamiento solo se ejecuta sobre la parte visible de tu pantalla, garantizando cero latencias (0 CPU spikes, uso nulo de memoria permanente).
- **Integración con Treesitter:** Aprovecha de forma transparente las capacidades de `arttexworkspace` para validar que los reemplazos ocurran únicamente dentro de zonas matemáticas válidas.
- **Base de Datos Masiva:** Soporta miles de conceals incluyendo alfabetos (`\mathbb`, `\mathcal`), letras griegas, fracciones (`\frac12`), modificadores (`^2`, `_i`) y muchos más.
- **Sistema de Temas Dinámico:** Permite cambiar el color de todos los símbolos sobre la marcha usando temas precargados (Tokyonight, Catppuccin, Dracula, Nord, Onedark).
- **Comportamiento Dinámico (Anti-conceal):** El plugin desactiva automáticamente el conceal en la línea actual donde se encuentra el cursor (tanto en modo normal como insertar), permitiéndote editar el texto original cómodamente sin que los símbolos visuales estorben.
- **Conceals Personalizados:** Posibilidad de inyectar tus propios reemplazos con comandos a medida, restringiendo si deben funcionar solo en modo matemático o texto.
- **Sincronización:** Se sincroniza automáticamente con el tema global de `arttexsourcecolor` si lo tienes instalado.

## Instalación 📦

El plugin es parte de la suite `artplugins`. Asegúrate de cargarlo apuntando a la carpeta `/home/userh/.config/nvim/artplugins/arttexconceal.nvim`.

## Uso y Comandos 🚀

El plugin se inicializa con la llamada a la función de setup:

```lua
require("arttexconceal").setup({
    enable_on_startup = true,
    theme = "tokyonight", -- Tema por defecto si arttexsourcecolor no está activo
    themes = {
        -- Puedes inyectar y modificar temas propios aquí
        mi_tema = {
            ArtTexConcealMath = { fg = "#ff0000" }
        }
    },
    custom_symbols = {
        -- Puedes crear tus propios conceals aquí
        { pattern = "\\mycmd", char = "❄", hl = "ArtTexConcealMath", is_regex = false, env = "math" },
        { pattern = "\\textemoji", char = "😎", hl = "ArtTexConcealSpecial", is_regex = false, env = "text" },
        -- 'env' puede ser "math", "text", o nil (se aplica siempre)
    }
})
```

### Comandos de Usuario
- `:ArtTexConcealMenu`: **(RECOMENDADO)** Abre el menú principal donde puedes cambiar el tema en caliente, activar/desactivar globalmente o desactivar únicamente el conceal matemático.
- `:ArtTexConcealEnable`, `:ArtTexConcealDisable`, `:ArtTexConcealToggle`.

#### Configuración de Which-Key sugerida
Puedes vincular el menú de control global a tu atajo `<leader>lOC` en tu configuración principal de atajos:
```lua
vim.keymap.set("n", "<leader>lOC", "<cmd>ArtTexConcealMenu<CR>", { desc = "Menú ArtTex Conceal" })
```

## Grupos de Resaltado (Highlights) 🎨
El plugin expone varios grupos de resaltado que son inyectados automáticamente por el gestor de temas:
- `ArtTexConcealMath`: Símbolos y operadores matemáticos.
- `ArtTexConcealMathbb`: Letras de pizarra (`\mathbb`).
- `ArtTexConcealMathsf`: Fuentes sans-serif (`\mathsf`).
- `ArtTexConcealMathfrak`: Fuentes Fraktur (`\mathfrak`).
- `ArtTexConcealMathcal`: Fuentes caligráficas (`\mathcal`).
- `ArtTexConcealFrac`: Símbolos de fracciones (ej. `½`, `¾`).
- `ArtTexConcealSuper`: Símbolos de superíndices.
- `ArtTexConcealSub`: Símbolos de subíndices.
- `ArtTexConcealSpecial`: Puntuación y espaciados especiales.

¡Disfruta de una escritura de LaTeX fluida y visualmente atractiva!
