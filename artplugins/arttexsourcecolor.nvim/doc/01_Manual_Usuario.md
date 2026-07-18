# 📖 Manual del Usuario - ArtTex SourceColor

¡Bienvenido a la documentación oficial de **ArtTex SourceColor**! Este plugin de Neovim ha sido diseñado desde cero para brindarte el motor de coloreado semántico más rápido y avanzado para LaTeX. A diferencia de las expresiones regulares tradicionales que congelan el editor, este plugin utiliza el motor interno de **Treesitter** (Abstract Syntax Tree) para comprender estructuralmente tu código y colorearlo en tiempo real consumiendo 0% de CPU.

---

## 🎨 Características Principales

1. **Rainbow Brackets Nativos (Paréntesis Arcoíris):** Colorea jerárquicamente todos tus grupos `{...}`, `[...]` y entornos `\begin{...}` / `\end{...}` para que nunca te pierdas cerrando una llave.
2. **Entornos Semánticos Visuales:** Resalta automáticamente todo el bloque interior de teoremas, corolarios o ecuaciones matemáticas con un fondo oscuro sutil para diferenciarlos del texto normal.
3. **Validación de Código en Tiempo Real (Linter Visual):** 
   - Líneas rojas onduladas si cometes errores de sintaxis en LaTeX.
   - Referencias (`\ref`, `\cite`) en rojo si apuntan a un origen inexistente en tu proyecto.
4. **Texto Virtual Integrado:** Etiquetas inyectadas al final de la línea que te muestran visualmente el contenido de comandos estructurales (ej. `📖 CAPÍTULO`) o la ruta completa de las imágenes incluidas con `\includegraphics`.
5. **Coloreado de Macros Kernel y Expl3:** Desarrolla tus propios paquetes con un resaltado especial e inteligente de variables como `\makeatletter`, `\c@chapter`, y sintaxis moderna de LaTeX3 (`\cs_new:Npn`).
6. **Integración con tu Workspace:** Si usas `arttexworkspace`, los colores detectarán automáticamente todas tus macros y entornos declarados a nivel proyecto.

---

## 🚀 Accediendo al Menú de Configuración

Para personalizar el comportamiento del plugin al instante (sin necesidad de reiniciar Neovim), simplemente utiliza la paleta de comandos o tu atajo de teclado:

```vim
:ArtSourceColorConfig
```

> **Atajo en tu familia LaTeX:** Puedes presionar `<leader>lOs` (`leader` + `l` + `O` + `s`).

Desde esta hermosa interfaz (acorde a todo el ecosistema ArtTeX) podrás:
- Apagar o encender el coloreado por completo.
- Alternar (Toggle) de cada función visual individualmente (Rainbow brackets, validación de errores, texto virtual, etc).
- 🎨 **Cambiar Tema:** Elegir entre temas premium optimizados (`tokyonight`, `catppuccin_mocha`, `gruvbox_dark`, `nord`) y aplicarlos instantáneamente.
- Restablecer tu configuración de fábrica si sientes que rompiste algo.

---

## 🔧 Grupos Personalizados (Custom Groups)

Puedes crear tus **propias familias de comandos** y asignarles el color, negrita o cursiva exactos que tú desees. Esta es la función más poderosa para un control total.

Todo se almacena en el archivo global JSON de configuración: `~/.config/nvim/arttexsourcecolor_config.json`. Si no lo tienes, puedes crearlo manualmente.

**Ejemplo de cómo crear tus propios grupos:**

```json
{
  "theme_name": "tokyonight",
  "custom_groups": [
    {
      "name": "ComandosMatematicos",
      "color": "#ff00ff",
      "bold": true,
      "italic": false,
      "commands": ["\\sin", "\\cos", "\\tan", "\\lim"]
    },
    {
      "name": "MisMacrosEspeciales",
      "color": "#00ffcc",
      "bold": false,
      "italic": true,
      "commands": ["\\miComandoA", "\\miComandoB"]
    }
  ]
}
```

*Nota: Asegúrate de escapar las barras invertidas en el JSON (usa `\\` para representar un solo `\`).*
Una vez que modifiques y guardes este JSON, abre tu menú `<leader>lOs` y presiona **"Restablecer"** o cambia de tema para que el motor recargue tu archivo instantáneamente.

---

## 📂 Comportamiento Inteligente con Paquetes (.sty, .cls)

Si te dedicas a programar paquetes de LaTeX (y tus archivos se encuentran dentro de tus directorios `library_paths` del Workspace), el plugin detectará automáticamente que estás en un "código fuente de desarrollo" e ignorará los errores sintácticos estrictos que Treesitter marca típicamente en macros complejas de LaTeX2e y Expl3.

---

## 🤝 Soporte
Si el plugin deja de colorear, o el resaltado se corrompe por una sobreescritura externa, siempre puedes forzar la resincronización visual presionando:
```vim
:ArtSourceColorSync
```
