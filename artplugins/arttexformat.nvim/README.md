# 📝 ArtTeX Format

**ArtTeX Format** es un formateador de código y gestor de indentaciones de altísimo rendimiento para el ecosistema LaTeX en Neovim. Combina la inmediatez de la evaluación nativa en tiempo real (Lua puro) con el poder de un formateador completo de fondo (`latexindent`), consumiendo 0% de CPU en tu escritura diaria.

---

## 🚀 Características Principales

1. **Estrategia Dual de Rendimiento:**
   - **Tiempo Real:** Mientras escribes, el motor ultraligero de Lua ajusta instantáneamente la sangría al abrir entornos o ecuaciones. Cero latencia.
   - **Formateo Profundo:** Al presionar un atajo o guardar, se ejecuta `latexindent` de fondo para alinear matrices, tablas complejas y limpiar espacios vacíos masivos.
2. **Totalmente Asíncrono:** Emplea hilos C-core de Neovim (`vim.uv.spawn`). Formatear un archivo de miles de líneas jamás congelará tu pantalla.
3. **Independencia de Proyectos:** El código se inyecta desde la memoria (tuberías stdin/stdout), lo que significa que el plugin funciona de forma impecable sin importar en qué carpeta o subcarpeta profunda de tu sistema te encuentres.
4. **Protección Anti-Escritura (Race Conditions):** Si tecleas código *mientras* el plugin está formateando de fondo, el plugin detectará el cambio y cancelará su propia inyección para no sobreescribir tus nuevas ideas.

---

## 🛠 Requisitos

El formateador profundo requiere **latexindent**. Generalmente, viene preinstalado si tienes TeX Live completo en tu sistema. Si no lo tienes, instálalo vía:

```bash
# Ubuntu / Debian
sudo apt install texlive-extra-utils

# Arch Linux (incluido en texlive-core o texlive-binextra)
sudo pacman -S texlive-binextra
```

---

## ⌨️ Atajos y Comandos

El plugin se acopla de manera automática a tu panel **Which-Key** dentro de la familia LaTeX (`<leader>l`).

| Atajo | Acción | Comando Equivalente |
| --- | --- | --- |
| `<leader>lf` | Formatear el archivo completo usando `latexindent`. | `:ArtTexFormat` |
| `<leader>lF` | Abre el menú flotante para encender/apagar funciones. | `:ArtFormatConfig` |
| `<leader>lr` | Abre directamente el archivo `.yaml` con tus reglas de estilo para editarlas en vivo. | `:ArtFormatEditRules` |

---

## ⚙️ Reglas de Formateo y Configuración

El plugin está conectado por defecto a tu propio ecosistema en:
`~/.config/nvim/artplugins/arttexformat.nvim/setting_latexindent.yaml`

Cualquier cambio que realices en ese archivo de reglas (como decidir si los tabuladores valen 2 espacios o si los ampersands de una matriz `&` deben alinearse en bloque) se reflejará **al instante** la próxima vez que presiones `<leader>lf`. ¡No es necesario reiniciar Neovim!

### Auto-Formato al Guardar
Desde el menú de configuración (`<leader>lF`), puedes activar el Auto-Formato. Cada vez que guardes tu documento (`:w`), el plugin estructurará todo silenciosamente por detrás y volverá a guardar sin interrumpir tu escritura.
