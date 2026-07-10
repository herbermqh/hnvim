# Documentación para Desarrolladores (Arquitectura ArtTeX Preview)

Bienvenido a la documentación técnica de **ArtTeX Preview**. Esta guía está diseñada para que cualquier desarrollador pueda entender la arquitectura del plugin, cómo interactúan sus módulos y cómo puede escalarse en el futuro.

## 🏗️ Arquitectura del Plugin

El plugin fue reestructurado para separar claramente la lógica central (core) de las interfaces de usuario (ui) y la configuración (config). Esta separación de preocupaciones (SoC - Separation of Concerns) hace que el plugin sea modular y altamente escalable.

La estructura de archivos es la siguiente:
```text
arttexpreview.nvim/
├── README.md               # Documentación para el usuario final
├── doc/
│   └── DEVELOPER.md        # Documentación técnica (este archivo)
└── lua/
    └── arttexpreview/
        ├── init.lua        # Punto de entrada principal (Autocomandos y ciclo de vida)
        ├── config.lua      # Almacena el estado global y valores por defecto
        ├── core/
        │   └── extractor.lua # Lógica pura: Extrae texto/rutas del buffer usando Treesitter
        └── ui/
            ├── menu.lua    # Lógica de la interfaz gráfica interactiva (Menú)
            └── renderer.lua# Lógica de renderizado gráfico (Ventanas flotantes, Nabla)
```

## 🧩 Descripción de Módulos y Funciones

### 1. `init.lua` (Controlador Principal)
Es el orquestador del plugin.
*   **`M.setup(opts)`**: Recibe la tabla `opts` proporcionada por el usuario (o por `lazy.nvim`) y la fusiona con las variables de configuración por defecto alojadas en `config.lua`. Inicializa los atajos de teclado (`<leader>lp`) y lanza los **autocomandos** (`CursorHold`, `CursorMoved`) que escuchan los eventos del editor.
*   **`try_auto_preview()`**: Función interna que evalúa el estado del cursor. Si `config.settings.auto_math` es verdadero, llama al `extractor` para obtener el bloque matemático y, si lo encuentra, se lo pasa al `renderer`.

### 2. `config.lua` (Estado Global)
*   **`M.settings`**: Tabla central que guarda el estado de habilitación de las opciones (`auto_math`, `auto_image`). Se mantiene como fuente única de verdad (Single Source of Truth) para que todos los demás módulos la consulten.

### 3. `core/extractor.lua` (Cerebro Analítico)
Encargado puramente de analizar texto y comunicarse con el AST (Abstract Syntax Tree) de Neovim.
*   **`M.get_math_at_cursor()`**: Utiliza `nvim-treesitter.ts_utils` para obtener el nodo exacto bajo el cursor. Si el nodo (o sus padres) son de tipo `math_environment`, `inline_formula` o `displayed_equation`, extrae el texto exacto. **Nota de escalabilidad:** Se eliminaron los fallbacks a expresiones regulares (`searchpairpos`) porque consumían demasiada CPU y bloqueaban el editor.
*   **`M.get_image_at_cursor()`**: Usa expresiones regulares rápidas en la **línea actual** (muy poco consumo de CPU) para detectar macros tipo `\includegraphics{...}` y resolver su ruta absoluta.

### 4. `ui/renderer.lua` (Motor Gráfico)
Encargado de dibujar en la pantalla de Neovim sin interferir con la lógica del negocio.
*   **`setup_window(width, height, title)`**: Función privada que calcula matemáticamente la esquina superior derecha del editor y genera un buffer temporal con borde curvo para alojar contenido.
*   **`M.show_math(math_code)`**: Inyecta el texto matemático en el buffer flotante y llama a la API de `nabla.nvim` para renderizar arte ASCII sobre ese buffer.
*   **`M.clear_preview()`**: Mata y limpia con seguridad cualquier ventana flotante activa. Previniendo memory leaks de buffers de Neovim.

### 5. `ui/menu.lua` (Interactividad)
*   **`M.open_menu()`**: Hace un puente con el plugin hermano `arttexworkspace` (específicamente `menu_builder.lua`) para renderizar un menú interactivo. Lee el estado desde `config.lua` y modifica ese mismo estado en tiempo real si el usuario aprieta "Enter".

## 🚀 Guía de Escalabilidad (Futuro)

Gracias a esta arquitectura, agregar nuevas funcionalidades es trivial y seguro:

1.  **Añadir un previsualizador de Tablas**:
    *   Crea una función `M.get_table_at_cursor()` en `core/extractor.lua`.
    *   Crea una función `M.show_table(data)` en `ui/renderer.lua`.
    *   Añade el toggle en `ui/menu.lua`.
    *   En `init.lua`, simplemente añade el condicional dentro de `try_auto_preview()`.

2.  **Cambiar Nabla por otro motor matemático (ej. renderizado Web/Markdown)**:
    *   **No toques el core**. Modifica exclusivamente la función `M.show_math` dentro de `ui/renderer.lua`. Como el resto del plugin solo espera que el `renderer` dibuje algo, el acoplamiento es mínimo.

Esta estructura modular asegura que el proyecto pueda crecer indefinidamente manteniendo el código legible y con bajo impacto en el rendimiento de Neovim.
