# 🌌 Comandos del Ecosistema ArtTeX (Cheatsheet)

Esta es la referencia oficial de tu entorno de trabajo. Todos los atajos están agrupados lógicamente bajo la tecla **`<leader>l`**.

## ⚡ Comandos de Acceso Rápido (Raíz)
Los comandos que utilizarás constantemente están en el primer nivel del menú (`<leader>l`).

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexCompile` | `<leader>lc` | Compilar (Auto) |
| `:ArtTexForwardSearch` | `<leader>lv` | Ver PDF (SyncTeX) |
| `:ArtTexFormat` | `<leader>lf` | Formatear Documento |
| `:ArtTexTOCToggle` | `<leader>lt` | Alternar Índice (TOC) |
| `:ArtTexStop` | `<leader>ls` | Detener Trabajo |
| `:ArtTexStopAll` | `<leader>lS` | Detener Todos |
| `:ArtTexViewLog` | `<leader>ll` | Ver Archivo .log |
| `:ArtTexClean` | `<leader>ld` | Limpiar Auxiliares |
| `:ArtTexErrors` | `<leader>le` | Ver Errores Quickfix |
| `:ArtTexMenuCompilatorConfig` | `<leader>lC` | Compilador |

## 🛠️ Utilidades (`<leader>lu`)
Colección de herramientas adicionales y snippets.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexDocCTAN` | `<leader>lud` | Doc CTAN Paquete |
| `:ArtTexSnippetsEdit` | `<leader>lue` | Editar Módulos |
| `:ArtTexSnippetsSearch` | `<leader>lus` | Buscar Snippets |
| `:ArtTexSnippetsConfig` | `<leader>luc` | Activar/Desactivar Snippets |
| `:ArtSourceColorSync` | `<leader>lur` | Refrescar Sintaxis |
| `:ArtTexLint` | `<leader>lul` | Analizar Linter (ChkTeX) |
| `require('arttexconceal').toggle()` | `<leader>luC` | Alternar Conceal |
| `:ToggleFileTexIllustrator` | `<leader>lui` | Figura Illustrator |

## ⚙️ Procesos y Compilación (`<leader>lp`)
Administra los trabajos en segundo plano del compilador.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexCompilePlain` | `<leader>lpC` | Compilar (PlainTeX) |
| `:ArtTexStatus` | `<leader>lpi` | Estado Procesos |
| `:ArtTexOutput` | `<leader>lpo` | Consola de Salida |
| `:ArtTexOutputClose` | `<leader>lpO` | Cerrar Consola Forzada |
| `:ArtTexDebugCommand` | `<leader>lpd` | Ver Comando Shell |

## 🗂️ Workspace y Sistema (`<leader>lw`)
Gestión del árbol de tu proyecto global.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexWorkspaceTree` | `<leader>lwt` | Árbol Workspace |
| `:ArtTexVerbatimEnvs` | `<leader>lwv` | Entornos Verbatim |
| `:ArtTexCreateProject` | `<leader>lwn` | Crear Proyecto |
| `:ArtTexVisualizeGraph` | `<leader>lwg` | Grafo Dependencias |
| `:ArtTexClearLog` | `<leader>lwc` | Limpiar BD Interna |

## 🪄 Visual Wizards (`<leader>lW`)
Interfaces gráficas para generar código complejo.

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexVisualTable` | `<leader>lWt` | Tablas (Grid) |
| `:ArtTexVisualMath` | `<leader>lWm` | Matemáticas (Editor) |
| `:ArtTexVisualGraph` | `<leader>lWg` | Gráficas TikZ |

## 🔧 Ajustes y Configuración (`<leader>la`)
Menús interactivos para personalizar el comportamiento del ecosistema. *(Nota: Observé en tu configuración que tienes asignado `<leader>lah` dos veces, una para `ArtTexHover` y otra para `ArtHoverConfig`. Es posible que quieras cambiar uno de ellos en el futuro).*

| Comando Neovim | Atajo | Descripción |
| :--- | :--- | :--- |
| `:ArtTexHover` | `<leader>lah` | Info Comando (Hover) |
| `:ArtCmpConfig` | `<leader>laa` | Autocompletado |
| `:ArtTeXConcealMenu` | `<leader>laC` | Conceal (Símbolos) |
| `:ArtHoverConfig` | `<leader>lah` | Hover (Emergentes) |
| `:ArtLinterConfig` | `<leader>lal` | Linter (ChkTeX) |
| `:ArtFormatConfig` | `<leader>laf` | Formateador |
| `:ArtTexTOCConfig` | `<leader>lat` | Índice (TOC) |
| `:ArtTexSelectViewer` | `<leader>lav` | Visor PDF |
| `:ArtSourceColorConfig` | `<leader>las` | Source Color |
| `:ArtTexPreviewConfig` | `<leader>lap` | Previsualizador |
| `:ArtFormatEditRules` | `<leader>lar` | Editar Reglas YAML |
