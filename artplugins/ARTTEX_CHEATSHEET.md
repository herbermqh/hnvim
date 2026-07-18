# 🌌 Comandos del Ecosistema ArtTeX (Cheatsheet)

Esta es la referencia oficial de tu entorno de trabajo. Todos los atajos están agrupados lógicamente bajo la tecla **`<leader>l`**.

## ⚡ Comandos de Acceso Rápido (Raíz)
Los comandos que utilizarás constantemente están en el primer nivel del menú.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexCompile` | `<leader>lc` | Iniciar compilador automático. |
| `:ArtTexForwardSearch` | `<leader>lv` | Ver PDF (SyncTeX a la línea actual). |
| `:ArtTexFormat` | `<leader>lf` | Formatear documento entero. |
| `:ArtTexTOCToggle` | `<leader>lT` | Alternar panel lateral del índice (TOC). |
| `:ToggleFileTexIllustrator` | `<leader>li` | Insertar/Editar figura de Illustrator. |
| `:ArtTexHover` | `<leader>lh` | Ver ventana de información flotante. |

## ⚙️ Procesos y Compilación (`<leader>lp`)
Administra los trabajos en segundo plano del compilador.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexCompilePlain` | `<leader>lpC` | Compilar en modo PlainTeX. |
| `:ArtTexStop` | `<leader>lps` | Detener proceso de compilación actual. |
| `:ArtTexStopAll` | `<leader>lpS` | Detener todos los procesos globales. |
| `:ArtTexStatus` | `<leader>lpi` | Imprime el estado de procesos activos. |
| `:ArtTexClean` | `<leader>lpx` | Limpiar archivos auxiliares de LaTeX. |
| `:ArtTexOutput` | `<leader>lpo` | Alterna consola de salida. |
| `:ArtTexOutputClose` | `<leader>lpO` | Cierra forzosamente consola de salida. |
| `:ArtTexViewLog` | `<leader>lpl` | Abre el archivo `.log` de compilación. |
| `:ArtTexDebugCommand` | `<leader>lpd` | Muestra comando Shell usado para compilar. |
| `:ArtTexErrors` | `<leader>lpe` | Parsea errores y abre el Quickfix. |

## 🗂️ Workspace y Sistema (`<leader>lw`)
Gestión del árbol de tu proyecto global.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexWorkspaceTree` | `<leader>lwt` | Visualiza estructura y dependencias. |
| `:ArtTexCreateProject` | `<leader>lwn` | Inicializa un nuevo proyecto raíz. |
| `:ArtTexVisualizeGraph` | `<leader>lwg` | Genera y muestra grafo de dependencias. |
| `:ArtTexClearLog` | `<leader>lwc` | Fuerza borrado de la BD interna del workspace. |
| `:ArtSourceColorSync` | `<leader>lwr` | Refresca forzosamente colores (Tree-sitter). |
| `:ArtTexLint` | `<leader>lwl` | Corre análisis semántico (ChkTeX) manualmente. |
| `require('arttexconceal').toggle()` | `<leader>lwC` | Alterna visualización de caracteres (Conceal). |

## ✂️ Snippets Avanzados (`<leader>ls`)
Manejo de plantillas modulares rápidas.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexSnippetsEdit` | `<leader>lse` | Edita módulo de snippets visualmente. |
| `:ArtTexSnippetsSearch` | `<leader>lss` | Abre Telescope para buscar un snippet. |
| `:ArtTexSnippetsConfig` | `<leader>lsc` | Activar/Desactivar módulos de snippets. |

## 🪄 Asistentes Visuales (`<leader>lW`)
Interfaces gráficas para generar código complejo.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexVisualTable` | `<leader>lWt` | Generador gráfico en formato rejilla (Excel). |
| `:ArtTexVisualMath` | `<leader>lWm` | Entorno de ecuaciones interactivas (RPC). |
| `:ArtTexVisualGraph` | `<leader>lWg` | Creador visual interactivo de esquemas TikZ. |

## 🔧 Configuraciones Globales (`<leader>lO`)
Menús interactivos para personalizar el comportamiento del ecosistema.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexMenuCompilatorConfig` | `<leader>lOc` | Opciones de backend de compilación. |
| `:ArtCmpConfig` | `<leader>lOa` | Autocompletado, fuentes y latencias. |
| `:ArtHoverConfig` | `<leader>lOh` | Retardos y ventana emergente de Hover. |
| `:ArtLinterConfig` | `<leader>lOl` | Habilitar Linter automático y reglas. |
| `:ArtFormatConfig` | `<leader>lOf` | Alternar auto-guardado del formateador. |
| `:ArtTexTOCConfig` | `<leader>lOt` | Ajustar profundidad visual del Índice. |
| `:ArtTexSelectViewer` | `<leader>lOv` | Selecciona visor PDF predeterminado. |
| `:ArtSourceColorConfig` | `<leader>lOs` | Configura qué elementos se colorean dinámicamente. |
| `:ArtTexPreviewConfig` | `<leader>lOp` | Configurar auto-previsualizador (imágenes/math). |
| `:ArtFormatEditRules` | `<leader>lOr` | Abre el archivo YAML para editar estilo de texto. |
